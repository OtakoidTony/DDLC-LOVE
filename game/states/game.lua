local skipspeed = 4
local audiotell = 0
local skip_rbtn = false

function drawGame()
	if autotimer > 0 or autoskip > 0 then
		scriptCheck()
		timerCheck()
	end
	love.graphics.setBackgroundColor(0,0,0)
	
	drawTopScreen()
	love.graphics.setColor(255,255,255,alpha)
	if bgch then love.graphics.draw(bgch) end
	if cgch and cg1 ~= '' then love.graphics.draw(cgch) end
	if xaload > 0 then
		drawSayori(s_Set.a,s_Set.b)
		drawYuri(y_Set.a,y_Set.b)
		drawNatsuki(n_Set.a,n_Set.b)
		drawMonika(m_Set.a,m_Set.b)
	end
	
	if poem_enabled then drawPoem()	end
	
	if menu_enabled and menu_type ~= 'choice' then
		love.graphics.setColor(255,255,255,128)
		love.graphics.rectangle('fill',0,0,400,240)
	end
	
	drawBottomScreen()
	love.graphics.setColor(255,255,255,alpha)
	if bgimg_disabled ~= true then love.graphics.draw(background_Image, posX, posY) end
	love.graphics.setFont(font)
	if textbox_enabled then
		drawNumbers()
		drawTextBox()
	end
	
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(font)
	if autotimer > 0 then 
		love.graphics.print('Auto-Forward On', 2, 20)
	elseif autoskip > 0 then
		if skip_rbtn then
			love.graphics.print('Skipping >>> (R)', 2, 20)
		else
			love.graphics.print('Skipping >>>', 2, 20)
		end
	end
	
	if state ~= 'newgame' and poem_enabled ~= true and event_enabled ~= true then
		love.graphics.setColor(255,189,225,alpha)
		love.graphics.rectangle('fill', 47, 2, 40, 16 ) 
		love.graphics.rectangle('fill', 139, 2, 32, 16 ) 
		love.graphics.rectangle('fill', 237, 2, 32, 16 ) 
		love.graphics.setColor(0,0,0,alpha)
		love.graphics.print('Menu',51,2,0,1,1)
		love.graphics.print('Auto',142,2,0,1,1)
		love.graphics.print('Skip',241,2,0,1,1) 
	end
	if settings.dtym == 1 then drawdatetime() end
	if menu_enabled then menu_draw() end
end

function updateGame(dt)
	if autotimer == 0 and autoskip == 0 then
		scriptCheck()
		timerCheck()
	end
	
	--auto next script
	if autotimer == 0 then
		autotimer = 0
	elseif autotimer <= settings.autospd then
		autotimer = autotimer + dt
	elseif autotimer >= settings.autospd then
		game_keypressed('a')
		autotimer = 0.01
	end
	
	--skipping
	if global_os ~= 'HorizonNX' and state ~= 'newgame' and event_enabled ~= true then
		if love.keyboard.isDown('x') then
			if autoskip < 1 then autoskip = 1 end
		elseif mouseDown and mouseX>=240 and mouseX<=270 then
			if mouseY<=16 or mouseY>=220 then
				if autoskip < 1 then autoskip = 1 end
			end
		elseif mouseDown == false and autoskip > 0 and skip_rbtn == false then
			autoskip = 0
		end
	end
	
	if menu_enabled == false and cl ~= 666 then
		if autoskip > 0 and autoskip < skipspeed then
			autoskip = autoskip + 1
		elseif autoskip >= skipspeed then
			autotimer = 0
			cl = cl + 1
			xaload = 0
			collectgarbage()
			collectgarbage()
			autoskip = 1
		end
	end
	
	if event_enabled then event_update(dt) end
	
	--custom audio looping
	if audio1 == '7' and persistent.ptr == 2 then
		audiotell = audiotell + dt
		if audiotell > 4.1 then audioUpdate('7a') end
	elseif audio1 == '7g' then
		audiotell = audiotell + dt
		if audiotell > 31.75 then audioUpdate('7g2') end
	elseif audio1 == '3g' then
		audiotell = audiotell + dt
		if audiotell > 25.5 and audio1 ~= '3g2' then audioUpdate('3g2') end
	else
		audiotell = 0
	end
end

function game_keypressed(key)
	if event_enabled then
		event_keypressed(key)
	elseif key == 'y' then --pause menu
		autotimer = 0
		if persistent.chr.m == 2 then menu_enable('pause2')
		else menu_enable('pause')
		end
	elseif key == 'b' then --auto on/off
		sfx1:play()
		if autotimer == 0 then autotimer = 0.01 else autotimer = 0 end		
	elseif key == 'x' then
		sfx1:play()
	elseif key == 'rbutton' or key == 'r' then
		sfx1:play()
		--[[
		if autoskip < 1 then
			autoskip = 1
			skip_rbtn = true
		else
			autoskip = 0
			skip_rbtn = false
		end
		]]
	else
		newgame_keypressed(key)
	end
end

function newgame_keypressed(key)
	if (key == 'a' or key == 'lbutton') and unitimer >= uniduration then 
		autotimer = 0
		cl = cl + 1 --next script
		xaload = 0
		unitimer = 0
		collectgarbage()
		collectgarbage()
	end
end

function game_mousepressed()
	if mouseX>=50 and mouseX<=80 and mouseY<=18 then game_keypressed('y')
	elseif mouseX>=142 and mouseX<=172 and mouseY<=18 then game_keypressed('b')
	elseif mouseX>=240 and mouseX<=270 and mouseY<=18 then game_keypressed('x')
	else game_keypressed('a')
	end
end