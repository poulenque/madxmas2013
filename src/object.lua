function Object(x, y, z)
	local self = {}

	self.x = x or 0
	self.y = y or 0
	self.z = z or 0

	function self.update(dt)
		return
	end

	function self.draw()
		return
	end

	return self
end
