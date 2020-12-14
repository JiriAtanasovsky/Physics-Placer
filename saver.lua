local util = require "util"

local saver = {}

function saver.save( mainTable, filename, centerLeft )
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
	-- local maxWidth, maxHeight = -32768, -32768
	local minXBound, minYBound = 32767, 32767
	local maxXBound, maxYBound = -32768, -32768
	
	for i = 1, #saveTab.objects do
		local X,Y = saveTab.objects[i].x, saveTab.objects[i].y
		local W,H = saveTab.objects[i].width, saveTab.objects[i].height
		--bounderies of object
		local minXB, maxXB = X - W/2, X + W/2
		local minYB, maxYB = Y - H/2, Y + H/2
		
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
		
		if minXB < minXBound then
			minXBound = minXB
		end
		if minYB < minYBound then
			minYBound = minYB
		end
		if maxXB > maxXBound then
			maxXBound = maxXB
		end
		if maxYB > maxYBound then
			maxYBound = maxYB
		end
		
		-- if W > maxWidth then
			-- maxWidth = W
		-- end
		-- if H > maxHeight then
			-- maxHeight = H
		-- end
	end
	
	local totalWidth = maxXBound - minXBound
	local totalHeight = maxYBound - minYBound
	
	for i = 1, #saveTab.objects do
		local object = saveTab.objects[i]
		object.x = centerLeft and (object.x - minXBound) or (object.x - minXBound - totalWidth/2)
		object.y = object.y - minYBound - totalHeight
	end
	
	saveTab.totalWidth = totalWidth
	saveTab.totalHeight = totalHeight
	
	--save as json
	util.saveFile ( saveTab, filename )
end

return saver