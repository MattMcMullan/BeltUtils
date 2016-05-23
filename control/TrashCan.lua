require("Common")

function OnTrashCanEntityTick(_Entity)
    _Entity.entity.get_inventory(1).clear()
end
