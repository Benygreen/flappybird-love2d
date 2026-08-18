local menu = {}
local funcs = require("functions")
local logo = love.graphics.newImage("logo.png")
local logoScale = 0.3
function menu.update()
    if love.keyboard.isDown("return") then
        funcs.SwitchState(Game)
    end
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end
function menu.draw()
    love.graphics.draw(logo, (love.graphics.getWidth() / 2) - ((logo:getWidth() * logoScale) / 2), 100, 0, logoScale)
    love.graphics.print({{0, 0, 0, 1}, "Press ENTER to start"}, 280, 200, 0, 2, 2)
    love.graphics.print({{0, 0, 0, 1}, "Press ESC to quit"}, 280, 230, 0, 2, 2)
end
return menu
