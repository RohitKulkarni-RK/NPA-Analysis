USE NPA
go

--Top 10 rows
select top(10) * from dbo.loans

--Total Number of records
SELECT 
COUNT(*) AS Total_Records,
SUM(loan_Amount) As Exposure
FROM loans;

--Check Distinct Loan Types
SELECT DISTINCT Loan_Type
FROM loans;

--Check for Null Values
SELECT
SUM(CASE WHEN Loan_ID IS NULL THEN 1 ELSE 0 END) AS Null_LoanID,
SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_CustomerID,
SUM(CASE WHEN Loan_Amount IS NULL THEN 1 ELSE 0 END) AS Null_LoanAmount,
SUM(CASE WHEN Credit_Score IS NULL THEN 1 ELSE 0 END) AS Null_CreditScore
FROM loans;

--Check Duplicate Loan IDs
SELECT Loan_ID, COUNT(*) AS cnt
FROM loans
GROUP BY Loan_ID
HAVING COUNT(*) > 1;

--Loan Distribution by Product and Risk Rank
SELECT
Loan_Type,
COUNT(*) AS Number_of_Loans,
SUM(Loan_Amount) AS Total_Amount,
ROUND(AVG(CAST(Default_Status AS FLOAT))*100,2) AS Default_Rate,
RANK() OVER(
ORDER BY AVG(CAST(Default_Status AS FLOAT)) DESC
) AS Risk_Rank
FROM loans
GROUP BY Loan_Type
ORDER BY Risk_Rank;

--Top 10 Largest Loans
SELECT top(10) *
FROM loans
ORDER BY Loan_Amount DESC;

------OR------
--Top 10
WITH ranked_loans AS (
SELECT *,
RANK() OVER(ORDER BY Loan_Amount DESC) AS rnk
FROM loans
)
SELECT Loan_ID, Customer_ID, Loan_Amount, rnk
FROM ranked_loans
WHERE rnk <= 10;

--Count and Exposure of Performing vs Non-Performing Loans
SELECT
CASE
WHEN Default_Status = 0 THEN 'Performing'
WHEN Default_Status = 1 THEN 'Non-Performing'
END AS Loan_Status,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Exposure
FROM loans
GROUP BY
CASE
WHEN Default_Status = 0 THEN 'Performing'
WHEN Default_Status = 1 THEN 'Non-Performing'
END;

--Credit Score and Default Rate by Risk Bands
WITH risk_seg AS (
SELECT *,
CASE
WHEN Credit_Score < 500 THEN 'High Risk'
WHEN Credit_Score < 650 THEN 'Medium Risk'
ELSE 'Low Risk'
END AS Risk_Category
FROM loans
)

SELECT
Risk_Category,
COUNT(*) AS Customers,
ROUND(AVG(CAST(Default_Status AS FLOAT))*100,2) AS Default_Rate
FROM risk_seg
GROUP BY Risk_Category;

--Collateral Coverage Ratio
SELECT top(10)
    Loan_ID,
    Loan_Amount,
    Collateral_Value,
    CAST(
        Collateral_Value * 1.0 / NULLIF(Loan_Amount,0)
        AS DECIMAL(18,6)
    ) AS Coverage_Ratio
FROM loans
ORDER BY Coverage_Ratio ASC;

-- Hidden Risk Accounts: Good score but poor repayment history.
SELECT *
FROM loans
WHERE Credit_Score > 650
AND Repayment_History < 60;

--Most Dangerous Loans : Low score + High amount + Non-performing
SELECT top(10) *
FROM loans
WHERE Default_Status = 1
ORDER BY Credit_Score ASC, Loan_Amount DESC;

--Approx Expected Loss (Banking-style loss logic.)
SELECT
Loan_ID,
Loan_Amount,
Collateral_Value,
(Loan_Amount - Collateral_Value) AS Net_Exposure,
Default_Status,
(Default_Status * (Loan_Amount - Collateral_Value)) AS Expected_Loss
FROM loans;