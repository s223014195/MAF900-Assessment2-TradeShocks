
# SCRIPT 4: STRATIFIED SAMPLING, FILTERS & WINSORIZATION
# Purpose: Sample 100 firms, filter ex-COVID quarters, and Winsorize margin deltas.
# ==============================================================================

library(tidyverse)

set.seed(42)

# Custom Base R Winsorization helper (no external dependencies)
winsorize_vec <- function(x, low = 0.01, high = 0.99) {
  q <- quantile(x, probs = c(low, high), na.rm = TRUE)
  pmax(pmin(x, q[2]), q[1])
}

# 1. Sectoral Cohort Mapping (GICS Sectors)
firm_sectors <- firm_oil_data |>
  distinct(gvkey, gsector) |>
  filter(gsector %in% c(10, 15, 25, 30, 35)) |>
  mutate(energy_group = if_else(gsector %in% c(10, 15), "High_Energy", "Low_Energy"))

# 2. Stratified Random Sampling (50 Group A / 50 Group B)
sampled_firms <- firm_sectors |>
  group_by(energy_group) |>
  slice_sample(n = 50) |>
  ungroup()

# 3. Simple Left Join & Filtering
firm_oil_data_filtered <- firm_oil_data |>
  # Simple left join to attach energy_group
  left_join(sampled_firms |> select(gvkey, energy_group), by = "gvkey") |>
  # Keep ONLY the sampled 100 firms
  filter(!is.na(energy_group)) |>
  # Remove COVID lockdown quarters
  filter(!year %in% c(2020, 2021)) |>
  # Drop missing lag values (2015 calibration quarters)
  filter(!is.na(delta_opm_yoy), !is.na(crude_shock_yoy)) |>
  mutate(delta_opm_yoy = winsorize_vec(delta_opm_yoy, low = 0.01, high = 0.99))

# Verify column existence and display summary
summary(firm_oil_data_filtered$delta_opm_yoy)

message("Script 04 Complete: Final unbalanced panel filtered and Winsorized.")