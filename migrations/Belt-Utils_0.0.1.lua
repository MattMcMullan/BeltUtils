game.reload_script()

for index, force in pairs(game.forces) do
  force.reset_recipes()
  force.reset_technologies()

  if force.technologies["oil-processing"].researched then
	  force.recipes["Trash Pipe"].enabled = true
  end
end