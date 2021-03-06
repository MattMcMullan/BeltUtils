require "defines"
require("control.SingleSplitter")
require("control.LeftLaneDiverter")
require("control.RightLaneDiverter")
require("control.TrashCan")
require("control.TrashPipe")

remote.add_interface("SingleSplitter",
{
    clean = function()
        global.SingleSplitter = {}
        global.BeltUtils = {}
    end
})

script.on_init(function() OnInitOrLoadOrUpgrade() end)
script.on_event(defines.events.on_tick, function(event) OnTick(event) end)
script.on_event(defines.events.on_built_entity, function(event) OnBuiltEntity(event) end)
script.on_event(defines.events.on_entity_died, function(event) OnRemovedEntity(event) end)
script.on_event(defines.events.on_preplayer_mined_item, function(event) OnRemovedEntity(event) end)
script.on_event(defines.events.on_player_rotated_entity, function(event) OnPlayerRotatedEntity(event) end)
script.on_event(defines.events.on_robot_built_entity, function(event) OnBuiltEntity(event) end)
script.on_event(defines.events.on_robot_pre_mined, function(event) OnRemovedEntity(event) end)
script.on_load(function() OnInitOrLoadOrUpgrade() end)

function OnInitOrLoadOrUpgrade()
    -- While not technically required for public releases, this level of granularity allows for smooth upgrades, even during development
    if (nil == global.SingleSplitter) then
        global.SingleSplitter = {}
    end

    if (nil == global.BeltUtils) then
        global.BeltUtils = {}
    end
    
    local name = "SingleSplitter"
    if (nil == global.BeltUtils[name]) then
        global.BeltUtils[name] = {
            ["Instances"] = global.SingleSplitter,
            ["OnEntityTick"] = OnSingleSplitterEntityTick
        }
    end
    
    name = "Left Lane Diverter"
    if (nil == global.BeltUtils[name]) then
        global.BeltUtils[name] = {
            ["Instances"] = {},
            ["OnEntityTick"] = OnLeftLaneDiverterEntityTick
        }
    end
    
    name = "Right Lane Diverter"
    if (nil == global.BeltUtils[name]) then
        global.BeltUtils[name] = {
            ["Instances"] = {},
            ["OnEntityTick"] = OnRightLaneDiverterEntityTick
        }
    end
    
    name = "Transport Belt Trash Can"
    if (nil == global.BeltUtils[name]) then
        global.BeltUtils[name] = {
            ["Instances"] = {},
            ["OnEntityTick"] = OnTrashCanEntityTick
        }
    end
    
    name = "Trash Pipe"
    if (nil == global.BeltUtils[name]) then
        global.BeltUtils[name] = {
            ["Instances"] = {},
            ["OnEntityTick"] = OnTrashPipeEntityTick
        }
    end
end

function OnPlayerRotatedEntity(_Event)
    local entity = _Event.entity
    local managedEntityInformation = global.BeltUtils[entity.name]
    
    -- This is not an entity managed by us
    if (managedEntityInformation == nil) then
        return
    end
    
    for key,value in pairs(managedEntityInformation["Instances"]) do 
        if value.pos.x == entity.position.x and value.pos.y == entity.position.y then
            value.dir = entity.direction
            value.cachedInBelt = nil
            value.cachedOutBelt = nil
            break
        end 
    end
end

function OnTick(_Event)	
    if((game.tick % 5) ~= 0) then return end
    
    for _,managedEntityInformation in pairs(global.BeltUtils) do
        for _, entity in pairs(managedEntityInformation["Instances"]) do
            managedEntityInformation["OnEntityTick"](entity)
        end
    end
end

function OnBuiltEntity(_Event)
    local _Entity = _Event.created_entity
    local managedEntityInformation = global.BeltUtils[_Entity.name]
    
    -- This is not an entity managed by us
    if (managedEntityInformation == nil) then
        return
    end
    
    -- This is the key that we will use later to identify this entity
    local set = {
        pos = _Entity.position,
        dir = _Entity.direction,
        lastInSide = 1,
        lastOut = {1,2},
        entity = _Entity
    }
    
    table.insert(managedEntityInformation["Instances"], set)
end

function OnRemovedEntity(_Event)
    local entity = _Event.entity
    local managedEntityInformation = global.BeltUtils[entity.name]
    
    -- This is not an entity managed by us
    if (managedEntityInformation == nil) then
        return
    end
    
    -- once we have found the correct type, we must find the instance
    for key,value in pairs(managedEntityInformation["Instances"]) do 
        if value.pos.x == entity.position.x and value.pos.y == entity.position.y then
            table.remove(managedEntityInformation["Instances"], key)
            break
        end
    end
end
