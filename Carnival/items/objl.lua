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

--Helper function to create a new invisable card area for the jokers to be stored in
local ensure_invis_card_area = function()
    if G.GAME.invis_card_area then return end
    local area = CardArea(
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
-- Helper function to search invisable card area made by amalgams, like SMODS.find_card() but for the invisable card area
G.FUNCS.search_invis_area = function (key)
    if not G.GAME.invis_card_area or not G.GAME.invis_card_area.cards then return end
    local results = {}
    for _, card in pairs(G.GAME.invis_card_area.cards) do
        if card and type(card) == 'table' and card.config and (card.config.center_key == key or (card.config.center and card.config.center.key == key)) then
            table.insert(results, card)
        end
    end
    return results
end

--OBJ_L joker
SMODS.Joker {
    key = "objl",
    atlas = "atlas_temp_jokers",
    pos = { x = 0, y = 0 },
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


    -- SMODS.find_card() returns an array of all cards with the given key.
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
    loc_txt = {
        name = "Amalgam",
        text = {
            "An amalgam of jokers.",
            "Can hold up to #2# jokers.",
            "Currently #1#/#2# slots used.",
            "",
            "You can rip up to #4# jokers out of this amalgam.",
            "Currently #3#/#4# rips used.",
            
        }
    },
    -- TODO: Make the art of the Amalgam update to show the jokers inside of it
    -- TODO: Make the amalgam have and show the effects of the jokers in it
    -- TODO: Make the values of the interted jokers double for each joker in the amalgam
    -- TODO: Track the number of times an amalgam has been ripped apart
    config = {
        extra = {
            stored_joker_keys = {nil, nil, nil, nil, nil, nil},
            current_slot = 1,
            used_slots = 0,
            available_slots = 6,
            used_rips = 0,
            available_rips = 3,

        },
    },
    remove_from_deck = function(self, card, from_debuff)
        sendDebugMessage("[Carnival] removing amalgam from deck")
        for i = 1, #card.ability.extra.stored_joker_keys do
            if card.ability.extra.stored_joker_keys[i] then
                local found = G.FUNCS.search_invis_area(card.ability.extra.stored_joker_keys[i])
                local joker = found and found[1]
                if joker then
                    SMODS.destroy_cards(joker, true)
                    sendDebugMessage("[Carnival] joker " .. joker.config.center_key .. " destroyed")
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)

        -- This displays tooltips on the side of the amalgam that show the jokers inside of it
        for i = 1, card.ability.extra.used_slots do
            local found = G.FUNCS.search_invis_area(card.ability.extra.stored_joker_keys[i])
            local joker = found and found[1]
            if joker and joker.config and joker.config.center_key then
                info_queue[#info_queue+1] = G.P_CENTERS[joker.config.center_key]
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
}


-- Function to merge the selected jokers into an amalgam
G.FUNCS.carnival_merge_jokers = function(e)

    if #G.Carnival.Merge_area.highlighted == 2 then
        -- TODO: Make sure that the amount of jokers in the amalgam is not greater than 6
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
                        G.GAME.invis_card_area:emplace(joker_1_copy)

                        SMODS.destroy_cards(joker_1, true)

                    else
                        local amalgam = create_card("Joker", G.jokers, nil, nil, true, true, "j_carnival_objl_amalgam")

                        -- This looks really bad, but all it does is take both jokers and store their centers in the amalgams 'stored_jokers' table,
                        -- then updates which slot is the next empty slot.

                        --New idea, for each joker, we store their .ability table, then make a new joker with the new .ability table in the amalgam's own, invisable, card area

                        
                        amalgam.ability.extra.stored_joker_keys[amalgam.ability.extra.current_slot] = joker_1.config.center_key
                        amalgam.ability.extra.current_slot = amalgam.ability.extra.current_slot + 1
                        amalgam.ability.extra.used_slots = amalgam.ability.extra.used_slots + 1 

                        amalgam.ability.extra.stored_joker_keys[amalgam.ability.extra.current_slot] = joker_2.config.center_key
                        amalgam.ability.extra.current_slot = amalgam.ability.extra.current_slot + 1
                        amalgam.ability.extra.used_slots = amalgam.ability.extra.used_slots + 1

                        G.jokers:emplace(amalgam)
                        amalgam:add_to_deck()

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

-- In base Balatro, you can't select multiple jokers, so we need to create a consumable that allows the player to merge two jokers into an amalgam.
-- Seal of Creation consumable
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
    end,
}

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
            "The joker ripped out of an {C:attention}amalgam{} is returned to the player's hand.",
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
        sendDebugMessage("[Carnival] the objl seal of destruction worked!") --Test code
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
