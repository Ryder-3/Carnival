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
    
    create_card = function(self, card, i)
        -- Build a list of quest jokers that are NOT owned
        local available_quests = {}
        local quest_suits = {"hearts", "spades", "clubs", "diamonds"}  
        for _, joker in ipairs(quest_suits) do
            if tablecontains(G.jokersn, "j_"..joker.."_quest") then
                table.insert(available_quests, joker)
            else
                table.insert(available_quests, "j_joker")
            end
        end
        return create_card("Joker", G.pack_cards, nil, nil, true, true, available_quests[i], nil)
    end
}