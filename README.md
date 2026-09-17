# Customer Churn & Retention Analysis
**Tools used:** Python (Pandas, Seaborn) · SQL Server (CTEs, Agrigations, Window Functions)

# Problem -
Company wants to understand why customers are churning and identify the Customer Segment which is high in risk churn.

# Dataset -
[IBM Telco Customer Churn dataset] 

#  Approach
1. **Python (EDA):** Cleaned data (fixed TotalCharges type issue, verified no missing values), explored distributions, and ran bivariate/correlation analysis to identify churn drivers.
2. **SQL Server:** Loaded cleaned data into a relational database. Wrote aggregate queries, CTEs, and window functions (RANK, running totals) to formalize segment-level churn metrics.
3. **Power BI:** Built an interactive dashboard with KPI cards, segment breakdowns, and slicers for contract type, payment method, and tenure.

# Key Findings
- Overall churn rate: 26.54%
- Month-to-month contracts churn at **42.70%** vs. **2.83%** for two-year contracts
- Electronic check payment method has the highest churn rate at **45.28%**
- Churn risk is concentrated in the first **12 months** of tenure
- Churned customers pay **higher** average monthly charges **58.22** 
  suggesting a value-perception issue rather than affordability

# Recommendation
Target retention campaigns at new **(<12 month)** customers on month-to-month 
contracts paying via electronic check — this segment shows the highest 
concentration of churn risk. Consider incentivizing annual contract 
upgrades and reviewing pricing perception for high-charge customers.
