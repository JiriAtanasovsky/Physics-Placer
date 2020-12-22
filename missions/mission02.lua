-- This file is for use with Corona(R) SDK
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
	local physics = { data =
	{ 
		
		["bush"] = {
                    
		}
		
		, 
		["cliff"] = {
                    
		}
		
		, 
		["hedgehog"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "hedgehog", density = 2, friction = 1000, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -36, -38  ,  42, 22  ,  46, 39  ,  37, 39  ,  -45, -23  ,  -45, -34  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "hedgehog", density = 2, friction = 1000, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -45, 24  ,  36, -38  ,  46, -22  ,  -37, 39  ,  -45, 39  }
                    }
                     ,
                    {
                    pe_fixture_id = "hedgehog", density = 2, friction = 1000, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   46, -22  ,  36, -38  ,  45, -34  }
                    }
                    
                    
                    
		}
		
		, 
		["polygon-beach"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "096-091-041-beach", density = 2, friction = 20, bounce = 0.1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   2654.5, 65  ,  2654.5, 184  ,  -2650.5, 184  ,  -2650.5, -182  }
                    }
                    
                    
                    
		}
		
		, 
		["sandbag1"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "sandbag", density = 2, friction = 300, bounce = 0.1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   14.5, -4.5  ,  14.5, 6.5  ,  11.5, 12.5  ,  -11.5, 12.5  ,  -15.5, 8.5  ,  -15.5, -5.5  ,  -10.5, -13.5  ,  9.5, -13.5  }
                    }
                    
                    
                    
		}
		
		, 
		["sandbag2"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "sandbag", density = 2, friction = 300, bounce = 0.1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   15.5, -4  ,  15.5, 7  ,  12.5, 13  ,  -10.5, 13  ,  -14.5, 9  ,  -14.5, -5  ,  -9.5, -13  ,  10.5, -13  }
                    }
                    
                    
                    
		}
		
		, 
		["sandbag3"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "sandbag", density = 2, friction = 300, bounce = 0.1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   15, -4  ,  15, 7  ,  12, 13  ,  -11, 13  ,  -15, 9  ,  -15, -5  ,  -10, -13  ,  10, -13  }
                    }
                    
                    
                    
		}
		
		, 
		["polygon-cliff"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "054-068-018-cliff", density = 2, friction = 150, bounce = 0.5, 
                    filter = { categoryBits = 32768, maskBits = 65535, groupIndex = 0 },
                    shape = {   416, -97.5  ,  440, -51.5  ,  -488, -52.5  ,  357, -137.5  ,  391, -127.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "054-068-018-cliff", density = 2, friction = 150, bounce = 0.5, 
                    filter = { categoryBits = 32768, maskBits = 65535, groupIndex = 0 },
                    shape = {   351, -175.5  ,  340, -171.5  ,  -488, -52.5  ,  -487, -237.5  ,  336, -241.5  ,  351, -223.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "054-068-018-cliff", density = 2, friction = 150, bounce = 0.5, 
                    filter = { categoryBits = 32768, maskBits = 65535, groupIndex = 0 },
                    shape = {   -488, -52.5  ,  340, -171.5  ,  357, -137.5  }
                    }
                    
                    
                    
		}
		
	} }

        -- apply scale factor
        local s = scale or 1.0
        for bi,body in pairs(physics.data) do
                for fi,fixture in ipairs(body) do
                    if(fixture.shape) then
                        for ci,coordinate in ipairs(fixture.shape) do
                            fixture.shape[ci] = s * coordinate
                        end
                    else
                        fixture.radius = s * fixture.radius
                    end
                end
        end
	
	function physics:get(name)
		return unpack(self.data[name])
	end

	function physics:getFixtureId(name, index)
                return self.data[name][index].pe_fixture_id
	end
	
	return physics;
end

return M
