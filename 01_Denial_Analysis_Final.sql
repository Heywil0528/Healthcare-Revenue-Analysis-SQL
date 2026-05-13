-- ============================================================
-- DENIAL ANALYSIS REPORT
-- Project  : Healthcare Revenue Cycle Portfolio
-- Data     : Kaggle Medical Cost Personal Dataset
-- Author   : [Your Name]
-- Purpose  : Identifying denial patterns by insurer, reason, and patient risk
-- ============================================================

-- [SECTION 1] Overall KPI Summary
-- Purpose: To understand the total financial impact and volume of denied claims.
SELECT 
    COUNT(*) AS total_claim_count,
    ROUND(SUM(billed_amount), 0) AS total_billed_amount,
    SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END) AS denied_count,
    ROUND(
        SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        1
    ) AS denial_rate_pct,
    ROUND(
        SUM(CASE WHEN claim_status = 'Denied' THEN billed_amount ELSE 0 END), 
        0
    ) AS total_denied_amount
FROM claims;


-- [SECTION 2] Payer Performance & Grading
-- Purpose: To evaluate insurance payers and identify high-risk partners.
WITH payer_stats AS (
    SELECT 
        payer_name,
        COUNT(*) AS total_count,
        SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END) AS denied_count,
        SUM(CASE WHEN claim_status = 'Denied' THEN billed_amount ELSE 0 END) AS denied_amt
    FROM claims
    GROUP BY payer_name
)
SELECT 
    payer_name,
    total_count AS total_claims,
    denied_count AS denied_claims,
    ROUND(denied_count * 100.0 / total_count, 1) AS denial_rate_pct,
    ROUND(denied_amt, 0) AS total_denied_amount,
    CASE 
        WHEN (denied_count * 100.0 / total_count) < 5 THEN 'Excellent (<5%)'
        WHEN (denied_count * 100.0 / total_count) < 10 THEN 'Warning (5-10%)'
        ELSE 'Critical (>10%)'
    END AS performance_grade
FROM payer_stats
ORDER BY denial_rate_pct DESC;


-- [SECTION 3] Denial Reason & Patient Risk Profile
-- Purpose: To analyze patient demographics associated with specific denial reasons.
SELECT 
    COALESCE(c.denial_reason, '(No Reason Provided)') AS denial_reason,
    COUNT(*) AS claim_count,
    ROUND(AVG(c.billed_amount), 0) AS avg_denied_amount,
    ROUND(
        SUM(CASE WHEN p.smoker = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        1
    ) AS smoker_ratio_pct,
    ROUND(AVG(p.bmi), 1) AS avg_bmi,
    ROUND(AVG(p.age), 1) AS avg_age
FROM claims c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.claim_status = 'Denied'
GROUP BY c.denial_reason
ORDER BY claim_count DESC;