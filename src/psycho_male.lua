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
local timestep=0.04
imgs["left"]    = love.graphics.newImage("graphics/male_right.png")
frames["left"]  = 12
timings["left"] = timestep
walk_speed["left"]   = {1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2}

imgs["right"]   = imgs["left"]
frames["right"] = 12
timings["right"]= timings["left"]
walk_speed["right"]  = {1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 2}

imgs["up"]      = love.graphics.newImage("graphics/male_up.png")
frames["up"]    = 12
timings["up"]   = timestep
walk_speed["up"]     = {1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0}

imgs["down"]    = love.graphics.newImage("graphics/male_down.png")
timings["down"] = timestep
frames["down"]  = 12
walk_speed["down"]   = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

imgs["idle_right1"]   = love.graphics.newImage("graphics/male_idle_right1.png")
timings["idle_right1"]= timestep
frames["idle_right1"] = 1

imgs["idle_right2"]   = love.graphics.newImage("graphics/male_idle_right2.png")
timings["idle_right2"]= timestep
frames["idle_right2"] = 1

imgs["idle_right3"]   = love.graphics.newImage("graphics/male_idle_right3.png")
timings["idle_right3"]= timestep
frames["idle_right3"] = 1

imgs["idle_up1"]   = love.graphics.newImage("graphics/male_idle_up1.png")
timings["idle_up1"]= timestep
frames["idle_up1"] = 1

imgs["idle_down1"]   = love.graphics.newImage("graphics/male_idle_down1.png")
timings["idle_down1"]= timestep
frames["idle_down1"] = 1


function PsychoMale(x, y, z)
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
	return self
end
