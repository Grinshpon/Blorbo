love.graphics.setDefaultFilter("nearest", "nearest")
local bump = require "collision/bump"
world = bump.newWorld()

player = {x=0,y=0,width=64,height=64,GRAVITY=1500,speed=300,xVelocity=0,yVelocity=0,FRICTION=1000,TERMINALV=1000,JUMP=-900,grounded=false,img=nil,left = false}
key = {down = love.keyboard.isDown}

function player.setPos(x,y)
	player.x,player.y = x,y
end

function player.update(dt)
	player.move(dt)
	player.gravity(dt)
	player.collide(dt)
end

function player.move(dt)
	function friction(dir)
	
	end
	if key.down("d","right") then
		player.xVelocity = player.speed
		player.left = false
	elseif key.down("a","left") then
		player.xVelocity = -player.speed
		player.left = true
	else 
		if player.left then
			if player.xVelocity < 0 then
				player.xVelocity = player.xVelocity + player.FRICTION*dt
			else
				player.xVelocity = 0
			end
		else
			if player.xVelocity > 0 then
				player.xVelocity = player.xVelocity - player.FRICTION*dt
			else
				player.xVelocity = 0
			end
		end
	end
end
function love.keypressed(key)
	if (key == "w" or key == "up" or key == " ") and player.grounded then
		player.grounded = false
		player.yVelocity = player.JUMP
	end
end

function player.gravity(dt)
	if player.yVelocity < player.TERMINALV then
		player.yVelocity = player.yVelocity + player.GRAVITY*dt
	else player.yVelocity = player.TERMINALV	
	end
end
Log,Log1 = 0,0--bugtest
function player.collide(dt)
	local futureX = player.x + player.xVelocity*dt
	local futureY = player.y + player.yVelocity*dt
	local nextX, nextY, cols, len = world:move(player, futureX, futureY)
	for i=1, len do
		local col = cols[i]
		if col.normal.y == -1 or col.normal.y == 1 then
			player.yVelocity = 0
		end 
		if col.normal.y == -1 then
			player.grounded = true
		end
		Log = col.normal.y --DELETE FOR FINAL PRODUCT
--[[col.normal.y does not work as intended. The value remains until the object interacts with another collision, until then, it will remain at the same value, allowing for double jumps when they are not intended--]]
	end
	if player.yVelocity ~= 0 then
		player.grounded = false
		Log1 = 1--DELETE FOR FINAL PRODUCT
	else
		Log1 = -1--DELETE FOR FINAL PRODUCT
	end
	player.x = nextX
	player.y = nextY
end

function player.draw()
	if player.left then 
		love.graphics.draw(player.img,player.x,player.y,0,-1,1,player.width,0)
	else
		love.graphics.draw(player.img,player.x,player.y)
	end
end

--local block = {x=0,y=500,width=64,height=64,img=nil}
--local block1 = {x=64,y=500,width=64,height=64,img=nil}

local level = require "lvl_1"

function loadLevel(level)
	local objects = level.layers[1].objects
	for i=1,#objects do
		local obj = objects[i]
		world:add(obj,obj.x,obj.y,obj.width,obj.height)
	end
end
function drawLevel(level)
	local objects = level.layers[1].objects
	for i=1,#objects do
		local obj = objects[i]
		love.graphics.draw(block_img,obj.x,obj.y)
	end
end

function love.load()
	world:add(player,player.x,player.y,player.width,player.height)
--	world:add(block,block.x,block.y,block.width,block.height)
--	world:add(block1,block1.x,block.y,block.width,block.height)
	player.setPos(64,64)
	player.img = love.graphics.newImage("player.png")
	block_img = love.graphics.newImage("shroom.png")
	love.graphics.setBackgroundColor(38,214,255)
	loadLevel(level)
end

function love.draw()
	player.draw()
	drawLevel(level)
	love.graphics.print(Log.." "..Log1.." "..tostring(player.grounded).." "..player.yVelocity,500,500,0,2,2) --[[(col.normal.y velocity player.grounded player.velocity) ::bugtesting, DELETE LATER--]]
end
--love.graphics.print({{0,0,0},Log.." "..Log1.." "..tostring(player.grounded).." "..player.yVelocity},500,500) 
function love.update(dt)
	player.update(dt)
end
