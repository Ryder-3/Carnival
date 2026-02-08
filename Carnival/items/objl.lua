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
    }
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
        sendDebugMessage("[Carnival] the objl seal of creation worked!") --Test code
        SMODS.add_card({key = "j_carnival_objl_amalgam", G.jokers}) -- Test code
    end,
    keep_on_use = function(self, card)
        return true
    end
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
        sendDebugMessage("[Carnival] the objl seal of destruction worked!")
    end,
    keep_on_use = function(self, card)
        return true
    end
}
