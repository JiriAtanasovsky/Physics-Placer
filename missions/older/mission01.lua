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
		
		["polygon_terrain"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   2499.5, 264.5  ,  2073, -214  ,  2497, -224  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -2281, -229  ,  -2156, -142  ,  -2500.5, 263.5  ,  -2497, -224  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   2499.5, 264.5  ,  1201, -96  ,  1505, -189  ,  1673, -223  ,  2073, -214  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -2027, -73  ,  -2500.5, 263.5  ,  -2156, -142  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -1885, -20  ,  -2500.5, 263.5  ,  -2027, -73  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   814, -106  ,  77, -37  ,  392, -224  ,  591, -272  ,  592, -272  ,  662, -254  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -859, -209  ,  -355, -34  ,  -1749, 8  ,  -1331, -174  ,  -1187, -215  ,  -1043, -233  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -1749, 8  ,  -2500.5, 263.5  ,  -1885, -20  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -2500.5, 263.5  ,  1201, -96  ,  2499.5, 264.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -355, -34  ,  -131, -3  ,  -2500.5, 263.5  ,  -1749, 8  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   905, -69  ,  -27, -11  ,  77, -37  ,  814, -106  }
                    }
                     ,
                    {
                    pe_fixture_id = "green_terrain", density = 2, friction = 100, bounce = 0.2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   905, -69  ,  -2500.5, 263.5  ,  -131, -3  }
                    }
                    
                    
                    
		}
		
		, 
		["polygon_floor"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "house", density = 2, friction = 0.2, bounce = 0.30000000000000004, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   66, 0  ,  -61, 1  ,  -61, -2  ,  66, -3  }
                    }
                    
                    
                    
		}
		
		, 
		["polygon_wall"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "house", density = 2, friction = 0.2, bounce = 0.30000000000000004, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -5, 41  ,  -7, 41  ,  -2, -37  ,  0, -37  }
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

