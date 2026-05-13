-- ============================================================
-- PROJECT 2: HEALTHCARE REVENUE CYCLE MANAGEMENT (RCM) REPORT
-- Task 07  : Final Comprehensive AR Aging Analysis
-- Description: Integrating all metrics (Efficiency, Risk, and Action Items)
--              into one final executive report.
-- ============================================================

/* [EXECUTIVE SUMMARY & BUSINESS INSIGHTS]
 ------------------------------------------------------------
 1. FINANCIAL RISK: 
    - 100% of the Outstanding AR ($8.6M) is in the 'Over 120 Days' bucket.
    - Average Days Past Due is 733 days, which is critical.
    
 2. TOP PAYER ANALYSIS:
    - 'Cigna' is identified as the #1 revenue source (from Task 06).
    - Strategic focus should be placed on Cigna's long-overdue claims.
    
 3. RECOMMENDATION:
    - Immediate write-off evaluation for claims older than 2 years.
    - Priority follow-up for the Top 30 high-value claims listed in Section 3.
 ------------------------------------------------------------
*/

-- [SECTION 1] Days in AR (Overall Collection Efficiency)
WITH ar_sum AS (
    SELECT SUM(billed_amount) AS total_ar 
    FROM claims 
    WHERE claim_status IN ('Denied', 'Pending')
),
daily AS (
    SELECT SUM(billed_amount) / 365.0 AS avg_daily_bill 
    FROM claims 
    WHERE submit_date >= '2022-01-01'
)
SELECT 
    ROUND(ar.total_ar, 0) AS total_receivables, 
    ROUND(ar.total_ar / daily.avg_daily_bill, 1) AS days_in_ar,
    CASE 
        WHEN ar.total_ar / daily.avg_daily_bill < 30 THEN 'Excellent' 
        WHEN ar.total_ar / daily.avg_daily_bill < 50 THEN 'Warning' 
        ELSE 'Needs Improvement' 
    END AS performance_rating
FROM ar_sum ar, daily;


-- [SECTION 2] AR Aging Buckets (Risk Segmentation)
WITH ab AS (
    SELECT 
        billed_amount, 
        DATE '2024-12-31' - submit_date AS days_diff,
        CASE 
            WHEN DATE '2024-12-31' - submit_date <= 30 THEN '1. 0-30 Days'
            WHEN DATE '2024-12-31' - submit_date <= 60 THEN '2. 31-60 Days'
            WHEN DATE '2024-12-31' - submit_date <= 90 THEN '3. 61-90 Days'
            WHEN DATE '2024-12-31' - submit_date <= 120 THEN '4. 91-120 Days'
            ELSE '5. Over 120 Days' 
        END AS bucket
    FROM claims 
    WHERE claim_status IN ('Denied', 'Pending')
)
SELECT 
    bucket, 
    COUNT(*) AS claim_count, 
    ROUND(SUM(billed_amount), 0) AS outstanding_amount,
    ROUND(AVG(days_diff)) AS avg_days_past_due,
    ROUND(SUM(billed_amount) * 100.0 / SUM(SUM(billed_amount)) OVER(), 1) AS percentage_of_total_ar
FROM ab 
GROUP BY bucket 
ORDER BY bucket;


-- [SECTION 3] High-Priority Follow-up List (Top 30 Action Items)
SELECT 
    ROW_NUMBER() OVER (ORDER BY c.billed_amount DESC) AS rank_no,
    c.claim_id, 
    c.payer_name, 
    p.region,
    c.billed_amount, 
    DATE '2024-12-31' - c.submit_date AS days_past_due,
    c.denial_reason
FROM claims c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.claim_status IN ('Denied', 'Pending')
ORDER BY c.billed_amount DESC 
LIMIT 30;