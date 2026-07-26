# Delta Lake Incremental Data Processing Assignment

## Overview

This project demonstrates incremental data processing using **Delta Lake** in **Databricks**. The assignment includes loading data into a Delta table, performing data cleaning, creating an incremental dataset, applying the Delta Lake MERGE operation, validating the results, and displaying the final dataset.

---

## Objective

Perform incremental data processing using Delta Lake by:

- Loading CSV data into a Delta table
- Cleaning the data
- Creating an incremental dataset
- Applying the MERGE operation
- Validating the processed data
- Displaying the final dataset

---

## Technologies Used

- Databricks
- Apache Spark (PySpark)
- Delta Lake
- CSV Files

---

## Project Structure

```
delta-lake-assignment/
│
├── data/
│   ├── customer_master.csv
│   └── customer_incremental.csv
│
├── notebooks/
│   └── delta_scd_assignment.ipynb
│
├── screenshots/
│   ├── data_loading/
│   ├── data_cleaning/
│   ├── scd1/
│   ├── scd2/
│   ├── validation/
│   └── final_output/
│
├── report/
│   └── assignment_summary.pdf
│
└── README.md
```

---

## Workflow

1. Read the customer CSV dataset.
2. Create a Delta table.
3. Perform data cleaning.
4. Save cleaned data.
5. Create an incremental dataset.
6. Create an incremental Delta table.
7. Merge the incremental Delta table into the customer Delta table.
8. Validate the results.
9. Display the final dataset.

---

## Delta Lake Features Used

- Delta Tables
- ACID Transactions
- MERGE INTO
- Data Versioning
- Incremental Processing

---

## Output

The final output demonstrates:

- Updated customer records
- Newly inserted customer records
- Duplicate-free data
- Successful incremental processing using Delta Lake

---

## Repository Contents

- Source datasets
- Databricks notebook
- Assignment screenshots
- Assignment summary report
- Project documentation

---

## Author

**Raj Chaudhary**

Data Engineering Internship Assignment