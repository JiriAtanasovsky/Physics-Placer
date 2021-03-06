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
		
		["barell"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "barell", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   73.5, -26  ,  89.5, -22.5  ,  101.5, 12.5  ,  91.5, 23  ,  65.5, 25  ,  41.5, 11  ,  43.5, -3.5  ,  52.5, -19  }
                    }
                     ,
                    {
                    pe_fixture_id = "barell", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   101.5, 12.5  ,  89.5, -22.5  ,  101, -12.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "barell", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   41.5, 11  ,  -100.5, 8  ,  -101.5, -1.5  ,  43.5, -3.5  }
                    }
                    
                    
                    
		}
		
		, 
		["reference"] = {
                    
		}
		
		, 
		["tower"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "0500-barell-1100", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -46.5, -11  ,  -20.5, -19  ,  -50.5, 43  ,  -79.5, 43  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "0400-tower-800", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -20.16101837158203, -19.932205200195312  ,  58.5, -20  ,  64.5, -12  ,  81.5, 39  ,  81.5, 45  ,  -50.5, 43  }
                    }
                     ,
                    {
                    pe_fixture_id = "0400-tower-800", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   89.5, 37  ,  81.5, 39  ,  64.5, -12  ,  88.5, -12  }
                    }
                    
                    
                    
		}
		
		, 
		["wheel"] = {
                    
                    
                    
                    {
                    pe_fixture_id = "wheel", density = 2, friction = 100, bounce = 0, 
                    filter = { categoryBits = 8192, maskBits = 57343, groupIndex = 0 },
                    radius = 25.942
                    }
                    
                    
		}
		
		, 
		["wheel_back"] = {
                    
                    
                    
                    {
                    pe_fixture_id = "wheel_back", density = 2, friction = 100, bounce = 0.1, 
                    filter = { categoryBits = 8192, maskBits = 57343, groupIndex = 0 },
                    radius = 25.255
                    }
                    
                    
		}
		
		, 
		["wheel_front"] = {
                    
                    
                    
                    {
                    pe_fixture_id = "wheel_front", density = 2, friction = 100, bounce = 0.1, 
                    filter = { categoryBits = 8192, maskBits = 57343, groupIndex = 0 },
                    radius = 31.200
                    }
                    
                    
		}
		
		, 
		["body"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "0600-armor-1200", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -217.5, 48.5  ,  -228.5, 18.5  ,  -102.5, -64.5  ,  -66.5, -64.5  ,  -66.5, 33.5  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "0600-engine-0900", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   219.5, -39.5  ,  229.5, -19.5  ,  223.5, 2.5  ,  170.5, 45.5  ,  93.5, 31.5  ,  92.5, -59.5  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "0600-body-1000", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   92.5, -60.5  ,  92.5, 31.5  ,  -66.5, 33.5  ,  -66.5, -64.5  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "0400-belly-0800", density = 2, friction = 100, bounce = 0.5, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   170.5, 46.5  ,  -216.5, 48.5  ,  -66.5, 32.5  ,  92.5, 30.5  }
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

