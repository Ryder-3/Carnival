local start_run_ref = Game.start_run
---@diagnostic disable-next-line: duplicate-set-field
function Game:start_run(args)
    start_run_ref(self, args)

    --Make the Carnival table
    if not G.GAME.Carnival then
        G.GAME.Carnival = {}
    end

    --Make the table for the Minor Arcana values
    if not G.GAME.Carnival.Rank_level_up_values then
        G.GAME.Carnival.Rank_leveling_values = {
            Ace = { chip_mod = 1, mult_mod = 13 },
            King = { chip_mod = 2, mult_mod = 12 },
            Queen = { chip_mod = 3, mult_mod = 11 },
            Jack = { chip_mod = 4, mult_mod = 10 },
            ["10"] = { chip_mod = 5, mult_mod = 9 },
            ["9"] = { chip_mod = 6, mult_mod = 8 },
            ["8"] = { chip_mod = 7, mult_mod = 7 },
            ["7"] = { chip_mod = 8, mult_mod = 6 },
            ["6"] = { chip_mod = 9, mult_mod = 5 },
            ["5"] = { chip_mod = 10, mult_mod = 4 },
            ["4"] = { chip_mod = 11, mult_mod = 3 },
            ["3"] = { chip_mod = 12, mult_mod = 2 },
            ["2"] = { chip_mod = 13, mult_mod = 1 },
        }
    end

    --Make the table that holds the current suit levels
    if not G.GAME.Carnival.current_suit_levels then
        G.GAME.Carnival.current_suit_levels = {
            Hearts = 0,
            Diamonds = 0,
            Spades = 0,
            Clubs = 0,
        }
    end

    --Make the table that holds current rank levels
    if not G.GAME.Carnival.current_rank_levels then
        G.GAME.Carnival.current_rank_levels = {
            Ace = 0,
            King = 0,
            Queen = 0,
            Jack = 0,
            ["10"] = 0,
            ["9"] = 0,
            ["8"] = 0,
            ["7"] = 0,
            ["6"] = 0,
            ["5"] = 0,
            ["4"] = 0,
            ["3"] = 0,
            ["2"] = 0,
        }
    end
end

-- Makes sure that the minor arcana tables are initialized
function Ensure_minor_arcana_tables()
    if not G.GAME then
        G.GAME = {}
    end
    if not G.GAME.Carnival then
        G.GAME.Carnival = {}
    end
    if not G.GAME.Carnival.current_suit_levels then
        G.GAME.Carnival.current_suit_levels = {
            Hearts = 0,
            Diamonds = 0,
            Spades = 0,
            Clubs = 0,
        }
    end
    if not G.GAME.Carnival.current_rank_levels then
        G.GAME.Carnival.current_rank_levels = {
            Ace = 0,
            King = 0,
            Queen = 0,
            Jack = 0,
            ["10"] = 0,
            ["9"] = 0,
            ["8"] = 0,
            ["7"] = 0,
            ["6"] = 0,
            ["5"] = 0,
            ["4"] = 0,
            ["3"] = 0,
            ["2"] = 0,
        }
    end
end