-- D_21_P_2. Use multiple CTEs to break down a complex query into logical steps.

WITH Patient_Metrics AS (
    SELECT service, COUNT(*) AS Total_Patients,
       ROUND(AVG(age), 2) AS Avg_Age, ROUND(AVG(satisfaction), 2) AS Avg_Satisfaction
    FROM patients
    GROUP BY service ),
Staff_Metrics AS (
    SELECT service, COUNT(*) AS Total_Staff
    FROM staff
    GROUP BY service ),
Weekly_Metrics AS (
    SELECT service, SUM(patients_admitted) AS Total_Admitted,
        SUM(patients_refused) AS Total_Refused
    FROM services_weekly
    GROUP BY service )
SELECT
    pm.service,
    sm.Total_Staff,
    pm.Total_Patients,
    pm.Avg_Age,
    pm.Avg_Satisfaction,
    wm.Total_Admitted,
    wm.Total_Refused,
    ROUND(100.0 * wm.Total_Admitted / (wm.Total_Admitted + wm.Total_Refused), 2) AS Admission_Rate
FROM Patient_Metrics pm
LEFT JOIN Staff_Metrics sm ON pm.service = sm.service
LEFT JOIN Weekly_Metrics wm ON pm.service = wm.service
ORDER BY pm.Avg_Satisfaction DESC;