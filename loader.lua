local loader = {}

local util = require "util"
local physics = require "physics"

function loader.load ( group, touchListener, filename )
	local mainTable = {}
	mainTable.objects = {}
	
	local parameters = util.loadFile ( filename )
	
	local objectsPar = parameters.objects
	local objects = require ( "missions." .. filename:sub ( 1, -6 ) ).physicsData(1) --loose json extention
	
	for i = 1, #objectsPar do
		local par = objectsPar[i]
		local img = display.newImageRect ( group, "missions/".. par.name ..".png", par.width, par.height )
		img.x, img.y = par.x + display.contentCenterX, par.y + display.contentCenterY
		
		img.touch = touchListener
		
		img:addEventListener ( "touch", img.touch )
		
		img.name = par.name
		img.id = par.id
		img.joints = {}
		img.jointsParams = par.joints
		
		physics.addBody( img, objects:get ( par.name ) )
		
		mainTable.objects[par.id] = img
	end
	
	for objAid, img in pairs ( mainTable.objects ) do
		for i = 1, #img.jointsParams do
			local par = img.jointsParams[i]
			
			local jointType, jointObjA, jointObjB, A, B, C, D = par.jointType, img, mainTable.objects[par.objBId], 0,0,0,0

			if jointType == "rope" then
				newJoint = physics.newJoint ( jointType, jointObjA, jointObjB, A, B, C, D )
			else
				newJoint = physics.newJoint ( jointType, jointObjA, jointObjB, jointObjA.x + A, jointObjA.y + B, 0,0 )
			end
		end
	end
	
	util.printTable ( mainTable )
	
	return mainTable
end

return loader