require("Common")
local north = defines.direction.north
local east = defines.direction.east
local south = defines.direction.south
local west = defines.direction.west

function IsSingleSplitter(_Entity)
    return (_Entity.name == "Single Splitter")
end

function OnSingleSplitterEntityTick(_Entity)
    local inBelt = GetFrontBelt(_Entity)
    local outBelt = GetRearBelt(_Entity)
    
    if (_Entity.lastOut == nil) then _Entity.lastOut = {1 , 1} end
    if nil ~= inBelt and nil ~= outBelt then
        for i=1,2 do
            local takeFromSide = NegateSide(_Entity.lastInSide)
            local takeToSide = NegateSide(_Entity.lastOut[takeFromSide])
            
            local InLane = inBelt.get_transport_line(takeFromSide)
            local OutLane = outBelt.get_transport_line(takeToSide)
            
            if InLane.can_insert_at(0) then
                takeFromSide = NegateSide(takeFromSide)
                takeToSide = NegateSide(_Entity.lastOut[takeFromSide])
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
                        _Entity.lastInSide = takeFromSide
                        _Entity.lastOut[takeFromSide] = takeToSide
                    end
                end
            end
        end
    end
end
