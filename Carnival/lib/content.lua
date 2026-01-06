SMODS.Atlas{
    key = "atlas_temp_jokers",
    path = "Jokers.png",
    px = 71,
    py = 95
}
SMODS.Atlas{
    key = "atlas_jokers",
    path = "CarnivalJokerSpriteSheet.png",
    px = 71,
    py = 95
}

-- Initialize the custom quest pool
if not G.P_JOKER_POOLS then G.P_JOKER_POOLS = {} end
G.P_JOKER_POOLS.carnival_quest = {}

