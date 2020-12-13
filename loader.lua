local loader = {}

local util = require "util"
local physics = require "physics"

function loader.load ( group, touchListener, filename, offsetX, offsetY )
	local mainTable = {}
	mainTable.objects = {}
	
	local parameters = util.loadFile ( filename )
	
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
	
	for objAid, img in pairs ( mainTable.objects ) do
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
	
	-- util.printTable ( mainTable )
	
	return mainTable
end

return loader