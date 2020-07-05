require("src/gameState")
require("src/sound/audioEngine")

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    print("debug on")
    require("lldebugger").start()
    io.stdout:setvbuf('no')
end

window = {};
gameState = GameState:new();
gameState:init()

fonts = {
    main = love.graphics.newFont("assets/A-Space Light Demo.otf", 15),
    title = love.graphics.newFont("assets/A-Space Light Demo.otf", 45)
}

colors = {
    main = {146 / 255, 211 / 255, 255 / 255, 1},
    bg = {0,0,0,0.6},
    spaceBg = {34 / 255, 32 / 255, 52 / 255, 1},
    success = {106 / 255, 190 / 255, 48 / 255},
    failed = {172  / 255, 50  / 255, 50  / 255},
    fuelBg = {172  / 255, 50  / 255, 50  / 255},
    fuel = {106 / 255, 190 / 255, 48 / 255},
    selected = {1,1,1,1},
    unselected = {146 / 255, 211 / 255, 255 / 255, 1}
}
function love.load()
    window = Vector.new(love.graphics.getWidth(), love.graphics.getHeight());
    love.math.setRandomSeed(love.timer.getTime())
    love.graphics.setFont(fonts.main)
    love.graphics.setColor(colors.main)
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
    menuChangeItem = audioEngine.getSound("sounds/menu_item_change.wav"),
    menuConfirm = audioEngine.getSound("sounds/menu_item_confirm.wav"),
    menuCancel = audioEngine.getSound("sounds/menu_cancel.wav"),
    engineOn = audioEngine.getLoop("sounds/thruster3.wav"),
    spaceshippCrash = audioEngine.getSound("sounds/crash5.wav"),
    yay = audioEngine.getSound("sounds/yay.wav"),
}

local musics = {
    bg = audioEngine.getLoop("sounds/Andromeda Journey-trimed.wav")
}

love.handlers.menuChangeItem = function() audioEngine.playSound(sounds.menuChangeItem) end
love.handlers.menuConfirm = function() audioEngine.playSound(sounds.menuConfirm) end
love.handlers.menuCancel = function() audioEngine.playSound(sounds.menuCancel) end
love.handlers.startBgMusic = function() audioEngine.playLoopOnce(musics.bg)end
love.handlers.spaceshipEngineOn = function() audioEngine.playLoopOnce(sounds.engineOn) end
love.handlers.spaceshipEngineOff = function() audioEngine.pauseSound(sounds.engineOn) end
love.handlers.spaceshipLanded = function() end
love.handlers.spaceshipCrashed = function() audioEngine.playSound(sounds.spaceshippCrash) end
love.handlers.victory = function() audioEngine.playSound(sounds.yay) end