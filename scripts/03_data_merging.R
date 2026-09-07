

# SCRIPT 3: MERGING & MACRO SHOCK CONSTRUCTION
# Purpose: Aggregate crude prices to quarterly level, compute YoY shock flags, and join.


library(tidyverse)

# 1. Aggregate Monthly Crude Prices to Quarterly Averages & Compute Macro Shock (%)
ppac_quarterly <- PPac_monthly |>
  mutate(year = year(Month_Date), quarter = quarter(Month_Date)) |>
  group_by(year, quarter) |>
  summarise(
    crude_price_3mnths = mean(crude_price_usd, na.rm = TRUE),
    .groups = "drop") |>
  arrange(year, quarter) |>
  mutate(
    crude_shock_yoy = ((crude_price_3mnths - lag(crude_price_3mnths, 4)) / lag(crude_price_3mnths, 4)) * 100,
    oil_shock_15 = if_else(crude_shock_yoy >= 15, 1, 0))

# 2. Merge Firm Financials with Quarterly Macro Crude Oil Benchmarks
firm_oil_data <- compustat_clean %>%
  left_join(ppac_quarterly, by = c("year", "quarter")) %>%
  filter(!is.na(crude_shock_yoy))
