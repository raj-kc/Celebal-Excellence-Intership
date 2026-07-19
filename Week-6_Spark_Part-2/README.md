# Apache Spark Assignment – Week 6

## Assignment Overview

This repository contains the solutions for the **Week 6 Apache Spark Assignment** completed as part of the **Data Engineering Internship at Celebal Technologies**.

The notebook includes both theoretical explanations and practical PySpark implementations covering Spark architecture, DataFrame operations, file handling, optimization techniques, and distributed data processing concepts.

---

## Folder Structure

```
Week6_Spark_Part-2/
│
├── data/
│   ├── input/
│   │   └── source.parquet
│   │
│   ├── output/
│   │   ├── part-00000-xxxxxxxx.csv
│   │   └── _SUCCESS
│   │
│   └── source.csv
│
├── Week6_Assignment.ipynb
└── README.md
```

---

## Topics Covered

### Spark Architecture
- Driver
- Cluster Manager
- Executor
- Client Mode vs Cluster Mode

### Spark Fundamentals
- Lazy Evaluation
- Transformations and Actions
- Lineage Graph (DAG)
- Fault Tolerance

### File Handling
- Reading CSV Files
- Reading Parquet Files
- Writing CSV Files
- CSV vs Parquet
- Predicate Pushdown

### DataFrame Operations
- Filtering Data
- Selecting Columns
- Renaming Columns
- Type Casting
- Creating New Columns

### Performance Optimization
- `.show()` vs `.collect()`
- Efficient Data Loading

---


## Dataset source.csv

The practical examples are based on a dataset containing the following columns:

- `order_id`
- `product_id`
- `product_name`
- `category`
- `price`
- `quantity`
- `discount_percent`
- `region`
- `status`
- `customer_name`
- `order_date`

Some assignment questions referenced columns such as **amount**, **priority**, **base_price**, **old_name**, and **user_id**, which were not present in the dataset. Appropriate equivalent columns were used wherever applicable, and explanatory notes have been included in the notebook.

---

## Technologies Used

- Python
- Apache Spark (PySpark)
- Jupyter Notebook

---

## Learning Outcomes

By completing this assignment, I gained practical experience with:

- Spark Architecture
- Lazy Evaluation
- Transformations and Actions
- Lineage Graph (DAG)
- Fault Tolerance
- CSV and Parquet File Formats
- Predicate Pushdown
- Spark DataFrame Operations
- Reading and Writing Data
- Spark Performance Optimization

---

## Conclusion

This assignment provided hands-on experience with Apache Spark and PySpark by combining theoretical concepts with practical implementations. It strengthened my understanding of distributed data processing, Spark optimizations, and DataFrame-based data analysis.