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
    create_card = function(self, card)
        
    end
}