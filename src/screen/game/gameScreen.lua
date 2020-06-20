require("src/lib/vector")
require("src/spacecraft")
require("src/platform")
require("src/screen/screen")
require("src/screen/game/pauseState")
require("src/screen/game/playingState")

GameScreen = {}
setmetatable(GameScreen, Screen)
GameScreen.__index = GameScreen

function GameScreen:new()
    local screen = {
        spacecraft = Spacecraft:new(),
        platform = Platform:new(),
        gameStates = {},
        currentGameState = {}
    };

    screen.gameStates = {
        playing = PlayingState:new(screen), 
        pause = PauseState:new(screen)
    }
    screen.currentGameState = screen.gameStates.playing;

    setmetatable(screen, self);
    return screen;
end

function GameScreen:reset()    
    self.currentGameState = self.gameStates.playing;
    self.gameStates.playing:reset()
    self.gameStates.pause:reset();
end

function GameScreen:update(dt)
    self.currentGameState:update(dt)
end

function GameScreen:draw()
    self.currentGameState:draw()
end

function GameScreen:keyPressed(key)
    self.currentGameState:keyPressed(key)
end