# MPV Config

A personal quality-focused [mpv](https://mpv.io/) configuration tuned for high-end AMD hardware with a 4K HDR display. Most profiles require a high-end GPU to run smoothly. Additionally features a battery-optimized profile for laptops with Intel Iris Xe graphics.

Includes automated profile switching, a mixed-DPI Wayland multi-monitor window management script, GLSL shaders, and UI enhancements via [uosc](https://github.com/tomasklaen/uosc).

> [!NOTE]
> Much of the custom Lua scripting, profile automation, and tuning in this repository was created with AI assistance. I did my best to ensure scripts work well, but treat it 'as-is' with no guarantees provided.

---

## Features

- **Multi-Monitor & Mixed-DPI Wayland Sizing (`autofit-wayland.lua`)**:
  - Solves the Wayland multi-monitor bug where percentage-based autofit is calculated incorrectly when launched on a secondary monitor.
  - Detects active display per-monitor (in my case, 4K@1.75x and 1440p@1.15x) and scales windows cleanly to 70% while maintaining native aspect ratios. Easily adjustable in the script.
  - Automatically falls back to single-display geometry when running on laptops or single-monitor setups.

- **Automated Profile Switching**:
  - **Auto Hardware Detection**: Detects device type (desktop PC vs. laptop) based on battery presence.
  - **`[Laptop]`**: Battery-conscious profile for laptops with Intel Iris Xe graphics.
  - **`[SDR-Upscale]`**: Enhances sub-4K SDR live-action content using `SSimSuperRes.glsl` and `CfL_Prediction.glsl`.
  - **`[4KSDR]` & `[4KHDR]`**: High-accuracy settings for 4K OLED panels.
  - **`[Anime-GENERAL]`**: Computationally heavy anime upscaling utilizing `ArtCNN_C4F32.glsl` alongside `CfL_Prediction.glsl`.
  - **`[AnimeLanguageSwitch]`**: Automatically prioritizes Japanese/Korean/Chinese audio.
  - **`[Linux]` & `[Windows]`**: OS-specific hardware settings.
---

## Custom Keybindings

| Key | Action |
| :--- | :--- |
| `Right` / `Left` | Seek 2 seconds forward / backward (frame-perfect) |
| `Up` / `Down` | Volume +2% / -2% |
| `Wheel Up` / `Wheel Down` | Volume +2% / -2% |
| `g` | Toggle all GLSL shaders & error-diffusion dithering on/off |
| `h` | Open Memo playback history menu |
| `b` | Toggle debanding |
| `u` | Toggle custom subtitle style override |

---

## Shaders & Scripts

### Shaders

| Shader | Purpose | License | Link |
| :--- | :--- | :--- | :--- |
| **ArtCNN** (`ArtCNN_C4F32.glsl`) | Neural network anime upscaler | MIT | [Artoriuz/ArtCNN](https://github.com/Artoriuz/ArtCNN) |
| **CfL Prediction** (`CfL_Prediction.glsl`) | Chroma-from-Luma prediction shader | MIT | [agyild/CfL_Prediction](https://gist.github.com/agyild/82219c545228d70c5604f865ce0b0ce5) |
| **SSimDownscaler** (`SSimDownscaler.glsl`) | Perceptual SSIM-based downscaler | LGPL-3.0 | [igv/SSimDownscaler](https://gist.github.com/igv/075e86576b5d0cbab4d7b7e335272a8e) |
| **SSimSuperRes** (`SSimSuperRes.glsl`) | High-frequency detail and edge refinement | LGPL-3.0 | [igv/SSimSuperRes](https://gist.github.com/igv/2364ffa6e81540f29cb7ab4c9bc05b6b) |

### Scripts

Scripts are provided in this repository but updated only occasionally. Sources are listed below:

| Script | Description | License | Link |
| :--- | :--- | :--- | :--- |
| **uosc** | Modern, feature-rich minimal OSD/UI for mpv | GPL-3.0 | [tomasklaen/uosc](https://github.com/tomasklaen/uosc) |
| **memo** | Recent files and playback history manager | GPL-3.0 | [po5/memo](https://github.com/po5/memo) |
| **autoload** | Automatically loads playlist entries from directory | LGPL-2.1+ | [mpv-player/mpv (autoload.lua)](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) |
| **auto-save-state** | Periodically saves watch progress | GPL-3.0 | [Argon-/mpv-config](https://github.com/Argon-/mpv-config/blob/master/scripts/auto-save-state.lua) |
| **fuzzydir** | Fuzzy directory matching for external audio/subtitles | MIT | [sibwaf/mpv-scripts](https://github.com/sibwaf/mpv-scripts/blob/master/fuzzydir.lua) |
| **persist-properties** | Persists selected properties across restarts | MIT | [d87/mpv-persist-properties](https://github.com/d87/mpv-persist-properties) |
| **visualizer** | Audio visualization overlay for music playback | MIT | [mfcc64/mpv-scripts](https://github.com/mfcc64/mpv-scripts/blob/master/visualizer.lua) |
| **autofit-wayland** | Multi-monitor & mixed-DPI Wayland window scaler | GPL-3.0 | *Custom script* (`scripts/autofit-wayland.lua`) |
| **toggle-gpu-effects** | Toggles active GLSL shaders & dithering at runtime | GPL-3.0 | *Custom script* (`scripts/toggle-gpu-effects.lua`) |

---

## License

This repository is licensed under the **GNU General Public License v3.0** ([GPL-3.0](LICENSE)) to ensure full compatibility with the bundled GPL-3.0, LGPL-3.0, and MIT third-party scripts and shaders. Individual scripts and shaders remain under their respective upstream licenses as noted above.