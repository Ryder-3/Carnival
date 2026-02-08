-- Colors are temperary, change them when I actually know what they do
SMODS.ConsumableType {
    key = "carnival_minor_arcana",
    primary_colour = G.C.CHIPS,
    secondary_colour = G.C.MULT,
    shop_rate = 2,
    loc_txt = { collection = "Minor Arcana", name = "Minor Arcana" },
    collection_rows = { 4, 4 },
}

--This is a test Consumable. Remember to get rid of it.
SMODS.Consumable {
    key = "test_minor_arcana",
    set = "carnival_minor_arcana",
    loc_txt = {
        name = "Test Minor Arcana",
        text = {
            "hopefully, this levels up 2s",
            "I would be suprised though, I havent coded that part yet."
        }
    },
    atlas = "atlas_temp_jokers",
    pos = { x = 0, y = 0 },
    use = function(self, card, area, copier)
        sendDebugMessage("[Carnival] the test consumable worked!")
    end
}
