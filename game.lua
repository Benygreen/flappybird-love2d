local birdImage
local pipeImage
local xPosition = 100
local yPosition = 200
local velocity = 0
local gravity = 800
local flapStrength = -300
local pipes = {}
local pipeTimer = 0
local pipeInterval = 1.0
local pipeSpeed = 240
local pipeGap = 50
local pipeScale = 0.3
local flapped = false
local funcs = require("functions")
local score = 0
local game = {}
local sounds = {
	flap = love.audio.newSource("flap.mp3", "static"),
	score = love.audio.newSource("score.mp3", "static"),
	gameOver = love.audio.newSource("gameover.mp3", "static")
}
local function checkCollision(b1, b2)
	return b1[1] < b2[1] + b2[3] and
		   b2[1] < b1[1] + b1[3] and
		   b1[2] < b2[2] + b2[4] and
		   b2[2] < b1[2] + b1[4]
end
local function spawnPipePair()
	local screenHeight = love.graphics.getHeight()
	local gapY = love.math.random(150, screenHeight - pipeGap - 150)
	table.insert(pipes, {
		x = love.graphics.getWidth(),
		y = gapY - 1000,
		flipped = true
	})
	table.insert(pipes, {
		x = love.graphics.getWidth(),
		y = (gapY + pipeGap),
		flipped = false
	})
end
function game.load()
	love.window.setTitle("Flappy Bird")
	birdImage = funcs.LoadImageFromPath("bird.png")
	pipeImage = funcs.LoadImageFromPath("pipe.png")
	yPosition = 200
	pipes = {}
	score = 0
end
function game.update(dt)
	if love.keyboard.isDown("escape") then
		funcs.SwitchState(Menu)
	end
	local birdPaddingX = 4
	local birdPaddingY = 4
	local birdWidth = (birdImage:getWidth() / 10) - (birdPaddingX * 2)
	local birdHeight = (birdImage:getHeight() / 10) - (birdPaddingY * 2)
	local birdBoundingBox = {
		xPosition + birdPaddingX,
		yPosition + birdPaddingY,
		birdWidth,
		birdHeight
	}
	if yPosition > 500 or yPosition < 0 then
		funcs.SwitchState(Menu)
		sounds.gameOver:play()
	end
	velocity = velocity + gravity * dt
	local flapCondition = (love.keyboard.isDown("space") or love.keyboard.isDown("up") or love.keyboard.isDown("w"))
	if flapCondition and not flapped then
		flapped = true
		velocity = flapStrength
		sounds.flap:clone():play()
	elseif (not flapCondition) and flapped then
		flapped = false
	end
	pipeTimer = pipeTimer + dt
	if pipeTimer >= pipeInterval then
		pipeTimer = pipeTimer - pipeInterval
		spawnPipePair()
	end
	for i = #pipes, 1, -1 do
		local pipe = pipes[i]
		local pipePaddingX = 6
		local pipeWidth = (pipeImage:getWidth() * pipeScale) - (pipePaddingX * 2)
		local pipeHeight = pipeImage:getHeight() * pipeScale
		local pipeBoundingBox = {
			pipe.x + pipePaddingX,
			pipe.y + (pipeHeight * (pipe.flipped and 2.5 or 0)),
			pipeWidth,
			pipeHeight
		}
		if checkCollision(birdBoundingBox, pipeBoundingBox) then
			funcs.SwitchState(Menu)
			sounds.gameOver:play()
		end
		if pipe.x >= (xPosition - 1) and pipe.x <= (xPosition + 1) then
			score = score + 0.5
			sounds.score:clone():play()
		end
		pipe.x = pipe.x - pipeSpeed * dt
		if pipe.x + pipeImage:getWidth() * pipeScale < 0 then
			table.remove(pipes, i)
		end
	end
	yPosition = yPosition + velocity * dt
end
function game.draw()
	love.graphics.draw(birdImage, xPosition, yPosition, velocity / 500, 0.125, 0.125)
	for _, pipe in ipairs(pipes) do
		if pipe.flipped then
			love.graphics.draw(
				pipeImage,
				pipe.x,
				(pipe.y + pipeImage:getHeight()) + 30, 
				0,
				pipeScale,
				-pipeScale
			)
		else
			love.graphics.draw(
				pipeImage,
				pipe.x,
				pipe.y + 30,
				0,
				pipeScale,
				pipeScale
			)
		end
	end
	love.graphics.print({{0, 0, 0, 1}, "Score: " .. score}, 50, 50, 0, 2, 2)
end
return game
