# Week 5 – PySpark DataFrame Operations

## 📌 Overview

This assignment focuses on the fundamentals of **Apache Spark** using **PySpark DataFrames**. It covers essential DataFrame operations, data cleaning techniques, aggregation functions, schema handling, and important Spark concepts such as **In-Memory Computing**, **Shuffle**, and **Immutability**.

The assignment uses the **Superstore.csv** dataset to perform various data processing tasks and demonstrates how Spark efficiently handles large-scale data.

---

## 📂 Files Included

- `Week_5_PySpark_Assignment.ipynb` – Jupyter Notebook containing all theory answers and PySpark code.
- `Superstore.csv` – Dataset used for performing DataFrame operations.
- `README.md` – Documentation for the Week 5 assignment.

---

## 🛠 Technologies Used

- Python
- PySpark
- Apache Spark
- Jupyter Notebook

---

## 📚 Topics Covered

### Apache Spark Concepts

- MapReduce vs Apache Spark
- In-Memory Computing
- Shuffle Process
- Wide Transformations
- Spark DataFrame Immutability
- Schema Inference (`inferSchema`)
- Explicit Schema (`StructType`)

### PySpark DataFrame Operations

- Creating a Spark Session
- Reading CSV files
- Removing duplicate records
- Filtering rows
- Handling null values
- Grouping data
- Aggregation using `.agg()`
- Renaming columns
- Casting data types
- Data cleaning pipeline

---

## 🔧 PySpark Functions Used

- `spark.read.csv()`
- `dropDuplicates()`
- `filter()`
- `where()`
- `between()`
- `groupBy()`
- `agg()`
- `sum()`
- `avg()`
- `min()`
- `max()`
- `count()`
- `na.fill()`
- `na.drop()`
- `withColumnRenamed()`
- `cast()`
- `alias()`

---

## 🎯 Learning Outcomes

After completing this assignment, I learned how to:

- Work with Spark DataFrames.
- Clean and preprocess datasets.
- Handle duplicate and null values.
- Filter and aggregate data efficiently.
- Apply multiple aggregation functions.
- Understand Spark's immutable DataFrame model.
- Explain the Shuffle process and wide transformations.
- Build simple data processing pipelines using PySpark.

---

## 📖 Dataset

The assignment uses the **Superstore** dataset, which contains information such as:

- Orders
- Customers
- Products
- Categories
- Sales
- Profit
- Region
- City

Some assignment questions used sample DataFrames because the required columns (such as `status`, `email`, `username`, `raw_timestamp`, and `store_id`) were not available in the Superstore dataset.

---

## 🚀 Conclusion

This assignment strengthened my understanding of Apache Spark fundamentals and provided hands-on experience with common PySpark DataFrame operations used in data engineering and ETL pipelines.
