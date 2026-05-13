-- ============================================================
-- PROJECT 2: PAYER COLLECTION PRIORITY ANALYSIS
-- Description: Assigning collection priorities based on AR amount and aging.
-- Strategic Goal: Focus on high-value, long-overdue payers first.
-- ============================================================

WITH ar_aged AS (
    SELECT 
        payer_name, 
        billed_amount,
        -- Calculate days passed since claim submission
        DATE '2024-12-31' - submit_date AS days_out
    FROM claims 
    WHERE claim_status IN ('Denied', 'Pending')
)
SELECT 
    payer_name,
    COUNT(*) AS claim_count,
    ROUND(SUM(billed_amount), 0) AS total_outstanding_amount,
    ROUND(AVG(days_out)) AS avg_days_outstanding,
    -- Prioritizing payers based on financial impact and time
    CASE 
        WHEN SUM(billed_amount) > 500000 AND AVG(days_out) > 60 THEN 'P1: Immediate'
        WHEN SUM(billed_amount) > 200000 OR AVG(days_out) > 60 THEN 'P2: High Priority'
        ELSE 'P3: Monitoring'
    END AS collection_priority
FROM ar_aged
GROUP BY payer_name
ORDER BY total_outstanding_amount DESC;