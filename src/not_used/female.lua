local imgs = {}
local frameCount = {}
local speed_right = {}
local speed_up = {}

for _, img in pairs(imgs) do
	img:setFilter("nearest")
end

function Dude(x, y, z, s)
	if s == 1 or s == "m" or s == "male" then
		imgs["left"] = love.graphics.newImage("graphics/male_right.png")
		imgs["right"] = love.graphics.newImage("graphics/male_right.png")
		imgs["up"] = love.graphics.newImage("graphics/male_up.png")
		imgs["down"] = love.graphics.newImage("graphics/male_down.png")
		frameCount["left"]=12
		frameCount["right"]=12
		frameCount["up"]=12
		frameCount["down"]=12

		imgs["idle1"] = love.graphics.newImage("graphics/male_idle1.png")
		imgs["idle2"] = love.graphics.newImage("graphics/male_idle2.png")
		imgs["idle3"] = love.graphics.newImage("graphics/male_idle3.png")
		frameCount["idle1"]=1
		frameCount["idle2"]=1
		frameCount["idle3"]=1

		speed_right = {1,2,1,1,1,2,1,2,1,1,1,2}
		speed_up    = {1,1,1,1,1,0,1,1,1,1,1,0}
		speed_down  = {0,1,1,1,1,1,0,1,1,1,1,1}
	end
	if s == 2 or s == "f" or s == "female" then
		imgs["left"] = love.graphics.newImage("graphics/fem_right.png")
		imgs["right"] = love.graphics.newImage("graphics/fem_right.png")
		imgs["up"] = love.graphics.newImage("graphics/fem_up.png")
		imgs["down"] = love.graphics.newImage("graphics/fem_down.png")
		frameCount["left"]=12
		frameCount["right"]=12
		frameCount["up"]=12
		frameCount["down"]=12

		imgs["idle1"] = love.graphics.newImage("graphics/fem_idle1.png")
		imgs["idle2"] = love.graphics.newImage("graphics/fem_idle2.png")
		imgs["idle3"] = love.graphics.newImage("graphics/fem_idle3.png")
		frameCount["idle1"]=26
		frameCount["idle2"]=18
		frameCount["idle3"]=39

		speed_right = {1,2,1,1,1,2,1,2,1,1,1,2}
		speed_up    = {1,1,1,1,1,0,1,1,1,1,1,0}
		speed_down  = {0,1,1,1,1,1,0,1,1,1,1,1}
	end



	local self = Object(x, y, z)

	-- local animate = true
	-- local timings = {0.07, 0.07, 0.07, 0.07, 0.07, 0.07,
	--                  0.07, 0.07, 0.07, 0.07, 0.07, 0.07}
	local animations = {}
	for k, img in pairs(imgs) do
		-- animations[k] = Animation(img, 13, 35, 12, timings)
		animations[k] = Animation(img, 13, 40, frameCount[k], timings)
	end

	local direction=1
	local state = "idle1"
	local animation = animations[state]

	function self.update(dt)
		local old_step = animation.anim_step()
		-- if animate then
			animation.update(dt)
		-- end
		local old_x = self.x
		local old_y = self.y

		if old_step~=animation.anim_step() then
			if state=="right" then
				self.x = self.x + speed_right[old_step]
			elseif state=="left" then
				self.x = self.x - speed_right[old_step]
			elseif state=="up" then
				self.y = self.y - speed_up[old_step]
			elseif state=="down" then
				self.y = self.y + speed_down[old_step]
			end
		end

		local old_ground = map.ground_height(old_x,old_y)
		local new_ground = map.ground_height(self.x,self.y)
		local heigh_step = old_ground - new_ground

 		--if you can jump there (no more than 5 pixels)
		if math.abs(heigh_step) < 5 then
			--if there is no holes in between
			local step = 1         -- up
			if heigh_step < 0 then -- or down
				step=-1
			end

			for i=1,math.abs(heigh_step) do
				if math.abs(map.ground_height(self.x,self.y) - map.ground_height(self.x,self.y+step))< 5 then
					self.y = self.y + step
				end
			end
		else
			self.x=old_x
			self.y=old_y
			self.move(0,0)
		end
		-- if not map.canWalk(self.x,self.y) then
		-- 	print("cannot move")
		-- 	-- self.move(0,0)
		-- end
	end

	function self.move(dx,dy)
		if dx > 0 then
			self.animation("right")
		elseif dx < 0 then
			self.animation("left")
		elseif dy > 0 then
			self.animation("down")
		elseif dy < 0 then
			self.animation("up")
		elseif not((state=="idle1") or (state=="idle2") or (state=="idle3")) then
			local r = math.random()
			r=math.ceil(r*3)
			if r==1 then
		 		self.animation("idle1")
		 	elseif r==2 then
		 		self.animation("idle2")
		 	elseif r==3 then
		 		self.animation("idle3")
		 	end
		end
	end	

	-- function self.animate(bool)
	-- 	if bool ~= animate then
	-- 		animate = bool
	-- 		animation.reset()
	-- 	end
	-- end

	function self.state()
		return state
	end

	function self.animation(name)
		if name == "left" then
			direction=-1
		elseif name=="right" then
			direction=1
		end

		state=name;

		if animation ~= animations[state] then
			animation = animations[state]
			animation.reset()
		end
	end

	function self.draw()
		-- original :     self.x - direction*4*6, self.y + 4*(3-40) , 0, direction*4,4) 
		   -- animation.draw(self.x - direction*24 , self.y - 148      , 0, direction*4,4)
		   animation.draw(self.x - direction*6 , self.y - 37      , 0, direction,1)
	end

	return self
end
