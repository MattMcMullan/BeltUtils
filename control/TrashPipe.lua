require("Common")

function OnTrashPipeEntityTick(_EntityInfo)
    local fluid = _EntityInfo.entity
    if (fluid ~= nil and fluid.valid) then
        if (fluid.fluidbox[1] ~= nil and fluid.fluidbox[1].amount == 10) then
            fluid.fluidbox[1] = nil
        end
    end
end