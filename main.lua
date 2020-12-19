-----------------------------------------------------------------------------------------
-- main.lua
--@module main

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Removes bottom bar on Android
if isAndroid then
	if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
		native.setProperty( "androidSystemUiVisibility", "lowProfile" )
	else
		native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
	end
end

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "editor" )