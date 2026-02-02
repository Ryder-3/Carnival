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
        if not self._quest_jokers then
            self._quest_jokers = {"hearts_quest", "spades_quest", "diamonds_quest", "clubs_quest"}
        end
        local key = self._quest_jokers[i] or self._quest_jokers[1]
        return { set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key = key }
    end
}