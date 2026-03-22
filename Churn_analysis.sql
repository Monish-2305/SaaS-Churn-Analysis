--Customer Churn Event Analysis

--1. Total Churn Events
SELECT COUNT(*) AS Churn_Events
FROM ravenstack_churn_events

--2. Unique accounts that churned
SELECT COUNT (DISTINCT account_id) AS unique_churn_accounts
FROM ravenstack_churn_events

--3.Monthly Churn Trend
SELECT
DATE_TRUNC(churn_date, month) AS churn_month,
COUNT(DISTINCT account_id) AS Churned_accounts
FROM ravenstack_churn_events
GROUP BY churn_month
ORDER BY churn_month

--4. Revenue Impact Analysis
--Total Revenue Lost
SELECT 
SUM (refund_amount_usd) AS Total_refund_loss
FROM ravenstack_churn_events

--Average Refund Per Account
SELECT
AVG(refund_amount_usd) AS average_refund_per_account
FROM ravenstack_churn_events

--Revenue Loss By Month
SELECT
DATE_TRUNC(churn_date, month) AS churn_month,
ROUND (SUM (refund_amount_usd),2) AS refund_loss
FROM ravenstack_churn_events
GROUP BY churn_month 
ORDER BY churn_month DESC

--5. Root Cause Analysis
--Top Churn Reason
SELECT 
reason_code,
Count(*) AS churn_count
FROM ravenstack_churn_events
GROUP BY reason_code
ORDER BY churn_count DESC
  
--Revenue Loss by Churn Reason
SELECT
reason_code,
ROUND (SUM(refund_amount_usd),2) AS refund_loss,
FROM data-analytics-464302.Ravenstack_churnevents.Ravenstack_churn
GROUP BY reason_code
ORDER BY refund_loss DESC

--6. Upgrade/Downgrade signals
--Percentage of people downgraded before churn
SELECT 
preceding_downgrade_flag,
COUNT (*) AS churn_count,
ROUND(COUNT (*) *100 / SUM (COUNT(*)) OVER(), 2) AS PERCENTAGE
FROM data-analytics-464302.Ravenstack_churnevents.Ravenstack_churn
GROUP BY preceding_downgrade_flag

--Percentage of People Ugraded before churn
SELECT
preceding_upgrade_flag,
COUNT (*) AS churn_count,
ROUND(COUNT (*) *100 / SUM (COUNT(*)) OVER(), 2) AS PERCENTAGE
FROM data-analytics-464302.Ravenstack_churnevents.Ravenstack_churn
GROUP BY preceding_upgrade_flag

--7. Reactivation Analysis
--Reactivation Rate
SELECT
is_reactivation,
COUNT (*) AS account_count,
FROM data-analytics-464302.Ravenstack_churnevents.Ravenstack_churn
GROUP BY is_reactivation

--Reactivation by Reason
select 
reason_code,
COUNT (CASE WHEN is_reactivation IS TRUE THEN 1 END) AS reactivated_accounts
FROM data-analytics-464302.Ravenstack_churnevents.Ravenstack_churn
GROUP BY reason_code
ORDER By reactivated_accounts DESC
