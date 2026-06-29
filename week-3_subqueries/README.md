# Week 3 Assignment – SQL Analysis using Subqueries, CTEs & Window Functions

## Overview

This project is part of the **Celebal Excellence Internship (CEI) – Week 3 Assignment**. The objective is to analyze the **Superstore Sales Dataset** using advanced SQL concepts such as **Subqueries**, **Common Table Expressions (CTEs)**, and **Window Functions**.

---

## Dataset

The Superstore dataset was imported into a raw table:

* `superstore_raw`

It was then normalized into three tables:

* `customers`
* `orders`
* `products`

Data was inserted into these tables using `SELECT DISTINCT`.

---

## Tasks Performed

* Created normalized tables from the raw dataset.
* Used **Subqueries** to analyze sales and customer orders.
* Used **CTEs** to calculate customer-wise total sales and identify above-average customers.
* Applied **Window Functions** (`ROW_NUMBER()`, `RANK()`) for ranking and partitioning data.
* Combined **JOIN + CTE + Window Functions** to generate customer sales insights.

---

## Mini Project

Performed customer sales analysis to answer:

* Top 5 customers
* Bottom 5 customers
* Customers with only one order
* Customers with above-average sales
* Highest order value per customer

---

## SQL Concepts Used

* Joins
* Subqueries
* Correlated Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* `ROW_NUMBER()`
* `RANK()`
* `PARTITION BY`
* Aggregate Functions

---

## Tools

* MySql Workbench

---

## Author

**Raj Chaudhary**
Celebal Excellence Internship (CEI)
