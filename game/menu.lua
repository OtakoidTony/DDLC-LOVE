local menu_items
local cX
local cY
local getcompare = {}
local rectwidth
local pagenum = 1
local savenum = {}
local itemnames = {}
local saveindicator = {}
local chch
local cpick

function menu_enable(m)
	menu_enabled = true
	menu_type = m
	
	if menu_type == 'savegame' or menu_type == 'loadgame' then
		for i = 1, 6 do
			if pagenum > 1 then	
				chch = ((pagenum-1)*6)+i
			else
				chch = i
			end
			savenum[i] = chch
			itemnames[i] = 'Save File '..chch
			if love.filesystem.isFile('save'..chch..'-'..persistent.ptr..'.sav') then
				saveindicator[i] = 1
			else
				saveindicator[i] = 0
			end
		end
	end
	
	if menu_type == 'mainyesno' then
		menutext = 'Are you sure you want to return to the main menu?\nThis will lose unsaved progress.'
		itemnames = {'Yes','No'}
		
	elseif menu_type == 'help' then
		menutext = 'Help'
		itemnames = {}
		
	elseif menu_type == 'title' then
		menutext = 'Main Menu'
		itemnames = {'New Game','Load Game','Settings','Help','Quit'}
		
	elseif menu_type == 'settings' then
		menutext = 'Settings'
		if pagenum == 1 then
			itemnames = {'Textbox Location','Text Speed','Auto-Forward Time','Show Date&Time','Characters','Save Settings'}
		elseif pagenum == 2 then
			itemnames = {'Char. Animations','Save Settings'}
		end
		
	elseif menu_type == 'settings2' then
		menutext = 'Settings'
		itemnames = {'Textbox Location','Show Date&Time','Char. Animations','Characters','Save Settings'}
	
	elseif menu_type == 'characters' then
		menutext = 'Characters'
		itemnames = {'Delete monika.chr','Delete natsuki.chr','Delete sayori.chr','Delete yuri.chr','Restore all'}
	
	elseif menu_type == 'pause' then
		menutext = 'Game Menu'
		itemnames = {'Save Game','Load Game','Main Menu','Settings','Help','Return'}
	
	elseif menu_type == 'pause2' then
		menutext = 'Game Menu'
		itemnames = {'Save Game','Load Game','Main Menu','Settings','Help','Quit','Return'}
	
	elseif menu_type == 'savegame' then
		menutext = 'Save Game'
	
	elseif menu_type == 'loadgame' then
		menutext = 'Load Game'
		
	elseif menu_type == 'dialog' then
		itemnames = {'OK'}
	end
	
	if menu_type == 'choice' then
		menu_items = #choices + 1
	else
		menu_items = #itemnames + 1
	end
	
	m_select(2)
end

function menu_draw()
	xaload = xaload + 1
	
	love.graphics.setColor(255, 255, 255, alpha)
	if bgimg_disabled ~= true then love.graphics.draw(background_Image, posX, posY) end
	if menu_type == 'choice' then
		for i = 1, #choices do
			getcompare[i] = font:getWidth(choices[i])
		end
	else
		for i = 1, #itemnames do
			getcompare[i] = font:getWidth(itemnames[i])
		end
	end
	rectwidth = math.max(unpack(getcompare)) + 5
	
	love.graphics.setColor(255, 189, 225, alpha)
	for i = 1, 8 do
		if menu_items >= i+1 then love.graphics.rectangle('fill',16, 20+(25*i),rectwidth,16) end
	end
	if menu_previous then love.graphics.rectangle('fill', 16, 220, 30, 16) end
	
	if bgimg_disabled then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(guicheckwhite,cX,cY)
	else
		love.graphics.setColor(0,0,0) 
		love.graphics.draw(guicheck,cX,cY)
	end
	love.graphics.print(menutext,16, 12)
	
	love.graphics.setColor(0,0,0)
	for i = 1, 8 do
		if menu_items >= i+1 and menu_type == 'choice' then love.graphics.print(choices[i],17,20+(25*i))
		elseif menu_items >= i+1 then love.graphics.print(itemnames[i],17,20+(25*i)) end
	end
	if menu_previous then love.graphics.print('Back',17, 220) end
	
	if menu_type == 'settings' or menu_type == 'settings2' then
		if menu_type == 'settings' and pagenum == 1 then
			love.graphics.print('Page 1 of 2',220,12)
			love.graphics.print('(<) X | Y (>)',223,27)
			love.graphics.print(settings.textloc..' Screen',140, 45)
			love.graphics.print(settings.textspd, 157, 70)
			love.graphics.print('(<)',140,70)
			love.graphics.print('(>)',184,70)
			love.graphics.print(settings.autospd..' sec.',157, 95)
			love.graphics.print('(<)',140,95)
			love.graphics.print('(>)',198,95)
			love.graphics.print(settings.dtym,140, 120)
			
		elseif menu_type == 'settings' and pagenum == 2 then
			love.graphics.print('Page 2 of 2',220,12)
			love.graphics.print('(<) X | Y (>)',223,27)
			love.graphics.print(settings.animh, 140, 45)
			
		elseif menu_type == 'settings2' then
			love.graphics.print(settings.textloc..' Screen',140, 45)
			love.graphics.print(settings.dtym,140, 70)
			love.graphics.print(settings.animh, 140, 95)
		end
		love.graphics.print('Press (<) and (>) to change settings.',16,188)
		love.graphics.print('DDLC-3DS '..dversion..' '..dvertype,16, 203)
		
	elseif menu_type == 'savegame' or menu_type == 'loadgame' then
		love.graphics.print('Page '..pagenum..' of 10',220,12)
		love.graphics.print('(<) X | Y (>)',230,27)
		for i = 1, 6 do
			if saveindicator[i] == 1 then
				love.graphics.setColor(0,255,0)
				love.graphics.rectangle('fill',95,25+(25*i),6,6)
			else
				love.graphics.setColor(255,0,0)
				love.graphics.rectangle('fill',95,25+(25*i),6,6)
			end
		end
		
	elseif menu_type == 'choice' then
		if settings.dtym == 1 then drawdatetime() end
		
	elseif menu_type == 'help' then
		love.graphics.setColor(255,189,225)
		love.graphics.rectangle('fill',14,30,260,110)
		love.graphics.rectangle('fill',14,150,260,16)
		love.graphics.rectangle('fill',14,180,260,30)
		love.graphics.setColor(0,0,0)
		love.graphics.print('Key Bindings:',16,30)
		love.graphics.print('A, L Trigger - Advances through the game,',16,45)
		love.graphics.print('activates menu choices',90,60)
		love.graphics.print('B - Exit Menu, AutoForward On/Off',16,80)
		love.graphics.print('X - (Menu) Previous Page, (Hold) Skip',16,100)
		love.graphics.print('Y - (Menu) Next Page, Enter Game Menu',16,120)
		love.graphics.print('Managing files: Go to Settings > Characters',16,150)
		love.graphics.print('Deleting save data: Delete everything in here',16,180)
		love.graphics.print('> sdmc:/3ds/data/LovePotion/DDLC-3DS/',16,195)
	end	
end

function menu_confirm()
	sfx1:play()
	
	if menu_type == 'title' then --title screen options
		menu_previous = 'title'
		
		--set player name to MC if not on 3DS
		if global_os ~= 'Horizon' then
			player = 'MC'
		end
		
		if m_selected == 2 then --new game
			if player == '' and global_os == 'Horizon' then --keyboard input for player name
				love.keyboard.setTextInput(true)
			elseif player ~= '' then --go straight to new game
				changeState('game',1)
			end
		
		elseif m_selected == 3 then --load game
			pagenum = 1
			menu_enable('loadgame')
			
		elseif m_selected == 4 then --settings
			pagenum = 1
			menu_enable('settings')
		
		elseif m_selected == 5 then --help
			menu_enable('help')
			
		elseif m_selected == 6 then --quit
			game_quit()
		end
		
	elseif menu_type == 'loadgame' then --load game confirm
		savenumber = savenum[m_selected-1]
		if love.filesystem.isFile('save'..savenumber..'-'..persistent.ptr..'.sav') then
			changeState('game',2)
		else
			menu_enable(menu_previous)
			menutext = 'Save File '..savenumber..' does not exist.'
		end
		
	elseif menu_type == 'savegame' then  --save game confirm 
		savenumber = savenum[m_selected-1]
		savegame()
		menu_enable(menu_previous)
	
	elseif menu_type == 'pause' then --pause menu options
		menu_previous = 'pause'
		if m_selected == 2 then
			pagenum = 1
			menu_enable('savegame')
		elseif m_selected == 3 then
			pagenum = 1
			menu_enable('loadgame')
		elseif m_selected == 4 then
			menu_enable('mainyesno')
		elseif m_selected == 5 then
			pagenum = 1
			menu_enable('settings')
		elseif m_selected == 6 then
			menu_enable('help')
		elseif m_selected == 7 then
			menu_enabled = false
			menu_previous = nil
		end
		
	elseif menu_type == 'pause2' then --pause menu options
		if m_selected >= 5 then menu_previous = 'pause2' end
		if m_selected == 2 and chapter == 30 then
			menutext = "There's no point in saving anymore.\nDon't worry, I'm not going anywhere."
		elseif m_selected == 5 then
			menu_enable('settings2')
		elseif m_selected == 6 then
			menu_enable('help')
		elseif m_selected == 7 then
			game_quit()
		elseif m_selected == 8 then
			menu_enabled = false
			menu_previous = nil
		end
	
	elseif menu_type == 'mainyesno' then
		if m_selected == 2 then
			changeState('title')
		elseif m_selected == 3 then
			menu_enable('pause')
		end
		
	elseif menu_type == 'settings' and pagenum == 1 then
		if m_selected == 2 or m_selected == 5 then
			menu_keypressed('left')
		elseif m_selected == 6 then
			menu_enable('characters')
		elseif m_selected == 7 then
			savesettings()
			menu_enable(menu_previous)
		end
		
	elseif menu_type == 'settings' and pagenum == 2 then
		if m_selected <= 3 then
			menu_keypressed('left')
		else
			savesettings()
			menu_enable(menu_previous)
		end
		
	elseif menu_type == 'settings2' then
		if m_selected <= 4 then
			menu_keypressed('left')
		elseif m_selected == 5 then
			menu_enable('characters')
		elseif m_selected == 6 then
			savesettings()
			menu_enable(menu_previous)
		end
		
	elseif menu_type == 'characters' then
		if m_selected == 2 then
			if persistent.chr.m < 2 or (persistent.chr.m == 2 and chapter >= 30) then
				persistent.chr.m = 0
			end
		elseif m_selected == 4 then
			if persistent.ptr == 0 then
				persistent.chr.s = 0
			end
		elseif m_selected == 6 then
			if persistent.ptr == 0 then
				persistent.chr.s = 1
			end
			if persistent.chr.m < 2 then
				persistent.chr.m = 1
			end
		end
		savepersistent()
		menu_enable(menu_previous)
		
	elseif menu_type == 'choice' then
		if choicepick ~= '' then
			scriptJump(cl+1)
			menu_type = nil
			menu_enabled = false
			menu_previous = nil
		end
		
	elseif menu_type == 'dialog' then
		scriptJump(cl+1)
		menu_type = nil
		menu_enabled = false
		menu_previous = nil
	end
end

function m_select(arg)
	if arg then m_selected = arg end
	if m_selected <= 5 then
		if menu_type == 'choice' then 
			choicepick = choices[m_selected-1] 
		else
			cpick = itemnames[m_selected-1]
		end
	end
	cX = 2
	cY = 22+(25*(m_selected-1))
end

function menu_keypressed(key)
	if key == 'down' or key == 'cpaddown' then
		sfx2:play()
		if m_selected <= menu_items-1 then
			m_selected = m_selected + 1
		else
			m_selected = 2
		end
		m_select()
		
	elseif key == 'up' or key == 'cpadup' then
		sfx2:play()
		if m_selected >= 3 then
			m_selected = m_selected - 1
		else
			m_selected = menu_items
		end
		m_select()
		
	elseif key == 'a' then
		if alpha == 255 then menu_confirm() end
		
	elseif key == 'b' then
		if menu_type == 'pause' or menu_type == 'pause2' then
			menu_enabled = false
		elseif menu_type ~= 'title' and menu_type ~= 'pause' and menu_type ~= 'pause2' and menu_type ~= 'choice' then
			menu_enable(menu_previous)
		end
		menu_previous = nil
		
	elseif key == 'left' or key == 'cpadleft' then
		if menu_type == 'settings' and m_selected <= 5 and pagenum == 1 then
			if cpick == 'Textbox Location' then
				if settings.textloc == 'Bottom' then
					settings.textloc = 'Top'
				else
					settings.textloc = 'Bottom'
				end
			elseif cpick == 'Text Speed' then
				if settings.textspd > 250 then
					settings.textspd = 250
				elseif settings.textspd > 50 then
					settings.textspd = settings.textspd - 25
				end
			elseif cpick == 'Auto-Forward Time' then
				if settings.autospd > 1 then
					settings.autospd = settings.autospd - 1
				end
			elseif cpick == 'Show Date&Time' then
				if settings.dtym == 0 then
					settings.dtym = 1
				else
					settings.dtym = 0
				end
			end
			
		elseif menu_type == 'settings' and m_selected <= 2 and pagenum == 2 then
			if cpick == 'Char. Animations' then
				if settings.animh == 0 then
					settings.animh = 1
				else
					settings.animh = 0
				end
			end
			
		elseif menu_type == 'settings2' and m_selected <= 4 then
			if cpick == 'Textbox Location' then
				if settings.textloc == 'Bottom' then
					settings.textloc = 'Top'
				else
					settings.textloc = 'Bottom'
				end
			elseif cpick == 'Show Date&Time' then
				if settings.dtym == 0 then
					settings.dtym = 1
				else
					settings.dtym = 0
				end
			elseif cpick == 'Char. Animations' then
				if settings.animh == 0 then
					settings.animh = 1
				else
					settings.animh = 0
				end
			end
		end
		
	elseif key == 'right' or key == 'cpadright' then
		if menu_type == 'settings' and m_selected <= 5 and pagenum == 1 then
			if cpick == 'Textbox Location' then
				menu_keypressed('left')
			elseif cpick == 'Text Speed' then
				if settings.textspd < 250 then
					settings.textspd = settings.textspd + 25
				end
			elseif cpick == 'Auto-Forward Time' then
				if settings.autospd < 15 then
					settings.autospd = settings.autospd + 1
				end
			elseif cpick == 'Show Date&Time' then
				menu_keypressed('left')
			end
			
		elseif menu_type == 'settings' and m_selected <= 2 and pagenum == 2 then
			if cpick == 'Char. Animations' then
				menu_keypressed('left')
			end
			
		elseif menu_type == 'settings2' and m_selected <= 4 then
			menu_keypressed('left')
		end
	
	elseif key == 'x' then
		if (menu_type == 'savegame' or menu_type == 'loadgame' or menu_type == 'settings') and pagenum > 1 then
			pagenum = pagenum - 1
			menu_enable(menu_type)
		end
		
	elseif key == 'y' then
		if ((menu_type == 'savegame' or menu_type == 'loadgame') and pagenum < 10) or (menu_type == 'settings' and pagenum < 2) then
			pagenum = pagenum + 1
			menu_enable(menu_type)
		end
	end
end

function menu_mousepressed()
	if menu_items >= 2 and mouseX>=16 and mouseX<=rectwidth+16 and mouseY>=45 and mouseY<=61 then
		m_select(2)
	elseif menu_items >= 3 and mouseX>=16 and mouseX<=rectwidth+16 and mouseY>=70 and mouseY<=86 then
		m_select(3)
	elseif menu_items >= 4 and mouseX>=16 and mouseX<=rectwidth+16 and mouseY>=95 and mouseY<=111 then
		m_select(4)
	elseif menu_items >= 5 and mouseX>=16 and mouseX<=rectwidth+16 and mouseY>=120 and mouseY<=136 then
		m_select(5)
	elseif menu_items >= 6 and mouseX>=16 and mouseX<=rectwidth+16 and mouseY>=145 and mouseY<=161 then
		m_select(6)
	elseif menu_items >= 7 and mouseX>=16 and mouseX<=rectwidth+16 and mouseY>=170 and mouseY<=186 then
		m_select(7)
	elseif menu_items >= 8 and mouseX>=16 and mouseX<=rectwidth+16 and mouseY>=195 and mouseY<=211 then
		m_select(8)
	elseif menu_items >= 9 and mouseX>=16 and mouseX<=rectwidth+16 and mouseY>=220 and mouseY<=236 then
		m_select(9)
	elseif menu_previous and mouseX>=16 and mouseX<=46 and mouseY>=220 and mouseY<=236 then
		menu_keypressed('b')
	elseif mouseX >= 140 and mouseX <= 157 and mouseY >= 70 and mouseY <= 90 and menu_type == 'settings' and pagenum == 1 then
		m_select(3)
		menu_keypressed('left')
	elseif mouseX >= 140 and mouseX <= 157 and mouseY >= 95 and mouseY <= 115 and menu_type == 'settings' and pagenum == 1 then
		m_select(4)
		menu_keypressed('left')
	elseif mouseX >= 184 and mouseX <= 201 and mouseY >= 70 and mouseY <= 90 and menu_type == 'settings' and pagenum == 1 then
		m_select(3)
		menu_keypressed('right')
	elseif mouseX >= 198 and mouseX <= 215 and mouseY >= 95 and mouseY <= 115 and menu_type == 'settings' and pagenum == 1 then
		m_select(4)
		menu_keypressed('right')
	end
	
	if mouseX <= rectwidth and mouseY <= 211 then
		menu_keypressed('a')
	end
end