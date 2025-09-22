
---@class GameState
---@field [integer] GameState.gameState
---@field fps integer
---@field current GameState.gameState
GameState = {}
GameState.fps = 60
GameState.current = nil

---@return GameState.gameState
function GameState:new()
    ---@class GameState.gameState
    ---@field initialize fun(self:GameState.gameState)
    ---@field entered fun(self:GameState.gameState, previous:GameState.gameState)
    ---@field switched fun(self:GameState.gameState, to:GameState.gameState)
    ---@field update fun(self:GameState.gameState, dt:number)
    ---@field draw fun(self:GameState.gameState)
    local new = {}

    self[#self+1] = new

    return new
end

---@param to GameState.gameState
function GameState:switch(to)
    local cur = self.current
    if cur then self:run("switched", to) end
    self.current = to
    self:run("entered", cur)
end

---@param method string
---@param ... any
function GameState:run(method, ...)
    local cur = self.current
    if cur[method] then cur[method](cur, ...) end
end

function GameState:initialize()
    for _, state in ipairs(self) do
        if state.initialize then state:initialize() end
    end
end

local lt = love.timer
local nextTime
function love.load()
    nextTime = lt.getTime()

    GameState:initialize()
end

function love.update(dt)
    local timeDiff = nextTime - lt.getTime()
    if timeDiff > 0 then lt.sleep(timeDiff) end
    nextTime = nextTime + 1/GameState.fps

    GameState:run("update", dt)
end

function love.draw()
    GameState:run("draw")
end
