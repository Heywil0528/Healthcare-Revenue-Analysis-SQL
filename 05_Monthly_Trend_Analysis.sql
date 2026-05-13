-- ============================================================
-- PROJECT 2: MONTHLY DENIAL RATE TREND ANALYSIS
-- Description: Using Window Functions (LAG) to analyze MoM (Month-over-Month) trends.
-- Goal: Identify if the denial rate is improving or worsening over time.
-- ============================================================

-- [STEP 1] Aggregate monthly data using a Common Table Expression (CTE)
WITH monthly_stats AS (
    SELECT 
        TO_CHAR(submit_date, 'YYYY-MM') AS month_year,
        COUNT(*) AS total_claims,
        SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END) AS denied_count
    FROM claims 
    WHERE submit_date IS NOT NULL
    GROUP BY TO_CHAR(submit_date, 'YYYY-MM')
)
-- [STEP 2] Use Window Functions to compare with the previous month
SELECT 
    month_year,
    -- Current Month's Denial Rate (%)
    ROUND(denied_count * 100.0 / total_claims, 1) AS current_denial_rate,
    
    -- Previous Month's Denial Rate (%) using LAG()
    LAG(ROUND(denied_count * 100.0 / total_claims, 1)) 
        OVER (ORDER BY month_year) AS previous_denial_rate,
        
    -- Monthly Variance (Percentage Point Change)
    ROUND(denied_count * 100.0 / total_claims, 1) - 
    LAG(ROUND(denied_count * 100.0 / total_claims, 1)) 
        OVER (ORDER BY month_year) AS monthly_variance
FROM monthly_stats
ORDER BY month_year;