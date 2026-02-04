--Quest pack
--Pick one of the four quest jokers to get
--TODO Make it so the weight scales based on the amount of owned quests
SMODS.Booster {
    key = "quest_pack",
    loc_txt = {
        name = "Quest Pack",
        text = {
            "Choose {C:attention}#1#{} of the",
            "{C:attention}#2#{} Hungry Jokers",
            "to add to your joker slots."
        },
        group_name = "Pick 1",
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
                    return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
                end
            end
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_hearts_quest")

        elseif i == 2 then

            for index, joker in ipairs(G.jokers.cards) do
                if joker.label == "j_carnival_spades_quest" then
                    return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
                end
            end
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_spades_quest")

        elseif i == 3 then

            for index, joker in ipairs(G.jokers.cards) do
                if joker.label == "j_carnival_diamonds_quest" then
                    return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
                end
            end

            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_diamonds_quest")

        elseif i == 4 then

            for index, joker in ipairs(G.jokers.cards) do
                if joker.label == "j_carnival_clubs_quest" then
                    return create_card("Joker", G.pack_cards, nil, nil, true, true, "j_joker")
                end
            end

            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_clubs_quest")

        end
    end
}