local north = defines.direction.north
local east = defines.direction.east
local south = defines.direction.south
local west = defines.direction.west

function MoveItems(ItemName, InputLane, OutputLane)
    if OutputLane.can_insert_at_back() then
        local stack = {name = ItemName, count = 1}
        InputLane.remove_item (stack)
        OutputLane.insert_at_back(stack)
        return true
    end
    return false
end

function NegateSide(Side)
    if(Side == 1) then 
        return 2
    else if(Side == 2) then return 1
        else return 1 end
    end
end

function GetScanArea(_Direction, _Position)
    local beltscan_coords = { -- Points to search for transport belts.
        [north] = {{_Position.x - 0.3, _Position.y - 1.1},{_Position.x + 0.3, _Position.y - 0.8}},
        [east] =  {{_Position.x + 1.1  , _Position.y - 0.3},{_Position.x + 0.8, _Position.y + 0.3}},
        [south] = {{_Position.x - 0.3, _Position.y + 1.1},{_Position.x + 0.3, _Position.y + 0.8}},
        [west] =  {{_Position.x - 1.1  , _Position.y - 0.3},{_Position.x - 0.8, _Position.y + 0.3}}
    }

    if _Direction == north then
        return beltscan_coords[south]
    elseif _Direction == east then
        return beltscan_coords[west]
    elseif _Direction == south then
        return beltscan_coords[north]
    elseif _Direction == west then
        return beltscan_coords[east]
        else
        return {{pos.x , pos.y},{pos.x , pos.y}}
    end
end

function GetFrontBelt(_Entity)  
    local frontBelt = _Entity.cachedInBelt
    if nil == frontBelt or not frontBelt.valid or not frontBelt.direction == _Entity.dir then
        _Entity.cachedInBelt = nil
        frontBelt = nil
        
        local scanArea = GetScanArea(_Entity.dir, _Entity.pos)
        local belt = game.get_surface(1).find_entities_filtered({type = "transport-belt", area = scanArea})
        if belt[1] ~= nil and belt[1].direction == _Entity.dir then
            frontBelt = belt[1]
            _Entity.cachedInBelt = frontBelt
        end
    end
    return frontBelt
end

function GetRearBelt(_Entity)
    local rearBelt = _Entity.cachedOutBelt
    if nil == rearBelt or not rearBelt.valid or not rearBelt.direction == _Entity.dir then
        _Entity.cachedOutBelt = nil
        rearBelt = nil
        
        local facing_directions = {[north] = south, [east] = west, [south] = north, [west] = east}
        local scanArea = GetScanArea(facing_directions[_Entity.dir], _Entity.pos)
    
        local belt = game.get_surface(1).find_entities_filtered({type = "transport-belt", area = scanArea})
        if belt[1] ~= nil and belt[1].direction == _Entity.dir then
            rearBelt = belt[1]
            _Entity.cachedOutBelt = rearBelt
        end
    end
    return rearBelt
end
