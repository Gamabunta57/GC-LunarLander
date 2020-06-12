require("src/gamestate")

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    print("debug on")
    require("lldebugger").start()
    io.stdout:setvbuf('no')
end

window = {};
gameState = GameState:new();

function love.load()
    window = Vector:new(love.graphics.getWidth(), love.graphics.getHeight());
    gameState:setState(gameState.titleScreen);
    gameState.currentState:reset();
end

function love.update(dt)
    gameState.currentState:update(dt)

    if(gameState.newState ~= gameState.currentState) then
        gameState:setState(gameState.newState)
        gameState.currentState:reset()
    end 
end

function love.draw()
    gameState.currentState:draw()
end