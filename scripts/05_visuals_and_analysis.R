

# Visual Trends and Empirical Analysis

library(dplyr)
library(ggplot2)
library(broom)
library(knitr)
library(patchwork)
library(here)

# Step 1: Adding dummy variable for the Shock

firm_oil_proposal <- firm_oil_data_filtered |>
  mutate(
    shock_dummy = if_else(crude_shock_yoy >= 15, 1, 0),
    shock_label = if_else(shock_dummy == 1, "Shock Quarter (>= +15%)", "Non-Shock Quarter")
  ) |>
  group_by(gvkey) |>
  arrange(datadate) |>
  ungroup()


# Step 2: Two-Sample t-test

# Filter strictly for shock quarters with valid YoY margin changes
shock_quarter_df <- firm_oil_proposal |>
  filter(shock_dummy == 1, !is.na(delta_opm_yoy))

# 1. Run Welch's t-test
ttest_result <- t.test(
  delta_opm_yoy ~ energy_group,
  data = shock_quarter_df,
  var.equal = FALSE
)

# 2. Extract and format cleanly
ttest_table <- tidy(ttest_result) |>
  transmute(
    `Comparison`       = "High Energy vs. Low Energy",
    `High Energy Mean` = paste0(round(estimate1, 2), "%"),
    `Low Energy Mean`  = paste0(round(estimate2, 2), "%"),
    `Difference`       = paste0(round(estimate1 - estimate2, 2), "%"),
    `t-Stat`           = round(statistic, 4),
    `df`               = round(parameter, 2),
    `p-value`          = round(p.value, 4),
    `95% CI`           = paste0("[", round(conf.low, 2), "%, ", round(conf.high, 2), "%]")
  )

# 3. Print clean table to console
kable(ttest_table, align = "c")

# 4. Export to CSV
write.csv(ttest_table, here("output", "tables", "welch_ttest_summary.csv"), row.names = FALSE)


# Step 3: Sid-by-Side Boxplots

plot_boxplots <- firm_oil_proposal |>
  filter(!is.na(delta_opm_yoy), !is.na(shock_label)) |>
  ggplot(aes(x = energy_group, y = delta_opm_yoy, fill = shock_label)) +
  geom_boxplot(outlier.alpha = 0.3) +
  labs(
    title = "Distribution of Year-over-Year Margin Changes (\u0394OPM)",
    subtitle = "Comparing Shock (\u2265 +15% YoY Crude Increase) vs. Non-Shock Quarters",
    x = "Sectoral Energy Group",
    y = "YoY Margin Change (% points: OPM_t - OPM_t-4)",
    fill = "Regime"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold")
  )

print(plot_boxplots)
# Saving Boxplot

ggsave("output/figures/welch_ttest_boxplot.png", plot = plot_boxplots, width = 8, height = 5, dpi = 300)

#Step 4: Line Axis Plot

# Prepare clean time-series data
ts_data <- firm_oil_proposal |>
  mutate(datadate = as.Date(datadate)) |>
  group_by(datadate, energy_group) |>
  summarise(
    avg_opm = mean(OPM, na.rm = TRUE),
    # FIX: Cleaned column name without .y suffix
    crude_price = mean(crude_price_3mnths, na.rm = TRUE),
    .groups = "drop"
  )

# Panel A: Sectoral Average OPM over time
p1 <- ggplot(ts_data, aes(x = datadate, y = avg_opm, color = energy_group)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Panel A: Sectoral Operating Profit Margins (OPM %)",
    y = "Average OPM (%)", 
    x = NULL, 
    color = "Energy Group"
  ) +
  theme_minimal() +
  theme(legend.position = "top", plot.title = element_text(face = "bold"))

# Panel B: Crude Oil Benchmark over time
p2 <- ggplot(ts_data, aes(x = datadate, y = crude_price)) +
  geom_line(color = "black", linetype = "dashed", linewidth = 0.9) +
  labs(
    title = "Panel B: Crude Oil Benchmark Price",
    y = "Crude Price (USD)", 
    x = "Quarter"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

# Combine plots using patchwork
combined_plot <- p1 / p2

print(combined_plot)

#Saving Combined_plot ---
ggsave("output/figures/opm_crude_timeseries_panel.png", plot = combined_plot, width = 10, height = 7, dpi = 300)


