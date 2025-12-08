
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
-- TODO come up with a better name and quest
SMODS.Joker{
    key = "hearts_quest",
    atlas = "atlasjokers",
    pos = { x = 2, y = 0 },
    loc_txt = {
        name = "Hearts Quest",
        text = {
            "After playing #2# heart cards",
            "This joker gives you {X:mult}#3#{} chips and mult",
            "Currently #1#/#2#"
        }
    },
    config = {
        immutable = {
            Emult = 1.5,
            Echips = 1.5,
            played_hearts = 0,
            --TODO change to 100 once testing is done
            goal = 1,
        },
    },
    rarity = "carnival_quest",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(center.ability.immutable.played_hearts),
				number_format(center.ability.immutable.goal),
				number_format(center.ability.immutable.Emult),
            }
        }
    end,
    --TODO sound effects for this should feel more powerful than the normal joker sound
    calculate = function(self, card, context)

        if context.before and context.cardarea == G.play then
            
        end
        --should check which cards are hearts before the hand scores
            --after that, add the number of played heart cards to "played_hearts"

        --should have another check AFTER all the cards score
            --during this moment, check if "played_hearts" is >= "goal"
            --If it is, then should raise the chips and mult to the power of 1.5
                --TODO look for an Emult and Echips function
        
    end,
}