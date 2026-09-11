# MAF900 Assessment 2: Trade Facilitation Frictions and Asymmetric Corporate Margins in Manufacturing

A reproducible R workflow evaluating global energy trade shocks and firm-level operating margins across Indian manufacturing sectors.

## Executive Summary

This empirical project investigates the firm-level transmission of significant global oil price shocks ($\ge 15\%$ YoY) on Operating Profit Margins ($\Delta\text{OPM}_{\text{YoY}}$) across a panel of 100 Indian manufacturing firms (2016 Q1 – 2025 Q4, ex-COVID). Using Welch's two-sample $t$-test, I evaluate whether firms in high energy-intensity sectors experience greater margin contractions compared to low energy-intensity cohorts during shock quarters.

### Key Empirical Findings

* **Welch $t$-Test Result:** $t = -1.9086$, $p = 0.0568$ ($df = 615.38$, $95\%\text{ CI: } [-14.83\%, 0.21\%]$).
* **Cohort Performance:** During energy shock quarters, High-Energy firms experienced a mean margin contraction of **$-2.35\%$**, whereas Low-Energy firms achieved a mean expansion of **$+4.96\%$**, yielding a net group difference of **$-7.31\text{ percentage points}$**.
* **Hypothesis Decision:** At the standard $5\%$ significance threshold ($\alpha = 0.05$), we **fail to reject $H_0$** ($p = 0.0568 > 0.05$). However, the finding demonstrates **marginal significance at the $10\%$ level ($p < 0.10$)**.
* **Economic Insight:** Indian manufacturing firms demonstrate notable operational resilience. While high energy intensity introduces directional margin pressure during global oil surges, cross-sectional variance indicates that pass-through capacity, inventory buffering, and long-term procurement contracts absorb a substantial portion of input cost volatility.

---

## Data Sources & Variable Definitions

Due to licensing constraints, raw proprietary firm financials are excluded from this repository via `.gitignore`.

### 1. Primary Data Sources & Access Requirements
* **Compustat Global (S&P Global Market Intelligence):** Provides firm-level quarterly financial metrics, income statements, and balance sheets for Indian manufacturing firms (requires institutional subscription access via WRDS).
* **Petroleum Planning & Analysis Cell (PPAC):** Official Ministry of Petroleum & Natural Gas (Government of India) portal providing Indian Crude Basket prices (publicly accessible via `ppac.gov.in`).

### 2. Time Period & Sample Frequency
* **Sample Window:** 2015 Q1 – 2025 Q4.
* **Base Panel:** Stratified sample of 100 Indian manufacturing firms across GICS sector groups (50 High Energy vs. 50 Low Energy).
* **Lagged Panel Calibration:** 2015 baseline quarters used for four-quarter rolling year-over-year ($\Delta\text{YoY}$) calculations; effective analysis window spans 2016 Q1 – 2025 Q4.
* **Data Filtering:** COVID lockdown years (2020 & 2021) are filtered out to eliminate non-market operational distortions.
* **Outlier Adjustment:** $\Delta\text{OPM}_{\text{YoY}}$ is Winsorized at the 1st and 99th percentiles to eliminate extreme financial ratio spikes.

### 3. Empirical Variables & Compustat Identifiers

| Variable / Identifier | Code Name | Source / Formula | Description |
| :--- | :--- | :--- | :--- |
| **Global Company Key** | `gvkey` | Compustat Primary Key | Unique 6-digit firm identifier |
| **Company Name** | `conm` | Compustat Identifier | Full legal name of the enterprise |
| **Sector Classification** | `gsector` | Compustat GICS Sector | 2-digit GICS sector code used for group mapping |
| **Fiscal Year** | `fyearq` | Compustat Fiscal Year | Fiscal year of the reporting period |
| **Fiscal Quarter** | `fqtr` | Compustat Fiscal Quarter | Fiscal quarter indicator (1–4) |
| **Data Date** | `datadate` | Compustat Statement Date | Calendar date corresponding to the end of the fiscal quarter |
| **Operating Income (Quarterly)** | `oiadpq` | Compustat Fundamental Quarterly | Operating income after depreciation and amortization expenses |
| **Sales / Revenue (Quarterly)** | `saleq` | Compustat Fundamental Quarterly | Total net sales or revenue generated during the fiscal quarter |
| **Operating Profit Margin** | `OPM` | `(oiadpq / saleq) * 100` | Operating Income After Depreciation / Sales |
| **YoY Margin Change** | `delta_opm_yoy` | $\\text{OPM}_{i,t} - \\text{OPM}_{i,t-4}$ | Year-over-year margin shift (percentage points), Winsorized 1%/99% |
| **Macro Crude Price** | `crude_price_3mnths` | PPAC Crude Basket | Quarterly average crude oil price (USD) |
| **Oil Shock Indicator** | `crude_shock_yoy` | $\\frac{P_t - P_{t-4}}{P_{t-4}} \\times 100 \\ge 15\\%$ | Binary flag for crude price increases $\\ge 15\\%$ YoY |
| **Energy Intensity** | `energy_group` | GICS Sector Mapping | Binary group: `High_Energy` (GICS 10, 15) vs. `Low_Energy` (GICS 25, 30, 35) |
"
---

## Project Structure & Reproducibility

```text
├── data/
│   ├── raw/                      # Proprietary raw CSVs (ignored via .gitignore)
│   └── processed/                # Cleaned intermediate objects
├── scripts/
│   ├── 01_data_loading.R         # Imports raw Compustat & PPAC files
│   ├── 02_data_cleaning.R        # Cleans dates, computes baseline OPM & 4-qtr lags
│   ├── 03_merging_and_shocks.R   # Computes macro shocks & merges datasets
│   ├── 04_sample_filtering.R     # Stratified sampling, ex-COVID filter & Winsorization
│   └── 05_visuals_and_analysis.R # Welch t-test, summary tables & ggplot figures
├── output/
│   ├── figures/                  # Exported plots (.png)
│   └── tables/                   # Exported CSV result tables
├── run_all.R                     # Master execution script
├── README.md                     # Project overview and documentation
└── MAF900_Part3.Rproj            # RStudio project file

How to Reproduce Analysis

Clone the repository: git clone <repo-url>
Open the RStudio Project: Double-click the .Rproj file in the root directory.
Obtain Data: Download the firm financial panel from Compustat Global and crude benchmarks from PPAC, then place raw .csv extracts into data/raw/.
Execute Pipeline: Run scripts/05_visuals_and_analysis.R to execute data transformations, run the Welch t-test, and auto-export formatted tables and plots into output/.

   