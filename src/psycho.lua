local width = 13
local height = 40
local imgs = {}
local frames = {}
local timings = {}
local walk_speed = {}

-- Bounding box for collisions
local nw_x = -3
local nw_y = 0
local se_x = 3
local se_y = 0

-- Images and animations
local timestep=0.07
local fac=1
imgs["left"]    = love.graphics.newImage("graphics/seg_right.png")
frames["left"]  = 1
timings["left"] = timestep
walk_speed["left"]   = {fac*1}

imgs["right"]   = imgs["left"]
frames["right"] = 1
timings["right"]= timings["left"]
walk_speed["right"]  = walk_speed["left"]

imgs["up"]      = love.graphics.newImage("graphics/seg_up.png")
frames["up"]    = 1
timings["up"]   = timestep
walk_speed["up"]     = {fac*1}

imgs["down"]    = love.graphics.newImage("graphics/seg_down.png")
timings["down"] = timestep
frames["down"]  = 1
walk_speed["down"]   = {fac*1}

imgs["idle_right1"]   = love.graphics.newImage("graphics/seg_right.png")
timings["idle_right1"]= timestep
frames["idle_right1"] = 1

imgs["idle_right2"]   = love.graphics.newImage("graphics/seg_right.png")
timings["idle_right2"]= timestep
frames["idle_right2"] = 1

imgs["idle_right3"]   = love.graphics.newImage("graphics/seg_right.png")
timings["idle_right3"]= timestep
frames["idle_right3"] = 1

imgs["idle_up1"]   = love.graphics.newImage("graphics/seg_up.png")
timings["idle_up1"]= timestep
frames["idle_up1"] = 1

imgs["idle_down1"]   = love.graphics.newImage("graphics/seg_down.png")
timings["idle_down1"]= timestep
frames["idle_down1"] = 1

function Psycho(x, y, z)
	-- Build opts for characters
	local opts = {}
	for _, i in ipairs({"left", "right", "up", "down"}) do
		opts[i] = {
			image = imgs[i],
			width = width,
			height = height,
			frames = frames[i],
			timings = timings[i],
			walk_speed = walk_speed[i],
		}
	end

	-- Left animation is same as right put flipped
	opts["left"].flipHorizontal = true

	-- Various idle animations
	opts["idle_left"] = {}
	opts["idle_right"] = {}
	opts["idle_up"] = {}
	opts["idle_down"] = {}
	for i = 1, 3 do
		opts["idle_left"][i] = {
			image = imgs["idle_right" .. i],
			width = width,
			height = height,
			frames = frames["idle_right" .. i],
			timings = timings["idle_right" .. i],
			flipHorizontal = true,
			walk_speed = 0
		}
	end
	for i = 1, 3 do
		opts["idle_right"][i] = {
			image = imgs["idle_right" .. i],
			width = width,
			height = height,
			frames = frames["idle_right" .. i],
			timings = timings["idle_right" .. i],
			walk_speed = 0
		}
	end
	for i = 1, 1 do
		opts["idle_up"][i] = {
			image = imgs["idle_up" .. i],
			width = width,
			height = height,
			frames = frames["idle_up" .. i],
			timings = timings["idle_up" .. i],
			walk_speed = 0
		}
	end
	for i = 1, 1 do
		opts["idle_down"][i] = {
			image = imgs["idle_down" .. i],
			width = width,
			height = height,
			frames = frames["idle_down" .. i],
			timings = timings["idle_down" .. i],
			walk_speed = 0
		}
	end

	local self = Character(x, y, z, nw_x, nw_y, se_x, se_y, opts)
	--self.draw_bounds = true

	self.onAnimationCallback=nil
	local psy_dx=0
	local psy_dy=0
	self.get_dx=function()
		return psy_dx
	end
	self.get_dy=function()
		return psy_dy
	end

	function self.move(dx_, dy_)
		local oldState = current_state
		if dx_ > 0 then
			psy_dx=psy_dx+.32
		elseif dx_ < 0 then
			psy_dx=psy_dx-.32
		end
		if dy_ > 0 then
			psy_dy=psy_dy+.32
		elseif dy_ < 0 then
			psy_dy=psy_dy-.32
		end


		if dx_ > 0 then
			self.setState("right")
		elseif dx_ < 0 then
			self.setState("left")
		elseif dy_ > 0 then
			self.setState("down")
		elseif dy_ < 0 then
			self.setState("up")
		else
			if     oldState=="left" then
				self.setState("idle_left")
			elseif oldState=="right" then
				self.setState("idle_right")
			elseif oldState=="up" then
				self.setState("idle_up")
			elseif oldState=="down" then
				self.setState("idle_down")
			end
		end
		psy_dx=psy_dx*.95
		psy_dy=psy_dy*.95
		-- print("vitesse")
		-- print(psy_dx)
		-- print(psy_dy)
		if not self.walkRelative(psy_dx, psy_dy) then
			-- if not love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
			-- 	-- psy_dx=-psy_dx*.5
			-- 	psy_dx=0
			-- end
			-- if not love.keyboard.isDown("up") and not love.keyboard.isDown("down") then
			-- 	-- psy_dy=-psy_dy*.5
			-- 	psy_dy=0
			-- end
			local xxx=psy_dx
			local yyy=psy_dy

			-- if psy_dx==0 then xxx=0
			-- elseif psy_dx<0 then xxx=-1
			-- else xxx=1
			-- end

			-- if psy_dy==0 then yyy=0
			-- elseif psy_dy<0 then yyy=-1
			-- else yyy=1
			-- end

			if not self.canWalk(self.x,self.y,self.x+xxx,self.y) then
				psy_dx=-psy_dx*.7
			end
			if not self.canWalk(self.x,self.y,self.x,self.y+yyy) then
				psy_dy=-psy_dy*.7
			end
		end
	end

	return self
end
