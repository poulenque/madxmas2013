function Animation(img, w, h, steps, timing, columns, first)
	local self = {}

	local quads = {}
	local steps = steps
	local first = first or 1
	local columns = columns or steps

	local base_scale_x  = 1
	local base_scale_y  = 1
	local base_rotation = 0
	local base_offset_x = 0
	local base_offset_y = 0
	local callback = nil

	for i = first - 1, steps - 1 do
		local row = math.floor(i / columns)
		local col = i % columns
		quads[i + 1] = love.graphics.newQuad(
			col * w, row * h, w, h, img:getWidth(), img:getHeight())
	end

	local anim_step, anim_time -- Set by self.reset() just before returning self
	local anim_step = -1
	local anim_time = -1

	function self.setCallback(func)
		self.callback = func
	end

	-- Set the base scale for the draw operation
	function self.setScale(sx, sy)
		base_scale_x = sx
		base_scale_y = sy
	end

	-- Set the base rotation for the draw operation
	function self.setRotation(r)
		base_rotation = r
	end

	-- Set the base offset for the draw operation
	function self.setOffset(x, y)
		base_offset_x = x
		base_offset_y = y
	end

	-- Updates the animation, intended to be called from love.update(dt)
	function self.update(dt)
		local speed

		if type(timing) == "number" then
			speed = timing
		else
			speed = timing[anim_step]
		end

		anim_time = anim_time + dt
		while anim_time > speed do
			local anim_step_old = anim_step
			anim_time = anim_time - speed
			if anim_step < steps then
				anim_step = anim_step + 1
			else
				anim_step = first
			end
				-- if(anim_step>steps)then
				-- 	print(anim_step.." and "..steps)
				-- end
			if type(self.callback) == "function" then
				self.callback(anim_step_old, anim_step)
			end
		end
	end

	-- Draw the animation parameters are the same as love.graphics.draw and
	-- they will modify what was set with setScale, set..., ... defined above.
	function self.draw(x, y, r, sx, sy, ox, oy, kx, ky )
		local r  = r  or 0
		local sx = sx or 1
		local sy = sy or 1
		love.graphics.draw(img, quads[anim_step],
			base_offset_x + x, base_offset_y + y,
			base_rotation + r, base_scale_x * sx, base_scale_y * sy,
			ox, oy, kx, ky)
	end

	-- Return the current step of the animation
	function self.getStep()
		return anim_step - first + 1
	end

	-- Return the number of steps in the animation
	function self.getSteps()
		return steps
	end

	-- Reset the state of the animation
	function self.reset()
		anim_step = first
		anim_time = 0
	end

	self.reset()
	return self
end
