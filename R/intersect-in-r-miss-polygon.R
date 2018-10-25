# Answer to 'Intersect in R - miss one polygon' ----
# (available online: https://stackoverflow.com/questions/52980973/intersect-in-r-miss-one-polygon)

library(sf)

#[1] Montagem da tabela de coordenadas dos postos pluviométricos
dados_precipitacao_1985 <- readxl::read_excel(path="data/DATA.xlsx") 
dados_precipitacao_1985 <- st_as_sf(dados_precipitacao_1985, coords = c("x", "y"), crs = 4326)
dados_precipitacao_1985_sp <- as(dados_precipitacao_1985, "Spatial")

#[2] Coleta dos dados espaciais da bacia hidrográfica
bacia_Caio_Prado <- st_read(dsn="data/SHAPE_CORRIGIDO", layer="ws_polygon_2")

#[3] Poligonos de Thiessen - 1 INTERPOLAÇÃO
limits_voronoi_WGS <- c(-40.00,-38.90,-5.00,-4.50)
v_WGS <- dismo::voronoi(dados_precipitacao_1985_sp, ext=limits_voronoi_WGS)
v_WGS_sf <- st_as_sf(v_WGS)

u_WGS_3 <- st_intersection(bacia_Caio_Prado, v_WGS_sf)
plot(u_WGS_3[, 6], key.pos = 1)
