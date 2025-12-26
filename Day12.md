# Day 12: Healthcare Data Analysis

## Overview
In Day 5, the focus was on analyzing the **clean healthcare dataset** created in previous ETL steps. Three main analyses were conducted:

1. **Average Length of Stay by Medical Condition**  
2. **Sleep Hours vs Length of Stay**  
3. **HbA1c vs Medical Condition**

All queries were executed on `clean_healthcare_metrics` in DuckDB. Non-numeric or unknown values were handled appropriately to avoid conversion errors.

---

## Analysis Results

### 1️⃣ Average Length of Stay by Medical Condition

| Medical Condition | Patient Count | Avg Length of Stay |
|------------------|---------------|------------------|
| Cancer           | 1234          | 12.96            |
| Diabetes         | 6417          | 5.52             |
| Unknown          | 4500          | 4.46             |
| Hypertension     | 7120          | 4.01             |
| Asthma           | 2037          | 3.97             |
| Obesity          | 3857          | 3.51             |
| Arthritis        | 1796          | 3.48             |
| Healthy          | 3039          | 1.49             |

**Insight:**  
- Cancer patients have the longest stays, Healthy patients the shortest.  
- Disease severity correlates with hospital length of stay.  

---

### 2️⃣ Sleep Hours vs Length of Stay

- Sleep hours range widely (e.g., 1.59–10.35 hours).  
- Average length of stay does not show a strong linear trend with sleep hours.  

**Insight:**  
- Sleep alone may not strongly predict hospital stay; further analysis could consider interactions with other metrics.  

---

### 3️⃣ HbA1c vs Medical Condition

| Medical Condition | Patient Count | Avg HbA1c |
|------------------|---------------|------------|
| Diabetes         | 6417          | 8.01       |
| Unknown          | 4500          | 6.31       |
| Obesity          | 3857          | 6.01       |
| Cancer           | 1234          | 5.94       |
| Hypertension     | 7120          | 5.81       |
| Arthritis        | 1796          | 5.68       |
| Asthma           | 2037          | 5.51       |
| Healthy          | 3039          | 5.19       |

**Insight:**  
- HbA1c clearly differentiates diabetic patients from others.  
- `"Unknown"` and non-diabetic patients have lower average HbA1c values.  

---

## Overall Takeaways

- Length of stay and HbA1c are strong indicators for patient stratification.  
- `"Unknown"` values remain in the dataset; handling missing values carefully is important for downstream analysis.  
- Sleep hours do not show a clear correlation with hospital stay, but could be considered with other behavioral or clinical metrics in more advanced modeling.
