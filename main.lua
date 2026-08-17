Game = require("game")
Menu = require("menu")
State = nil
local funcs = require("functions")
function love.load()
	love.graphics.setBackgroundColor(3 / 255, 223 / 255, 252 / 255, 1)
	funcs.SwitchState(Menu)
end
function love.update(dt)
	if State.update then State.update(dt) end
end
function love.draw()
	if State.draw then State.draw() end
end