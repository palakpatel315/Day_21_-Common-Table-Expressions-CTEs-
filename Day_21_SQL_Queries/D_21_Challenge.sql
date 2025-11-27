-- D_21_Challenge_Question: Create a comprehensive hospital performance dashboard using CTEs. Calculate: 
-- 1) Service-level metrics (total admissions, refusals, avg satisfaction), 
-- 2) Staff metrics per service (total staff, avg weeks present), 
-- 3) Patient demographics per service (avg age, count). 
-- Then combine all three CTEs to create a final report showing service name, all calculated metrics,
--  and an overall performance score (weighted average of admission rate and satisfaction). Order by performance score descending.

WITH service_metrics AS (
    SELECT service,
        SUM(patients_admitted) AS Total_Admissions,
        SUM(patients_refused) AS Total_Refusals,
        ROUND(AVG(patient_satisfaction), 2) AS Avg_Satisfaction
    FROM services_weekly
    GROUP BY service ),
staff_metrics AS (
    SELECT service,
        COUNT(DISTINCT staff_id) AS Total_Staff,
        ROUND(AVG(week_present), 2) AS Avg_Of_Week_Present
    FROM (SELECT service, staff_id, SUM(present) AS week_present FROM staff_schedule GROUP BY service, staff_id) 
    AS staff_week_count GROUP BY service ),
patient_demographics AS (
    SELECT service,
        ROUND(AVG(age), 1) AS Avg_Age,
        COUNT(patient_id) AS Patient_Count
    FROM patients
    GROUP BY service )
SELECT 
    sm.service,
    sm.Total_Admissions,
    sm.Total_Refusals,
    sm.Avg_Satisfaction,
    st.Avg_Of_Week_Present,
    st.Total_Staff,
    pd.Avg_Age,
    pd.Patient_Count,
    ROUND( (0.7 * (sm.Total_Admissions * 1.0 / (sm.Total_Admissions + sm.Total_Refusals)) * 100) +
        (0.3 * sm.Avg_Satisfaction), 2 ) AS Performance_Score
FROM service_metrics sm
JOIN staff_metrics st ON sm.service = st.service
JOIN patient_demographics pd ON sm.service = pd.service
ORDER BY Performance_Score DESC ;
