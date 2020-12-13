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
	end
	
	if type ( toSave ) == "string" then
		local path = system.pathForFile( filename or "myfile.txt", system.DocumentsDirectory )
		
		local file, errorString = io.open( path, "w" )
 
		if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
		else
			-- Write data to file
			file:write( toSave )
			-- Close the file handle
			io.close( file )
			print ( "File saved." )
		end
		file = nil
	else
		return false
	end
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

return util