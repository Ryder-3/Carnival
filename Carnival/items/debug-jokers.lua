-- All of these jokers dump a different table into the console.
--[[SMODS.Joker{
    key = "G_DUMP",
    atlas = "atlas_temp_jokers",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "G DUMP",
        text = {
            "Upon getting this joker, G will be dumped into the console"
        }
    },
    add_to_deck = function()
        sendInfoMessage('[Carnival] G is currently ' .. inspect(G))
    end
}
SMODS.Joker{
    key = "G.jokers_DUMP",
    atlas = "atlas_temp_jokers",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "G.jokers DUMP",
        text = {
            "Upon getting this joker, G.jokers will be dumped into the console"
        }
    },
    add_to_deck = function()
        sendInfoMessage('[Carnival] G.jokers is currently ' .. inspect(G.jokers))
    end
}
--G.jokers.cards just stores the number of owned jokers. seemingly can't get anything else from this.
SMODS.Joker{
    key = "G.jokers.cards_DUMP",
    atlas = "atlas_temp_jokers",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "G.jokers.cards DUMP",
        text = {
            "Upon getting this joker, G.jokers.cards will be dumped into the console"
        }
    },
    add_to_deck = function()
        sendInfoMessage('[Carnival] G.jokers.cards is currently ' .. inspect(G.jokers.cards))
    end
}

SMODS.Joker{
    key = "feature_test",
    atlas = "atlas_temp_jokers",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Feature Test Joker",
        text = {
            "Upon obtaining this joker... something will happon",
            "something = Iterating through G.jokers.cards and printing the joker"
        }
    },
    add_to_deck = function()
        for index, joker in ipairs(G.jokers.cards) do
            sendDebugMessage(inspect(joker))
        end
    end
}
]] --
