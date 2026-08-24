-- toggle-gpu-effects.lua
-- Toggles all shaders and error-diffusion dithering on/off.
-- Preserves disabled state across file changes.

local mp  = require("mp")
local msg = require("mp.msg")

local effects_disabled = false
local saved_shaders    = {}
local saved_dither     = ""

local function toggle_effects()
    if not effects_disabled then
        -- Save current state using native API
        saved_shaders = mp.get_property_native("glsl-shaders", {})
        saved_dither  = mp.get_property("dither", "")

        mp.set_property_native("glsl-shaders", {})
        mp.set_property("dither", "no")

        effects_disabled = true
        mp.osd_message("GPU effects: OFF", 2)
        msg.info("disabled shaders and dithering")
    else
        -- Restore saved state
        mp.set_property_native("glsl-shaders", saved_shaders)
        mp.set_property("dither", saved_dither)

        effects_disabled = false
        mp.osd_message("GPU effects: ON", 2)
        msg.info("restored shaders and dithering")
    end
end

-- When a new file loads, auto-profiles re-apply and reset glsl-shaders/dither.
-- Capture the freshly applied profile values then disable again to stay consistent.
mp.register_event("file-loaded", function()
    if effects_disabled then
        saved_shaders = mp.get_property_native("glsl-shaders", {})
        saved_dither  = mp.get_property("dither", "")
        mp.set_property_native("glsl-shaders", {})
        mp.set_property("dither", "no")
        msg.info("file-loaded: effects still disabled, re-applied off state")
    end
    -- Effects-on case: no action needed.
    -- toggle_effects() always reads the current live state when disabling,
    -- so saved_shaders is always captured fresh at the moment of the next toggle.
end)

-- No default key; bind via input.conf: g script-binding toggle-gpu-effects
mp.add_key_binding(nil, "toggle-gpu-effects", toggle_effects)
