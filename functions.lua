local funcs = {}
function funcs.LoadImageFromPath(filePath)
	local f = io.open(filePath, "rb")
	if f then
		local data = f:read("*all")
		f:close()
		if data then
			data = love.filesystem.newFileData(data, "tempname")
			data = love.image.newImageData(data)
			local image = love.graphics.newImage(data)
			return image
		end
	end
end
function funcs.SwitchState(newState)
	State = newState
	if State.load then State.load() end
end
return funcs