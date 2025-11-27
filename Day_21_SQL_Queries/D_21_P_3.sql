-- D_21_P_3. Build a CTE for staff utilization and join it with patient data.

WITH Staff_Utilization AS (
    SELECT service, COUNT(staff_id) AS Staff_Count
    FROM staff GROUP BY service),
    Patient_Metrics AS (
    SELECT service, COUNT(*) AS Total_Patients,
       ROUND(AVG(satisfaction), 2) AS Avg_Satisfaction
    FROM patients
    GROUP BY service )
SELECT pm.service,
    pm.Total_Patients,
    pm.Avg_Satisfaction,
    su.Staff_Count
FROM Staff_Utilization su
 JOIN Patient_Metrics pm ON pm.service = su.service
ORDER BY pm.service;
