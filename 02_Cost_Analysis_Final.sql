-- ============================================================
-- PROJECT 2: HEALTHCARE COST & DEMOGRAPHIC ANALYSIS
-- Description: Joining patients and claims to analyze spending patterns.
-- ============================================================

-- [STEP 1] Average Billed Amount by Gender and Smoker Status
-- We use JOIN to bring 'billed_amount' from the claims table.
SELECT 
    p.sex, 
    p.smoker, 
    COUNT(p.patient_id) AS patient_count,
    ROUND(AVG(c.billed_amount), 0) AS avg_medical_charge
FROM patients p
JOIN claims c ON p.patient_id = c.patient_id
GROUP BY p.sex, p.smoker
ORDER BY avg_medical_charge DESC;


-- [STEP 2] BMI Category vs. Average Billed Amount
SELECT 
    CASE 
        WHEN p.bmi < 18.5 THEN 'Underweight'
        WHEN p.bmi >= 18.5 AND p.bmi < 25 THEN 'Normal'
        WHEN p.bmi >= 25 AND p.bmi < 30 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category,
    ROUND(AVG(c.billed_amount), 0) AS avg_medical_charge,
    COUNT(p.patient_id) AS patient_count
FROM patients p
JOIN claims c ON p.patient_id = c.patient_id
GROUP BY bmi_category
ORDER BY avg_medical_charge DESC;


-- [STEP 3] Age Group Analysis
SELECT 
    FLOOR(p.age / 10) * 10 AS age_group,
    ROUND(AVG(c.billed_amount), 0) AS avg_medical_charge,
    COUNT(p.patient_id) AS patient_count
FROM patients p
JOIN claims c ON p.patient_id = c.patient_id
GROUP BY age_group
ORDER BY age_group;