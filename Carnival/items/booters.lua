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
    atlas = "atlasjokers",
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

        for _, suit in ipairs(quest_suits) do
            if not Carnival.owned_quests[suit] then
                table.insert(available_quests, "j_carnival_" .. suit .. "_quest")
            else
                table.insert(available_quests, "j_joker")
            end
        end

        -- If there are no available quests, return nil
        if #available_quests == 0 then
            return nil
        end

        -- Use the index to ensure variety in the pack
        local selected_key = available_quests[((i - 1) % #available_quests) + 1]

        return create_card("Joker", G.pack_cards, nil, nil, true, true, selected_key, nil)
    end
}