local objects = nil
local selectable_character={}
local selected_character
local selected_character_indice = 1
view_x = 0
view_y = 0
view_dx = 0
view_dy = 0
view_zoom = 4
local view_zoom_compensation_x = 0
local view_zoom_compensation_y = 0
local super_weapon=0

local killable={}

local begin_time

function game_load()
	begin_time=love.timer.getTime()

	objects = {}
	Music = love.audio.newSource("music/the_king_s_Singers__Danny_Boy.mp3")
	Music:setLooping(true)
	Music:setVolume(0.5)
	Music:play()
	--Music:stop()


	map = Map("piccard_v2")

	-- the game begins here for piccard_v2 :
	-- x = 2592
	-- y = 380 - map.height(2592,380) - 40

	view_x = 2592
	view_y = 380 - map.height(2592,380) - 40 - 400

	-- objects["rectest1"] = Rectangle(20, 20, 1, 50, 50)
	-- objects["rectest2"] = Rectangle(love.graphics.getWidth() / 2 - 25, love.graphics.getHeight() / 2 - 25, 1, 50, 50)
	-- objects["rectest3"] = Rectangle(love.graphics.getWidth() - 70, love.graphics.getHeight() -70, 1, 50, 50)
	-- for _, o in pairs(objects) do
	-- 	o.x = o.x + view_x
	-- 	o.y = o.y + view_y
	-- end

	-- objects["female1"] = Female(2592, 380, map.height(2592,380))
	-- objects["male1"] = Male(2592, 380, map.height(2592,380))

	-- for i=1,300 do
	-- 	if math.random()<.5 then
	-- 		table.insert(objects,Male(1430,380,map.height(1430,380)))
	-- 	else
	-- 		table.insert(objects,Female(1430,380,map.height(1430,380)))
	-- 	end
	-- end

	local temp_dude
				for i=1,300 do
					-- while math.random()<.5 do
						if math.random()<.5 then
							temp_dude=Male(500+1500*i/300,325,map.height(1430,380))
						else
							temp_dude=Female(500+1500*i/300,325,map.height(1430,380))
						end
						table.insert(objects,temp_dude)	
						table.insert(killable,temp_dude)		
					-- end
				end
				for i=1,100 do
					-- while math.random()<.5 do
						if math.random()<.5 then
							temp_dude=Male(2350,150+200*i/100,map.height(1430,380))
						else
							temp_dude=Female(2350,150+200*i/100,map.height(1430,380))
						end
						table.insert(objects,temp_dude)
						table.insert(killable,temp_dude)		
					-- end
				end

				for i=1,100 do
					-- while math.random()<.5 do
						if math.random()<.5 then
							temp_dude=Male(2050+200*i/100,250,map.height(1430,380))
						else
							temp_dude=Female(2050+200*i/100,250,map.height(1430,380))
						end
						table.insert(objects,temp_dude)
						table.insert(killable,temp_dude)		
					-- end
				end

				for i=1,100 do
					-- while math.random()<.5 do
						if math.random()<.5 then
							temp_dude=Male(100+300*i/100,370,map.height(1430,380))
						else
							temp_dude=Female(100+300*i/100,370,map.height(1430,380))
						end
						table.insert(objects,temp_dude)
						table.insert(killable,temp_dude)		
					-- end
				end

	for i=1,50 do
		-- while math.random()<.5 do
			if math.random()<.5 then
				temp_dude=Male(2800+100*i/50,360,map.height(1430,380))
			else
				temp_dude=Female(2800+100*i/50,360,map.height(1430,380))
			end
			table.insert(objects,temp_dude)
			table.insert(killable,temp_dude)		
		-- end
	end

	-- selected_character="male1"
	-- switch_selected_character()

	local psy = Psycho(2592, 380, map.height(2592,380))
	objects["YOU1"] = psy
	table.insert(selectable_character,psy)
	psy.bot_mode(false)

	local psy2 = PsychoFemale(2592+50, 380, map.height(2592,380))
	objects["YOU2"] = psy2
	table.insert(selectable_character,psy2)
	psy2.bot_mode(false)

	local psy3 = PsychoMale(2592-50, 380, map.height(2592,380))
	objects["YOU3"] = psy3
	table.insert(selectable_character,psy3)
	psy3.bot_mode(false)

	selected_character=psy
	-- objects["YOU"] = Psycho(2792, 380, map.height(2592,380))
	selected_character.bot_mode(false)
	-- Call set map on all objects which support it
	for _, o in pairs(objects) do
		if type(o["setMap"]) == "function" then
			o.setMap(map)
		end
	end
end

function switch_selected_character()

	-- selected_character.bot_mode(true)
	selected_character_indice = selected_character_indice + 1
	if selected_character_indice > #selectable_character then
		selected_character_indice=1
	end
	selected_character = selectable_character[selected_character_indice]
	selected_character.bot_mode(false)

	-- objects[selected_character].bot_mode(true)
	-- if selected_character == "female1" then
	-- 	selected_character = "male1"
	-- else
	-- 	selected_character = "female1"
	-- end
	-- objects[selected_character].bot_mode(false)
	-- print (selected_character)
end

local theta=0
local dtheta=0

-- local super_weapon_charged = 20
local super_weapon_charged = 10
function game_update(dt)
	for k, v in pairs(objects) do
		v.update(dt)
	end
	local new_killable={}

	for k, v in pairs(killable) do
		if math.abs(v.x-selected_character.x)<6 and math.abs(v.y-selected_character.y)<8 then
			theta=3.1415*.5 + 3.14*.5*math.random()
			super_weapon=super_weapon+1
			super_weapon=math.min(super_weapon,super_weapon_charged)
			v.kill(selected_character.get_dx(),selected_character.get_dy())
		else
			table.insert(new_killable,v)
		end
	end
	killable=new_killable
end


function fire_super_weapon()
	if super_weapon==super_weapon_charged then
		super_weapon=0
		local new_killable={}
		for k, v in pairs(killable) do
			local dist_x = math.min(math.min(math.abs(v.x-selected_character.x),math.abs(v.x-map.get_loop_x()-selected_character.x)),math.abs(v.x+map.get_loop_x()-selected_character.x))
			local dist_y = math.abs(v.y-selected_character.y)
			if dist_x<=100 and dist_y<=100 then

					theta=3.1415*.5 + 3.14*math.random()
					local d  = dist_x*dist_x + dist_y*dist_y
					d= 1+math.sqrt(d)
					local vx = (v.x-selected_character.x)/d
					local vy = (v.y-selected_character.y)/d
					v.kill(200*vx/d,200*vy/d)
					-- super_weapon=super_weapon+1
			else
				table.insert(new_killable,v)
			end
		end
		killable=new_killable
	end
end


function game_draw()
	love.graphics.push()

	-- View position
	game_view_update_zoom_compensation()
	love.graphics.scale(view_zoom, view_zoom)
	love.graphics.translate(love.graphics.getWidth()/2-view_x, love.graphics.getHeight()/2-view_y)
	love.graphics.translate(view_zoom_compensation_x, view_zoom_compensation_y)

	-- Draw objects, we could use a skip list to improve performance
	local todraw = {}

	-- Objects
	for _, obj in pairs(objects) do
		table.insert(todraw, obj)
	end

	-- Map
	for _, obj in pairs(map.getObjects()) do
		table.insert(todraw, obj)
	end

	-- Sort everything
	table.sort(todraw, game_draw_order)	
	for _, o in ipairs(todraw) do
		o.draw()
	end

	love.graphics.pop()

	if #killable ==0 then
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("WELL... IT SEEMS LIKE",          20+10*math.random(), 0*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("YOU KILLED EVERYONE...",         20+10*math.random(), 1*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("I REALLY DONT KNOW",             20+10*math.random(), 2*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("WHAT TO TELL YOU ...",           20+10*math.random(), 3*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("CONGRATULATIONS ?",              20+10*math.random(), 4*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("YOU CAN PUT YOUT NAME",          20+10*math.random(), 5*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("HERE : _ _ _ _ _ _ _ _",      20+10*math.random(), 6*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("(USE A PEN ON WHATEVER) ",       20+10*math.random(), 7*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("YOU WASTED " .. math.floor(love.timer.getTime()-begin_time) .. " SECONDS",       20+10*math.random(), 8*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
		love.graphics.print("OF YOUR LIFE ",       20+10*math.random(), 9*50+20+10*math.random(),0,4,4)
		love.graphics.setColor(255*math.random(),255*math.random(),255*math.random(),255)
	else
		local border = 10
		local t= love.timer.getTime()
		if super_weapon<super_weapon_charged then
			love.graphics.setColor(255,255,255,128)
		else
			love.graphics.setColor(
				128+128*math.cos(t*10),
				128+128*math.cos(t*10),
				128+128*math.cos(t*10),
				128)
		end

		love.graphics.rectangle("fill", 120-border, 540-border, 400+2*border, 20+2*border)
		border = 0
		love.graphics.setColor(0,0,0,64)
		love.graphics.rectangle("fill", 120-border, 540-border, 400+2*border, 20+2*border)
		border = -4
		love.graphics.setColor(128,128,128,128)
		love.graphics.rectangle("fill", 120-border, 540-border, 400+2*border, 20+2*border)
		love.graphics.setColor(255,0,0,255)
		love.graphics.rectangle("fill", 120, 540, (super_weapon/super_weapon_charged)*400, 20)
		love.graphics.setColor(255,255,255,255)

		if super_weapon==super_weapon_charged then
			love.graphics.print("! PRESS SPACE !", 120+10*math.random(), 520+10*math.random(),0,4,4)
		end

		theta=theta+dtheta
		dtheta = dtheta - .2 * theta
		dtheta = dtheta*0.8
		-- love.graphics.print(#killable, 700, 550,theta,4+2+2*math.sin(theta),4+2+2*math.sin(theta),10,7)
		love.graphics.print(#killable, 700, 550+8*20,theta,4+2+2*math.sin(theta),4+2+2*math.sin(theta),10 + 27*math.sin(theta),7 + 27*math.cos(theta))
		-- love.graphics.present()
	end
end

-- Used to sort the objects before drawing
function game_draw_order(a, b)
	-- if a.z == b.z then
	-- 	ret =  a.y < b.y
	-- else
	-- 	ret = b.z > a.z
	-- end
	if a.y == b.y then
		ret = b.z > a.z
	else
		ret =  a.y < b.y
	end
	return ret
end

function game_view_update_zoom_compensation()
	local view_height = love.graphics.getHeight()
	local view_width = love.graphics.getWidth()
	view_zoom_compensation_x = -view_width * (1 - 1/view_zoom) / 2
	view_zoom_compensation_y = -view_height * (1 - 1/view_zoom) / 2
end

function character_move(dx, dy)
	selected_character.move(dx,dy)
	-- print (selected_character.x..","..selected_character.y)
end

function get_character()
	return selected_character
end