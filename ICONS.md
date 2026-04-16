# java+ File Type Icons

This document describes the icon system for the java+ programming language.

## Icon Design Specification

### Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary | `#FF6B35` | Vibrant Orange - Main accent, J+ text |
| Secondary | `#004E89` | Deep Blue - Trust, technology, folder tabs |
| Accent | `#F7B801` | Golden Yellow - Highlights, achievements |
| Background | `#1A1A2E` | Dark Navy - Document backgrounds |

### Icon Types

#### 1. Source Files (.jpp)
- **Shape**: Document with folded corner
- **Symbol**: `J+` monogram in orange
- **Style**: Flat design with subtle gradient and shadow
- **Sizes**: 16x16, 32x32, 48x48, 64x64, 128x128, 256x256, 512x512

#### 2. Project Folders
- **Shape**: Standard folder with tab
- **Symbol**: Gamepad icon
- **Color**: Blue folder with orange accent
- **Style**: Slightly open suggesting active project

#### 3. Compiled Builds (.jpx)
- **Shape**: Gear/cog icon
- **Symbol**: Binary pattern background
- **Color**: Metallic gray with orange highlights
- **Style**: 3D appearance suggesting executable power

#### 4. Asset Bundles (.jpa)
- **Shape**: Stacked layers
- **Symbol**: Image + Sound wave symbols
- **Color**: Purple gradient
- **Style**: Layered appearance

#### 5. Config Files (.jpc)
- **Shape**: Gear with document
- **Symbol**: Wrench/settings icon
- **Color**: Green
- **Style**: Clean, technical

## Installation

### macOS

```bash
# After running install.sh, install icons with:
sudo ~/.javaplus/scripts/install_icons_macos.sh

# Or manually apply icons:
# 1. Right-click a .jpp file
# 2. Select "Get Info"
# 3. Drag ~/.javaplus/icons/jpp.icns to the icon in the top left
```

### Linux

```bash
# After running install.sh, install icons with:
~/.javaplus/scripts/install_icons_linux.sh

# Log out and log back in for changes to take effect
```

### Windows

Windows icon installation requires manual steps or a registry script (coming soon).

## Generating Icons

Icons are generated using the Python script:

```bash
# Requires Pillow
pip install Pillow

# Generate all icons
python3 scripts/generate_icons.py ~/.javaplus/icons
```

## Visual Style Guidelines

- **Flat Design**: Modern, clean appearance
- **Subtle Depth**: Soft shadows for layering
- **Rounded Corners**: 2-3px radius for friendly feel
- **Consistent Stroke**: 2px outline width
- **High Contrast**: Accessible color combinations
- **Dark Mode Optimized**: Works well in dark themes

## Icon Locations After Installation

```
~/.javaplus/
├── icons/
│   ├── jpp-16.png
│   ├── jpp-32.png
│   ├── jpp-48.png
│   ├── jpp-64.png
│   ├── jpp-128.png
│   ├── jpp-256.png
│   ├── jpp-512.png
│   ├── jpp.icns          (macOS)
│   ├── jpp-folder-256.png
│   ├── jpp-build-256.png
│   └── Info.plist        (macOS)
└── scripts/
    ├── generate_icons.py
    ├── install_icons_macos.sh
    └── install_icons_linux.sh
```

## File Associations

### macOS
- Extension: `.jpp`
- MIME Type: `text/x-jpp`
- Bundle ID: `dev.javaplus.jpp`
- Icon: `jpp.icns`

### Linux
- Extension: `.jpp`
- MIME Type: `text/x-jpp`
- Icon Name: `text-x-jpp`

### Windows
- Extension: `.jpp`
- ProgID: `javaplus.jpp`
- Icon: `%USERPROFILE%\.javaplus\icons\jpp-256.png`
