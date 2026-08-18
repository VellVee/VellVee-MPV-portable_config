-- toggle-gpu-effects.lua
-- Toggles all shaders and error-diffusion dithering on/off.

local mp = require("mp")
local msg = require("mp.msg")

local effects_disabled = false
local saved_shaders = ""
local saved_dither = ""

local function toggle_effects()
    if not effects_disabled then
        -- Save current state
        saved_shaders = mp.get_property("glsl-shaders", "")
        saved_dither = mp.get_property("dither", "")

        -- Disable
        mp.set_property("glsl-shaders", "")
        mp.set_property("dither", "no")

        effects_disabled = true
        mp.osd_message("GPU effects: OFF", 2)
        msg.info("disabled shaders and error-diffusion dithering")
    else
        -- Restore
        mp.set_property("glsl-shaders", saved_shaders)
        mp.set_property("dither", saved_dither)

        effects_disabled = false
        mp.osd_message("GPU effects: ON", 2)
        msg.info("restored shaders and error-diffusion dithering")
    end
end

-- No default key; bind via input.conf: g script-binding toggle-gpu-effects
mp.add_key_binding(nil, "toggle-gpu-effects", toggle_effects)
