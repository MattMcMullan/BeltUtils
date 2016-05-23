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
