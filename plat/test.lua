local level = require "levels/lvl_1"

function loadLevel(level)
	local objects = level.layers[1].objects
	for i=1,#objects do
		local obj = objects[i]
		print(tostring(obj.x))
	end
end

loadLevel(level)
