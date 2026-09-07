library(tidyverse)
library(here)
library(readxl)
library(lubridate)


colnames(ppac_raw)

ppac_raw <- read_excel(here("data", "raw", "datarawppac_crude_price.xlsx"), skip = 12)

#Changing monthly headers and renaming them clearly 

month_names <- c("Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar")
colnames(ppac_raw)[2:13] <- month_names

# Wide Grid to long Date-Time format 

PPac_monthly <- ppac_raw |> select (Year, Apr:Mar) |> 
  pivot_longer(cols = Apr:Mar, names_to = "Month", values_to ="crude_price_usd")|>
  mutate(
    crude_price_usd = as.numeric(crude_price_usd),
    FY_Start = as.numeric(substr(Year, 1, 4)),
    Cal_Year = if_else(Month %in% c("Jan", "Feb", "Mar"), FY_Start + 1, FY_Start),
    Month_Date = ym(paste(Cal_Year, Month))
    )|> 
  filter(Month_Date >= as.Date("2015-01-01")& Month_Date <= as.Date("2025-12-31")) |>
  arrange(Month_Date)|>
  select(Month_Date, crude_price_usd)
  
  
# Step 2 Aggregating monthly price to quarterly prices 
  
ppac_quarterly <- PPac_monthly|>
 mutate(year = year(Month_Date), quarter = quarter(Month_Date))|>
  group_by(year, quarter)|>
  summarise(crude_price_3mnths = mean(crude_price_usd, na.rm = TRUE),
            .group = "drop")

# Step 3 Cleaning Compustat data and Calculation Operating Profit Margin

compustat_clean <- compustat_raw|>
  select(gvkey, gsector, conm, datadate, fyearq, fqtr, saleq, oiadpq)|>
  mutate(year = year(datadate),
         quarter = quarter(datadate), 
         OPM = (oiadpq / saleq) * 100)|>
  filter(saleq > 0, !is.na(OPM)) |>
           
    # Group by firm and sort chronologically before lagging
 group_by(gvkey) %>%
  arrange(datadate, .by_group = TRUE) |>
  mutate( delta_opm_yoy = OPM - lag(OPM, 4)) |>
  ungroup()

  
    

  
  
