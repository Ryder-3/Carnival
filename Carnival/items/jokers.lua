
--Test Joker (use this as a template for new jokers)
--[[SMODS.Joker{
    key = "test_joker",
    atlas = "atlasjokers",
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = "Test Joker",
        text = {"A joker to test with",
                "And here is a second line of text",
                "{C:attention}Color{} {X:mult}is{} cool!"}
    },
    cost = 5,
    config = {
        extra = {
            Xmult = 2,
            chips = 10,
        }
    },
    local_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult,
                        center.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = "X" .. card.ability.extra.Xmult .. "mult",
                color = G.C.MULT
            }
        end
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            return {
                card = card,
                chip_mod = card.ability.extra.chips,
                message = "+" .. card.ability.extra.chips .. " chips",
                color = G.C.MULT
            }
        end
    end,
}]]

-- Hearts quest joker
-- Idea: Ryder
-- Coder: Ryder
--[[ TODO come up with a better name and quest]]
SMODS.Joker{
    key = "hearts_quest",
    atlas = "atlasjokers",
    pos = { x = 1, y = 0 },
    set = "carnival_quest",
    loc_txt = {
        name = "Hearts Quest",
        text = {
            "After playing #2# heart cards",
            "Scored hearts give {X:dark_edition,C:white}^#3#{} chips and mult",
            "Currently #1#/#2#"
        }
    },
    config = {
            Emult = 1.5,
            Echips = 1.5,
            played_hearts = 0,
            goal = 100,
    },
    rarity = "carnival_quest",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.played_hearts,
				card.ability.goal,
				card.ability.Emult,
                card.ability.Echips,
            }
        }
    end,
    --TODO sound effects for this should feel more powerful than the normal joker sound
    calculate = function(self, card, context)

        --The logic for making progress on the joker.
        if context.before and not context.blueprint and not context.retrigger_joker then
            local heart_played = false
            local num_hearts = 0
            for _, played_card in ipairs(context.scoring_hand) do
                if played_card:is_suit('Hearts') then
                    card.ability.played_hearts = card.ability.played_hearts + 1
                    heart_played = true
                    num_hearts = num_hearts + 1
                end
            end
            if heart_played and card.ability.played_hearts - num_hearts < card.ability.goal then
                return {
                    card = card,
                    message = card.ability.played_hearts .. "/" .. card.ability.goal,
                    colour = G.C.HEARTS
                }
            end
        end

        --Logic for the scoring after the quest is done
        --TODO Try and make there be two triggers
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            if card.ability.goal < card.ability.played_hearts then
                for _, played_card in ipairs(context.scoring_hand) do
                    if played_card:is_suit('Hearts') then
                        return {
                            message = {"^1.5 Chips and Mult!"},
                            Echip_mod = lenient_bignum(card.ability.Echips),
                            Emult_mod = lenient_bignum(card.ability.Emult),
				            colour = G.C.DARK_EDITION,
                        }
                    end
                end
            end
        end
    end
}

-- Spades quest joker
-- Idea: Ryder
-- Coder: Ryder
--[[ TODO come up with a better name and quest]]
SMODS.Joker{
    key = "spades_quest",
    atlas = "atlasjokers",
    pos = { x = 1, y = 0 },
    set = "carnival_quest",
    loc_txt = {
        name = "Spades Quest",
        text = {
            "After playing #2# spade cards",
            "scored spades give {X:dark_edition,C:white}^#3#{} chips and mult",
            "Currently #1#/#2#"
        }
    },
    config = {
            Emult = 1.5,
            Echips = 1.5,
            played_spades = 0,
            goal = 100,
    },
    rarity = "carnival_quest",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.played_spades,
				card.ability.goal,
				card.ability.Emult,
                card.ability.Echips,
            }
        }
    end,
    --TODO sound effects for this should feel more powerful than the normal joker sound
    calculate = function(self, card, context)

        --The logic for making progress on the joker.
        if context.before and not context.blueprint and not context.retrigger_joker then
            local spades_played = false
            local num_spades = 0
            for _, played_card in ipairs(context.scoring_hand) do
                if played_card:is_suit('Spades') then
                    card.ability.played_spades = card.ability.played_spades + 1
                    spades_played = true
                    num_spades = num_spades + 1
                end
            end
            if spades_played and card.ability.played_spades - num_spades < card.ability.goal then
                return {
                    card = card,
                    message = card.ability.played_spades .. "/" .. card.ability.goal,
                    colour = G.C.SPADES
                }
            end
        end

        --Logic for the scoring after the quest is done
        --TODO Try and make there be two triggers
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            if card.ability.goal < card.ability.played_spades then
                for _, played_card in ipairs(context.scoring_hand) do
                    if played_card:is_suit('Spades') then
                        return {
                            message = {"^1.5 Chips and Mult!"},
                            Echip_mod = lenient_bignum(card.ability.Echips),
                            Emult_mod = lenient_bignum(card.ability.Emult),
				            colour = G.C.DARK_EDITION,
                        }
                    end
                end
            end
        end
    end
}
-- Diamonds quest joker
-- Idea: Ryder
-- Coder: Ryder
--[[ TODO come up with a better name and quest]]
SMODS.Joker{
    key = "diamonds_quest",
    atlas = "atlasjokers",
    pos = { x = 1, y = 0 },
    set = "carnival_quest",
    loc_txt = {
        name = "Diamonds Quest",
        text = {
            "After playing #2# diamond cards",
            "scored diamonds give {X:dark_edition,C:white}^#3#{} chips and mult",
            "Currently #1#/#2#"
        }
    },
    config = {
            Emult = 1.5,
            Echips = 1.5,
            played_diamonds = 0,
            goal = 100,
    },
    rarity = "carnival_quest",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.played_diamonds,
				card.ability.goal,
				card.ability.Emult,
                card.ability.Echips,
            }
        }
    end,
    --TODO sound effects for this should feel more powerful than the normal joker sound
    calculate = function(self, card, context)

        --The logic for making progress on the joker.
        if context.before and not context.blueprint and not context.retrigger_joker then
            local diamonds_played = false
            local num_diamonds = 0
            for _, played_card in ipairs(context.scoring_hand) do
                if played_card:is_suit('Diamonds') then
                    card.ability.played_diamonds = card.ability.played_diamonds + 1
                    diamonds_played = true
                    num_diamonds = num_diamonds + 1
                end
            end
            if diamonds_played and card.ability.played_diamonds - num_diamonds < card.ability.goal then
                return {
                    card = card,
                    message = card.ability.played_diamonds .. "/" .. card.ability.goal,
                    colour = G.C.DIAMONDS
                }
            end
        end

        --Logic for the scoring after the quest is done
        --TODO Try and make there be two triggers
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            if card.ability.goal < card.ability.played_diamonds then
                for _, played_card in ipairs(context.scoring_hand) do
                    if played_card:is_suit('Diamonds') then
                        return {
                            message = {"^1.5 Chips and Mult!"},
                            Echip_mod = lenient_bignum(card.ability.Echips),
                            Emult_mod = lenient_bignum(card.ability.Emult),
				            colour = G.C.DARK_EDITION,
                        }
                    end
                end
            end
        end
    end
}
-- Clubs quest joker
-- Idea: Ryder
-- Coder: Ryder
--[[ TODO come up with a better name and quest]]
SMODS.Joker{
    key = "clubs_quest",
    atlas = "atlasjokers",
    pos = { x = 1, y = 0 },
    set = "carnival_quest",
    loc_txt = {
        name = "Clubs Quest",
        text = {
            "After playing #2# club cards",
            "Scored clubs give {X:dark_edition,C:white}^#3#{} chips and mult",
            "Currently #1#/#2#"
        }
    },
    config = {
            Emult = 1.5,
            Echips = 1.5,
            played_clubs = 0,
            goal = 100,
    },
    rarity = "carnival_quest",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.played_clubs,
				card.ability.goal,
				card.ability.Emult,
                card.ability.Echips,
            }
        }
    end,
    --TODO sound effects for this should feel more powerful than the normal joker sound
    calculate = function(self, card, context)

        --The logic for making progress on the joker.
        if context.before and not context.blueprint and not context.retrigger_joker then
            local clubs_played = false
            local num_clubs = 0
            for _, played_card in ipairs(context.scoring_hand) do
                if played_card:is_suit('Clubs') then
                    card.ability.played_clubs = card.ability.played_clubs + 1
                    clubs_played = true
                    num_clubs = num_clubs + 1
                end
            end
            if clubs_played and card.ability.played_clubs - num_clubs < card.ability.goal then
                return {
                    card = card,
                    message = card.ability.played_clubs .. "/" .. card.ability.goal,
                    colour = G.C.CLUBS
                }
            end
        end

        --Logic for the scoring after the quest is done
        --TODO Try and make there be two triggers
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            if card.ability.goal < card.ability.played_clubs then
                for _, played_card in ipairs(context.scoring_hand) do
                    if played_card:is_suit('Clubs') then
                        return {
                            message = {"^1.5 Chips and Mult!"},
                            Echip_mod = lenient_bignum(card.ability.Echips),
                            Emult_mod = lenient_bignum(card.ability.Emult),
				            colour = G.C.DARK_EDITION,
                        }
                    end
                end
            end
        end
    end
}

--Pity system joker
--idea Ryder
-- coder Ryder

-- TODO: Make a system that will actually calculate the death streak
--[[SMODS.joker {
    key = "pity_system",
    atlas = "atlasjokers",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Pity System",
        text = {
            "Gain {X:mult}x #1#{} mult for",
            "each death sense last win",
            "Currently {X:mult}x #3#{}"
        }
    },
    config = {
        mult_scaling = 2,
    },
}]]

