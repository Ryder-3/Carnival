local start_run_ref = Game.start_run
function Game:start_run(args)

    start_run_ref(self, args)

    --Make the Carnival table
    if not G.GAME.Carnival then
        G.GAME.Carnival = {}
    end


    --Make the table for the Minor Arcana values
    if not G.GAME.Carnival.Rank_level_up_values then
        G.GAME.Carnival.Rank_leveling_values = {
            Ace = { chips = 1, mult = 13},
            King = { chips = 2, mult = 12},
            Queen = { chips = 3, mult = 11},
            Jack = { chips = 4, mult = 10},
            ["10"] = { chips = 5, mult = 9},
            ["9"] = { chips = 6, mult = 8},
            ["8"] = { chips = 7, mult = 7},
            ["7"] = { chips = 8, mult = 6},
            ["6"] = { chips = 9, mult = 5},
            ["5"] = { chips = 10, mult = 4},
            ["4"] = { chips = 11, mult = 3},
            ["3"] = { chips = 12, mult = 2},
            ["2"] = { chips = 13, mult = 1},
        }
    end

end