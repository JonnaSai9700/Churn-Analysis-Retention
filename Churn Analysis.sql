Select * from telco_churn
--> Aggregation --> CTE --> Widow function <--
-- Find Overall Churn Rate Percentage --
select COUNT(*) as total_customer,
		Sum(Churn_flag) as churn_customer,
		ROUND(100.0 * Sum(Churn_flag) / Count(*) ,2) as Churn_percentage
from telco_churn

-- Find	Churn Rate & Contract type --
Select
	Contract,
	Count(*) as total_customers,
	SUM(Churn_flag) as churn_customers,
	ROUND(100.0 * sum(Churn_flag) / count(*),2) as churn_percentage
from telco_churn
Group by Contract
Order by churn_percentage Desc	



--Find Churn Rate & Payment_methods---
Select 
	PaymentMethod,
	COUNT(*) as total_customers,
	SUM(Churn_flag) as churn_customers,
	ROUND(100.0 * sum(Churn_flag) / count(*),2) as churn_percentage
from telco_churn
group by PaymentMethod
order by churn_percentage desc

--find Tenure cohort analysis
select 
	case 
		when tenure <= 12 then '0-12 months'
		when tenure <= 24 then '13-24 months'
		when tenure <= 48 then '25 - 48 months'
		Else '49+ months'
	End as TenureGroup,
	COUNT(*) as total_customers,
	SUM(Churn_flag) as churn_customers,
	ROUND(100.0 * SUM(Churn_flag) / COUNT(*),2) as churn_percentage
from telco_churn
group by 
	case
		when tenure <= 12 then '0-12 months'
		when tenure <= 24 then '13-24 months'
		when tenure <= 48 then '25 - 48 months'
		Else '49+ months'
	End 
Order by MIN(tenure)

-- Revenue at Risk
-- Find MonthlyCharges of Churn = yes--
Select 
Round(SUM(MonthlyCharges),2) as month_revenuerisk,
Round(sum(MonthlyCharges * 12),2) as annual_revenuerisk
from telco_churn
where Churn = 'Yes'

--> CTE is for temparory table
-- Bulit a clean segment summary table--
with segmentsummary as
(
Select
	Contract,
	PaymentMethod,
	case
		when tenure <= 12 then '0-12 months'
		when tenure <= 24 then '13-24 months'
		when tenure <= 48 then '25- 48 months'
		Else '49+ months'
	End as tenure_group,
	Churn_flag,
	MonthlyCharges
from telco_churn
)
Select
	Contract,
	tenure_group,
	count(*) as total_customers,
	SUM(Churn_flag) as churn_customers,
	ROUND(100.0 * SUM(Churn_flag) / Count(*),2) as churn_persentagerate,
	Round(avg(MonthlyCharges),2) as avg_monthlycharges
from segmentsummary
Group by Contract, tenure_group
order by Contract, tenure_group

--> Window Function-- Ranking the Customers by charges with a Contract type--
Select
	customerID,
	Contract,
	MonthlyCharges,
RANK() Over(Partition by Contract Order by MonthlyCharges Desc) as rank_chargeincontract
from telco_churn


--> Win func -- Run the Total Churned revenue --
Select
	tenure,
	ROUND(MonthlyCharges,2) AS MonthlyCharges,
	rOUND(SUM(MonthlyCharges) OVER (ORDER BY tenure ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS current_churnprice
from telco_churn
where Churn = 'Yes'
Order by tenure