## Day 13: Data Quality Checks

**Objective:**  
Ensure the `clean_healthcare_metrics` table meets expected data quality standards before performing analytical queries.

### Steps & Checks:

1. **Check for missing or unexpected values:**
   - Columns like `gender`, `medical_condition`, and numeric clinical metrics (`glucose`, `blood_pressure`, `bmi`, `hba1c`, etc.) were examined.
   - Non-numeric values (`'Unknown'`, `'Out of range'`) were identified and counted.

2. **Summary of Findings:**
   - Numeric metrics contain some `'Unknown'` or `'Out of range'` values due to cleaning rules.
   - Example:
     - `glucose`: 25,500 numeric values, 4,500 `'Unknown'`
     - `blood_pressure`: 25,500 numeric values, 4,500 `'Unknown'`
     - `lengthofstay`: 30,000 numeric values, 0 `'Unknown'` or `'Out of range'`

3. **Purpose of Checks:**
   - Verify that numeric columns can be safely used in CAST and AVG operations.
   - Ensure no unexpected strings cause errors in downstream SQL analysis.


## Day 14: Clean Layer Analysis
**Objective:**  
Perform clean layer analysis to explore relationships between behavioral/lifestyle factors, clinical metrics, and hospitalization trends.

---

## Query Results & Insights

### Query 1: Sleep Hours vs Length of Stay
| sleep_hours_group | patient_count | avg_length_of_stay |
|------------------|---------------|------------------|
| 1-2              | 3             | 6.33             |
| 2-3              | 90            | 5.13             |
| 3-4              | 804           | 5.41             |
| 4-5              | 3669          | 5.23             |
| 5-6              | 8118          | 4.96             |
| 6-7              | 9371          | 4.42             |
| 7-8              | 5839          | 3.53             |
| 8+               | 2106          | 2.88             |

**Insight:**  
Patients with fewer sleep hours tend to have slightly longer hospital stays. A downward trend in `avg_length_of_stay` is observed as sleep hours increase.

---

### Query 2: Physical Activity vs Length of Stay
- `patient_count` ranges across values from -3.68 to 12.41
- `avg_length_of_stay` varies between 1 and 8 days

**Insight:**  
Extreme negative values may indicate data issues. In general, higher physical activity correlates with slightly shorter hospital stays.

---

### Query 3: Diet Score vs Length of Stay
- `diet_score` ranges from -1.75 to 12.06
- `avg_length_of_stay` mostly 1–8 days

**Insight:**  
Patients with higher diet scores tend to have shorter hospital stays, suggesting healthier diets may be associated with faster recovery.

---

### Query 4: Average Glucose by Medical Condition
| medical_condition | patient_count | avg_glucose |
|------------------|---------------|-------------|
| Diabetes          | 5466          | 180.14      |
| Unknown           | 3788          | 123.86      |
| Hypertension      | 6077          | 109.99      |
| Cancer            | 1033          | 109.38      |
| Obesity           | 3318          | 105.29      |
| Asthma            | 1718          | 100.13      |
| Arthritis         | 1501          | 99.91       |
| Healthy           | 2599          | 94.57       |

**Insight:**  
Diabetes patients have significantly higher glucose levels. Unknown condition patients show moderate glucose averages.

---

### Query 5: Average HbA1c by Medical Condition
| medical_condition | patient_count | avg_hba1c |
|------------------|---------------|-----------|
| Diabetes          | 6417          | 8.01      |
| Unknown           | 4500          | 6.31      |
| Obesity           | 3857          | 6.01      |
| Cancer            | 1234          | 5.94      |
| Hypertension      | 7120          | 5.81      |
| Arthritis         | 1796          | 5.68      |
| Asthma            | 2037          | 5.51      |
| Healthy           | 3039          | 5.19      |

**Insight:**  
HbA1c is highest in Diabetes patients, as expected. Other conditions have moderate values.

---

### Query 6: Average Cholesterol by Medical Condition
| medical_condition | patient_count | avg_cholesterol |
|------------------|---------------|----------------|
| Hypertension      | 7120          | 230.44         |
| Obesity           | 3857          | 220.60         |
| Cancer            | 1234          | 215.20         |
| Unknown           | 4500          | 212.81         |
| Diabetes          | 6417          | 209.73         |
| Arthritis         | 1796          | 209.71         |
| Asthma            | 2037          | 200.94         |
| Healthy           | 3039          | 179.15         |

**Insight:**  
Hypertension and Obesity patients show the highest cholesterol levels. Healthy patients have the lowest.

---

### Query 7: Grouped by Gender
| gender | patient_count | avg_length_of_stay | avg_glucose | avg_hba1c |
|--------|---------------|------------------|-------------|-----------|
| Female | 10939         | 4.40             | 123.95      | 6.31      |
| Male   | 10734         | 4.41             | 123.51      | 6.29      |

**Insight:**  
No major gender differences in average hospital stay, glucose, or HbA1c.

---

### Query 8: Grouped by Age Group
| age_group | patient_count | avg_length_of_stay | avg_glucose | avg_hba1c |
|-----------|---------------|------------------|-------------|-----------|
| 0-19      | 467           | 3.35             | 98.57       | 5.41      |
| 20-39     | 3151          | 3.60             | 100.95      | 5.64      |
| 40-59     | 9515          | 4.48             | 129.46      | 6.50      |
| 60+       | 8581          | 4.65             | 126.51      | 6.35      |

**Insight:**  
Older patients tend to stay longer and have higher glucose/HbA1c averages.

---

### Query 9: Outliers — Length of Stay
| outlier_lengthofstay_count |
|----------------------------|
| 0                          |

**Insight:**  
No extreme outliers detected in `lengthofstay`.

---

### Query 10: High Glucose Count
| high_glucose_count |
|------------------|
| 2009             |

**Insight:**  
2,009 patients have glucose values considered unusually high (>200).

---

### Query 11: High HbA1c Count
| high_hba1c_count |
|-----------------|
| 345             |

**Insight:**  
345 patients have HbA1c > 10, indicating poor glycemic control.

---

### Query 12: Outlier BMI Count
| outlier_bmi_count |
|-----------------|
| 0                |

**Insight:**  
No extreme outliers in BMI were detected, likely due to prior cleaning steps.

---

## Summary

- **Behavioral & Lifestyle:** Sleep, physical activity, and diet influence hospital stay. More sleep and higher diet scores correlate with shorter stays.  
- **Clinical Metrics:** Diabetes patients show the highest glucose and HbA1c. Cholesterol highest in Hypertension and Obesity patients.  
- **Demographics:** Older patients have longer stays and higher average glucose/HbA1c. Gender differences are minimal.  
- **Outliers:** Limited extreme values after cleaning; major numeric placeholders (`Unknown`, `Out of range`) were properly handled.  
