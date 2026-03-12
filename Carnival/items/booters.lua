--Quest pack
--Pick one of the four quest jokers to get
--TODO Make it so the weight scales based on the amount of owned quests
SMODS.Booster {
    key = "hungry_pack",
    loc_txt = {
        name = "Hungry Pack",
        text = {
            "Choose {C:attention}#1#{} of the",
            "{C:attention}#2#{} Hungry Jokers",
            "to add to your joker slots."
        },
        group_name = "Hungry Pack",
    },
    --TODO: make an actual booster atlas and put this in it
    atlas = "atlas_temp_jokers",
    pos = {x = 0, y = 0},
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose, card.ability.extra
            }
        }
    end,
    config = {
        extra = 4,
        choose = 1
    },
    
    
    create_card = function(self, card, i)
        
        if i == 1 then
            
            -- Makes sure that the player doesn't already own the joker
            for index, joker in ipairs(G.jokers.cards) do
                if joker.label == "j_carnival_hearts_quest" then
                    ---@diagnostic disable-next-line: return-type-mismatch
                    return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
                end
            end
            ---@diagnostic disable-next-line: return-type-mismatch
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_hearts_quest")

        elseif i == 2 then

            for index, joker in ipairs(G.jokers.cards) do
                if joker.label == "j_carnival_spades_quest" then
                    ---@diagnostic disable-next-line: return-type-mismatch
                    return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
                end
            end
            ---@diagnostic disable-next-line: return-type-mismatch
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_spades_quest")

        elseif i == 3 then

            for index, joker in ipairs(G.jokers.cards) do
                if joker.label == "j_carnival_diamonds_quest" then
                    ---@diagnostic disable-next-line: return-type-mismatch
                    return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
                end
            end

            ---@diagnostic disable-next-line: return-type-mismatch
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_diamonds_quest")

        elseif i == 4 then

            for index, joker in ipairs(G.jokers.cards) do
                if joker.label == "j_carnival_clubs_quest" then
                    ---@diagnostic disable-next-line: return-type-mismatch
                    return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
                end
            end

            ---@diagnostic disable-next-line: return-type-mismatch
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_clubs_quest")

        else

            ---@diagnostic disable-next-line: return-type-mismatch
            return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
        end

    end
}

-- Minor Arcana Pack
-- Pick 1 of 3 Minor arcana cards
SMODS.Booster {
    key = "minor_arcana_pack",
    loc_txt = {
        name = "Minor Arcana Pack",
        text = {
            "Pick 1 of 3 {C:attention} Minor Arcana {}to be used immediately"
        },
        group_name = "Minor Arcana"
    },
    atlas = "atlas_temp_jokers",
    pos = { x = 0, y = 0},
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose, card.ability.extra
            }
        }
    end,
    config = {
        extra = 3,
        choose = 1
    },
    create_card = function(self, card, i)
        card = SMODS.create_card({set = "carnival_minor_arcana", area = G.pack_cards, skip_materialize = true})
        --- @diagnostic disable-next-line:return-type-mismatch
        return card
    end,
}

-- Jumbo Minor Arcana Pack
-- Pick 1 of 5 Minor arcana cards
SMODS.Booster {
    key = "jumbo_minor_arcana_pack",
        loc_txt = {
            name = "Jumbo Minor Arcana Pack",
            text = {
                "Pick 1 of 5 {C:attention} Minor Arcana {}to be used immediately"
            },
            group_name = "Minor Arcana"
        },
        atlas = "atlas_temp_jokers",
        pos = { x = 0, y = 0},
        discovered = true,
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.choose, card.ability.extra
                }
            }
        end,
        config = {
            extra = 5,
            choose = 1
        },
        create_card = function(self, card, i)
            card = SMODS.create_card({set = "carnival_minor_arcana", area = G.pack_cards, skip_materialize = true})
            --- @diagnostic disable-next-line:return-type-mismatch
            return card
        end,
}

-- Mega Minor Arcana Pack
-- Pick 2 of 5 Minor arcana cards
SMODS.Booster {
    key = "mega_minor_arcana_pack",
        loc_txt = {
            name = "Mega Minor Arcana Pack",
            text = {
                "Pick 2 of 5 {C:attention} Minor Arcana {}to be used immediately"
            },
            group_name = "Minor Arcana"
        },
        atlas = "atlas_temp_jokers",
        pos = { x = 0, y = 0},
        discovered = true,
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.choose, card.ability.extra
                }
            }
        end,
        config = {
            extra = 5,
            choose = 2
        },
        create_card = function(self, card, i)
            card = SMODS.create_card({set = "carnival_minor_arcana", area = G.pack_cards, skip_materialize = true})
            --- @diagnostic disable-next-line:return-type-mismatch
            return card
        end,
}