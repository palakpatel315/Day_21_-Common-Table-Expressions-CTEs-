# 📘 21 Days SQL Challenge – Day 21  
### **Topic: Common Table Expressions (CTEs)**  

---

## 🎯 Objective  
Day 21 focused on **CTEs using the WITH clause**—a powerful way to organize queries, break down complex logic, and improve readability. You also explored multi-step CTEs and how they help structure analytical SQL workflows.

---

## 🧠 Key Learnings  

- CTEs create **temporary named result sets** used within a query.  
- They make complex queries easier to read and maintain.  
- CTEs can **reference other CTEs**, enabling step-by-step calculations.  
- Multiple CTEs can be combined for layered analysis.  
- CTEs are great for tasks like service stats, staff summaries, and linked performance metrics.

---

## 🧩 Daily Challenge  

### **Question:**  
Create a comprehensive hospital performance dashboard using CTEs. Calculate:

1. **Service-level metrics**  
   - Total admissions  
   - Total refusals  
   - Average satisfaction  

2. **Staff metrics per service**  
   - Total staff  
   - Average weeks present  

3. **Patient demographics per service**  
   - Average age  
   - Patient count  

Then combine all three CTEs to create a final report showing service name, all calculated metrics, and an **overall performance score** (weighted average of admission rate and satisfaction). Order by performance score descending.

---

## ✅ SQL Query Used

```sql
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
```
## 📸 **SQL Queries**

![Check_SQL Query File](https://github.com/palakpatel315/Day_21_-Common-Table-Expressions-CTEs-/tree/main/Day_21_SQL_Queries)


---
Thank you [Indian Data Club](https://www.linkedin.com/company/indian-data-club/posts/?feedView=all) for starting this challenge and [DPDzero](https://www.linkedin.com/company/dpdzero/) the title sponsor of this challenge

---

## 👩‍💻 **About Me**
**Palak Patel**  
*Aspiring Data Analyst | Skilled in SQL, Power BI, Excel*  
📍 Passionate about turning data into insights and solving real-world business problems.  

🔗 [Connect with me on LinkedIn](https://www.linkedin.com/in/palak-patel-0711242a0/)

---
