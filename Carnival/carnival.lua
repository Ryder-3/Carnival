--- CARNIVAL MOD
--- A Cryptid addon focused on making the game even more chaotic
--- Author: Ryder

if not Carnival then
    Carnival = {}
end

-- Get the current mod object
local carnival_mod = SMODS.current_mod


-- Helper function to load all Lua files from a directory
local function load_directory(path)
    local files = NFS.getDirectoryItems(carnival_mod.path .. path)
    if not files then return end

    for _, file in ipairs(files) do
        local file_path = path .. '/' .. file
        local full_path = carnival_mod.path .. file_path

        -- Check if it's a directory (recursive loading)
        local info = NFS.getInfo(full_path)
        if info and info.type == 'directory' then
            load_directory(file_path)
        -- Load .lua files
        elseif file:match('%.lua$') then
            local chunk, err = NFS.load(full_path)
            if chunk then
                local success, error_msg = pcall(chunk)
                if not success then
                    sendErrorMessage('[Carnival] Error loading ' .. file_path .. ': ' .. tostring(error_msg))
                end
            else
                sendErrorMessage('[Carnival] Error reading ' .. file_path .. ': ' .. tostring(err))
            end
        end
    end
end

-- Load mod components in order
local load_order = {
    'lib',           -- Load helper libraries first
    'items',         -- Load game content (jokers, consumables, etc.)
}

-- Load each directory in order
for _, dir in ipairs(load_order) do
    local dir_path = carnival_mod.path .. dir
    if NFS.getInfo(dir_path) then
        load_directory(dir)
    end
end

-- Print successful load message
sendInfoMessage("[Carnival] And let the games... begin!")


