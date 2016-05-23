require("Common")

function OnTrashCanEntityTick(_EntityInfo)
    _EntityInfo.entity.get_inventory(1).clear()
    
    DeleteBeltOutputs(GetInputBelt(defines.direction.north, _EntityInfo.pos))
    DeleteBeltOutputs(GetInputBelt(defines.direction.south, _EntityInfo.pos))
    DeleteBeltOutputs(GetInputBelt(defines.direction.east, _EntityInfo.pos))
    DeleteBeltOutputs(GetInputBelt(defines.direction.west, _EntityInfo.pos))
end

function GetInputBelt(_Direction,_Position)
    local scanArea = GetScanArea(_Direction, _Position)
    local belt = game.get_surface(1).find_entities_filtered({type = "transport-belt", area = scanArea})[1]
    if (belt ~= nil and belt.direction ~= _Direction) then
        belt = nil
    end
    return belt
end

function DeleteBeltOutputs(_TransportBelt)
    if (nil == _TransportBelt) then
        return
    end
    
    for lineIndex=1,2 do
        local line = _TransportBelt.get_transport_line(lineIndex)
        if (not line.can_insert_at(0)) then
            local contents = line.get_contents()
            for itemName, itemCount in pairs(contents) do
                local stack = {name = itemName, count = 1}
                line.remove_item(stack)
                break
            end
        end
    end
end
