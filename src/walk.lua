function Walk(obj, nw_x, nw_y, se_x, se_y)
	local self = {}

	-- Bounding box
	--  (nw_x, nw_y)  +-----+  (se_x, nw_y)
	--                |     |
	--                |     |
	--  (nw_y, se_y)  +-----+  (se_x, se_y)
	local nw_x = nw_x or 0
	local nw_y = nw_y or 0
	local se_x = se_x or nw_x
	local se_y = se_y or nw_y

	-- It may make sense to expose those tweakable parameters but do it only if
	-- absolutely needed.
	local walk_step_x = 1
	local walk_step_y = 1

	-- If set, canWalk(x, y) will be called on it to determine if the object
	-- can walk on a particular point or not.
	local map = nil

	-- Set the map on which canWalk(x, y) will be called
	function self.setMap(new_map)
		map = new_map
	end

	--return false if cannot walk there
	function self.walkRelative(dx, dy)
		return self.walkTo(dx + self.x, dy + self.y)
	end

	local limit_height_walk=5
	-- Not perfect but should be a good enough approximation for our purpose:
	--   If each corner is in an acceptable position then the whole bounding
	--   box is in an acceptable position.
	function self.canWalk_one_step(from_x, from_y,to_x,to_y)
		local ret
		if map == nil then
			ret = true
		else
			ret = 
			      math.abs(map.height(from_x     ,from_y     )-map.height(to_x     ,to_y     ))< limit_height_walk
			  and math.abs(map.height(from_x+nw_x,from_y+nw_y)-map.height(to_x+nw_x,to_y+nw_y))< limit_height_walk
			  and math.abs(map.height(from_x+nw_x,from_y+se_y)-map.height(to_x+nw_x,to_y+se_y))< limit_height_walk
			  and math.abs(map.height(from_x+se_x,from_y+se_y)-map.height(to_x+se_x,to_y+se_y))< limit_height_walk
			  and math.abs(map.height(from_x+se_x,from_y+nw_y)-map.height(to_x+se_x,to_y+nw_y))< limit_height_walk
		end
		return ret
	end
	function self.canWalk(from_x, from_y,to_x,to_y)
		local ret
		if map == nil then
			ret = true
		else
			ret = 
			      math.abs(map.height(from_x     ,from_y     )-map.height(to_x     ,to_y     ))< limit_height_walk
			  and math.abs(map.height(from_x+nw_x,from_y+nw_y)-map.height(to_x+nw_x,to_y+nw_y))< limit_height_walk
			  and math.abs(map.height(from_x+nw_x,from_y+se_y)-map.height(to_x+nw_x,to_y+se_y))< limit_height_walk
			  and math.abs(map.height(from_x+se_x,from_y+se_y)-map.height(to_x+se_x,to_y+se_y))< limit_height_walk
			  and math.abs(map.height(from_x+se_x,from_y+nw_y)-map.height(to_x+se_x,to_y+nw_y))< limit_height_walk
		end
		return ret
	end
	-- function self.canWalk(from_x, from_y,to_x,to_y)
	-- 	local ret=true
	-- 	local i_max
	-- 	local i_sgn
	-- 	local i

	-- 	i=0
	-- 	i_max=math.abs(to_x-from_x)
	-- 	i_sgn=math.abs(to_x-from_x)/(to_x-from_x)
	-- 	while ret and i<i_max do
	-- 		i=i+1
	-- 		ret = self.canWalk_one_step(self.x,self.y,self.x+i*i_sgn,self.y)
	-- 		if not ret then break end
	-- 	end
	-- 	self.x=self.x+i_sgn*i

	-- 	i=0
	-- 	i_max=math.abs(to_y-from_y)
	-- 	i_sgn=math.abs(to_y-from_y)/(to_y-from_y)
	-- 	while ret and i<i_max do
	-- 		i=i+1
	-- 		ret = self.canWalk_one_step(self.x,self.y,self.x,self.y+i*i_sgn)
	-- 		if not ret then break end
	-- 	end
	-- 	self.y=self.y+i_sgn*i

	-- 	return ret
	-- end


	function self.walkTo(x, y)
		local dx = x - self.x < 0 and -1 or 1
		local dy = y - self.y < 0 and -1 or 1
		local old_x = self.x
		local old_y = self.y

		function walk_x()
			local continue
			if math.abs(x-self.x)<1 then
				continue = false
			else
				local new_x = self.x + dx
				if (new_x - x < 0 and -1 or 1) * dx < 0 then
					new_x = x
				end
				if self.canWalk(self.x,self.y,new_x, self.y) then
					self.x = new_x%map.get_loop_x()
					if self.x~=new_x then
						x=x%map.get_loop_x()
					end
					self.z = map.height(self.x,self.y)
					continue =  true
				else
					continue =  false
				end
			end
			return continue 
		end

		function walk_y()
			if math.abs(y - self.y)<1 then
				return false
			else
				local new_y = self.y + dy
				if (new_y - y < 0 and -1 or 1) * dy < 0 then
					new_y = y
				end
				if self.canWalk(self.x,self.y,self.x, new_y) then
					self.y = new_y
					self.z = map.height(self.x,self.y)
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

		--lets assume that there is only a few calls of walking
		return self.canWalk(old_x,old_y,x,y)
	end

	return setmetatable(self, {
			__index=obj,
			__newindex = function (table, key, value) obj[key] = value end
		})
end
