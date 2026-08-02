# E-Commerce Order Analytics System

## Overview

The E-Commerce Order Analytics System is a mini data engineering project developed as part of the Celebal Technologies Internship.

The project demonstrates a complete data processing pipeline, starting from raw CSV datasets, performing data cleaning and validation, loading the cleaned data into a SQLite database, executing analytical SQL queries, and generating reports using Python.

The objective of the project is to simulate a real-world ETL (Extract, Transform, Load) workflow while applying SQL analytics, data validation, and reporting techniques.

---

# Technologies Used

* Python 3
* Pandas
* SQLite
* SQL
* Git & GitHub

---

# Project Architecture

```
                  Raw CSV Files
                         │
                         ▼
               Data Cleaning Script
               (clean_data.py)
                         │
                         ▼
            Cleaned CSV Files + Report
                         │
                         ▼
             Database Loading Script
               (load_data.py)
                         │
                         ▼
                 SQLite Database
               (ecommerce.db)
                         │
        ┌────────────────┴────────────────┐
        ▼                                 ▼
 SQL Analytics                    Python Reports
(SQL Scripts)                 (report_generator.py)
        │                                 │
        └────────────────┬────────────────┘
                         ▼
                Generated Reports
```

---

# Project Structure

```
week-8_E-Commerce_Order_Analytics_System/

├── data/
│   ├── raw/
│   └── cleaned/
│
├── database/
│   └── ecommerce.db
│
├── output/
│   ├── cleaning_report.md
│   ├── rejected_order_items.csv
│   └── sample_reports/
│
├── scripts/
│   ├── clean_data.py
│   ├── load_data.py
│   ├── quick_check.py
│   ├── generate_data.py
│   ├── report_generator.py
│   ├── export_query_results.py
│   └── test_cases.py
│
├── sql/
│   ├── schema.sql
│   ├── aggregations.sql
│   ├── window_functions.sql
│   └── cohort_analysis.sql
│
├── requirements.txt
└── README.md
```

---

# Workflow

# Workflow

## Step 1 – Raw Data Generation

The project begins by generating synthetic e-commerce datasets to simulate a real-world transactional system.

The generated datasets include:

* Customers
* Products
* Orders
* Order Items

The datasets intentionally contain data quality issues such as:

* Missing values
* Invalid email addresses
* Duplicate records
* Inconsistent date formats
* Missing customer references
* Invalid discounts
* Negative and zero quantities
* Invalid order references

These issues are introduced to demonstrate data cleaning and validation techniques in later stages.

Output:

* Raw CSV files stored in `data/raw/`

---

## Step 2 – Data Cleaning

The raw datasets are cleaned using `clean_data.py`.

Cleaning operations include:

* Removing duplicate records
* Standardizing customer and product names
* Handling missing values
* Standardizing date formats
* Validating email addresses
* Replacing missing customer references
* Removing records with negative quantities
* Detecting invalid discounts
* Generating a cleaning report

Output:

* Cleaned CSV files
* `cleaning_report.md`

---

## Step 3 – Database Loading

The cleaned datasets are loaded into SQLite using `load_data.py`.

The loading process includes:

* Creating database tables
* Applying primary keys
* Applying foreign keys
* Applying CHECK constraints
* Validating referential integrity
* Rejecting invalid records before insertion

Output:

* `ecommerce.db`
* `rejected_order_items.csv`

---

## Step 4 – SQL Analytics

Analytical SQL queries are executed to generate business insights using joins, aggregations, window functions, Common Table Expressions (CTEs), and cohort analysis.

---

## Step 5 – Python Reporting

The report generator connects to the SQLite database and produces analytical reports for a user-specified date range.

The report includes:

* Total orders
* Total revenue
* Unique customers
* Top 3 products
* Comparison with the previous period

---

## Step 6 – Export Query Results

All SQL query outputs are exported as CSV files for validation and reporting.

Output:

* `output/sample_reports/`

---

## Step 7 – Edge Case Testing

The project includes automated test cases to validate important edge cases, including:

* Invalid order references
* Invalid discount values
* Zero quantity records
* Future order dates


`test_cases.py` validates important edge cases such as:

* Invalid order references
* Invalid discount values
* Zero quantity records
* Future order dates

---

# How to Run

## 1. Install Dependencies

```
pip install -r requirements.txt
```

---

## 2. Clean the Data

```
python scripts/clean_data.py
```

---

## 3. Load the Database

```
python scripts/load_data.py
```

---

## 4. Run Test Cases

```
python scripts/test_cases.py
```

---

## 5. Generate Report

```
python scripts/report_generator.py
```

---

## 6. Export SQL Query Results

```
python scripts/export_query_results.py
```

---

# Outputs

The project generates the following outputs:

* Cleaned CSV datasets
* Cleaning report
* SQLite database
* Rejected records report
* SQL query result CSV files
* Command-line summary report

---

# Learning Outcomes

This project demonstrates practical implementation of:

* ETL pipeline development
* Data cleaning and validation
* SQLite database design
* SQL joins and aggregations
* Window functions
* Common Table Expressions (CTEs)
* Cohort analysis
* Data integrity checks
* Python and SQL integration
* Report generation
* Edge case handling

---

# Author

Raj Chaudhary

Celebal Excelence Internship – Week 8 Mini Project
