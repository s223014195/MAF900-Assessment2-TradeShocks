
# Data Merging & calculating the Crude Oil Shock 

firm_oil_data <- compustat_clean |>
  left_join(ppac_quarterly, by = c("year", "quarter"))

# Calculate YoY Crude Oil Price Shock (%) at macro level
crude_shocks <- ppac_quarterly |>
  ungroup() |>
  arrange(year, quarter) |>
  mutate(
    crude_shock_yoy = ((crude_price_3mnths - lag(crude_price_3mnths, 4)) / lag(crude_price_3mnths, 4)) * 100
  ) |>
  select(year, quarter, crude_price_3mnths, crude_shock_yoy)

# Merging firm data with quarterly prices and shock measures

firm_oil_data <- compustat_clean |>
  left_join(ppac_quarterly, by = c("year", "quarter")) |>
  left_join(crude_shocks, by = c("year", "quarter")) |>
  filter(!is.na(crude_shock_yoy))

