-----------------------------------------------------------------------------------------
--This is utilities module.
--@module utilities

local util = {}

math_sqrt = math.sqrt
math_atan = math.atan2
math_deg = math.deg
math_rad = math.rad
math_abs = math.abs
math_sin = math.sin
math_cos = math.cos
math_acos = math.acos

function util.printTable ( tbl, iter )
--[[
prints full table and tables inside this table
]]	

	if not ( type ( tbl ) == "table" ) then print ( "WARNING: no table provided to print" ) return false end
	local itr = iter or 0 --this is for recursive function to prevent stack overflow
	if itr < 3 then
		local tabulator = ""
		for i = 1, itr do
			tabulator = tabulator .. "        "
		end
		for k, v in pairs ( tbl ) do
			if type ( v ) == "table" then
				print ( tabulator..tostring(k)..":" )
				util.printTable ( v, itr + 1 )
				print ( tabulator.."=====" )
			else
				print ( tabulator..tostring(k), tabulator..tostring(v) )
			end
		end
	else
		return false
	end
end

function util.saveFile ( what, filename )
--[[
saves string or table as string or json formated string
]]
	local toSave = what
	
	if type ( toSave ) == "table" then
		local json = require "json"
		toSave = json.encode( toSave )
		toSave = json.prettify ( toSave )
		json = nil
	end
	
	if type ( toSave ) == "string" then
		local path = system.pathForFile( filename or "myfile.txt", system.DocumentsDirectory )
		
		local file, errorString = io.open( path, "w" )
 
		if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
			return false
		else
			-- Write data to file
			file:write( toSave )
			-- Close the file handle
			io.close( file )
			print ( "File saved." )
			file = nil
			return true
		end
		
	else
		return false
	end
end

function util.loadFile ( filename )
--[[
looks for filename in documents folder and tries to convert if from json to lua table
returns lua table created from json string saved in filename
]]
	local jsonString
	local convertedTable
	
	local path = system.pathForFile( filename or "myfile.txt", system.DocumentsDirectory )
	local file, errorString = io.open( path, "r" )
	
	if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
		else
			jsonString = file:read ( "*a" )
			io.close ( file )
		end
	
	if jsonString then
		local json = require "json"
		convertedTable = json.decode (jsonString)
		json = nil
	end
	
	return convertedTable or false
end

util.border = {
	CX = display.contentCenterX,
	CY = display.contentCenterY,
	left = - ( ( display.actualContentWidth - display.contentWidth ) / 2 ),
	right = ( ( display.actualContentWidth - display.contentWidth ) / 2 ) + display.contentWidth, --Height is width --landscape position, not portrait
	up = - ( ( display.actualContentHeight - display.contentHeight ) / 2 ),
	down = ( ( display.actualContentHeight - display.contentHeight ) / 2 ) + display.contentHeight,
}

util.newImage = function (...)
	--schroederapps
	--source: https://forums.solar2d.com/t/is-there-a-way-to-use-newimagerect-taking-automatically-the-width-and-height-of-the-1x-image/346684/2
	local parent = display.currentStage
	local filename = ''
	local baseDir = system.ResourceDirectory
	local w, h = nil, nil
	for i = 1, #arg do
		local a = arg[i]
			if type(a) == 'string' then
				filename = a
			elseif type(a) == 'table' then
				parent = a
			elseif type(a) == 'userdata' then
				baseDir = a
			elseif type(a) == 'number' then
				if w == nil then
					w = a
				else
					h = a
				end
			end
	end
	
	if (w == nil and h == nil) then
		local sizer = display.newImage(filename, baseDir)
		w, h = sizer.width, sizer.height
		display.remove(sizer)
		sizer = nil
	end
	
	img = display.newImageRect(parent, filename, baseDir, w, h)
	return img
end

function util.getBoundingCentroid( pts )
	--source: https://gist.github.com/HoraceBury/9431861
	--[[
	Calculates the middle of a polygon's bounding box - as if drawing a square around the polygon and finding the middle.
	Also calculates the width and height of the bounding box.
	
	Parameters:
		Polygon coordinates as a table of points, display group or list of coordinates.
	
	Returns:
		Centroid (centre) x, y
		Bounding box width, height
	
	Notes:
		Does not centre the polygon. To do this use: math.centrePolygon
]]--

	local function tableToPoints( tbl )
	-- converts a table of {x,y,x,y,...} to points {x,y}
		local pts = {}
		
		for i=1, #tbl-1, 2 do
			pts[#pts+1] = { x=tbl[i], y=tbl[i+1] }
		end
		
		return pts
	end

	pts = tableToPoints( pts )
	
	local xMin, xMax, yMin, yMax = 100000000, -100000000, 100000000, -100000000
	
	for i=1, #pts do
		local pt = pts[i]
		if (pt.x < xMin) then xMin = pt.x end
		if (pt.x > xMax) then xMax = pt.x end
		if (pt.y < yMin) then yMin = pt.y end
		if (pt.y > yMax) then yMax = pt.y end
	end
	
	local width, height = xMax-xMin, yMax-yMin
	local cx, cy = xMin+(width/2), yMin+(height/2)
	
	local output = {
		centroid = { x=cx, y=cy },
		width = width,
		height = height,
		bounding = { xMin=xMin, xMax=xMax, yMin=yMin, yMax=yMax },
	}
	
	return output
end

return util