function Rectangle(x, y, z, w, h, r, g, b, a)
	local self = Object(x, y, z)

	self.width  = w or 10
	self.height = h or 10
	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255

	function self.draw()
		love.graphics.setColor(self.r, self.g, self.b, self.a)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end

	return self
end
