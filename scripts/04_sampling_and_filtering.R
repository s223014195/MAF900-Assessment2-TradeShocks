 

# Stratified Random Sampling & filtering COVID Years


set.seed(42)

# Sectoral Mapping

firm_sectors <- firm_oil_data |>
  distinct(gvkey, gsector) |>
  filter( gsector %in% c(10, 15, 25, 30, 35)) |>
  mutate(energy_group = if_else(gsector %in% c(10, 15), "High_Energy", "Low_Energy"))

# Random Sampling 

sampled_firms <- firm_sectors |>
  group_by(energy_group) |>
  slice_sample(n = 50) |>
  ungroup()

# Cutoff 1st and 99th percentile

p01 <- quantile(firm_oil_data$OPM, 0.01, na.rm = TRUE)
p99 <- quantile(firm_oil_data$OPM, 0.99, na.rm = TRUE)

# Filtering out COVID years mentioned in proposal, and keeping the sampled firms and trimming outliers

firm_oil_data_filtered <- firm_oil_data |>
  filter(!year %in% c(2020, 2021)) |>
  inner_join(sampled_firms |>select(gvkey, energy_group), by = "gvkey") |>
  filter(OPM >= p01 & OPM <= p99)

summary(firm_oil_data_filtered$OPM)

