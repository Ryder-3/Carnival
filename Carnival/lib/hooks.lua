--On run start, make sure a G.GAME.Carnival table exists
local start_run_ref = Game.start_run
function Game:start_run(args)

    start_run_ref(self, args)

    --Make the Carnival table
    if not G.GAME.Carnival then
        G.GAME.Carnival = {}
    end

end