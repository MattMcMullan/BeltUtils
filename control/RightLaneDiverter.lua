require("Common")

function OnRightLaneDiverterEntityTick(_Entity)
    local frontBelt = GetFrontBelt(_Entity)
    local rearBelt = GetRearBelt(_Entity)
    
    if (_Entity.lastOut == nil) then
        _Entity.lastOut = {1, 1}
    end
    
    if nil ~= frontBelt and nil ~= rearBelt then
        local takeFromSide = NegateSide(_Entity.lastInSide)
        local takeToSide =2
        local frontLane = frontBelt.get_transport_line(takeFromSide)
        local rearLane = rearBelt.get_transport_line(takeToSide)
        
        if frontLane.can_insert_at(0) then
            takeFromSide = NegateSide(takeFromSide)
            frontLane = frontBelt.get_transport_line(takeFromSide)
        end
        
        if not frontLane.can_insert_at(0) then
            local frontLaneItem = frontLane.get_contents()
            for itemName, itemCount in pairs(frontLaneItem) do
                if MoveItems(itemName, frontLane, rearLane) then
                    _Entity.lastInSide = takeFromSide
                end
            end
        end
    end
end
