-- D_21_P_1. Create a CTE to calculate service statistics, then query from it.

WITH service_stats AS (
    SELECT service,
           COUNT(*) AS Patient_Count,
           ROUND(AVG(satisfaction),2) AS Avg_Satisfaction
    FROM patients
    GROUP BY service
)
SELECT * FROM service_stats
WHERE Avg_Satisfaction > 75 ORDER BY Patient_Count DESC;