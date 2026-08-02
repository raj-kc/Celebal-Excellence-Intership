# Shadow Revenue Detection System

## Overview

The **Shadow Revenue Detection System** is a Data Engineering project developed using **Databricks**, **Apache Spark**, **Delta Lake**, and the **Medallion Architecture (Bronze → Silver → Gold)**. The project focuses on identifying revenue leakage by processing raw transactional data, improving data quality, and generating business-ready analytics.

The system compares two different data pipelines:

* **Bad Pipeline:** Processes raw data without any cleaning or quality checks, demonstrating how poor data quality leads to incorrect business metrics.
* **Good Pipeline:** Applies production-grade data engineering practices such as deduplication, null handling, type casting, and Slowly Changing Dimension (SCD Type 2) handling to produce accurate analytics.

The final output includes Gold-layer fact tables, KPI summary tables, and interactive dashboard queries for business reporting.

---

# Problem Statement

Organizations often experience revenue discrepancies due to:

* Missing payment records
* Orphan payments
* Duplicate transactions
* Incorrect product prices
* Poor data quality

Without proper data engineering practices, these issues result in inaccurate revenue reporting and financial leakage.

This project demonstrates how a Medallion Architecture can improve data quality and help identify revenue anomalies before they impact business decisions.

---

# Project Objectives

* Build a Medallion Architecture using Databricks.
* Load raw CSV files into Delta Lake.
* Create Bronze, Silver, and Gold layers.
* Compare Bad and Good data pipelines.
* Detect revenue anomalies.
* Generate business KPIs.
* Prepare datasets for AI/BI dashboards.
* Demonstrate enterprise data engineering best practices.

---

# Technology Stack

| Category          | Technology              |
| ----------------- | ----------------------- |
| Platform          | Databricks Free Edition |
| Processing Engine | Apache Spark            |
| Language          | PySpark, Spark SQL      |
| Storage Format    | Delta Lake              |
| Catalog           | Unity Catalog           |
| Architecture      | Medallion Architecture  |
| Version Control   | Git & GitHub            |

---

# Dataset

The project uses four CSV datasets:

| Dataset       | Description                             |
| ------------- | --------------------------------------- |
| orders.csv    | Customer order information              |
| payments.csv  | Payment transactions                    |
| products.csv  | Product catalog with SCD Type 2 history |
| customers.csv | Customer master data                    |

---

# Medallion Architecture

## Bronze Layer

Stores raw data exactly as received.

Features:

* Raw CSV ingestion
* No transformations
* Delta format storage

Tables

* bronze_orders
* bronze_payments
* bronze_products
* bronze_customers

---

## Silver Layer

The Silver layer contains two independent pipelines.

### Bad Pipeline

The Bad pipeline intentionally skips all quality checks.

Characteristics:

* Duplicate records retained
* Null values retained
* No type casting
* No data cleansing
* No proper SCD handling

Tables

* silver_orders_bad
* silver_payments_bad
* silver_products_bad
* silver_customers_bad

---

### Good Pipeline

The Good pipeline applies production-grade transformations.

Transformations:

* Duplicate removal using Window Functions
* Decimal type casting for financial precision
* Date parsing
* Null filtering
* SCD Type 2 filtering using current product records
* Temporary views for downstream processing

Tables

* silver_orders_good
* silver_payments_good
* silver_products_good
* silver_customers_good

---

## Gold Layer

The Gold layer creates business-ready analytical datasets.

Outputs:

* Revenue fact tables
* KPI summary tables
* Revenue anomaly detection
* Dashboard datasets

Tables

* fact_revenue_bad
* fact_revenue_good
* kpi_revenue_bad
* kpi_revenue_good
* kpi_comparison

---

# Revenue Anomalies Detected

The system identifies the following anomalies:

* Missing Payments
* Orphan Payments
* Price Mismatches
* Duplicate Orders
* Revenue Difference

---

# KPIs Generated

The project calculates:

* Total Revenue
* Total Payment
* Revenue Difference
* Accuracy Ratio
* Missing Payments Count
* Orphan Payments Count
* Price Mismatch Count
* Duplicate Orders Count

---

# Dashboard Visualizations

The final dashboard includes:

1. KPI Cards

   * Total Revenue
   * Total Payment
   * Revenue Difference
   * Accuracy Ratio
   * Missing Payments
   * Orphan Payments

2. Revenue Comparison (Bad vs Good)

3. Missing Payments Analysis

4. Issue Distribution (Donut Chart)

5. Revenue Trend Over Time

6. Revenue Leakage Analysis

7. Per-Order Revenue Difference Table

---

# Project Workflow

```text
Raw CSV Files
        │
        ▼
Bronze Layer
(Raw Delta Tables)
        │
        ▼
Silver Layer
├── Bad Pipeline
└── Good Pipeline
        │
        ▼
Gold Layer
├── Revenue Fact Tables
├── KPI Tables
└── Dashboard Queries
        │
        ▼
Databricks AI/BI Dashboard
```

---

# Repository Structure

```text
Shadow-Revenue-Detection-System/
│
├── README.md
├── requirements.txt
│
├── data/
│   └── raw/
│       ├── orders.csv
│       ├── payments.csv
│       ├── products.csv
│       └── customers.csv
│
├── notebooks/
│   ├── 00_Project_Setup
│   ├── 01_Bronze_Layer
│   ├── 02_Silver_Layer
│   ├── 03_Gold_Layer
│   └── 04_Dashboard_Queries
│
├── screenshots/
│
└── docs/
```

---

# Notebook Description

| Notebook             | Description                                                         |
| -------------------- | ------------------------------------------------------------------- |
| 00_Project_Setup     | Creates Unity Catalog, schemas, and volumes for the project.        |
| 01_Bronze_Layer      | Loads raw CSV files into Bronze Delta tables.                       |
| 02_Silver_Layer      | Builds Bad and Good pipelines with data quality transformations.    |
| 03_Gold_Layer        | Creates revenue fact tables, detects anomalies, and generates KPIs. |
| 04_Dashboard_Queries | Prepares SQL queries for dashboard visualizations.                  |

---

# How to Run the Project

1. Create a Unity Catalog and Bronze, Silver, and Gold schemas.
2. Upload the raw CSV files to the project volume.
3. Execute notebooks in the following order:

   * 00_Project_Setup
   * 01_Bronze_Layer
   * 02_Silver_Layer
   * 03_Gold_Layer
   * 04_Dashboard_Queries
4. Create visualizations in Databricks AI/BI Dashboard using the prepared queries.

---

# Project Deliverables

This project includes:

* Complete Databricks notebooks
* Bronze, Silver, and Gold Delta tables
* Revenue anomaly detection logic
* KPI summary tables
* Dashboard SQL queries
* Dashboard visualizations
* Project documentation
* GitHub repository

---

# Future Enhancements

* Incremental data ingestion using Auto Loader
* Delta Live Tables implementation
* Real-time streaming using Structured Streaming
* Automated data quality monitoring
* CI/CD pipeline for deployment
* Integration with Power BI or Tableau

---

# Author

**Raj Chaudhary**

Data Engineering Project

Celebal Technologies Internship

2026
