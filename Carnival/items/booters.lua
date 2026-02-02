--Quest pack
--Pick one of the four quest jokers to get

SMODS.Booster {
    key = "quest_pack",
    loc_txt = {
        name = "Quest Pack",
        text = {
            "Choose {C:attention}#1#{} of the",
            "{C:attention}#2#{} quest cards to add to your",
            "joker slots."
        },
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
    
    --I'm pretty sure that create_card works like a for loop that gets iterated throgugh config.extra times
    create_card = function(self, card, i)
        if i == 1 then
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_hearts_quest")
        elseif i == 2 then
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_spades_quest")
        elseif i == 3 then
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_diamonds_quest")
        elseif i == 4 then
            return create_card("Joker", G.pack_cards, nil, "carnival_quest", true, true, "j_carnival_clubs_quest")
        end
    end
}