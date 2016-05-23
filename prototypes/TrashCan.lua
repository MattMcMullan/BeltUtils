-- Resource Definition
data:extend(
    {
    {
        type = "item",
        name = "Transport Belt Trash Can",
        icon = "__Belt-Utils__/graphics/TrashCan.png",
        flags = { "goes-to-quickbar" },
        subgroup = "belt",
        place_result="Transport Belt Trash Can",
        stack_size= 50,
    },
    }
)

-- Recipe
data:extend(
  { 
    {
      type = "recipe",
      name = "Transport Belt Trash Can",
      enabled = "true",
      ingredients = 
      {
        {"electronic-circuit",2},
        {"iron-plate",2}
      },
      result = "Transport Belt Trash Can"
    }
  }
)

-- Entity Prototype
data:extend(
    {
    {
        type = "container",
        name = "Transport Belt Trash Can",
        icon = "__Belt-Utils__/graphics/TrashCan.png",
        flags = {"placeable-neutral", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.5, result = "Transport Belt Trash Can"},
        max_health = 40,
        corpse = "small-remnants",
        resistances =
        {
            {
                type = "fire",
                percent = 90
            }
        },
        collision_box = {{-0.25, -0.25}, {0.25, 0.25}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        inventory_size = 32,
        picture =
        {
            filename = "__Belt-Utils__/graphics/TrashCan.png",
            priority = "extra-high",
            width = 38,
            height = 32,
            shift = {0.1, 0}
        }
    },
    }
)
