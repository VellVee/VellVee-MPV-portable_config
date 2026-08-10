-- autofit-wayland.lua
-- Replaces autofit for multi-monitor Wayland with different scaling factors.

local mp = require("mp")
local msg = require("mp.msg")

local AUTOFIT_PERCENT = 0.70

-- Monitor configs from: kscreen-doctor --outputs
-- Update these if you change monitors or scaling.
--   fps    = active mode refresh rate (used to detect which monitor)
--   width  = logical width  (Geometry W value from kscreen-doctor)
--   height = logical height (Geometry H value from kscreen-doctor)
local MONITORS = {
    { fps = 240, width = 2195, height = 1235, name = "DP-1 (4K@1.75x)" },
    { fps = 120, width = 2227, height = 1253, name = "DP-3 (1440p@1.15x)" },
}

local function find_monitor(display_fps)
    if not display_fps then return nil end
    for _, mon in ipairs(MONITORS) do
        if math.abs(display_fps - mon.fps) < 5 then
            return mon
        end
    end
    return nil
end

local function apply_autofit()
    local display_fps = mp.get_property_number("display-fps")
    local vw = mp.get_property_number("video-params/w")
    local vh = mp.get_property_number("video-params/h")
    local hidpi = mp.get_property_number("display-hidpi-scale") or 1.0

    if not display_fps or not vw or not vh or vw == 0 or vh == 0 then
        msg.verbose("missing properties, skipping")
        return
    end

    local mon = find_monitor(display_fps)
    if not mon then
        msg.warn(string.format("no monitor match for fps=%.1f", display_fps))
        return
    end

    -- 70% of monitor logical dimensions
    local max_w = mon.width * AUTOFIT_PERCENT
    local max_h = mon.height * AUTOFIT_PERCENT

    -- With hidpi-window-scale=yes, native window = video_size * hidpi_scale
    local native_w = vw * hidpi
    local native_h = vh * hidpi

    -- Don't upscale: if native size already fits in the 70% box, leave it
    if native_w <= max_w and native_h <= max_h then
        msg.info(string.format(
            "%s: video %dx%d native %dx%d fits in %dx%d, no resize",
            mon.name, vw, vh, native_w, native_h, max_w, max_h
        ))
        return
    end

    -- Calculate target size maintaining video aspect ratio
    local aspect = vw / vh
    local target_w, target_h

    if native_w / max_w > native_h / max_h then
        -- Width is the binding constraint
        target_w = math.floor(max_w)
        target_h = math.floor(max_w / aspect)
    else
        -- Height is the binding constraint
        target_h = math.floor(max_h)
        target_w = math.floor(max_h * aspect)
    end

    -- Geometry uses unscaled coordinates; compositor divides by hidpi to get
    -- the logical window size. Multiply by hidpi to compensate.
    local geom_w = math.floor(target_w * hidpi)
    local geom_h = math.floor(target_h * hidpi)

    msg.info(string.format(
        "%s: video=%dx%d hidpi=%.2f → geometry=%dx%d (target=%dx%d, 70%% of %dx%d)",
        mon.name, vw, vh, hidpi, geom_w, geom_h, target_w, target_h, mon.width, mon.height
    ))

    mp.set_property("geometry", geom_w .. "x" .. geom_h)
end

mp.register_event("file-loaded", function()
    mp.add_timeout(0.3, apply_autofit)
end)
