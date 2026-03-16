math.randomseed(os.time())
-- Joker: OBJ_L: Creation Incarnate
-- Idea: Ryder
-- Coder: Ryder
-- Art: OBJ_Lily
-- As long as this joker is owned, the player has twosuits negative consumables that allowed them to merge two jokers into an amalgam and rip a joker out of an amalgam.
-- An amalgam has alll abilities of the jokers used to create it.
-- An amalgam can have up to six jokers in it.
-- The values of the jokers in an amalgam are doubled for each joker in it.
-- An amalgam has any and all powerups (negative, holographic, etc.) of the jokers used to create it.
-- You can rip a joker out of an amalgam to get back the joker you ripped out.
-- You can only rip a joker out of an amalgam three times before it is destroyed.


--#region Helper Functions
--Creates a new invisable card area for the jokers to be stored in
---@return nil
local ensure_invis_card_area = function()
    if G.GAME.invis_card_area then return end
    local area = CardArea(

        -- Way off screen
        G.ROOM.T.x + 100000,
        G.ROOM.T.y + 100000,
        0, 0,
        {
            type = "joker",
            card_limit = 999,
            highlight_limit = 0,
            visable = false,
            no_ui = true
        }
    )
    area.states.visible = false

    function area:draw() end

    G.GAME.invis_card_area = area
end

if not G.FUNCS then G.FUNCS = {} end
--Searches invisable card area made by amalgams, like SMODS.find_card() but for the invisable card area
---@param key string
---@return (table | nil) results
G.FUNCS.carnival_search_invis_area = function (key)
    if not G.GAME.invis_card_area or not G.GAME.invis_card_area.cards then return end
    local results = {}
    for _, card in pairs(G.GAME.invis_card_area.cards) do
        if card and type(card) == 'table' and card.config and (card.config.center_key == key or (card.config.center and card.config.center.key == key)) then
            table.insert(results, card)
        end
    end
    return results
end

--Takes the input table and returns a table with all nil values removed
--
--Eg: fill_holes({1, nil, 2, nil, 3, nil}) -> {1, 2, 3}
---@param table {}
---@return {}
local function fill_holes(table)
    local new_table = {}
    for _, value in pairs(table) do
        new_table[#new_table+1] = value
    end
    return new_table
end
--#endregion


--OBJ_L joker
SMODS.Joker {
    key = "objl",
    atlas = "atlas_jokers",
    pos = { x = 4, y = 0 },
    rarity = "carnival_ringleader",
    loc_txt = {
        name = "OBJ_L: Creation Incarnate",
        text = {
            "Grants the {C:attention}Seal of Creation{} and {C:attention}Seal of Destruction{} while owned.",
        }
    },
    add_to_deck = function(self, card) 
        SMODS.add_card({key = "c_carnival_objl_seal_of_creation", G.consumeables})
        SMODS.add_card({key = "c_carnival_objl_seal_of_destruction", G.consumeables})
        ensure_invis_card_area()
    end,
    remove_from_deck = function(self, card)
        SMODS.destroy_cards(SMODS.find_card("c_carnival_objl_seal_of_creation")[1], true)
        SMODS.destroy_cards(SMODS.find_card("c_carnival_objl_seal_of_destruction")[1], true)
    end,
}

--Amalgam joker
SMODS.Joker {
    key = "objl_amalgam",
    atlas = "atlas_temp_jokers",
    pos = { x = 0, y = 0 },
    no_collection = true,
    rarity = "carnival_creation",
    loc_txt = {
        name = "Amalgam",
        text = {
            "An amalgam of {C:attention}jokers{}.",
            "Can hold up to {C:attention}#2#{} jokers.",
            "Currently {C:attention}#1#{}/{C:attention}#2#{} slots used.",
            "",
            "You can rip up to {C:attention}#4#{} jokers out of this amalgam.",
            "Currently {C:attention}#3#{}/{C:attention}#4#{} rips used.",
            
        }
    },
    -- TODO: Make the art of the Amalgam update to show the jokers inside of it
    -- TODO: Make the values of the interted jokers double for each joker in the amalgam
    config = {
        extra = {
            stored_joker_keys = {},
            current_slot = 1,
            used_slots = 0,
            available_slots = 6,
            used_rips = 0,
            available_rips = 3,

        },
    },
    add_to_deck = function(self, card)
        -- To handle the case where there are duplicate jokers in the invis_card_area, all amalgams have a unique key, and jokers in that amalgam have a new parameter that stores its parent amalgam's key
        ::reset_key::
        card.ability.extra.identity_key = math.random(1, 1000000)
        for _, joker in pairs(G.jokers.cards) do
            if joker.ability.extra and joker.ability.extra.identity_key and joker.ability.extra.identity_key == card.ability.extra.identity_key then
                goto reset_key
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for i = 1, #card.ability.extra.stored_joker_keys do
            if card.ability.extra.stored_joker_keys[i] then
                local found = G.FUNCS.carnival_search_invis_area(card.ability.extra.stored_joker_keys[i])
                local joker = found and found[1]
                if joker then
                    SMODS.destroy_cards(joker, true)
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)

        -- This displays tooltips on the side of the amalgam that show the jokers inside of it
        for i = 1, card.ability.extra.used_slots do
            local found = G.FUNCS.carnival_search_invis_area(card.ability.extra.stored_joker_keys[i])
            local joker = found and found[1]
            if joker then
                local center = (joker.config and joker.config.center) or (joker.config and joker.config.center_key and G.P_CENTERS[joker.config.center_key])
                if center then
                    info_queue[#info_queue+1] = center
                end
            end
        end

        return {
            vars = {
                card.ability.extra.used_slots,
                card.ability.extra.available_slots,
                card.ability.extra.used_rips,
                card.ability.extra.available_rips,
                card.ability.extra.stored_joker_keys,
                card.ability.extra.current_slot,
            }
        }
    end,
    --[[draw = function(self, card, layer)
        --Updates the art in the amalgam to show all the jokers inside of it
        --TODO: Start work from here!
        --    loop through each stored joker, find their position in the amalgam, then cut their atlases and store the cut up parts as stored_amalgam_quads[key]
    end]]
}

--#region seal of creation

-- ### Function that gets called when the "Merge" button in the below menu is pressed.
--**Should only be called by Seal of Creation**
--
--Finds the highlighted cards in G.Carnival.Merge_area and checks if either of them is\
--an amalgam.
--
--If neither of the selected cards are an amalgam, creates an amalgam and a copy of each\
--highlighted card, gives the copied cards a tag for finding which amalgam they are in,\
--puts the keys of the coppied cards in amalgam.ability.extra.stored_joker_keys,increments\
--amalgam.ability.extra.current_slot and used_slots, then places the copied cards in the invis_card_area.
--
--If one of the selected cards is an amalgam, then the same process happens, except instead\
--of making a new amalgam, the data of the non-amalgam is stored in the amalgam.
--
--If both selected cards are an amalgam, then the menue isn't closed, and the merege doesn't happen.
---@param e {}
---@return nil
G.FUNCS.carnival_merge_jokers = function(e)

    if #G.Carnival.Merge_area.highlighted == 2 then
        -- TODO: Add error messages for when the merge fails (if there are too many jokers in the amalgam, or if both jokers are amalgams)

        -- Make sure that two amalgams are not selected
        if not (G.Carnival.Merge_area.highlighted[1].config.center_key == "j_carnival_objl_amalgam" and G.Carnival.Merge_area.highlighted[2].config.center_key == "j_carnival_objl_amalgam") then

            -- Store the selected jokers then close the overlay menu
            local joker_1 = G.Carnival.Merge_area.highlighted[1].carnival_original_joker
            local joker_2 = G.Carnival.Merge_area.highlighted[2].carnival_original_joker
            -- Makes sure that, if joker_1 is an amalgam, it still has free slots
            if not (joker_1.config.center_key == "j_carnival_objl_amalgam" and (joker_1.ability and joker_1.ability.extra and joker_1.ability.extra.used_slots and joker_1.ability.extra.used_slots == 6)) then
                -- Makes sure that, if joker_2 is an amalgam, it still has free slots
                if not (joker_2.config.center_key == "j_carnival_objl_amalgam" and (joker_2.ability and joker_2.ability.extra and joker_2.ability.extra.used_slots and joker_2.ability.extra.used_slots == 6)) then
                    G.FUNCS.exit_overlay_menu()

                    -- If either of the selected jokers is an amalgam, the other joker is inserted into it. Otherwise, a new amalgam is made,
                    -- and both jokers are inserted into it.

                    if joker_1.config.center_key == "j_carnival_objl_amalgam" then

                        -- This looks really bad, but all it does is take the non-amalgam joker's center and stores it in the amalgam's 'stored_jokers' table,
                        -- then updates which slot is the next empty slot.
                        
                        joker_1.ability.extra.stored_joker_keys[joker_1.ability.extra.current_slot] = joker_2.config.center_key
                        joker_1.ability.extra.current_slot = joker_1.ability.extra.current_slot + 1
                        joker_1.ability.extra.used_slots = joker_1.ability.extra.used_slots + 1

                        -- Store the joker_2 in the invisable card area
                        local joker_2_copy = copy_card(joker_2)

                        joker_2_copy.ability = joker_2.ability or {}
                        joker_2_copy.ability.extra = joker_2.ability.extra or {}
                        joker_2_copy.ability.extra.parent_amalgam_key = joker_1.ability.extra.identity_key

                        G.GAME.invis_card_area:emplace(joker_2_copy)

                        SMODS.destroy_cards(joker_2, true)

                    
                    elseif joker_2.config.center_key == "j_carnival_objl_amalgam" then

                        -- This looks really bad, but all it does is take the non-amalgam joker's center and stores it in the amalgam's 'stored_jokers' table,
                        -- then updates which slot is the next empty slot.
                        joker_2.ability.extra.stored_joker_keys[joker_2.ability.extra.current_slot] = joker_1.config.center_key
                        joker_2.ability.extra.current_slot = joker_2.ability.extra.current_slot + 1
                        joker_2.ability.extra.used_slots = joker_2.ability.extra.used_slots + 1

                        -- Store the joker_1 in the invisable card area
                        local joker_1_copy = copy_card(joker_1)


                        joker_1_copy.ability = joker_1.ability or {}
                        joker_1_copy.ability.extra = joker_1.ability.extra or {}
                        joker_1_copy.ability.extra.parent_amalgam_key = joker_2.ability.extra.identity_key

                        G.GAME.invis_card_area:emplace(joker_1_copy)

                        SMODS.destroy_cards(joker_1, true)

                    else
                        local amalgam = create_card("Joker", G.jokers, nil, nil, true, true, "j_carnival_objl_amalgam")

                        -- This looks really bad, but all it does is take both jokers and store their centers in the amalgams 'stored_jokers' table,
                        -- then updates which slot is the next empty slot.

                        amalgam:add_to_deck()

                        joker_1.ability = joker_1.ability or {}
                        joker_1.ability.extra = joker_1.ability.extra or {}
                        joker_1.ability.extra.parent_amalgam_key = amalgam.ability.extra.identity_key

                        joker_2.ability = joker_2.ability or {}
                        joker_2.ability.extra = joker_2.ability.extra or {}
                        joker_2.ability.extra.parent_amalgam_key = amalgam.ability.extra.identity_key

                        
                        amalgam.ability.extra.stored_joker_keys[amalgam.ability.extra.current_slot] = joker_1.config.center_key
                        amalgam.ability.extra.current_slot = amalgam.ability.extra.current_slot + 1
                        amalgam.ability.extra.used_slots = amalgam.ability.extra.used_slots + 1 

                        amalgam.ability.extra.stored_joker_keys[amalgam.ability.extra.current_slot] = joker_2.config.center_key
                        amalgam.ability.extra.current_slot = amalgam.ability.extra.current_slot + 1
                        amalgam.ability.extra.used_slots = amalgam.ability.extra.used_slots + 1

                        G.jokers:emplace(amalgam)
                        

                        local joker_1_copy = copy_card(joker_1)
                        local joker_2_copy = copy_card(joker_2)
                        G.GAME.invis_card_area:emplace(joker_1_copy)
                        G.GAME.invis_card_area:emplace(joker_2_copy)

                        SMODS.destroy_cards(joker_1, true)
                        SMODS.destroy_cards(joker_2, true)


                    end
                end
            end
        end
    end
end


--In base Balatro, you can't select multiple jokers, so we need to create a consumable that allows the player to merge two jokers into an amalgam.
--Seal of Creation consumable
SMODS.Consumable {
    key = "objl_seal_of_creation",
    set = "carnival_abilities",
    loc_txt = {
        name = "Seal of Creation",
        text = {
            "Allows the player to merge two jokers into an {C:attention}amalgam{}.",
            "An {C:attention}amalgam{} can have up to six jokers in it.",
            "The values of the jokers in an {C:attention}amalgam{} are doubled for each joker in it.",
        }
    },
    atlas = "atlas_temp_jokers",
    pos = { x = 0, y = 0 },
    -- OBJ_L can't be fused, so the seal can only be used when you have OBJ_L and two other jokers
    can_use = function(self, card)
        if #G.jokers.cards >= 3 then
            return true
        end
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                
                -- Make an area to store all the jokers that are not OBJ_L"
                G.Carnival.Merge_area = CardArea(0, 0, G.jokers.T.w, G.jokers.T.h, {
                    type = "joker",
                    highlight_limit = 2,
                    card_limit = #G.jokers.cards - 1,
                })
                G.Carnival.Merge_area.config.card_limits.extra_slots_used = 0 --For some reason, this is not being set correctly, so we need to set it manually
                -- Get all jokers that are not OBJ_L and add them to the merge area
                for i = 1, #G.jokers.cards do
                    local joker = G.jokers.cards[i]
                    if joker.config and joker.config.center and joker.config.center.key ~= "j_carnival_objl" then
                        local copy = copy_card(joker) -- We need to copy the joker so that we can add it to the merge area without affecting the original joker
                        
                        -- For now, we can still sell the jokers in the merge area, so we need to set the cost to 0 so there's no benifit to selling them
                        -- in the future, I'd like to find some way to make the jokers in the merge area not sellable, but I'm not sure how to do that yet
                        copy.cost = 0
                        copy.sell_cost = 0
                        copy.sell_cost_label = (copy.facing == 'back' and '?') or 0
                        copy.carnival_original_joker = joker
                        
                        G.Carnival.Merge_area:emplace(copy)
                    end
                end

                -- Display the merge area in an overlay menu
                G.FUNCS.overlay_menu({
                    definition = create_UIBox_generic_options({
                        contents = {
                            {n = G.UIT.C, config = {align = "cm", padding = 0.2, r = 0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes = {
                                {n = G.UIT.O, config = {object = G.Carnival.Merge_area}},
                                {n = G.UIT.C, config = {button = "carnival_merge_jokers", align = "cm", padding = 0.2, colour = G.C.PURPLE, r = 0.1, shadow = true}, nodes = {
                                    {n = G.UIT.T, config = {text = "Merge",align = "cm", scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
                                }}
                            }}
                        },
                    }),
                })
                return true
            end
        }))

    end,
    keep_on_use = function(self, card)
        return true
    end,
    eternal_compat = true,
    add_to_deck = function(self, card)
        card:set_eternal(true)
        card:set_edition('e_negative', true, true)
    end
}
--#endregion

--#region seal of destruction

-- ### Function that gets called when the "Rip" button in the below menu is pressed
--
-- **Should only be called in the process of using the Seal of Destruction**
--
--Finds the amalgam that is being ripped from and the cards being ripped from it.
--
--Then creates a copy of the selected card, adds it to G.jokers, then removes the original from invis_card_area.
--
--Then removes the joker key from the amalgam, condences the amalgam's stored_joker_keys, decrements the amalgams used and current slot.\
--Then, if the amalgam has no jokers in it, or if it has been ripped 3 times, destroyes the amalgam.
---@param e {}
G.FUNCS.carnival_rip = function(e)
    local selected_amalgam = G.Carnival and G.Carnival.ripping_amalgam
    if not selected_amalgam then return end

    local selected_joker = G.Carnival.Ripping_menu.highlighted[1].carnival_original_joker
    local outer_joker = copy_card(selected_joker)

    -- Spawn at 0,0 so the joker doesn't inherit the invis area's off-screen position
    outer_joker.T.x = 0
    outer_joker.T.y = 0
    outer_joker:hard_set_T()

    -- Remove the parent_amalgam_key from the copy (if it exists)
    if outer_joker.ability and outer_joker.ability.extra and outer_joker.ability.extra.parent_amalgam_key then
        outer_joker.ability.extra.parent_amalgam_key = nil
    end

    --Put the outer joker into G.jokers
    G.jokers:emplace(outer_joker)
    outer_joker:add_to_deck()

    --Remove the selected joker from the invisable card area
    SMODS.destroy_cards(selected_joker, true)

    --Remove the selected joker key from the amalgam's stored_joker_keys
    for i = 1, 6 do
        if (
            selected_amalgam.ability and
            selected_amalgam.ability.extra and
            selected_amalgam.ability.extra.stored_joker_keys and
            selected_amalgam.ability.extra.stored_joker_keys[i] == selected_joker.config.center_key
        ) then

            selected_amalgam.ability.extra.stored_joker_keys[i] = nil
            selected_amalgam.ability.extra.used_slots = selected_amalgam.ability.extra.used_slots - 1
            selected_amalgam.ability.extra.current_slot = selected_amalgam.ability.extra.current_slot - 1
            selected_amalgam.ability.extra.stored_joker_keys = fill_holes(selected_amalgam.ability.extra.stored_joker_keys)
            selected_amalgam.ability.extra.used_rips = selected_amalgam.ability.extra.used_rips + 1
            if selected_amalgam.ability.extra.used_rips == selected_amalgam.ability.extra.available_rips or selected_amalgam.ability.extra.used_slots == 0 then
                SMODS.destroy_cards(selected_amalgam, true)
            end
            break
        end
    end
    G.Carnival.ripping_amalgam = nil
    G.FUNCS.exit_overlay_menu()
end

--Function that gets called when the "Select" button in the below menu is pressed.
--
--Stores the selected amalgam from G.Carnical.Amalgam_menu, then loops through that amalgam's\
--stored_joker_keys to build a CardArea with copies of all the jokers in that amalgam.
--
--Then opens a menu that allowes the player to select 1 joker to rip out of the amalgam. 
---@param e {}
G.FUNCS.carnival_open_rip_menu = function(e)
    G.Carnival = G.Carnival or {}
    local selected_amalgam_copy = G.Carnival.Amalgam_menu and G.Carnival.Amalgam_menu.highlighted[1]
    if not selected_amalgam_copy or not selected_amalgam_copy.carnival_original_amalgam then return end
    -- Store the real amalgam so carnival_rip can read it
    G.Carnival.ripping_amalgam = selected_amalgam_copy.carnival_original_amalgam

    --Make a cardarea with all the jokers in the selected amalgam
    G.Carnival.Ripping_menu = CardArea(0, 0, G.jokers.T.w, G.jokers.T.h, {
        type = "joker",
        highlight_limit = 1,
        card_limit = 6
    })
    G.Carnival.Ripping_menu.config.card_limits.extra_slots_used = 0 --For some reason, this is not being set correctly, so we need to set it manually

    for _, joker in pairs(G.GAME.invis_card_area.cards) do
        for _, stored_key in pairs(selected_amalgam_copy.ability.extra.stored_joker_keys) do
            if joker.config.center_key == stored_key then
                local joker_copy = copy_card(joker)
                joker_copy.cost = 0
                joker_copy.sell_cost = 0
                joker_copy.sell_cost_label = (joker_copy.facing == 'back' and "?") or 0
                joker_copy.carnival_original_joker = joker
                -- Spawn at 0,0 so copies don't inherit the invis area's off-screen position
                joker_copy.T.x = 0
                joker_copy.T.y = 0
                joker_copy:hard_set_T()

                G.Carnival.Ripping_menu:emplace(joker_copy)
            end
        end
    end

    G.FUNCS.exit_overlay_menu()

    G.FUNCS.overlay_menu({
        definition = create_UIBox_generic_options({
            contents = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.2, r = 0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes = {
                    {n = G.UIT.O, config = {object = G.Carnival.Ripping_menu}},
                    {n = G.UIT.C, config = {button = "carnival_rip", align = "cm", padding = 0.2, colour = G.C.PURPLE, r = 0.1, shadow = true}, nodes = {
                        {n = G.UIT.T, config = {text = "Rip", align = "cm", scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
                    }}
                }}
            }
        })
    })
end

-- To keep with the consistency of jokers not having any buttons, we need to create a consumable that allows the player to rip a joker out of an amalgam.
-- Seal of Destruction consumable
SMODS.Consumable {
    key = "objl_seal_of_destruction",
    set = "carnival_abilities",
    loc_txt = {
        name = "Seal of Destruction",
        text = {
            "Allows the player to rip a joker out of an {C:attention}amalgam{}.",
            "An {C:attention}amalgam{} can only be ripped apart three times before it is destroyed.",
            "The joker ripped out of an {C:attention}amalgam{} is returned to the joker tray.",
        }
    },
    atlas = "atlas_temp_jokers",
    pos = { x = 0, y = 0 },
    can_use = function(self, card)
        if next(SMODS.find_card("j_carnival_objl_amalgam")) then
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- First, open a menu that has all the player's amalgams in it
        G.Carnival.Amalgam_menu = CardArea(0, 0, G.jokers.T.w, G.jokers.T.h, {
            type = "joker",
            highlight_limit = 1,
            card_limit = #G.jokers.cards,
        })
        G.Carnival.Amalgam_menu.config.card_limits.extra_slots_used = 0 --For some reason, this is not being set correctly, so we need to set it manually
        -- Get all amalgams and add them to the menu
        for _, card in ipairs(G.jokers.cards) do
            if card.config.center_key == "j_carnival_objl_amalgam" then
                local copy = copy_card(card)
                copy.cost = 0
                copy.sell_cost = 0
                copy.sell_cost_label = (copy.facing == 'back' and '?') or 0
                copy.carnival_original_amalgam = card
                G.Carnival.Amalgam_menu:emplace(copy)
            end
        end

        -- Display the amalgam menu in an overlay menu
        G.FUNCS.overlay_menu({
            definition = create_UIBox_generic_options({
                contents = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.2, r = 0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes = {
                        {n = G.UIT.O, config = {object = G.Carnival.Amalgam_menu}},
                        {n = G.UIT.C, config = {button = "carnival_open_rip_menu", align = "cm", padding = 0.2, colour = G.C.PURPLE, r = 0.1, shadow = true}, nodes = {
                            {n = G.UIT.T, config = {text = "Select",align = "cm", scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
                        }}
                    }}
                }
            })
        })
    end,
    keep_on_use = function(self, card)
        return true
    end,
    eternal_compat = true,
    add_to_deck = function(self, card)
        card:set_eternal(true)
        card:set_edition('e_negative', true, true)
    end,
}

--Stores the invis_card's parent_amalgam_key, then loops through all jokers in G.jokers until it finds a joker with that key, then returns that card.
local function get_amalgam_for_invis_joker(invis_card)
    if not invis_card or not invis_card.config or not G.jokers or not G.jokers.cards then return nil end
    local card_key = invis_card.ability.extra.parent_amalgam_key
    if not card_key then return nil end
    for _, card in ipairs(G.jokers.cards) do
        if (card.ability.extra and card.ability.extra.indentity_key) and card.ability.extra.indentity_key == card_key then
            for i = 1, #card.ability.extra.stored_joker_keys do
                if card.ability.extra.stored_joker_keys[i] == key then
                    return card
                end
            end
        
        end
    end
    return nil
end
--#endregion

-- Redirect scoring messages from invis_card_area jokers to appear under their amalgam.
do
    local orig = card_eval_status_text
    ---@diagnostic disable-next-line: lowercase-global
    function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
        if card and G.GAME and G.GAME.invis_card_area and card.area == G.GAME.invis_card_area then
            local amalgam = get_amalgam_for_invis_joker(card)
            if amalgam then card = amalgam end
        end
        return orig(card, eval_type, amt, percent, dir, extra)
    end
end

-- When a joker inside an amalgam triggers, shake the amalgam.
if SMODS and SMODS.calculate_effect then
    local orig_calc = SMODS.calculate_effect
    ---@diagnostic disable-next-line: duplicate-set-field
    SMODS.calculate_effect = function(effect, scored_card, from_edition, pre_jokers)
        if effect and effect.juice_card and G.GAME and G.GAME.invis_card_area and effect.juice_card.area == G.GAME.invis_card_area then
            local amalgam = get_amalgam_for_invis_joker(effect.juice_card)
            if amalgam then effect.juice_card = amalgam end
        end
        return orig_calc(effect, scored_card, from_edition, pre_jokers)
    end
end

-- Make jokers in invis_card_area see context.cardarea == G.jokers so their passive/before/after
-- effects trigger (many jokers check context.cardarea == G.jokers and skip otherwise).
if SMODS and SMODS.calculate_card_areas then
    local orig_calc_card_areas = SMODS.calculate_card_areas
    ---@diagnostic disable-next-line: duplicate-set-field
    SMODS.calculate_card_areas = function(_type, context, return_table, args)
        if _type ~= 'jokers' or not context or not G.GAME or not G.GAME.invis_card_area then
            return orig_calc_card_areas(_type, context, return_table, args)
        end
        local real = context
        local proxy = setmetatable({}, {
            __index = real,
            __newindex = function(_, k, v)
                if k == 'cardarea' and v == G.GAME.invis_card_area then
                    real[k] = G.jokers
                else
                    real[k] = v
                end
            end
        })
        return orig_calc_card_areas(_type, proxy, return_table, args)
    end
end


--MAIN TODO SPOT
--Have the art update.
--  I can give things a draw() function that will get called after the main draw