local img_intro = {}
local img_intro_quad
img_intro[1] = love.graphics.newImage("graphics/title_screen_code.png")
img_intro[2] = love.graphics.newImage("graphics/title_screen_pixels.png")
img_intro[3] = love.graphics.newImage("graphics/warning.png")
img_intro[4] = love.graphics.newImage("graphics/tab.png")
img_intro[5] = love.graphics.newImage("graphics/issue.png")
loading =  love.graphics.newImage("graphics/loading.png")
loading:setFilter("nearest")
img_intro[1]:setFilter("nearest")
img_intro[2]:setFilter("nearest")
img_intro[3]:setFilter("nearest")
img_intro[4]:setFilter("nearest")
img_intro[5]:setFilter("nearest")
img_intro_quad = love.graphics.newQuad(
	0, 0, img_intro[1]:getWidth(), img_intro[1]:getHeight(), img_intro[1]:getWidth(), img_intro[1]:getHeight())	--goto intro !

MAX_PARTICLES=50

function love.load()
	love.window.setMode( 800, 600, {borderless =true} )
	love.graphics.setDefaultFilter("nearest")
	-- Check love version
	if love._version_major == nil
	or love._version_major < 0
	or (love._version_major == 0 and love._version_minor < 9) then
		error("This version of Löve is outdated, please install 0.9 or higher.")
	end

	love.graphics.clear()
	-- love.graphics.print("LOADING AMASING GRAPHICS",100,500,0,4)
	love.graphics.draw(loading,img_intro_quad,0,0,0,4)
	love.graphics.present()

	-- love.graphics.print("Wainting for correct star alignment...", 200, 300)
	-- love.graphics.present()

	-- Load textures and stuff here
	--love.timer.sleep(2)
	require "utils"
	require "game"
	require "object"
	require "rectangle"
	require "animation"
	require "female"
	require "psycho_female"
	require "male"
	require "psycho_male"
	require "psycho"
	require "map"
	require "walk"
	require "character"

	game_load()

	-- love.graphics.print("...game is now starting!", 420, 320)
	-- love.graphics.present()
	--love.timer.sleep(1)

	love.draw = draw_intro
	love.keypressed=keypressed_intro
	love.update=update_intro
end

local time_begin = love.timer.getTime( )
local tmp_time=time_begin
local time_objectif = time_begin
local frame_intro=0

function draw_intro()
	if tmp_time<time_objectif then
		-- love.graphics.setColor(255, 255, 255, 255)
		-- love.graphics.setBackgroundColor(0, 0, 0)
		love.graphics.draw(img_intro[frame_intro],img_intro_quad,0,0,0,4)

		tmp_time=love.timer.getTime()
	else
		time_objectif=tmp_time+10
		frame_intro=frame_intro+1
		if frame_intro>#img_intro then
			--go INGAME !
			love.draw=draw_ingame
			love.keypressed = keypressed_ingame
			love.update=update_ingame
		end
	end
end

function keypressed_intro(k)
	time_objectif=tmp_time
end

function update_intro(dt)

end

local MESSAGE=""
local MESSAGE_TIME=0

function draw_ingame()
	game_draw()
	if MESSAGE_TIME>0 then
		love.graphics.print(MESSAGE,0,0,0,4)
	end
end

function update_ingame(dt)
	if MESSAGE_TIME>0 then
		MESSAGE_TIME=MESSAGE_TIME-dt
	end

	game_update(dt)
	----------------
	--CAMERA CONTROL
	-- if love.keyboard.isDown('+') or love.keyboard.isDown('=') then
	-- 	view_zoom = view_zoom * 1.05
	-- end
	-- if love.keyboard.isDown('-') then
	-- 	view_zoom = view_zoom / 1.05
	-- end
	-- if love.keyboard.isDown('f9') then
	-- 	view_dx = view_dx - 5
	-- end
	-- if love.keyboard.isDown('f10') then
	-- 	view_dy = view_dy + 5
	-- end
	-- if love.keyboard.isDown('f11') then
	-- 	view_dy = view_dy - 5
	-- end
	-- if love.keyboard.isDown('f12') then
	-- 	view_dx = view_dx + 5
	-- end



	----------------
	--DUDE CONTROL
	local dx =0
	local dy =0

	local follow_speed=3
	follow_speed=3

	if love.keyboard.isDown('up') then
		dy=dy-1
		view_dy = view_dy - follow_speed
	end
	if love.keyboard.isDown('down') then
		dy=dy+1
		view_dy = view_dy + follow_speed
	end
	if love.keyboard.isDown('left') then
		dx=dx-1
		view_dx = view_dx - follow_speed
	end
	if love.keyboard.isDown('right') then
		dx=dx+1
		view_dx = view_dx + follow_speed
	end
	character_move(dx, dy)

	--WOW THIS IS WAS MADE BY A TERRIBLE PROGRAMME, PROBABLY A PHYSICIST
	if get_character().x-view_x<-1000 then
		view_x=view_x-map.get_loop_x()
	end
	if get_character().x-view_x>1000 then
		view_x=view_x+map.get_loop_x()
	end

	view_dx = view_dx*0.8
	view_dy = view_dy*0.8


	view_dx=view_dx + (get_character().x-view_x)*.05
	view_dy=view_dy + (get_character().y-get_character().z-30-view_y)*.05


	view_x=view_x+view_dx*.25
	view_y=view_y+view_dy*.25


	-- view_x=view_x%map.get_loop_x()
	-- view_y=view_y%map.get_loop_y()




end

function keypressed_ingame(k)
	if k == 'escape' then
		love.event.push('quit')
	elseif k == 'tab' then
		switch_selected_character()
	elseif k== ' ' then
		fire_super_weapon()
	elseif k== 'o' then
		MAX_PARTICLES= MAX_PARTICLES-5
		if MAX_PARTICLES<0 then
			MAX_PARTICLES=0
		end
		MESSAGE="max_particle_per_person = "..MAX_PARTICLES
		MESSAGE_TIME=2
	elseif k== 'p' then
		MAX_PARTICLES= MAX_PARTICLES+5
		if MAX_PARTICLES>50 then
			MAX_PARTICLES=50
		end
		MESSAGE="max_particle_per_person = "..MAX_PARTICLES
		MESSAGE_TIME=2
	end

end

function love.keyreleased(k)
	-- if k == 'up' or k == 'down' or k == 'left' or k == 'right' then
	-- 	character_move(0,0)
	-- end
end
