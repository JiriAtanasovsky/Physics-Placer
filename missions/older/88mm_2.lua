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
		
		["base"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "0500-base-1200", density = 2, friction = 100, bounce = 0.7, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -200, -5  ,  -39, -17  ,  39, -17  ,  209, -2  ,  211, 15.5  ,  -209, 15.5  ,  -214, 4.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "0500-base-1200", density = 2, friction = 100, bounce = 0.7, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   211, 15.5  ,  209, -2  ,  213, 7.5  }
                    }
                    
                    
                    
		}
		
		, 
		["body"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "0300-body-1000", density = 4, friction = 10, bounce = 0.4, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   98.5, 24.5  ,  71, 35  ,  29, 29  ,  -98, -5.5  ,  -96.5, -34.5  ,  -81.5, -57.5  ,  13, -53.5  ,  83, -39.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "0300-body-1000", density = 4, friction = 10, bounce = 0.4, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -41, 58  ,  -94.5, 21.5  ,  -98, -5.5  ,  29, 29  ,  28, 57.5  }
                    }
                    
                    
                    
		}
		
		, 
		["barell"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "0200-barell-1000", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   278, 17  ,  108, 16  ,  121, 4  ,  283, 4  ,  289, 6  ,  291.5, 14.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "0200-barell-1000", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   -292.5, 38.5  ,  -292.5, 14.5  ,  -287, -5  ,  -229, -14  ,  -6, 52  ,  -276, 52  ,  -289.5, 48.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "0200-barell-1000", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   -6, 52  ,  -229, -14  ,  -212, -42  ,  -203, -48  ,  -186, -53  ,  2, 21  ,  3.5, 47.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "0200-barell-1000", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   -12, -4.5  ,  -186, -53  ,  -185, -53  ,  -17, -30  }
                    }
                     ,
                    {
                    pe_fixture_id = "0200-barell-1000", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   -186, -53  ,  74, 20  ,  2, 21  }
                    }
                     ,
                    {
                    pe_fixture_id = "0200-barell-1000", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 8192, maskBits = 65535, groupIndex = 0 },
                    shape = {   108, 16  ,  74, 20  ,  -12, -4.5  ,  65, -4  ,  121, 4  }
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

