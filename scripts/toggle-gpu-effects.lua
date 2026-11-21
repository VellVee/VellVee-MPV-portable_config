-- toggle-gpu-effects.lua
-- Toggles all shaders and error-diffusion dithering on/off.
-- Preserves disabled state across file changes and auto-profile evaluations.

local mp  = require("mp")
local msg = require("mp.msg")

local effects_disabled = false
local saved_shaders    = {}
local saved_dither     = "error-diffusion"

local function toggle_effects()
    if not effects_disabled then
        local current_shaders = mp.get_property_native("glsl-shaders", {})
        if current_shaders and #current_shaders > 0 then
            saved_shaders = current_shaders
        end

        local current_dither = mp.get_property("dither", "")
        if current_dither and current_dither ~= "" and current_dither ~= "no" then
            saved_dither = current_dither
        end

        effects_disabled = true
        mp.set_property_native("glsl-shaders", {})
        mp.set_property("dither", "no")

        mp.osd_message("GPU effects: OFF", 2)
        msg.info("disabled shaders and dithering")
    else
        effects_disabled = false
        mp.set_property_native("glsl-shaders", saved_shaders)
        mp.set_property("dither", saved_dither)

        mp.osd_message("GPU effects: ON", 2)
        msg.info("restored shaders and dithering")
    end
end

-- When auto-profiles re-apply shaders/dither on new files or property changes while disabled,
-- capture the incoming profile values and suppress them immediately so effects stay OFF.
mp.observe_property("glsl-shaders", "native", function(_, val)
    if effects_disabled and val and #val > 0 then
        saved_shaders = val
        mp.set_property_native("glsl-shaders", {})
        msg.info("auto-profile applied shaders while disabled; saved and suppressed")
    end
end)

mp.observe_property("dither", "string", function(_, val)
    if effects_disabled and val and val ~= "no" then
        saved_dither = val
        mp.set_property("dither", "no")
        msg.info("auto-profile applied dither while disabled; saved and suppressed")
    end
end)

-- No default key; bind via input.conf: g script-binding toggle-gpu-effects
mp.add_key_binding(nil, "toggle-gpu-effects", toggle_effects)

