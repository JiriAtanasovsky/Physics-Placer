-----------------------------------------------------------------------------------------
--This is main editor module.
--@module editor

local filename = "m4a1"
local objects = require ( "missions." .. filename ).physicsData(1)

local composer = require( "composer" )
local scene = composer.newScene()

local util = require "util"
local widget = require "widget"
local physics = require "physics"
local isPhysicsPaused
local physicsDrawMode = "hybrid"

local saver = require "saver"
local centerLeftOnSave = false
local loader = require "loader"

local metod = "create"
local selectedObject, selectedJoint
local jointObjA, jointObjB, jointLine

---Table of supported types of joints with their parameters in indexed subtable.
--@table jointTypes
local jointTypes = { 
	weld = { "anchor_x", "anchor_y", }, --weld joint "anchor_x", "anchor_y" ( content coords)
	pivot = { "anchor_x", "anchor_y", }, --pivot joint "anchor_x", "anchor_y" ( content coords)
	friction = { "anchor_x", "anchor_y", }, --friction joint "anchor_x", "anchor_y" ( content coords)
	rope = { "offsetA_x", "offsetA_y", "offsetB_x", "offsetB_y" }, --rope joint "offsetA_x", "offsetA_y", "offsetB_x", "offsetB_y" ( local coords)
	}
	
local spawnTypes = { "player", "enemy" }
local whatSpawn = "player"
	
local sliderVal = { 0,0,0,0 }

local ui, uiGroup
local panGroup

local mainTable

--- Displays info text that transits up and disapears
-- Some description, can be over several lines.
-- @param X first parameter
-- @param Y second parameter
-- @param text second parameter
-- @param group second parameter
-- @return nothing
-- @see second_fun
function info ( X, Y, text, group )

	local infotext = display.newText ( {
		text = text,
		x = X,
		y = Y,
		
	})
	group:insert ( infotext )
	
	transition.to ( infotext, { y = Y - 200, time = 2000, onComplete = function () display.remove (infotext) end, } )
end

local function setMetod ( met )
	metod = met
	ui.metodText.text = tostring ( metod )
	
	if metod == "joint" then
		ui:showSliders ( true )
	else
		ui:showSliders ( false )
	end
end

local function keyListener ( event )
	local phase = event.phase
	local key = event.keyName
	
	if phase == "up" then
		if key == "p" then
			if isPhysicsPaused then
				physics.start ()
				isPhysicsPaused = false
				ui.physicsText.text = "RUNNING " .. physicsDrawMode
			else
				physics.pause ()
				isPhysicsPaused = true
				ui.physicsText.text = "PAUSED " .. physicsDrawMode
			end
		elseif key == "q" then
			setMetod ( "pan" )
		elseif key == "d" then
			setMetod ( "drag" )
		elseif key == "insert" then
			setMetod ( "create" )
		elseif key == "deleteForward" then
			setMetod ( "deleteObject" )
		elseif key == "deleteBack" then
			setMetod ( "deleteJoint" )
		elseif key == "j" then
			setMetod ( "joint" )
		elseif key == "b" then
			setMetod ( "bodyType" )
		elseif key == "o" then
			physicsDrawMode = physicsDrawMode == "hybrid" and "normal" or "hybrid"
			ui.physicsText.text = ( isPhysicsPaused and "PAUSED" or "RUNNING" ) .. " " .. physicsDrawMode
			physics.setDrawMode( physicsDrawMode )
		else
			print ( key )
		end
	end
end

function touchListener ( event )
	local phase = event.phase
	local target = event.target
	
	if metod == "drag" then
		if ( phase == "began" ) then
			-- Set touch focus
			display.getCurrentStage():setFocus( target )
			target.isFocus = true
			
			target.offsetX, target.offsetY = target.x - event.x, target.y - event.y
		elseif ( target.isFocus ) then
			if ( phase == "moved" ) then
			target.x, target.y = math.round (event.x + target.offsetX), math.round (event.y + target.offsetY)
			elseif ( phase == "ended" or phase == "cancelled" ) then
				-- Reset touch focus
				display.getCurrentStage():setFocus( nil )
				target.isFocus = nil
			end
		end
	elseif metod == "deleteObject" then
		if ( phase == "ended" ) then
			info ( event.x, event.y, "delete " .. target.name, target.parent )
			local targetID = target.id
			local targetGroup = target.parent
			mainTable.objects[targetID] = nil
			display.remove ( target )
			
			--search for orphaned joints ( joints where this was B object )
			for i = 1, #mainTable.objects do
				local object = mainTable.objects[i]
				-- print ( i, object )
				if object then
					for a = #object.jointsParams, 1, -1 do
						
						local jointParams = object.jointsParams[a]
						-- print ( "  " .. a )
						if jointParams.objBId == targetID then
							-- print ( "   remove" )
							info ( event.x, event.y, "orphaned joint removed", targetGroup )
							display.remove ( object.joints[a] )
							table.remove ( object.joints, a )
							table.remove ( object.jointsParams, a )
						end
					end
				end
			end
			targetGroup = nil
		end
	elseif metod == "deleteJoint" then
		if ( phase == "ended" and #target.joints > 0 ) then

			for i = #target.joints, 1, -1 do
				local jointToDelete = target.joints[i]
				local jointToDeleteParams = target.jointsParams[i]
				info ( event.x, event.y, "delete " .. jointToDeleteParams.jointType .. " JOINT on " .. target.name, target.parent )
				display.remove ( jointToDelete )
				
				table.remove ( target.joints, i )
				table.remove ( target.jointsParams, i )
			end
		end
	elseif metod == "joint" then
		if selectedJoint then
			if phase == "began" and target then
				jointObjA = target
				-- jointLine = display.newLine ( target.x, target.y, event.x, event.y )
				-- jointLine.strokeWidth = 4
			elseif phase == "moved" and jointObjA and target then
				display.remove ( jointLine )
				jointLine = display.newLine ( panGroup, jointObjA.x + sliderVal[1], jointObjA.y + sliderVal[2], target.x + sliderVal[3], target.y + sliderVal[4] )
				jointLine.strokeWidth = 4
				
				jointObjB = target
			elseif phase == "ended" and target and jointObjA then
				
			elseif phase == "cancelled" then
				print ( "CANCELLED" )
				display.remove ( jointLine )
				jointLine = nil
				jointObjA, jointObjB = nil, nil
			end
		end
	elseif metod == "bodyType" then
		if phase == "began" and target then
			target.bodyType = target.bodyType == "dynamic" and "static" or "dynamic"
			info ( event.x, event.y, target.bodyType, target.parent )
		end
	elseif metod == "pan" then
		return false
	end

	return true
end

local function runtimeTouchListener ( event )
	local phase = event.phase
	local target = event.target
	
	if metod == "pan" then
		if ( phase == "began" ) then
			panGroup.originalX = panGroup.x
			panGroup.originalY = panGroup.y
		elseif ( phase == "moved" ) then
			panGroup.x = event.xDelta + panGroup.originalX
			panGroup.y = event.yDelta + panGroup.originalY
		end
		
	elseif metod == "create" then
		if selectedObject and objects then
			if phase == "ended" then
				local img
				if selectedObject:find ( "polygon" ) then
					img = display.newGroup ()
					panGroup:insert ( img )
					for i = 1, #objects.data[selectedObject] do
						local newPolygonParams = util.getBoundingCentroid ( objects.data[selectedObject][i].shape )
						img[i] = display.newPolygon ( img, newPolygonParams.centroid.x, newPolygonParams.centroid.y, objects.data[selectedObject][i].shape )
					end
				else
					img = util.newImage ( panGroup, "missions/" .. selectedObject .. ".png" )
				end
				
				img.x, img.y = panGroup:contentToLocal ( math.round ( event.x ), math.round ( event.y ) )
				img.name = selectedObject
				img.joints = {}
				img.jointsParams = {}
				img.touch = touchListener
				img:addEventListener ( "touch", img.touch )
				
				physics.addBody( img, objects:get ( selectedObject ) )
				mainTable.objects[#mainTable.objects+1] = img
				img.id = #mainTable.objects
			end
		end
	elseif metod == "spawn" then
		if event.phase == "ended" then
			local X, Y = panGroup:contentToLocal ( event.x, event.y )
			local newSpawn = display.newText( {
				parent = panGroup,
				x = math.round ( X ),
				y = math.round ( Y ),
				text = whatSpawn,
				})
			newSpawn.name = "spawn"..whatSpawn
			newSpawn.spawnType = whatSpawn
			newSpawn:setFillColor ( 1,0,0,1 )
			
			-- newSpawn.touch = touchListener
			-- newSpawn:addEventListener ( "touch", newSpawn.touch )
			
			mainTable.spawn[#mainTable.spawn+1] = newSpawn
		end
	else
	
	end
end

function createButtonAction ()
	if metod == "joint" and jointObjA and jointObjB and jointLine then
	--create new joint
		display.remove ( jointLine )
		jointLine = nil
		if not ( jointObjA == jointObjB ) then
			
			local newJoint
			
			if selectedJoint == "rope" then
				newJoint = physics.newJoint ( selectedJoint, jointObjA, jointObjB, sliderVal[1],sliderVal[2],sliderVal[3],sliderVal[4] )
			else
				newJoint = physics.newJoint ( selectedJoint, jointObjA, jointObjB, jointObjA.x + sliderVal[1], jointObjA.y + sliderVal[2], 0,0 )
			end
			info ( jointObjA.x, jointObjA.y, selectedJoint, jointObjA.parent )
			
			jointObjA.joints[#jointObjA.joints+1] = newJoint
			jointObjA.jointsParams[#jointObjA.jointsParams+1] = { jointType = selectedJoint, objBId = jointObjB.id, slider1 = sliderVal[1], slider2 = sliderVal[2], slider3 = sliderVal[3], slider4 = sliderVal[4] }
		else
			info ( jointObjA.x, jointObjA.y, "Same objects selected!", jointObjA.parent )
			jointObjB = nil
		end
	else
		print ( "Couldnt create anything" )
	end
end

function spawnButtonAction ( event )
	local what = event.target:getLabel ()
	whatSpawn = what
	setMetod ( "spawn" )
end

function sliderListener ( event )
	local id = event.target.id
	local val = event.value*4 - 200
	
	ui["sliderText"..id].text = ui["sliderText"..id].par .. " " .. val
	sliderVal[id] = val
	
	if metod == "joint" and jointObjA and jointObjB and jointLine then
		display.remove ( jointLine )
		jointLine = display.newLine ( panGroup, jointObjA.x + sliderVal[1], jointObjA.y + sliderVal[2], jointObjB.x + sliderVal[3], jointObjB.y + sliderVal[4] )
		jointLine.strokeWidth = 4
	end
end

function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect ( sceneGroup, display.contentCenterX, display.contentCenterY, 2000, 1200 )
	background:setFillColor ( 0.5,0.5,0.5 )
	
	mainTable = {}
	mainTable.objects = {}
	mainTable.spawn = {} --spawn points
	
	physics.start()
	physics.setDrawMode ( physicsDrawMode )
	physics.setGravity( 0, 10 )
	physics.pause()
	isPhysicsPaused = true
	
	panGroup = display.newGroup()
	sceneGroup:insert ( panGroup )
	
	--UI
	uiGroup = display.newGroup()
	sceneGroup:insert ( uiGroup )
	
	ui = {}
	ui.metodText = display.newText ({
		x = util.border.left + 100,
		y = util.border.up + 100,
		text = metod,
	})
	
	ui.physicsText = display.newText ({
		x = util.border.left + 200,
		y = util.border.up + 100,
		text = "PAUSED " .. physicsDrawMode,
	})
	
	local function saveWrap () saver.save ( mainTable, filename..".json", centerLeftOnSave ) end
	
	ui.save = widget.newButton( {
		onPress = saveWrap,
		x = util.border.right - 60,
		y = util.border.up + 60,
		shape = "roundedRect",
		width = 100,
		height = 100,
		cornerRadius = 2,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
		strokeWidth = 4,
		label = "Save",
	})
	
	local function savecheckboxAction ( event ) centerLeftOnSave = event.target.isOn end
	
	ui.savecheckbox = widget.newSwitch( {
		x = util.border.right - 170,
		y = util.border.up + 60,
        style = "checkbox",
        id = "Checkbox",
        onPress = savecheckboxAction
    })
	
	ui.savecheckboxText = display.newText ({
		x = util.border.right - 170,
		y = util.border.up + 80,
		text = "Center left",
	})
	
	
	local function loadWrap ()
		-- for i = #mainTable.objects, 1, -1 do
		for i, v in pairs ( mainTable.objects ) do
			display.remove ( v )
			mainTable.objects[i] = nil
		end
		
		for i = 1, #mainTable.spawn do
			display.remove ( mainTable.spawn[i] )
			mainTable.spawn[i] = nil
		end
		
		mainTable = nil
		mainTable = loader.load ( panGroup, touchListener, filename..".json", display.contentCenterX, display.contentCenterY )
	end
	
	ui.save = widget.newButton( {
		onPress = loadWrap,
		x = util.border.right - 60,
		y = util.border.up + 170,
		shape = "roundedRect",
		width = 100,
		height = 100,
		cornerRadius = 2,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
		strokeWidth = 4,
		label = "Load",
	})
	
	--lines to mark middles
	local line1 = display.newLine ( panGroup, display.contentCenterX, -22000, display.contentCenterX, 22000 )
	local line2 = display.newLine ( panGroup, -22000, display.contentCenterY, 22000, display.contentCenterY )
	
	line1.strokeWidth, line2.strokeWidth = 2,2
	
	--=================================
	--LOAD OBJECTS FROM PhysicsEditor FILE
	--=================================
	
	local counter = 1
	
	ui.objectText = display.newText ({
		x = util.border.left + 60,
		y = util.border.up + 150,
		text = tostring ( selectedObject ),
	})
	
	function selectObject ( event )
		--what object will spawn on click
		setMetod ( "create" )
		
		local object = event.target:getLabel ()
		selectedObject = object
		ui.objectText.text = object
	end
	
	for obj in pairs ( objects.data ) do
		ui[obj .. "Button"] = widget.newButton({
			onPress = selectObject,
			x = util.border.left + 60,
			y = util.border.up + 200 + 60 * counter,
			shape = "roundedRect",
			width = 100,
			height = 50,
			cornerRadius = 2,
			fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
			strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
			strokeWidth = 4,
			label = obj,
		}
		)
		
		counter = counter + 1
	end
	
	--=================================
	--CREATE BUTTONS FOR JOINTs CREATION
	--=================================	
	function selectJoint ( event )
		setMetod ( "joint" )
		
		local jointType = event.target:getLabel ()
		selectedJoint = jointType
		ui.objectText.text = jointType
		
		--labels on sliders
		local params = jointTypes[selectedJoint]
		ui:setSliders ( params )
	end
	
	counter = 1
	
	--for i = 1, #jointTypes do
	for joint, params in pairs ( jointTypes ) do
		ui[joint .. "jointButton"] = widget.newButton({
			onPress = selectJoint,
			x = util.border.right - 60,
			y = util.border.up + 200 + 60 * counter,
			shape = "roundedRect",
			width = 100,
			height = 50,
			cornerRadius = 2,
			fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
			strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
			strokeWidth = 4,
			label = joint,
		}
		)
		counter = counter + 1
	end
	
	counter = nil
	
	--=================================
	--CREATE SLIDERS
	--=================================	

	for i = 1, 4 do
		local startX, gapX, Y = 10, 220, 40
		local W = 200
		
		ui["slider"..i] = widget.newSlider({
			x = util.border.left + startX + gapX*i,
			y = util.border.up + Y,
			width = W,
			value = 50,
			id = i,
			listener = sliderListener,
		})
		
		ui["sliderText"..i] = display.newText ({
			x = util.border.left + startX + gapX*i,
			y = util.border.up + Y*2,
			text = " - - 0",
		})
		
		ui["sliderText"..i].par = " - - "
	end
	
	ui["createButton"] = widget.newButton({
		onPress = createButtonAction,
		x = util.border.right - 460,
		y = util.border.up + 100,
		shape = "roundedRect",
		width = 100,
		height = 50,
		cornerRadius = 2,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
		strokeWidth = 4,
		label = "createJoint",
	}
	)
	
	function ui:setSliders ( params )
		for a = 1, 4 do
			sliderVal[a] = 0
			self["slider"..a]:setValue ( 50 )
			self["sliderText"..a].par = params[a] and params[a] or " - - "
			self["sliderText"..a].text = self["sliderText"..a].par .. " " .. sliderVal[a]
		end
	end
	
	function ui:showSliders ( yesno )
		for a = 1, 4 do
			self["slider"..a].isVisible = yesno
			self["sliderText"..a].isVisible = yesno
		end
		ui["createButton"].isVisible = yesno
	end
	
	--=================================
	--CREATE SPAWN POINTs BUTTONS
	--=================================	
	
	for i = 1, #spawnTypes do
		local what = spawnTypes[i]
		ui[what.."spawnButton"] = widget.newButton({
		onPress = spawnButtonAction,
		x = util.border.left + 60*i,
		y = util.border.down - 60,
		shape = "roundedRect",
		width = 50,
		height = 50,
		cornerRadius = 2,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
		strokeWidth = 4,
		label = what,
		}
		)
	end
	
	--=================================
	--=================================
	
	for k,v in pairs ( ui ) do
		if type ( v ) == "table" then
			uiGroup:insert ( v )
		end
	end

	Runtime:addEventListener( "key", keyListener )
	Runtime:addEventListener( "touch", runtimeTouchListener )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		
		metod = "drag"
		Runtime:removeEventListener( "key", keyListener )
		
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	for k, v in pairs ( ui ) do
		display.remove ( v )
		ui[k] = nil
	end
	ui = nil
	uiGroup = nil
	panGroup = nil
	mainTable = nil
	objects = nil
	metod = "drag"
	
	centerLeftOnSave = false
	
	selectedObject, selectedJoint = nil, nil
	jointObjA, jointObjB, jointLine = nil, nil, nil
	
	Runtime:removeEventListener( "key", keyListener )
	Runtime:removeEventListener( "touch", runtimeTouchListener )

	physics.stop ()
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-----------------------------------------------------------------------------------------

return scene
