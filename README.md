# MAF900 Assessment 2: Trade Facilitation Frictions and Asymmetric Corporate Margins in Manufacturing

A reproducible R workflow evaluating global energy trade shocks and firm-level operating margins across Indian manufacturing sectors.

## Executive Summary
This empirical project investigates the firm-level transmission of significant global oil price shocks ($\ge 15\%$ YoY) on Operating Profit Margins ($\Delta\text{OPM}_{\text{YoY}}$) across a panel of 100 Indian manufacturing firms. Using Welch's two-sample $t$-test, I evaluate whether firms in high energy-intensity sectors experience greater margin contractions compared to low energy-intensity cohorts during shock quarters.

## Key Empirical Finding
* **Welch $t$-Test Result:** $t = -0.270$, $p = 0.787$ ($df = 953.41$).
* **Conclusion:** There is **no statistically significant difference** in YoY OPM changes between high-energy ($\text{Mean} = 40.55\%$) and low-energy ($\text{Mean} = 50.55\%$) manufacturing cohorts during major oil price shocks.
* **Economic Insight:** Indian manufacturing firms demonstrate structural resilience or pass-through pricing capacity, mitigating direct operational margin shocks. Alternative mechanisms (e.g., inventory buffering, long-term procurement contracts) play a significant mitigating role.

---

## Data Sources & Variable Definitions

Due to licensing constraints, raw proprietary firm financials and data extracts are excluded from this repository via `.gitignore`.

### Primary Data Sources & Access Requirements
1. **Compustat Global (S&P Global Market Intelligence):** Provides firm-level quarterly financial metrics, income statements, and balance sheets Indian manufacturing firms. *(Requires institutional subscription access via WRDS).*
2. **Petroleum Planning & Analysis Cell (PPAC):** Official Ministry of Petroleum & Natural Gas (Government of India) portal providing Indian Crude Basket prices. *(Publicly accessible via ppac.gov.in).*

### 2. Time Period & Sample Frequency
* **Sample Window:** **Q1 2015 – Q4 2025**.
* **Base Panel:** 100 Indian manufacturing firms across 8 two-digit GICS sector groups.
* **Lagged Panel Calibration:** 2016 panel lags implemented for four-quarter rolling year-over-year ($\Delta_{\text{YoY}}$) calculations.
* **Data Filtering:** COVID years of 2020 & 2021 are filtered out to eliminate the non-market operational distortions caused by nationwide pandemic lockdowns. 

### 3.Empirical Variables & Compustat Identifiers
| Variable / Identifier | Code Name | Source / Compustat Code | Description & Formula |
| :--- | :--- | :--- | :--- |
| **Global Company Key** | `gvkey` | Compustat Primary Key | Unique 6-digit firm identifier for cross-sectional tracking |
| **Company Name** | `conm` | Compustat Identifier | Full legal name of the manufacturing enterprise |
| **Sector Classification** | `gsector` | Compustat GICS Sector | 2-digit GICS sector code used to map energy intensity |
| **Operating Margin** | `OPM` | `OIBDPQ` / `SALEQ` | $\frac{\text{Operating Income Before Depreciation (OIBDPQ)}}{\text{Net Sales/Revenue (SALEQ)}} \times 100$ |
| **YoY Margin Change** | `d_OPM_YoY` | Calculated | $\Delta\text{OPM}_{i,t} = \text{OPM}_{i,t} - \text{OPM}_{i,t-4}$ (Quarter-on-same-quarter prior year) |
| **Oil Shock Indicator** | `oil_shocks` | PPAC Indian Crude Basket | Binary flag: $1$ if Crude YoY Growth ($\frac{P_t - P_{t-4}}{P_{t-4}}$) $\ge 15\%$, else $0$ |
| **Energy Intensity** | `energy_group` | Compustat (`gsector`) & PPAC | Binary sectoral group (`High` vs. `Low` energy intensity mapped via GICS) |
---

## How to Reproduce Analysis
1. **Clone the repository:** `git clone <repo-url>`
2. **Open the RStudio Project:** Double-click the `.Rproj` file in the root directory.
3. **Obtain Data:** Download the firm financial panel from Compustat Global and crude benchmarks from PPAC, then place raw `.csv` extracts into `data/raw/`.
4. **Execute Pipeline:** Run `scripts/05_visuals_and_analysis.R` to execute data transformations, run the Welch $t$-test, and auto-export formatted tables and plots into `output/`.

---

## Software & Dependencies
* **R Environment:** `dplyr`, `ggplot2`, `patchwork`, `broom`, `knitr`, `fixest`.