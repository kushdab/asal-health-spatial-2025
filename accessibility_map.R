library(sf)
library(tidyverse)
library(tmap)

# Project: ASAL Health Spatial 2025
# Analysis of healthcare accessibility in simulated Arid and Semi-Arid Lands

# 1. Setup Study Area (Simulated Northern Kenya Region)
# Coordinates roughly representing a section of ASAL
poly_coords <- matrix(c(36, -1, 41, -1, 41, 4, 36, 4, 36, -1), ncol = 2, byrow = TRUE)
asal_boundary <- st_sfc(st_polygon(list(poly_coords)), crs = 4326) %>% st_sf()
asal_boundary$region <- "ASAL Study Area"

# 2. Simulate Spatial Features
set.seed(2025)

# Health Facilities (Points)
facilities <- st_sample(asal_boundary, size = 12) %>%
  st_sf() %>%
  mutate(id = row_number(), 
         type = sample(c("Primary Clinic", "Referral Hospital"), 12, replace = TRUE))

# Settlements/Villages (Points)
settlements <- st_sample(asal_boundary, size = 60) %>%
  st_sf() %>%
  mutate(id = row_number(), 
         population = rpois(60, 450))

# 3. Spatial Analysis: Distance to Nearest Facility
# Transform to UTM 37N (EPSG:32637) for metric calculations
asal_proj <- st_transform(asal_boundary, 32637)
fac_proj <- st_transform(facilities, 32637)
set_proj <- st_transform(settlements, 32637)

# Calculate distance matrix
dist_matrix <- st_distance(set_proj, fac_proj)
set_proj$dist_to_health_km <- apply(dist_matrix, 1, min) / 1000

# Identify settlements further than 15km (Low access)
set_proj$access_status <- ifelse(set_proj$dist_to_health_km > 15, "Low Access", "Adequate")

# 4. Visualization
tmap_mode("plot")
main_map <- tm_shape(asal_proj) +
  tm_polygons(col = "#f0f0f0", border.col = "black", lwd = 2) +
  tm_shape(set_proj) +
  tm_dots(col = "dist_to_health_km", 
          palette = "YlOrRd", 
          size = 0.15, 
          title = "Distance to Health (km)",
          midpoint = 15) +
  tm_shape(fac_proj) +
  tm_symbols(shape = 3, col = "blue", size = 0.6, border.lwd = 2) +
  tm_layout(main.title = "ASAL Healthcare Accessibility 2025",
            legend.outside = TRUE,
            bg.color = "#e6f3ff") +
  tm_add_legend(type = "symbol", shape = 3, col = "blue", labels = "Health Facility")

# Save Output
tmap_save(main_map, "accessibility_map_output.png")
print("Analysis complete. Map saved as accessibility_map_output.png")