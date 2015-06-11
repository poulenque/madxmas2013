function Walk(obj, map, nw_x, nw_y, se_x, se_y)
	local self = {}

	local map = map
	local nw_x = nw_x or 0
	local nw_y = nw_y or 0
	local se_x = se_x or nw_x
	local se_y = se_y or nw_y
	local walk_step_x = 1
	local walk_step_y = 1

	-- Not perfect but should be a good enough approximation for our purpose.
	function self.walkTo(x, y)
		local dx = x - self.x < 0 and -1 or 1
		local dy = y - self.y < 0 and -1 or 1

		function canWalk(x, y)
			local r = map.canWalk(x + nw_x, y + nw_y)
				and map.canWalk(x + nw_x, y + se_y)
				and map.canWalk(x + se_x, y + se_y)
				and map.canWalk(x + se_x, y + nw_y)
			return r
		end

		function walk_x()
			local continue
			if x == self.x then
				continue = false
			else
				local new_x = self.x + dx
				if (new_x - x < 0 and -1 or 1) * dx < 0 then
					new_x = x
				end
				if canWalk(new_x, self.y) then
					self.x = new_x
					continue =  true
				else
					continue =  false
				end
			end
		end

		function walk_y()
			if y == self.y then
				return false
			else
				local new_y = self.y + dy
				if (new_y - y < 0 and -1 or 1) * dy < 0 then
					new_y = y
				end
				if canWalk(self.x, new_y) then
					self.y = new_y
					return true
				else
					return false
				end
			end
		end
			
		local walking = true
		while walking do
			walking = walk_x() or walk_y()
		end
	end
	
	return setmetatable(self, {
			__index=obj,
			__newindex = function (table, key, value) obj[key] = value end
		})
end
