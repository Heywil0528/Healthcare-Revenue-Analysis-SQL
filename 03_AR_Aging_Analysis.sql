-- ============================================================
-- PROJECT 2: AR AGING REPORT (Revenue Cycle Management)
-- Description: Categorizing unpaid claims by how long they have been outstanding.
-- Goal: Identify high-risk receivables (over 90 days).
-- ============================================================

-- [STEP 1] Calculating Days in AR (Overall Efficiency)
-- This calculates the average number of days it takes to collect payments.
WITH ar_summary AS (
    SELECT 
        SUM(billed_amount) AS total_ar
    FROM claims 
    WHERE claim_status IN ('Denied', 'Pending')
),
daily_avg AS (
    SELECT 
        SUM(billed_amount) / 365.0 AS daily_billed
    FROM claims
    WHERE submit_date >= DATE '2022-01-01'
)
SELECT 
    ROUND(ar.total_ar, 0) AS total_receivables,
    ROUND(da.daily_billed, 0) AS avg_daily_billing,
    ROUND(ar.total_ar / da.daily_billed, 1) AS days_in_ar,
    CASE 
        WHEN ar.total_ar / da.daily_billed < 30 THEN 'Excellent'
        WHEN ar.total_ar / da.daily_billed < 50 THEN 'Warning'
        ELSE 'Needs Improvement'
    END AS performance_rating
FROM ar_summary ar, daily_avg da;


-- [STEP 2] AR Aging Buckets (Risk Segmentation)
-- Categorizing each claim into age groups (0-30 days, 31-60 days, etc.)
WITH ar_bucketed AS (
    SELECT 
        billed_amount,
        -- Reference Date is set to 2024-12-31 for the calculation
        DATE '2024-12-31' - submit_date AS days_outstanding,
        CASE 
            WHEN DATE '2024-12-31' - submit_date <= 30 THEN '1. 0-30 Days'
            WHEN DATE '2024-12-31' - submit_date <= 60 THEN '2. 31-60 Days'
            WHEN DATE '2024-12-31' - submit_date <= 90 THEN '3. 61-90 Days'
            WHEN DATE '2024-12-31' - submit_date <= 120 THEN '4. 91-120 Days'
            ELSE '5. Over 120 Days'
        END AS aging_bucket
    FROM claims 
    WHERE claim_status IN ('Denied', 'Pending')
)
SELECT 
    aging_bucket,
    COUNT(*) AS claim_count,
    ROUND(SUM(billed_amount), 0) AS outstanding_amount,
    ROUND(AVG(days_outstanding)) AS avg_days_past_due,
    ROUND(
        SUM(billed_amount) * 100.0 / SUM(SUM(billed_amount)) OVER(), 
        1
    ) AS percentage_of_total_ar
FROM ar_bucketed
GROUP BY aging_bucket
ORDER BY aging_bucket;