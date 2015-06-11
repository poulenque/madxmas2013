function Character(x, y, z, nw_x, nw_y, se_x, se_y, opts)

-- x, y, z = Initial position
-- nw_x, nw_y, se_x, se_y = Bounding box as per doc in walk.lua
--
-- opts are like this:
-- opts = {
--     left = A,
--     right = A,
--     up = A,
--     down = A,
--     idle = A
-- }
-- where A is either
--   A = B
-- or
--   A = {B, B, B, B}  -- A list of one or more B
-- and where B is
-- B = {
--     images = love.graphics.newImage(...)
--     width = image width
--     height = image height
--     frames = number of frames
--     timings = number for timings of all animation steps or table
--               with one timing per animation frame
--     flipHorizontal = true to flip the animation horizontally
--     walk_speed = {0, 1, 1}  -- Deplacement speed for this animation
-- }

	local self = Walk(Object(x, y, z), nw_x, nw_y, se_x, se_y)

	local bot_state = true
	-- Those will be set bellow before returning self
	local current_opts, current_state

	-- Interesting functions inherited from Walk:
	-- setMap(map) set the map used for collisions

	for _, i in ipairs({"left", "right", "up", "down", "idle_left", "idle_right", "idle_up", "idle_down"}) do
		assert_table(opts[i])
		if #opts[i] > 0 then
			for _, o in pairs(opts[i]) do
				assert_number_or_table(o.walk_speed)
			end
		else
			assert_number_or_table(opts[i].walk_speed)
		end
	end

	function createAnimation(o)
		assert_userdata(o.image)
		assert_number(o.height)
		assert_number_or_table(o.timings)
		o.animation = Animation(o.image, o.width, o.height,
			o.frames, o.timings)
		o.animation.setOffset(-6, -37)
		if o.flipHorizontal then
			o.animation.setScale(-1, 1)
			-- o.animation.setOffset(o.width, 0)
			o.animation.setOffset(6, -37)
		end
	end

	for k, opts_state in pairs(opts) do
		if #opts_state > 0 then
			for k, opt in pairs(opts_state) do
				assert_table(opt)
				createAnimation(opt)
			end
		else
			assert_table(opts_state)
			createAnimation(opts_state)
		end
	end

	function self.move_random()
		local direction = 1-2*math.floor(2*math.random())
		local up_down   = 1-2*math.floor(2*math.random())
		if up_down==1 then
			self.move(direction,0)
		else
			self.move(0,direction)
		end
	end

	function self.onAnimationCallback(old_step, new_step)

		local walk_speed
		
		if old_step	> current_opts.frames then
			old_step=1
		end
		assert_number_or_table(current_opts.walk_speed)
		if type(current_opts.walk_speed) == "table" then
			walk_speed = current_opts.walk_speed[old_step]
		else
			walk_speed = current_opts.walk_speed
		end
		-- assert_number(walk_speed)
		local could_walk = false
		if current_state == "right" then
			could_walk=self.walkRelative(walk_speed, 0)
		elseif current_state == "left" then
			could_walk=self.walkRelative(-walk_speed, 0)
		elseif current_state == "up" then
			could_walk=self.walkRelative(0 ,-walk_speed)
		elseif current_state == "down" then
			could_walk=self.walkRelative(0 ,walk_speed)
		end

		if not could_walk then
			if bot_state then
				if math.random()<.7 then
					-- random other direction
					self.move_random()
					-- self.move(0,0)
				else
					self.move(0,0)
				end
			else
				self.move(0,0)
			end
		end
	end

	function self.get_dx()
		local walk_speed
		if type(current_opts.walk_speed) == "table" then
			walk_speed = current_opts.walk_speed[current_opts.animation.getStep()]
		else
			walk_speed = current_opts.walk_speed
		end
		if current_state == "right" then
			return walk_speed
		end
		return -walk_speed
	end
	function self.get_dy()
		local walk_speed
		if type(current_opts.walk_speed) == "table" then
			walk_speed = current_opts.walk_speed[current_opts.animation.getStep()]
		else
			walk_speed = current_opts.walk_speed
		end
		if current_state == "up" then
			return walk_speed
		end
		return -walk_speed
	end


	function self.bot_mode(b)
		if b then
			bot_state=true
			self.update= self.update_bot
		else
			bot_state=false
			self.update= self.update_controlled
		end
	end

	local bot_timing = 0
	function self.update_bot(dt)
		bot_timing=bot_timing-dt
		if bot_timing<0 then
			if math.random()>0.8 then
				--idle
				bot_timing = 2*math.random()
				self.move(0,0)
			else
				--random move
			
				--normal speed :
				bot_timing = math.log(1+20*math.random())
			
				--boost speed
				-- bot_timing = math.log(1+2*math.random())

				self.move_random()
			end
		end
		current_opts.animation.update(dt)
	end

	function self.update_controlled(dt)
		current_opts.animation.update(dt)
	end

	function self.update(dt)
	end

	self.update=self.update_bot

	function self.move(dx, dy)
		local oldState = current_state
		if dx > 0 then
			self.setState("right")
		elseif dx < 0 then
			self.setState("left")
		elseif dy > 0 then
			self.setState("down")
		elseif dy < 0 then
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
	end

	function self.setState(state)
		if current_state ~= state then
			current_state = state
			local possible_opts = opts[state]
			if #possible_opts > 0 then
				-- We have a list of opts; choose one randomly
				local choice = math.ceil(math.random() * #possible_opts)
				current_opts = possible_opts[choice]
			else
				-- Only one opts
				current_opts = possible_opts
			end
			current_opts.animation.reset()

			-- We could also set the callback of all animation at initialisation
			-- but it's more code to write and I'm feeling lazy
			current_opts.animation.setCallback(self.onAnimationCallback)
		end
	end

	function self.state()
		return current_state
	end


	local t_explosion=0
	local kill_particles={}
	function self.draw_explosion()
		local i=1
		if math.abs(view_x                    - self.x) < 200 then
			for k,v in pairs(kill_particles) do
				i=i+1
				if i>MAX_PARTICLES then break end
				love.graphics.setColor(v.r, v.g, v.b, 255)
				love.graphics.rectangle("fill", v.x                  -.5*math.cos(v.speed*t_explosion), v.y-v.z-.5*math.sin(v.speed*t_explosion), 2+math.abs(v.dx)+math.cos(v.speed*t_explosion), math.max(1+math.abs(v.dy)+v.dz,2)+math.sin(v.speed*t_explosion))
			end

		elseif math.abs(view_x - map.get_loop_x() - self.x) < 200 then
			for k,v in pairs(kill_particles) do
				i=i+1
				if i>MAX_PARTICLES then break end
				love.graphics.setColor(v.r, v.g, v.b, 255)
				love.graphics.rectangle("fill", v.x+ map.get_loop_x()-.5*math.cos(v.speed*t_explosion), v.y-v.z-.5*math.sin(v.speed*t_explosion), 2+math.abs(v.dx)+math.cos(v.speed*t_explosion), math.max(1+math.abs(v.dy)+v.dz,2)+math.sin(v.speed*t_explosion))
			end
		elseif math.abs(view_x + map.get_loop_x() - self.x) < 200 then
			for k,v in pairs(kill_particles) do
				i=i+1
				if i>MAX_PARTICLES then break end
				love.graphics.setColor(v.r, v.g, v.b, 255)
				love.graphics.rectangle("fill", v.x- map.get_loop_x()-.5*math.cos(v.speed*t_explosion), v.y-v.z-.5*math.sin(v.speed*t_explosion), 2+math.abs(v.dx)+math.cos(v.speed*t_explosion), math.max(1+math.abs(v.dy)+v.dz,2)+math.sin(v.speed*t_explosion))
			end
		end
		love.graphics.setColor(255,255,255,255)
	end
	function self.update_explosion(dt)
		t_explosion=t_explosion+dt
		local continue=false
		for k,v in pairs(kill_particles) do
			v.x=v.x+v.dx
			v.y=v.y+v.dy
			v.z=v.z+v.dz
			v.dz=v.dz-.2

			v.dx=v.dx*.95
			v.dy=v.dy*.95
			v.dz=v.dz*.95
			if v.z<=0 then
				v.dx= 0.2*v.dx
				v.dy= 0.2*v.dy
				v.dz=-0.8*v.dz
				if v.dx<0 then
					v.dx=math.ceil(v.dx)
				else
					v.dx=math.floor(v.dx)
				end
				if v.dy<0 then
					v.dy=math.ceil(v.dy)
				else
					v.dy=math.floor(v.dy)
				end
				if v.dz<0 then
					v.dz=math.ceil(v.dz)
				else
					v.dz=math.floor(v.dz)
				end
			end
			if v.dz~=0 or v.dx~=0 or v.dy~=0 then
				continue=true
			end
		end
		if not continue then
			self.update= function() end
		end
	end
	function self.kill(killdx,killdy)
		for i=1,50 do
			local red
			local green
			local blue
			if math.random()<.2 then
				red=128+50*math.random()
				green=50*math.random()
				blue=50*math.random()
			else
				red=255*math.random()
				green=255*math.random()
				blue=255*math.random()
			end
			table.insert(kill_particles,{ x=11*math.random()+self.x,
											y=4*math.random()+self.y,
											z=35*math.random()+self.z,
											dx=killdx+killdx*(.5-math.random())+2*(.5-math.random()),
											dy=killdy+killdy*(.5-math.random())+2*(.5-math.random()),
											dz=(math.abs(killdx)+math.abs(killdy)+2)*math.random(),
											r=red,
											g=green,
											b=blue,
											speed=100*math.random()})

		end
		self.draw=self.draw_explosion
		self.update=self.update_explosion
		self.y=-1000+1
	end

	--    return vec4((1.0+sin(time))/2.0, abs(cos(time)), abs(sin(time)), 1.0);
	local effect = love.graphics.newShader [[
		extern number time;
		extern vec4 pulle;
		extern vec4 pulle_dark;
		extern vec4 bas;
		extern vec4 bas_soft_dark;
		extern vec4 bas_dark;
		vec4 effect(vec4 color, Image t, vec2 texture_coords, vec2 pixel_coords)
		{
			vec4 pixelcol = texture2D(t,texture_coords);
			if (pixelcol == vec4(1,0,0,1))
				return pulle;
			if (pixelcol == vec4(1,1,0,1))
				return pulle_dark;
			if (pixelcol == vec4(0,0,1,1))
				return bas;
			if (pixelcol == vec4(0,1,1,1))
				return bas_dark;
			if (pixelcol == vec4(1,1,1,1))
				return bas_soft_dark;

			return texture2D(t,texture_coords);
		}
    ]]
			-- //	return vec4(203/255.,32/255.,24/255.,1);
				-- return vec4(1-.5*sin(time),0,0,1);
	local pulle           = {math.random(),math.random(),math.random(),1}
	local pulle_dark      = {pulle[1]*0.8 ,pulle[2]*0.8 ,pulle[3]*0.8 ,1}
	local bas             = {math.random(),math.random(),math.random(),1}
	local bas_soft_dark   = {bas[1]*0.8   ,bas[2]*0.8   ,bas[3]*0.8   ,1}
	local bas_dark        = {bas[1]*0.7   ,bas[2]*0.7   ,bas[3]*0.7   ,1}

		effect:send("pulle", pulle)
		effect:send("pulle_dark", pulle_dark)
		effect:send("bas", bas)
		effect:send("bas_soft_dark", bas_soft_dark)
		effect:send("bas_dark", bas_dark)

	function self.draw()
		-- Draw bounds, usefull for debug
		-- if self.draw_bounds then
		-- 	love.graphics.push()
		-- 	love.graphics.rectangle("fill", self.x + nw_x, self.y + nw_y, 1 + se_x - nw_x, 1 + se_y - nw_y)
		-- 	love.graphics.pop()
		-- end
		-- Draw the actual character
		if math.abs(view_x                    - self.x) < 100 then
			love.graphics.setShader(effect)
			current_opts.animation.draw(self.x, self.y - self.z)
			love.graphics.setShader()
		elseif math.abs(view_x -map.get_loop_x()- self.x) < 100 then
			love.graphics.setShader(effect)
			current_opts.animation.draw(self.x+map.get_loop_x(), self.y - self.z)
			love.graphics.setShader()
	elseif math.abs(view_x +map.get_loop_x()- self.x) < 100 then
			love.graphics.setShader(effect)
			current_opts.animation.draw(self.x-map.get_loop_x(), self.y - self.z)
			love.graphics.setShader()
		end
		-- current_opts.animation.draw(self.x, self.y)
	end

	self.setState("idle_right")
	return self
end


