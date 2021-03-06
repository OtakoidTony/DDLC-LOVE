function loaderAssets(l_timer)
	--loading assets
	if l_timer == 96 then
		consolefont = lg.newFont('assets/fonts/F25_Bank_Printer.ttf',18)
		allerfont = lg.newFont('assets/fonts/Aller_Rg.ttf',22)
		lg.setFont(allerfont)
		
	elseif l_timer == 97 then
		sfx1 = love.audio.newSource('assets/audio/sfx/select'..audio_ext,'static')
		sfx2 = love.audio.newSource('assets/audio/sfx/hover'..audio_ext,'static')
		menu_bg_m = lg.newImage("assets/images/gui/menu_bg_m.png")
		gui = {}
		gui.keysbox = lg.newImage("assets/images/gui/button/box.png")
		gui.mmenu = lg.newImage("assets/images/gui/overlay/main_menu.png")
		gui.gmenu = lg.newImage("assets/images/gui/overlay/game_menu.png")
		gui.mainbuttons = lg.newImage("assets/images/gui/overlay/mainbuttons.png")
		gui.gamebuttons = lg.newImage("assets/images/gui/overlay/gamebuttons.png")
		gui.history = lg.newImage("assets/images/gui/overlay/history.png")
		gui.gamemenu = lg.newImage("assets/images/gui/overlay/gamemenu.png")
		gui.load = lg.newImage("assets/images/gui/overlay/load.png")
		gui.save = lg.newImage("assets/images/gui/overlay/save.png")
		gui.settings = lg.newImage("assets/images/gui/overlay/settings.png")
		gui.setbuttons = lg.newImage("assets/images/gui/overlay/setbuttons.png")
		
	elseif l_timer == 98 then
		--splash, title screen, gui elements, sfx
		namebox = lg.newImage('assets/images/gui/namebox.png')
		textbox = lg.newImage('assets/images/gui/textbox.png')
		background_Image = lg.newImage('assets/images/gui/menu_bg.png')
		gui.check = lg.newImage('assets/images/gui/button/check_selected_foreground.png')
		gui.ctc = lg.newImage('assets/images/gui/ctc.png')
		gui.skip = lg.newImage('assets/images/gui/skip.png')
		gui.sidebar = lg.newImage('assets/images/gui/overlay/sidebar.png')
		gui.slothover = lg.newImage('assets/images/gui/button/slot_hover_background.png')
		gui.slotidle = lg.newImage('assets/images/gui/button/slot_idle_background.png')
		gui.scrbarh = lg.newImage('assets/images/gui/scrollbar/horizontal_poem_bar.png')
		gui.scrhover = lg.newImage('assets/images/gui/slider/horizontal_hover_thumb.png')		
		
	elseif l_timer == 99 then
		--set your custom fonts for translations here!
		if settings.lang == 'eng' then
			m1 = lg.newFont('assets/fonts/m1.ttf',28) --monika poem font
			y1 = lg.newFont('assets/fonts/y1.ttf',30) --yuri poem font
			s1 = lg.newFont('assets/fonts/s1.ttf',32) --sayori poem font
			n1 = lg.newFont('assets/fonts/n1.ttf',26) --natsuki poem font
			deffont = lg.newFont('assets/fonts/VerilySerifMono.ttf',23) --act 2 "edited" text font
			halogenfont = lg.newFont('assets/fonts/Halogen.ttf',28) --poem game font
			rifficfont = lg.newFont('assets/fonts/RifficFree-Bold.ttf',24) --charactername font
		--[[
		elseif settings.lang == 'languagecode' then
			m1 = lg.newFont('assets/fonts/nameoffont.ttf',fontsize)
		]]
		end
	end
end