-- Joker: OBJ_L: Creation Incarnate
-- Idea: Ryder
-- Coder: Ryder
-- Art: OBJ_Lily
-- As long as this joker is owned, the player has a negative consumable that allows them to merge two jokers into an amalgam.
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

    remove_from_deck = function(self, card)
        SMODS.destroy_cards(SMODS.find_card("c_carnival_objl_seal_of_creation"), true)
        SMODS.destroy_cards(SMODS.find_card("c_carnival_objl_seal_of_destruction"), true)
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
        }
    },
    config = {
        extra = {
            stored_jokers = {},
        },
    },
}


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
                local merge_area = CardArea(0, 0, G.jokers.T.w, G.jokers.T.h, {
                    type = "joker",
                    highlight_limit = 2,
                    card_limit = #G.jokers.cards - 1,
                })
                merge_area.config.card_limits.extra_slots_used = 0 --For some reason, the card limit is not being set correctly, so we need to set it manually
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

                        merge_area:emplace(copy)
                    end
                end

                -- Display the merge area in an overlay menu
                G.FUNCS.overlay_menu({
                    definition = create_UIBox_generic_options({
                        contents = {
                            {n = G.UIT.C, config = {align = "cm", padding = 0.2, r = 0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes = {
                                {n = G.UIT.O, config = {object = merge_area}}
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
