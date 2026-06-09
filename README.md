# 🏦 Credit Risk & NPA Analysis — MBA Final Project

![SQL](https://img.shields.io/badge/SQL-Server-blue?logo=microsoftsqlserver) ![Python](https://img.shields.io/badge/Python-3.x-yellow?logo=python) ![Tableau](https://img.shields.io/badge/Tableau-Visualization-orange?logo=tableau) ![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## 📌 Overview

This project presents an end-to-end **Credit Risk and Non-Performing Asset (NPA) Analysis** on a simulated loan portfolio, replicating the type of analysis performed in banking and financial institutions. The goal is to identify high-risk borrowers, assess portfolio health, and quantify expected credit losses using a combination of **SQL**, **Python (Pandas, Seaborn, Matplotlib)**, and **Tableau**.

The project follows a structured analytical pipeline inspired by real-world banking practices: data quality checks → segmentation → risk scoring → expected loss estimation → visual storytelling.

---

## 🎯 Scope

The analysis covers the following areas:

- Portfolio-level health assessment (performing vs. non-performing loans)
- Credit risk segmentation by loan type, credit score band, and repayment behavior
- Collateral coverage and net exposure analysis
- Detection of hidden risk accounts (borrowers with good scores but poor repayment history)
- Identification of the most dangerous loans in the portfolio
- Probability of Default (PD) modeling and risk categorization
- Expected Loss (EL) estimation using banking-style logic

> **Out of Scope:** This project does not include Loss Given Default (LGD) or Exposure at Default (EAD) modeling in full Basel III form, nor does it involve real customer PII data.

---

## 🗃️ Database & Dataset Explanation

### Database: `NPA` (SQL Server)
**Table:** `dbo.loans`

The dataset contains **~14,000+ simulated loan records** across five loan product types, designed to mirror a retail bank's loan book.

| Column | Type | Description |
|---|---|---|
| `Loan_ID` | VARCHAR | Unique identifier for each loan (e.g., L00001) |
| `Customer_ID` | VARCHAR | Unique identifier for each borrower (e.g., C00001) |
| `Loan_Amount` | INT | Principal loan amount disbursed (₹) |
| `Loan_Type` | VARCHAR | Product category: Personal, Business, Vehicle, Home, Education |
| `Credit_Score` | INT | CIBIL-style credit score (300–850) |
| `Repayment_History` | FLOAT | % of on-time repayments made by the borrower (50–100) |
| `Collateral_Value` | INT | Market value of asset pledged as security (₹) |
| `Loan_Tenure` | INT | Loan duration in months |
| `Default_Status` | BIT | Binary flag — 0: Performing, 1: Non-Performing (NPA) |

### Engineered Features (Python)

The Python notebook further enriches the dataset with the following derived columns:

| Derived Column | Description |
|---|---|
| `Score_Band` | Credit score bucketed as Poor / Average / Good / Excellent |
| `Repayment_Band` | Repayment history bucketed as Weak / Moderate / Good / Strong |
| `Collateral_Ratio` | Collateral Value ÷ Loan Amount (coverage proxy) |
| `Loan_Status` | Human-readable label: Performing / Non-Performing |
| `PD` | Probability of Default (modeled score, 0–1) |
| `PD_Risk_Category` | PD bucketed as Low / Medium / High Risk |

---

## ❓ Key Questions Explored

1. What is the overall default rate across the portfolio?
2. Which loan product type carries the highest credit risk?
3. How does credit score correlate with default behavior?
4. Are there "hidden risk" accounts — borrowers who look creditworthy but behave poorly?
5. Which loans have the lowest collateral coverage relative to their exposure?
6. What is the estimated Expected Loss (EL) across the portfolio?
7. How are high-risk accounts distributed across risk bands?
8. What are the defining characteristics of the most dangerous loans?

---

## 🔧 Approach

The project follows a three-layer analytical stack:

### Layer 1 — SQL (Data Exploration & Business Logic)
- Data quality checks: null values, duplicate Loan IDs
- Loan distribution by product with risk ranking (using `RANK()` window function)
- Performing vs. Non-Performing segmentation
- Credit score risk banding using `CASE` logic
- Collateral Coverage Ratio computation with `NULLIF` safeguard
- Hidden risk detection (high score + poor repayment)
- Expected Loss calculation: `Default_Status × (Loan_Amount − Collateral_Value)`

### Layer 2 — Python (EDA & Feature Engineering)
- Libraries: `Pandas`, `NumPy`, `Matplotlib`, `Seaborn`
- Data loading, profiling, and validation
- Feature engineering: Score bands, Repayment bands, Collateral Ratio, PD score
- Exploratory visualizations: distribution plots, heatmaps, segmentation charts
- Probability of Default (PD) scoring model
- Risk categorization: Low / Medium / High Risk

### Layer 3 — Tableau (Dashboard & Visual Storytelling)
- Interactive dashboard built on the enriched dataset
- KPIs: Total Exposure, NPA Exposure, Default Rate, Avg. Credit Score
- Visual breakdowns: NPA by Loan Type, Risk Band Distribution, PD Heatmap, Collateral Coverage

---

## 📦 Deliverables

| File | Description |
|---|---|
| `SQL_Final_File.sql` | All SQL queries for data exploration, segmentation, and loss estimation |
| `Credit_Risk_Analysis.ipynb` | Python notebook for EDA, feature engineering, and PD modeling |
| `Credit_Risk_Analysis.twb` | Tableau workbook with interactive credit risk dashboard |
| `npa_dataset.csv` | Dataset used |
| `README.md` | Project documentation (this file) |

---

## 📊 Key Findings

- **Portfolio Default Rate:** A significant proportion of the loan book is non-performing, with certain product types showing disproportionately high default rates.
- **Personal Loans** carry the highest default risk by loan type, while **Home Loans** tend to be the most stable.
- **Credit Score Bands:** Borrowers in the "Poor" score band (< 500) showed the highest default rates. Notably, the "Average" band (500–650) contributed a large share of NPA volume due to its size.
- **Hidden Risk Accounts:** A notable subset of borrowers with credit scores above 650 displayed repayment history below 60% — indicating that credit score alone is insufficient as a risk filter.
- **Collateral Coverage:** Several loans in the portfolio have collateral values well below the outstanding loan amount, creating significant uncovered exposure in a default scenario.
- **Expected Loss:** Loans with low collateral coverage combined with non-performing status represent the highest Expected Loss concentration in the portfolio.
- **PD Modeling:** High-Risk accounts (PD > 0.7) are concentrated in the Poor Score Band and Weak Repayment Band, confirming that multi-variable segmentation is more predictive than any single metric.

---

## 🔭 Future Scope

- **Full EL = PD × LGD × EAD Model:** Incorporate Loss Given Default and Exposure at Default for a complete Basel-aligned Expected Loss computation.
- **Machine Learning:** Build a logistic regression or gradient boosting model (XGBoost) to predict probability of default with higher precision.
- **Vintage Analysis:** Track default rates by loan origination cohort to identify deteriorating underwriting periods.
- **Stress Testing:** Simulate macro-economic shocks (e.g., interest rate hike, unemployment spike) and model their impact on portfolio NPA rates.
- **Early Warning System:** Develop rule-based triggers for proactive NPA detection before formal default occurs.
- **Geographic Segmentation:** If location data were available, map NPA concentration by region to identify geographic risk clusters.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| Microsoft SQL Server | Data storage, querying, business logic |
| Python 3.x (Google Colab) | EDA, feature engineering, PD modeling |
| Pandas / NumPy | Data manipulation |
| Matplotlib / Seaborn | Statistical visualizations |
| Tableau Desktop | Interactive dashboard |
| GitHub | Version control and project showcase |

---

## 📁 Repository Structure

```
credit-risk-npa-analysis/
│
├── SQL_Final_File.sql           # SQL analysis scripts
├── Credit_Risk_Analysis.ipynb   # Python EDA & modeling notebook
├── Credit_Risk_Analysis.twb     # Tableau dashboard workbook
├── npa dataset.csv              # Dataset
├── assets/                      # Screenshots and visual exports (see below)
│   ├── dashboard_overview.png
│   ├── default_rate_by_loan_type.png
│   ├── credit_score_distribution.png
│   └── collateral_coverage_heatmap.png
└── README.md
```

---

## ⚠️ Disclaimer

This project uses a **simulated dataset** created solely for academic and educational purposes. All Loan IDs, Customer IDs, loan amounts, and associated attributes are fictitious and do not represent any real individuals, financial institutions, or transactions. The analysis and findings are intended to demonstrate analytical methodology and should not be interpreted as financial advice or a reflection of any actual lending portfolio.

---

## 👤 Author

**Rohit Kulkarni**
MBA Candidate | Finance & Analytics

---

*Submitted as part of MBA Final Project — [Birla Institute of Technology and Science], [2026]*
