math.randomseed(os.time())

-- Colors are temperary, change them when I actually know what they do
SMODS.ConsumableType {
    key = "carnival_minor_arcana",
    primary_colour = G.C.CHIPS,
    secondary_colour = G.C.MULT,
    shop_rate = 2,
    loc_txt = { collection = "Minor Arcana", name = "Minor Arcana" },
    collection_rows = { 4, 4 },
}


-- Hooking into the functions that determine the scores of playing cards to add their level bonus
-- (Rank leveling + Spades chips; get_chip_mult is hooked again below for Clubs)
do
    local gcb = Card.get_chip_bonus
    function Card:get_chip_bonus()
        local ret = gcb(self)
        if not ret then return ret end
        -- Rank leveling
        if self.base and self.base.value and G.GAME and G.GAME.Carnival and G.GAME.Carnival.Rank_leveling_values then
            local level_bonus = (G.GAME.Carnival.Rank_leveling_values[self.base.value].chip_mod * (G.GAME.Carnival.current_rank_levels[self.base.value] or 0)) or 0
            ret = ret + level_bonus
        end
        -- Spades: +5 chips per Spade level
        if self.base and self.base.suit == "Spades" and G.GAME and G.GAME.Carnival and G.GAME.Carnival.current_suit_levels then
            ret = ret + 5 * (G.GAME.Carnival.current_suit_levels["Spades"] or 0)
        end
        return ret
    end

    local gcm = Card.get_chip_mult
    function Card:get_chip_mult()
        local ret = gcm(self)
        if not ret then return ret end
        -- Rank leveling
        if self.base and self.base.value and G.GAME and G.GAME.Carnival and G.GAME.Carnival.Rank_leveling_values then
            local level_bonus = (G.GAME.Carnival.Rank_leveling_values[self.base.value].mult_mod * (G.GAME.Carnival.current_rank_levels[self.base.value] or 0)) or 0
            ret = ret + level_bonus
        end
        -- Clubs: +0.7 mult per Club level
        if self.base and self.base.suit == "Clubs" and G.GAME and G.GAME.Carnival and G.GAME.Carnival.current_suit_levels then
            ret = ret + 0.7 * (G.GAME.Carnival.current_suit_levels["Clubs"] or 0)
        end
        return ret
    end
end


-- All of these bonuses are just the suit's uncommon joker, just 10 times worse
-- For each heart level, all hearts have a [heart_level] in 20 chance to give *1.5 mult
do
    local gcxm = Card.get_chip_x_mult
    function Card:get_chip_x_mult()
        local ret = gcxm(self)
        local is_heart = self.base and self.base.suit == "Hearts"
        if is_heart then
            if ret and self.base and self.base.suit then
                local spin = math.random(1, 20)
                -- I was going to use a fraction, which is why it's called numerator, but I realized I didn't need to do that. I couldn't come up with a better name.
                local numerator = G.GAME.Carnival.current_suit_levels[self.base.suit]

                -- If the heart level is greater than 20, the plater get a guaranteed bonus and a [level]-20 chance to get another bonus
                while numerator > 20 do
                    if ret < 1.5 then
                        ret = 1.5
                    else
                        ret = ret * 1.5
                    end
                    numerator = numerator - 20
                end

                -- The numerator is now less than 20, so we can use it to determine the chance to get another bonus
                if spin <= numerator then
                    if ret < 1.5 then
                        ret = 1.5
                    else
                        ret = ret * 1.5
                    end
                end
            end
        end
        return ret
    end
end

-- For each diamond level, all diamonds give 0.1 money
do
    local gpd = Card.get_p_dollars
    function Card:get_p_dollars()
        local ret = gpd(self)
        local is_diamond = self.base and self.base.suit == "Diamonds"
        if is_diamond then
            if not ret then
                ret = 0
            end
            if ret and self.base and self.base.suit then
                ret = ret + (0.1 * G.GAME.Carnival.current_suit_levels["Diamonds"])
            end
        end
        return ret
    end
end

-- Creates all the minor arcana cards
local suits = {{"Wands", "Hearts"}, {"Cups", "Spades"}, {"Pentacles", "Diamonds"}, {"Swords", "Clubs"}}
local rank_for_name = {"Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Knight", "Queen", "King"}
local rank_for_key = {"Ace", '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King'}

for _, suit_pair in ipairs(suits) do
    for rank_index, rank_name in ipairs(rank_for_name) do
        SMODS.Consumable {
        key = rank_for_key[rank_index] .. " of " .. suit_pair[1],
        set = "carnival_minor_arcana",
        loc_txt = {
            name = rank_name .. " of " .. suit_pair[1],
            text = {
                "Levels up {C:" .. string.lower(suit_pair[2]) .. "}#1#{} and {C:attention}#2#s{}",
                "Currently, {C:" .. string.lower(suit_pair[2]) .. "}#1#{} are level {C:attention}#3#{}",
                "and {C:attention}#2#s{} are level {C:attention}#4#{}",
            }
        },
        config = {
            extra = {
                suit = suit_pair[2],
                rank = rank_for_key[rank_index],
            },
        },
        loc_vars = function(self, info_queue, card)
            Ensure_minor_arcana_tables()
            local extra = (card and card.ability.extra) or self.config.extra
            local suit = extra.suit
            local rank = extra.rank
            local suit_level = G.GAME.Carnival.current_suit_levels[suit] or 0
            local rank_level = G.GAME.Carnival.current_rank_levels[rank] or 0
            return {
                vars = {
                    suit,
                    rank,
                    suit_level,
                    rank_level,
                },
            }
        end,
        cost = 4,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            local suit = suit_pair[2]
            local rank = rank_for_key[rank_index]
            G.GAME.Carnival.current_suit_levels[suit] = G.GAME.Carnival.current_suit_levels[suit] + 1 or 1
            G.GAME.Carnival.current_rank_levels[rank] = G.GAME.Carnival.current_rank_levels[rank] + 1 or 1

            -- Invalidate playing card tooltip cache so chips/mult/dollars text updates
            for _, c in ipairs(G.playing_cards or {}) do
                c.ability_UIBox_table = nil
            end

            card_eval_status_text(card, "extra", nil, 1, nil, {message = suit .. " leveled up!"})
            delay(0.6)
            card_eval_status_text(card, "extra", nil, 1, nil, {message = rank .. "s leveled up!"})
            delay(0.6)
        end,
        atlas = "atlas_temp_jokers",
        pos = { x = 0, y = 0 },
        }
    end
end


-- Hook SMODS.localize_perma_bonuses to show Hearts chance line (raw UI node, no localization)
do
    local lpb = SMODS.localize_perma_bonuses
    function SMODS.localize_perma_bonuses(specific_vars, desc_nodes)
        if specific_vars and specific_vars.carnival_hearts_x and desc_nodes then
            local h = specific_vars.carnival_hearts_x
            local level = h.level or 0
            local mult = h.mult or 1.5
            local sure_mult = 1
            while level > 20 do
                sure_mult = sure_mult * 1.5
                level = level - 20
            end
            local msg
            if sure_mult == 1 then
                msg = level .. "/20 chance for X " .. mult .. " Mult"
            else
                msg = level .. "/20 chance for X " .. mult .. " Mult and a guaranteed X " .. sure_mult .. " Mult"
            end
            -- This was causing crashes, so I'm just setting it manually
            local col = (G.C.MULT and copy_table(G.C.MULT)) or { 1, 0.5, 0.2, 1 }
            if not col[4] then col[4] = 1 end
            local text_node = { n = G.UIT.T, config = { text = msg, scale = 0.35, colour = col } }
            desc_nodes[#desc_nodes + 1] = { text_node }
        end
        return lpb(specific_vars, desc_nodes)
    end
end

-- Hook generate_card_ui so playing card tooltips use current level-based values
do
    local gcu = generate_card_ui
    function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
        if G.GAME and G.GAME.Carnival and card and (card_type == 'Default' or card_type == 'Enhanced') and specific_vars and specific_vars.playing_card and card.base then
            local total_chips = card:get_chip_bonus()
            local nominal = card.base.nominal or 0
            local extra_chips = total_chips - nominal
            specific_vars.bonus_chips = (extra_chips ~= 0) and extra_chips or nil

            local mult = card:get_chip_mult()
            specific_vars.bonus_mult = (mult ~= 0) and mult or nil

            -- Only override x_mult for Hearts; for Hearts show chance line instead of random value
            if card.base.suit == "Hearts" and G.GAME.Carnival.current_suit_levels["Hearts"] > 0 then
                specific_vars.bonus_x_mult = nil
                specific_vars.carnival_hearts_x = {
                    level = G.GAME.Carnival.current_suit_levels["Hearts"] or 0,
                    mult = 1.5
                }
            end

            local p_dollars = card:get_p_dollars()
            specific_vars.bonus_p_dollars = (p_dollars and p_dollars ~= 0) and p_dollars or nil
        end
        return gcu(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    end
end

