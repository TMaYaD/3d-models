# 3D Models Repository

This repository contains a collection of 3D models developed over time using FreeCAD and OpenSCAD. The models include source files (.FCStd, .scad), exported formats (.stl, .step, .3mf), and some slicer project files.

**Last Updated:** January 8, 2026

## Table of Contents

- [Overview](#overview)
- [Project Categories](#project-categories)
- [File Formats](#file-formats)
- [Libraries](#libraries)
- [Projects](#projects)
  - [Game Organization](#game-organization)
  - [Furniture](#furniture)
  - [Electronics & Mounting](#electronics--mounting)
  - [Cable Management](#cable-management)
  - [Home Improvement](#home-improvement)
  - [Storage & Organization](#storage--organization)
  - [Tools & Jigs](#tools--jigs)
  - [Hardware & Brackets](#hardware--brackets)
  - [Work in Progress](#work-in-progress)
- [Dependencies](#dependencies)

## Overview

This repository contains **60+ 3D models** spanning various categories including furniture, electronics enclosures, organizational systems, tools, and home improvement items. Models are primarily created in:
- **FreeCAD** (.FCStd) - Parametric CAD models
- **OpenSCAD** (.scad) - Programmatic CAD models

Most projects include exported formats ready for 3D printing:
- **STL** - Standard 3D printing format
- **STEP** - CAD exchange format
- **3MF** - Modern 3D printing format with slicer project data

## Project Categories

### Game Organization

#### Catan Game Storage System
A complete storage solution for Settlers of Catan board game components.

**Location:** `Catan/`

**Files:**
- `catan case.FCStd` / `catan case.step` - Main game case
- `catan case 2.FCStd` / `catan case 2.step` / `catan case 2.3mf` - Alternative case design
- `catan lid.FCStd` / `catan lid.step` - Case lid
- `catan game part holder.FCStd` / `catan game part holder.step` - Holder for game pieces
- `catan player part holder.FCStd` / `catan player part holder.step` - Player-specific component holder
- `catan cards holder.FCStd` / `catan cards holder.step` - Card storage component

**Added:** January 8, 2025

---

### Furniture

#### Drawing Room Sofa
Complete modular sofa system with multiple components.

**Location:** `Drawing room sofa/`

**Files:**
- `Assembly.FCStd` / `Assembly.step` - Complete assembly model
- `Components.FCStd` - Individual components
- `Corner Unit.FCStd` - Corner section
- `Drawing room Sofa center.FCStd` - Center section
- `Drawing room Sofa corner.FCStd` - Corner variant
- `Drawing room Sofa lounger.FCStd` - Lounger section
- `Lounger Unit.FCStd` - Lounger component
- `Single Unit.FCStd` - Single seat unit

**Added:** January 8, 2025

---

### Electronics & Mounting

#### ESP8266 Programming Jig
Jig for flashing ESP/Beken chips using pogo sticks.

**Files:**
- `esp jig.scad` / `esp jig.stl`

**Added:** August 22, 2024

#### Charger Stand
Stand for charging devices with USB-A adapter support.

**Files:**
- `Charger stand.scad` / `Charger stand.stl` / `Charger stand.3mf`

**Added:** February 18, 2024
**Updated:** February 21, 2024 (USB-A adapter support)

#### Meanwell LRS Power Supply Wall Mount
Wall mount system for Meanwell LRS power supplies.

**Files:**
- `Meanwell-LRS-powersupply wall mount.scad`
- `Meanwell-LRS-powersupply wall mount top.stl` / `Meanwell-LRS-powersupply wall mount top.3mf`
- `Meanwell-LRS-powersupply wall mount bottom.stl`

**Added:** November 23, 2024

#### Fan Temperature Controller Case
Enclosure for fan temperature controller.

**Files:**
- `fan temperature controller case .FCStd`
- `fan temperature controller case -base.step`

**Added:** January 8, 2025

#### Tablet Wall Mount
Wall mounting system for tablets.

**Files:** (WIP - check git history)

**Added:** March 12, 2025

---

### Cable Management

#### Cable Helix
Helical cable management system.

**Files:**
- `cable helix.scad`

#### Cable Spiral
Spiral cable organizer supporting multiple connectors.

**Files:**
- `cable spiral.scad` / `cable spiral.stl`

**Added:** August 22, 2024
**Updated:** August 23, 2024 (multiple connector support)

#### Cable Winder Gridfinity Base
Gridfinity-compatible base for cable winder.

**Files:**
- `cable winder gridfinity base.scad`
- `cable winder gridfinity base 1x1.stl` / `cable winder gridfinity base 1x1.3mf`
- `cable winder gridfinity base 4x1.stl`

**Added:** March 12, 2025

#### Cable Wrap
Cable wrapping system with cutout.

**Location:** `cable-wrap/`
**Files:**
- `cable cutout.scad`

#### Nexon Dicky Grommet Cable Spacer
Cable spacer for Nexon car dicky (trunk) grommet.

**Files:**
- `nexon dicky grommet cable spacer.scad`
- `nexon dicky grommet cable spacer.stl`
- `nexon dicky grommet cable spacer-thin.stl`

**Added:** November 4, 2024

---

### Home Improvement

#### Shower Cover System
Complete shower cover system with multiple components.

**Files:**
- `shower cover.FCStd` / `shower cover.step`
- `shower cover-Half shell.3mf`
- `shower cover-half shell, inner.step`
- `shower cover-Half shell, outer.step`
- `shower cover support.step`
- `Shower Washer.step` / `Shower Washer - with cut.step`

**Added:** January 8, 2025

#### Pipe Cover
Cover for pipes.

**Files:**
- `pipe cover.FCStd` / `pipe cover.step` / `pipe cover.3mf`

**Added:** January 8, 2025

#### Pipe Adapter
Configurable pipe adapter with flexible dimensions.

**Files:**
- `pipe adapter.scad` / `pipe adapter.stl`

**Added:** March 12, 2025

#### Pool Filter Pipe Adapter
Adapter for pool filter pipes.

**Files:**
- `pool filter pipe adapter.scad`

**Added:** January 8, 2025

#### Curtain Double Track Template
Template for double track curtain systems.

**Files:**
- `Curtain Double Track template.scad` / `Curtain Double Track template.stl`

**Added:** January 8, 2025

#### Electric Point Cover
Cover for electrical gang boxes.

**Files:**
- `electric point cover.FCStd` / `electric point cover.step`

**Added:** January 8, 2025

#### Downlight Bracket for Candle Holder
Bracket for mounting downlights with candle holders.

**Files:**
- `Downlight bracket for candle holder.FCStd` / `Downlight bracket for candle holder.step`

**Added:** January 8, 2025

#### Wall Light Bracket
Bracket for wall-mounted lights.

**Files:**
- `wall light bracket.FCStd` / `wall light bracket.step`

**Added:** January 8, 2025

---

### Storage & Organization

#### Wine Grid System
Hexagonal grid system for wine storage with jig.

**Files:**
- `wine grid.scad` / `wine grid.stl` / `wine grid.3mf`
- `wine grid jig.stl` / `wine grid jig.3mf`

**Added:** March 12, 2025

#### Gridfinity System
Various Gridfinity-compatible organizers.

**Amazonbasics Precision Screwdriver Gridfinity**
- `gridfinity - amazonbasics precision screwdriver.FCStd` / `gridfinity - amazonbasics precision screwdriver.step`

**Tweezers Gridfinity**
- `Tweezers.FCStd` / `tweezer bin.FCStd`

**Added:** January 8, 2025

#### KitchenAid Organizer
Organizer for KitchenAid accessories.

**Files:**
- `kitchenaid organiser.scad` / `kitchenaid organiser.stl` / `kitchenaid organiser.3mf`

**Added:** January 8, 2025

#### TTR Tray
Tray system (TTR - likely Table Top Roleplaying).

**Files:**
- `TTR tray.scad` / `TTR tray.stl` / `TTR tray.3mf`
- `TTR tray copy.scad`

**Added:** January 8, 2025

#### SAMLA Rod Holder
Rod holder for IKEA SAMLA containers.

**Files:**
- `samla-rod-holder.scad`

**Added:** March 10, 2025

#### Bangle Holder
Holder for bangles/jewelry.

**Files:**
- `bangle-holder.stl`

**Added:** January 8, 2025

---

### Tools & Jigs

#### Narrow Profile Hinge Jig
Jig for making precise cuts in narrow aluminum profiles to fit Blum hinges.

**Files:**
- `narrow-profile-hinge-jig.stl`

**Added:** March 12, 2025

#### Spacer Cutting Jig
Jig for cutting silicone spacers precisely.

**Files:**
- `spacer cutting jig.scad` / `spacer cutting jig.stl`

**Added:** November 23, 2024
**Updated:** March 12, 2025 (optimized design)

#### Comma-3x Install Jig
Installation jig for Comma 3x with spacer system.

**Files:**
- `comma-3x install jig.scad` / `comma-3x install jig.stl` / `comma-3x install jig.3mf`

**Added:** March 12, 2025

#### Multiconnect Connector Cutout
Negative cutout for multiconnect connectors.

**Files:**
- `Multiconnect - connector cutout - negative.scad`

---

### Hardware & Brackets

#### Picture Frame Hook
Hook with interlocking teeth for picture frames.

**Files:**
- `picture frame hook.scad` / `picture frame hook.stl`

**Added:** March 12, 2025

#### Remote Wall Bracket
Wall bracket for remote controls.

**Files:**
- `remote wall bracket.scad` / `remote wall bracket.stl`

**Added:** August 22, 2024

#### Beam Hook
Hook for MS (metal stud) beams.

**Files:**
- `beam hook.scad` / `beam hook.stl`

**Added:** November 23, 2024

#### Screw Driver Clip
Clip for holding screwdrivers.

**Files:**
- `screw-driver-clip.scad` / `screw-driver-clip.stl`

**Added:** January 8, 2025

#### Knob
Knob with axel and indicator.

**Files:**
- `knob.scad` / `knob.stl`

**Added:** March 12, 2025

#### Partition Connector
Configurable connector for partitions.

**Files:**
- `partition-connector.scad`

**Added:** March 12, 2025

#### Hiliter Stand
Stand for Hiliter products.

**Files:**
- `hiliter stand.FCStd` / `hiliter stand.step`

**Added:** January 8, 2025

#### Bush
Bushing component.

**Files:**
- `bush.step`

**Added:** January 8, 2025

#### Silicone Spray Nozzle
Nozzle for 10mm rod silicone spray.

**Files:**
- `silicone spray nozzle - 10mm rod.FCStd` / `silicone spray nozzle - 10mm rod.step`

**Added:** January 8, 2025

---

### Miscellaneous

#### Simple Person
Simple person model.

**Files:**
- `simple person.scad` / `simple person.stl`

**Added:** January 8, 2025

#### For Stamp
Model for stamping.

**Files:**
- `For Stamp.scad`

**Added:** January 8, 2025

#### Bone Handle
Handle in the shape of a bone.

**Files:**
- `bone handle.scad`

**Added:** November 4, 2024

---

## Libraries

### OpenSCAD Libraries

**Location:** `lib/`

#### `honeycomb.scad`
Library for creating repeating honeycomb patterns around a center hex grid.

**Author:** Daniel <headbulb>

**Usage:** Used in wine grid system and other hexagonal grid projects.

#### `ESPModels.scad`
Comprehensive ESP8266 module library with detailed component models.

**Versions:**
- V1.4 - 2018-11-16 (DonJuanito)
- V1.5 - 2023-11-14 (Mads Kjeldgaard)

**Supported Modules:**
- ESP-01 through ESP-13
- ESP-12F/ESP-12E
- Witty
- Wemos D1 Mini, D1 Battery Shield, D1 Prototyping Shield
- NodeMCU V0.9, V1.0, V3 (Amica, RoboDyn, LoLin), USB-C version
- And more...

**Usage:** Used in ESP jig and other ESP8266-related projects.

---

## Dependencies

### External Libraries

**Location:** `vendor/`

#### Gridfinity Rebuilt OpenSCAD
Submodule containing the Gridfinity Rebuilt OpenSCAD library by kennetek.

**Repository:** `vendor/kennetek/gridfinity-rebuilt-openscad/`

This is a comprehensive library for creating Gridfinity-compatible storage systems. Used in several Gridfinity projects in this repository.

---

## File Formats

### Source Files
- **.FCStd** - FreeCAD native format (parametric CAD)
- **.scad** - OpenSCAD format (programmatic CAD)

### Exported Formats
- **.stl** - Stereolithography format (standard for 3D printing)
- **.step** - STEP format (CAD exchange format)
- **.3mf** - 3D Manufacturing Format (modern format with slicer project data)

### Slicer Projects
Some projects include `.3mf` files which may contain slicer project settings (printer settings, supports, etc.).

---

## Usage Notes

1. **FreeCAD Projects**: Open `.FCStd` files in FreeCAD to view and modify parametric models.
2. **OpenSCAD Projects**: Open `.scad` files in OpenSCAD. Many projects use libraries from the `lib/` directory - ensure these are accessible.
3. **3D Printing**: Use `.stl` or `.3mf` files directly in your slicer. `.3mf` files may contain pre-configured slicer settings.
4. **CAD Exchange**: `.step` files can be imported into most CAD software for further modification.

---

## Repository Statistics

- **Total Projects:** 60+
- **FreeCAD Projects:** ~20
- **OpenSCAD Projects:** ~40
- **First Commit:** February 18, 2024
- **Latest Activity:** January 8, 2026

---

## Contributing

This is a personal repository of 3D models. If you find these models useful, feel free to use and modify them for your own projects.

---

## License

Please check individual project files for licensing information. Some projects may use external libraries with their own licenses (e.g., Gridfinity Rebuilt OpenSCAD).

---

*Documentation generated from git history and repository structure analysis.*
