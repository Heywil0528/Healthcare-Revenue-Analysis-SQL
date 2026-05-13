-- ============================================================
-- PROJECT 2: HEALTHCARE COST & OPERATION ANALYSIS
-- Task 06  : Top 5 Payer Ranking Analysis
-- Description: Using RANK() Window Function to identify top revenue sources.
-- Goal     : Determine the top 5 insurance companies by total billed amount.
-- ============================================================

-- [STEP 1] Calculate total billing per payer and assign ranks
WITH payer_revenue AS (
    SELECT 
        payer_name,
        ROUND(SUM(billed_amount), 0) AS total_revenue,
        COUNT(*) AS total_claims,
        -- Use RANK() to order payers by revenue in descending order
        RANK() OVER (ORDER BY SUM(billed_amount) DESC) AS revenue_rank
    FROM claims
    GROUP BY payer_name
)
-- [STEP 2] Filter for the Top 5 Payers
SELECT 
    revenue_rank,
    payer_name,
    total_revenue,
    total_claims,
    ROUND(total_revenue / total_claims, 0) AS avg_revenue_per_claim
FROM payer_revenue
WHERE revenue_rank <= 5
ORDER BY revenue_rank;