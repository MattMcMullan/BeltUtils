require("Common")
local north = defines.direction.north
local east = defines.direction.east
local south = defines.direction.south
local west = defines.direction.west

function IsSingleSplitter(_Entity)
    return (_Entity.name == "Single Splitter")
end

function GetSplitterInBelt(Splitter)  
    local inBelt = Splitter.cachedInBelt			
    if nil == inBelt or not inBelt.valid or not inBelt.direction == Splitter.dir then
        Splitter.cachedInBelt = nil
        inBelt = nil
		
        local scanArea = GetScanArea(Splitter.dir, Splitter.pos)
        local belt = game.get_surface(1).find_entities_filtered({	type="transport-belt", area = scanArea})
        if belt[1] ~= nil and belt[1].direction == Splitter.dir then			
            inBelt = belt[1]
            Splitter.cachedInBelt = inBelt
        end
    end
    return inBelt
end

function GetSplitterOutBelt(Splitter)  
    local outBelt = Splitter.cachedOutBelt			
    if nil == outBelt or not outBelt.valid or not outBelt.direction == Splitter.dir then
        Splitter.cachedOutBelt = nil
        outBelt = nil
		
        local facing_directions = {[north] = south, [east] = west, [south] = north, [west] = east}
        local scanArea = GetScanArea(facing_directions[Splitter.dir], Splitter.pos)
    
        local belt = game.get_surface(1).find_entities_filtered({	type="transport-belt", area = scanArea})
        if belt[1] ~= nil and belt[1].direction == Splitter.dir then			
            outBelt = belt[1]
            Splitter.cachedOutBelt = outBelt
        end
    end
    return outBelt
end

function OnSingleSplitterEntityTick(splitter)
    local inBelt = GetSplitterInBelt(splitter)
    local outBelt = GetSplitterOutBelt(splitter)	
    
    if (splitter.lastOut == nil) then splitter.lastOut = {1 , 1} end
    if nil ~= inBelt and nil ~= outBelt then
        for i=1,2 do
            local takeFromSide = NegateSide(splitter.lastInSide)
            local takeToSide = NegateSide(splitter.lastOut[takeFromSide])	
            
            local InLane = inBelt.get_transport_line(takeFromSide)
            local OutLane = outBelt.get_transport_line(takeToSide)
            
            if InLane.can_insert_at(0) then
                takeFromSide = NegateSide(takeFromSide)
                takeToSide = NegateSide(splitter.lastOut[takeFromSide])
                InLane = inBelt.get_transport_line(takeFromSide)
                OutLane = outBelt.get_transport_line(takeToSide)					
            end	

            if not InLane.can_insert_at(0) then
                local InLaneContents=InLane.get_contents()	
                for itemName,_ in pairs(InLaneContents) do 
                
                    local moved = true
                    if not MoveItems(itemName, InLane, OutLane) then 
                        takeToSide = NegateSide(takeToSide)	
                        OutLane = outBelt.get_transport_line(takeToSide)
                        if not MoveItems(itemName, InLane, OutLane) then
                            moved = false
                        end
                    end
                    
                    if (moved) then 
                        splitter.lastInSide = takeFromSide
                        splitter.lastOut[takeFromSide] = takeToSide
                    end
                end
            end
        end
    end
end
