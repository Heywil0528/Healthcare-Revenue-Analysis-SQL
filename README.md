# Healthcare-Revenue-Analysis-SQL
# Healthcare Revenue Cycle SQL Portfolio

## About This Project

This portfolio is developed by a Certified Revenue Cycle Representative (CRCR) currently pursuing a HIMT (Health Information Management and Technology) Post-baccalaureate program (Expected Completion: May 2027).

Unlike typical data portfolios, this project is built on real RCM domain knowledge. Every query, insight, and action plan reflects how a credentialed revenue cycle professional would actually interpret billing data — not just how to write SQL.

Core expertise applied in this project:
- Medical Terminology & Coding: ICD-10, CPT structures, and clinical data interpretation
- RCM Workflows: End-to-end claim lifecycle management to minimize denials and optimize cash flow
- Financial Compliance: AR aging audits and collection rate improvement per CRCR standards

---

## Data Source & Methodology

- Source: Kaggle Medical Cost Personal Dataset (1,338 records, 7 columns)
- Restructured flat-file data into a relational model with 3 tables — `patients`, `claims`, `payments`
- Added simulated RCM fields (`claim_status`, `denial_reason`) to replicate real-world billing environments
- Established PK/FK relationships for data integrity

> Note: Financial figures are based on a simulated dataset. Metrics like Days in AR are intentionally set to critical levels to practice RCM recovery workflows.

---

## Repository Structure

```
📁 scripts/
  └── 02_Projects/
      ├── task_01_denial_analysis.sql
      ├── task_02_cost_analysis_age_group.sql
      ├── task_03_ar_aging.sql
      ├── task_04_payer_priority.sql
      ├── task_05_monthly_trend.sql
      ├── task_06_top5_payer_ranking.sql
      └── task_07_final_ar_aging_report.sql
📁 outputs/
  ├── screenshots/
  └── reports/
      └── 07_Final_AR_Aging_Report.csv
```

---

## Key Analysis & Insights

### Task 01 — Denial Root Cause Analysis
- Duplicate Claim (93) and Not Medically Necessary (92) drive 63% of all denials — an administrative problem, not a clinical one.
- Prior Authorization Required averages $43,271 per denied claim, nearly 3x higher than any other category, making it the highest financial risk.
- Not Medically Necessary shows a 52.2% smoker ratio, suggesting lifestyle data may be influencing insurer decisions — a compliance flag a CRCR would immediately escalate.

### Task 02 — Patient Demographics & Cost Correlation
- Charges peak in the 50s ($15,494 avg) then drop in the 60s ($11,986), consistent with the Medicare coverage transition — a key payer mix signal.

### Task 03 — AR Aging Critical Risk Assessment
- 100% of outstanding AR ($8.6M) is in the 120+ Days bucket, with an average of 733 days past due.
- Per CRCR standards, anything beyond 90 days requires escalation. At 733 days, this portfolio is designed to simulate a full AR recovery scenario.

### Task 04 — Payer Priority & Outstanding AR
- Cigna ($1,534,990) and United Healthcare ($1,468,027) hold the two largest outstanding balances.
- Every payer averages 700+ days outstanding — a systemic collections failure, not an isolated payer issue.

### Task 05 — Monthly Denial Rate Trend (Window Function: LAG)
- December 2022 spiked to 35.0%, reflecting year-end processing backlogs — a pattern a CRCR would flag for proactive staffing adjustments.
- October 2023 showed a +10.3% variance, triggering high-alert status and requiring immediate operational review.

### Task 06 — Top 5 Payer Revenue Ranking
- Cigna ($3,192,333) and United Healthcare ($3,110,687) are the primary revenue drivers and highest-priority contract relationships.
- Medicare ranks 4th in volume but leads in average revenue per claim ($14,425), underscoring the value of accurate Medicare documentation.

### Task 07 — Final Executive AR Aging Report (Top 30 High-Value Claims)
- Prior Authorization Required is the dominant denial reason across top-tier claims, consistent with Task 01 findings.
- 10 of 30 claims remain Pending with no denial recorded — immediate recovery opportunities requiring follow-up.
- The longest overdue claim is 1,090 days (Cigna) — a near 3-year unresolved account, and the first escalation priority.

---

## Technical Stack

- Database: PostgreSQL 16 + pgAdmin 4
- SQL Techniques: JOINs, CTEs, Subqueries, CASE Statements, Window Functions (LAG, RANK)
- Data Modeling: Relational schema design, PK/FK normalization

---

## Key Action Plan

| Priority | Action | Impact |
|---|---|---|
| P1 | Escalate Top 30 AR claims immediately | Recover ~$1.47M |
| P1 | Build Prior Authorization pre-submission checklist | Prevent $43K avg denials |
| P2 | Automate eligibility verification at intake | Eliminate preventable denials |
| P2 | Flag December submissions for additional audit | Prevent year-end spikes |
| P3 | Review Not Medically Necessary smoker claims | Strengthen appeals documentation |
