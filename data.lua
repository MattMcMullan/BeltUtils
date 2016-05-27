require("prototypes.SingleSplitter")
require("prototypes.LeftLaneDiverter")
require("prototypes.RightLaneDiverter")
require("prototypes.TrashCan")
require("prototypes.TrashPipe")

table.insert(data.raw.technology["oil-processing"].effects,{type = "unlock-recipe", recipe = "Trash Pipe"})
