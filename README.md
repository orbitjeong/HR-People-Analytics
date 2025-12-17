# HR People Analytics Dashboard

## 📌 Project Overview

This project demonstrates a complete HR People Analytics workflow using real-world–style HR data.
Employee demographic data and employment history are combined to analyze workforce trends and key HR metrics.
The dashboard is designed to support data-driven HR decision-making through clear KPIs and interactive visualizations.

---

## 📊 Business Questions

- How has overall headcount changed over time?
- What is the employee turnover rate for a given period?
- Which departments experience higher employee turnover?
- How effectively is the organization retaining employees?

---

## 🗂 Data Sources

| File | Description |
| --- | --- |
| `people_data.csv` | Employee demographic and job-related information (dimension table) |
| `people_employment_history.csv` | Hire and termination history used to calculate HR metrics (fact table) |

Raw data is stored in `data/raw/` and is not modified directly.

---

## 🛠 Tools & Technologies

- **Python (Pandas)** – Data cleaning, date parsing, and table joins
- **SQL** – HR metrics calculation (headcount, turnover, retention)
- **Power BI** – Data modeling, DAX measures, and interactive dashboards
- **GitHub** – Project documentation and version control

---

## 🔄 Data Preparation Workflow

1. Raw HR datasets are loaded from `data/raw/`
2. Python is used to:
    - Clean and standardize date fields
    - Join employee master data with employment history
3. A clean, analysis-ready dataset is saved to `data/processed/people_fact_clean.csv`
4. SQL and Power BI both use this processed dataset for analysis

---

## 📈 Key Metrics

- **Headcount** – Active employees as of a selected date
- **Retention Rate** – Percentage of employees retained over a period
- **Turnover Rate** – Percentage of employees who left during a period

Metric definitions follow common HR analytics practices and are documented in SQL and DAX.

---

## 📊 Dashboard Preview

### 🔹 Cover Page
<img width="957" alt="Cover Page" src="https://github.com/user-attachments/assets/98e8b302-49e0-4569-9369-b2ba8605a75b" />

### 🔹 Headcount Analysis
<img width="100%" alt="Headcount Dashboard" src="https://github.com/user-attachments/assets/06937dee-22e6-4d78-b340-35f991ebda2c" />

### 🔹 Retention Analysis
<img width="100%" alt="Retention Dashboard" src="https://github.com/user-attachments/assets/26954353-8f56-465e-9270-b27931e06d3c" />

### 🔹 Turnover Analysis
<img width="100%" alt="Turnover Dashboard" src="https://github.com/user-attachments/assets/fb1f7ad5-5f41-4b51-a0a4-f397d4911b71" />

---


## 📂 Project Structure

```
HR-People-Analytics/
├─ data/
│  ├─ raw/
│  └─ processed/
├─ python/
│  ├─ 01_data_exploration.ipynb
│  └─ 02_metric_validation.ipynb
├─ sql/
│  ├─ schema.sql
│  └─ analysis_queries.sql
├─ powerbi/
│  └─ HR_People_Analytics.pbix
├─ images/
└─ README.md
```

---

## 💡 Key Insights

- Workforce size trends provide visibility into hiring and attrition patterns
- Turnover analysis highlights departments with higher attrition risk
- Retention metrics support workforce planning and HR strategy decisions

---

## 👤 Author

**Jennie Jeong**

Data Analyst | Power BI • SQL • Python

📎 GitHub: https://github.com/orbitjeong
