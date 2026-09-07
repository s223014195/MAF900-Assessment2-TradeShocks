
# SCRIPT 2: DATA CLEANING & FIRM-LEVEL LAGGING
# Purpose: Clean PPAC date structures, compute baseline OPM, and calculate YoY lags.


library(tidyverse)
library(lubridate)

# 1. Clean Monthly PPAC Benchmark Data
month_names <- c("Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar")
colnames(ppac_raw)[2:13] <- month_names

PPac_monthly <- ppac_raw |>
  select(Year, Apr:Mar) |>
  pivot_longer(cols = Apr:Mar, names_to = "Month", values_to = "crude_price_usd") |>
  mutate(
    crude_price_usd = as.numeric(crude_price_usd),
    FY_Start = as.numeric(substr(Year, 1, 4)),
    Cal_Year = if_else(Month %in% c("Jan", "Feb", "Mar"), FY_Start + 1, FY_Start),
    Month_Date = ym(paste(Cal_Year, Month))
  ) |>
  filter(Month_Date >= as.Date("2015-01-01") & Month_Date <= as.Date("2025-12-31")) %>%
  arrange(Month_Date) |>
  select(Month_Date, crude_price_usd)

# 2. Clean Compustat Data & Calculate Baseline OPM and 4-Quarter YoY Lag

compustat_clean <- compustat_raw %>%
  select(gvkey, gsector, conm, datadate, fyearq, fqtr, saleq, oiadpq) |>
  mutate(
    year = year(datadate),
    quarter = quarter(datadate), 
    OPM = (oiadpq / saleq) * 100) |>
  filter(saleq > 0, !is.na(OPM)) |>
  group_by(gvkey) |>
  arrange(datadate, .by_group = TRUE) |>
  mutate(delta_opm_yoy = OPM - lag(OPM, 4)) |>
  ungroup()