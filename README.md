# ASAL Health Spatial Analysis 2025

## Overview
This project provides a spatial analysis framework for evaluating healthcare facility distribution and accessibility within Arid and Semi-Arid Lands (ASAL). It focuses on identifying regions where settlements are located beyond critical travel distances (e.g., 15km) from the nearest health center.

## Features
- Synthetic spatial data generation for ASAL boundaries.
- Euclidean distance modeling between settlements and facilities.
- Accessibility gap mapping using `tmap`.
- Support for projected coordinate systems (UTM 37N).

## Installation
You will need R (version 4.0+) and the following libraries:

```r
install.packages(c("sf", "tidyverse", "tmap"))
```

## Usage
1. Open the R project.
2. Execute `accessibility_map.R`.
3. The script will generate a thematic map `accessibility_map_output.png` highlighting service gaps in the simulated region.