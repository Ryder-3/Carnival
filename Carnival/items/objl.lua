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
    end,


    -- SMODS.find_card() returns an array of all cards with the given key.
    remove_from_deck = function(self, card)
        SMODS.destroy_cards(SMODS.find_card("c_carnival_objl_seal_of_creation")[1], true)
        SMODS.destroy_cards(SMODS.find_card("c_carnival_objl_seal_of_destruction")[1], true)
    end,

}

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
            stored_jokers = {nil, nil, nil, nil, nil, nil},
            current_slot = 1,
            used_slots = 0,
            available_slots = 6,
            used_rips = 0,
            available_rips = 3,

        },
    },
    loc_vars = function(self, info_queue, card)


        return {
            vars = {
                card.ability.extra.used_slots,
                card.ability.extra.available_slots,
                card.ability.extra.used_rips,
                card.ability.extra.available_rips,
                --Not sure this is going to do anything
                card.ability.extra.stored_jokers,
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
            local joker_1 = G.Carnival.Merge_area.highlighted[1]
            local joker_2 = G.Carnival.Merge_area.highlighted[2]
            -- Makes sure that, if joker_1 is an amalgam, it still has free slots
            if not (joker_1.config.center_key == "j_carnival_objl_amalgam" and joker_1.ability.extra.used_slots == 6) then
                -- Makes sure that, if joker_2 is an amalgam, it still has free slots
                if not (joker_2.config.center_key == "j_carnival_objl_amalgam" and joker_2.ability.extra.used_slots == 6) then
                

                    G.FUNCS.exit_overlay_menu()

                    -- SMODS.find_card returns a table, so we need to get the first and second jokers if the same joker is selected twice
                    if joker_1.config.center_key == joker_2.config.center_key then
                        local found_jokers = SMODS.find_card(joker_1.config.center_key)
                        joker_1 = found_jokers[1]
                        joker_2 = found_jokers[2]
                    else
                        joker_1 = SMODS.find_card(joker_1.config.center_key)[1]
                        joker_2 = SMODS.find_card(joker_2.config.center_key)[1]
                    end

                    

                    -- If either of the selected jokers is an amalgam, the other joker is inserted into it. Otherwise, a new amalgam is made,
                    -- and both jokers are inserted into it.

                    if joker_1.config.center_key == "j_carnival_objl_amalgam" then

                        -- This looks really bad, but all it does is take the non-amalgam joker's center and stores it in the amalgam's 'stored_jokers' table,
                        -- then updates which slot is the next empty slot.
                        joker_1.ability.extra.stored_jokers[joker_1.ability.extra.current_slot] = joker_2.config.center
                        sendDebugMessage("[Carnival] joker_1.config.center.config.extra.stored_jokers[joker_1.config.center.config.extra.current_slot]: \n" .. inspectDepth(joker_1.config.center.config.extra.stored_jokers[joker_1.config.center.config.extra.current_slot], 4, 5))
                        joker_1.ability.extra.current_slot = joker_1.ability.extra.current_slot + 1
                        joker_1.ability.extra.used_slots = joker_1.ability.extra.used_slots + 1

                        SMODS.destroy_cards(joker_2)
                    
                    elseif joker_2.config.center_key == "j_carnival_objl_amalgam" then

                        -- This looks really bad, but all it does is take the non-amalgam joker's center and stores it in the amalgam's 'stored_jokers' table,
                        -- then updates which slot is the next empty slot.
                        joker_2.ability.extra.stored_jokers[joker_2.ability.extra.current_slot] = joker_1.config.center
                        sendDebugMessage("[Carnival] joker_2.ability.extra.stored_jokers[joker_2.ability.extra.current_slot]: \n" .. inspectDepth(joker_2.ability.extra.stored_jokers[joker_2.ability.extra.current_slot], 4, 5))
                        joker_2.ability.extra.current_slot = joker_2.ability.extra.current_slot + 1
                        joker_2.ability.extra.used_slots = joker_2.ability.extra.used_slots + 1

                        SMODS.destroy_cards(joker_1)

                    else
                        local amalgam = create_card("Joker", G.jokers, nil, nil, true, true, "j_carnival_objl_amalgam")

                        sendDebugMessage("[Carnival] amalgam.ability.extra: " .. inspectDepth(amalgam.ability.extra, 4, 5))
                        -- This looks really bad, but all it does is take both jokers and store their centers in the amalgams 'stored_jokers' table,
                        -- then updates which slot is the next empty slot.
                        amalgam.ability.extra.stored_jokers[amalgam.ability.extra.current_slot] = joker_1.config.center
                        
                        amalgam.ability.extra.current_slot = amalgam.ability.extra.current_slot + 1
                        amalgam.ability.extra.used_slots = amalgam.ability.extra.used_slots + 1 
                    

                        amalgam.ability.extra.stored_jokers[amalgam.ability.extra.current_slot] = joker_2.config.center
                        
                        amalgam.ability.extra.current_slot = amalgam.ability.extra.current_slot + 1
                        amalgam.ability.extra.used_slots = amalgam.ability.extra.used_slots + 1
                        
                        sendDebugMessage("[Carnival] amalgam.ability.extra: " .. inspectDepth(amalgam.ability.extra, 4, 5))

                        G.jokers:emplace(amalgam)

                        -- Remove the selected jokers from G.jokers
                        SMODS.destroy_cards(joker_1, true)
                        SMODS.destroy_cards(joker_2, true)
                    end
                end
            end
        end
    end
end



-- In base Balatro, you can't select multiple jokers, so we need to create a consumable that allows the player to merge two jokers into an amalgam.
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
