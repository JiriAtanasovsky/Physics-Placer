-----------------------------------------------------------------------------------------
--This is loader module.
--@module loader

local loader = {}

local util = require "util"
local physics = require "physics"

function loader.load ( group, touchListener, filename, offsetX, offsetY )
	local mainTable = {}
	mainTable.objects = {}
	mainTable.spawn = {}
	
	local parameters = util.loadFile ( filename )
	local spawnPar = parameters.spawn or {}
	local objectsPar = parameters.objects
	local objects = require ( "missions." .. filename:sub ( 1, -6 ) ).physicsData(1) --loose json extention
	
	for i = 1, #objectsPar do
		local par = objectsPar[i]
		
		local img
		if par.name:find ( "polygon" ) then
			img = display.newGroup ()
			group:insert ( img )
			for i = 1, #objects.data[par.name] do
				local newPolygonParams = util.getBoundingCentroid ( objects.data[par.name][i].shape )
				img[i] = display.newPolygon ( img, newPolygonParams.centroid.x, newPolygonParams.centroid.y, objects.data[par.name][i].shape )
			end
		else
			img = display.newImageRect ( group, "missions/".. par.name ..".png", par.width, par.height )
		end
		img.x, img.y = par.x + ( offsetX or 0 ), par.y + ( offsetY or 0 )
		
		img.touch = touchListener
		
		img:addEventListener ( "touch", img.touch )
		
		img.name = par.name
		img.id = par.id
		img.joints = {}
		img.jointsParams = par.joints
		
		physics.addBody( img, objects:get ( par.name ) )
		img.bodyType = par.bodyType
		
		mainTable.objects[par.id] = img
	end
	
	for a = 1, #mainTable.objects do
		local img = mainTable.objects[a]
		for i = 1, #img.jointsParams do
			local par = img.jointsParams[i]
			
			local jointType, jointObjA, jointObjB, A, B, C, D = par.jointType, img, mainTable.objects[par.objBId], par.slider1,par.slider2,par.slider3,par.slider4

			if jointType == "rope" then
				newJoint = physics.newJoint ( jointType, jointObjA, jointObjB, A, B, C, D )
			else
				newJoint = physics.newJoint ( jointType, jointObjA, jointObjB, jointObjA.x + A, jointObjA.y + B, 0,0 )
			end
		end
	end
	
	for i = 1, #spawnPar do
		local X,Y,whatSpawn = spawnPar[i].x, spawnPar[i].y, spawnPar[i].spawnType
		
		local newSpawn = display.newText( {
			parent = group,
			x = X + ( offsetX or 0 ),
			y = Y + ( offsetY or 0 ),
			text = whatSpawn,
			})
		newSpawn.spawnType = whatSpawn
		newSpawn:setFillColor ( 1,0,0,1 )
		newSpawn.name = "spawn"..whatSpawn
		
		-- newSpawn.touch = touchListener
		-- newSpawn:addEventListener ( "touch", newSpawn.touch )
		
		mainTable.spawn[#mainTable.spawn+1] = newSpawn
	end
	
	-- util.printTable ( mainTable )
	
	return mainTable
end

return loader