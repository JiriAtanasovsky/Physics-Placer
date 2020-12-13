local util = require "util"

local saver = {}

function saver.save( mainTable, filename )
	local saveTab = {}
	saveTab.objects = {}
	saveTab.spawn = {}
	
	--put processed data into saveTab
	local saveI = 1 --this is to prevent gaps in table in case obj = nil (deleted object)
	for i = 1, #mainTable.objects do
		local obj = mainTable.objects[i]
		
		if obj then
			saveTab.objects[saveI] = {
				x = obj.x,
				y = obj.y,
				width = obj.width,
				height = obj.height,
				name = obj.name,
				id = i,
				joints = obj.jointsParams,
				bodyType = obj.bodyType,
				
				-- joints = obj.joints --this is user data
				
				}
			saveI = saveI + 1
		end
	end
	
	--optimize x and y to start @ 0,0
	local minX, minY = 32767, 32767
	local maxX, maxY = -32768, -32768
	
	for i = 1, #saveTab.objects do
		local X,Y = saveTab.objects[i].x, saveTab.objects[i].y
		if X < minX then
			minX = X
		end
		if Y < minY then
			minY = Y
		end
		if X > maxX then
			maxX = X
		end
		if Y > maxY then
			maxY = Y
		end
	end
	
	local totalWidth = maxX - minX
	local totalHeight = maxY - minY
	
	for i = 1, #saveTab.objects do
		local object = saveTab.objects[i]
		print ( object.x, object.y )
		object.x = object.x - minX -- totalWidth / 2
		object.y = object.y - minY -- totalHeight / 2
		print ( object.x, object.y )
	end
	
	saveTab.totalWidth = totalWidth
	saveTab.totalHeight = totalHeight
	
	--save as json
	util.saveFile ( saveTab, filename .. ".json" )
end

return saver