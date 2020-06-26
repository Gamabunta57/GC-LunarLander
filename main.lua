require("src/gamestate")

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    print("debug on")
    require("lldebugger").start()
    io.stdout:setvbuf('no')
end

window = {};
gameState = GameState:new();
gameState:init()

function love.load()
    window = Vector.new(love.graphics.getWidth(), love.graphics.getHeight());
    love.math.setRandomSeed(love.timer.getTime())
    gameState.bgScreen:reset();
    gameState:setState(gameState.titleScreen);
    gameState.currentState:reset();
end

function love.update(dt)
    gameState.currentState:update(dt)

    if(gameState.hasAskForStateChange()) then
        gameState:setState(gameState.newState)
        gameState.currentState:reset()
    end 
end

function love.draw()
    gameState.bgScreen:draw()
    gameState.currentState:draw()
end

function love.keypressed(key)
    gameState.currentState:keyPressed(key)
end


local sounds = {
    menuChangeItem = AudioEngine.getSound("sounds/menu_item_change.wav"),
    menuConfirm = AudioEngine.getSound("sounds/menu_item_confirm.wav"),
    menuCancel = AudioEngine.getSound("sounds/menu_cancel.wav"),
    engineOn = AudioEngine.getLoop("sounds/thruster2.wav"),
    spaceshippCrash = AudioEngine.getSound("sounds/crash5.wav"),
}

local musics = {
    bg = AudioEngine.getLoop("sounds/Andromeda Journey.mp3")
}

love.handlers.menuChangeItem = function() AudioEngine.playSound(sounds.menuChangeItem) end
love.handlers.menuConfirm = function() AudioEngine.playSound(sounds.menuConfirm) end
love.handlers.menuCancel = function() AudioEngine.playSound(sounds.menuCancel) end
love.handlers.startBgMusic = function() AudioEngine.playSound(musics.bg) end
love.handlers.spaceshipEngineOn = function() AudioEngine.playSound(sounds.engineOn) end
love.handlers.spaceshipEngineOff = function() AudioEngine.stopSound(sounds.engineOn) end
love.handlers.spaceshipLanded = function() end
love.handlers.spaceshipCrashed = function() AudioEngine.playSound(sounds.spaceshippCrash) end