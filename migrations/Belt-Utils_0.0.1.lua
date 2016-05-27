game.reload_script()

for index, force in pairs(game.forces) do
    force.reset_recipes()
    force.reset_technologies()

    if force.technologies["oil-processing"].researched then
      force.recipes["Trash Pipe"].enabled = true
    else
      force.recipes["Trash Pipe"].enabled = false
    end
    
    if force.technologies["logistics"].researched then
      force.recipes["Left Lane Diverter"].enabled = true
      force.recipes["Right Lane Diverter"].enabled = true
    else
      force.recipes["Left Lane Diverter"].enabled = false
      force.recipes["Right Lane Diverter"].enabled = false
    end
    
    if force.technologies["electronics"].researched then
      force.recipes["Transport Belt Trash Can"].enabled = true
      force.recipes["Single Splitter"].enabled = true
    end
end