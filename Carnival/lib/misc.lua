--Function to print a table (for debugging)
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

--Function that returns true if the element is in the table and false if it isn't
function tablecontains(table, element)
    sendInfoMessage("[Carnival] Checking if element "..element.." is in table "..dump(table))
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end