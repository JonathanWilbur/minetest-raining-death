local path = minetest.get_modpath("raining_death")
if minetest.registered_nodes["tnt:tnt_burning"] then
    dofile(path .. "/source/main.lua")
    minetest.log("action", "Raining Death Mod Loaded")
else
    minetest.log("error", "Raining Death Mod did not load because no burning TNT model was loaded.")
end