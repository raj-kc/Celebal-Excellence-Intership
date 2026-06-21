# ShopEase E-Commerce Sales Database
### Celebal Summer Internship 2026 — Week 2 Task

## Overview

This repository contains the schema, sample data, and SQL solutions for the
Week 2 task: analyzing sales, customer behavior, and product performance for
**ShopEase**, a mid-sized e-commerce company.

The database models four related entities:

```
customers ──(1:N)──▶ orders ──(1:N)──▶ order_items ◀──(N:1)── products
```

## Folder Structure

```
sql-assignment/
│── schema/
│   ├── 00_create_database.sql    -- CREATE DATABASE / USE statement
│   ├── 01_create_tables.sql      -- CREATE TABLE statements (PK/FK/CHECK constraints)
│   ├── 02_create_indexes.sql     -- CREATE INDEX statements
│   └── 03_insert_data.sql        -- Sample data INSERTs
│── Section_A/
│   └── basic_queries.sql         -- Q1–Q6: SELECT basics, constraints, PKs
│── Section_B/
│   └── filtering_queries.sql     -- Q7–Q12: WHERE filtering, indexing, SARGability
│── Section_C/
│   └── aggregation_queries.sql   -- Q13–Q18: GROUP BY, SUM/COUNT/AVG/MIN/MAX, HAVING
│── Section_D/
│   └── joins_queries.sql         -- Q19–Q23: INNER/LEFT/RIGHT/FULL joins, FKs
│── Section_E/
│   └── advanced_queries.sql      -- Q24–Q27: CASE, ACID, transactions
│── README.md
```

## How to Run

This was developed and tested in **MySQL Workbench**.

1. Open MySQL Workbench and connect to your local MySQL server instance.
2. Open `schema/00_create_database.sql` (File → Open SQL Script) and execute it
   (the lightning bolt icon, or Ctrl+Shift+Enter) to create and select the
   `shopease_db` database.
3. In the schema sidebar, right-click and refresh, then double-click
   `shopease_db` to set it as your active schema.
4. Open and execute, in order:
   - `schema/01_create_tables.sql`
   - `schema/02_create_indexes.sql`
   - `schema/03_insert_data.sql`
5. Open any `Section_X/*.sql` file and execute the queries to see results in
   the Result Grid at the bottom of the editor.

## Verification Note

Every query in this repository was executed and verified against the sample
dataset in **MySQL Workbench** before being included here — including the
constraint violations in Section A (Q5, Q6), the foreign key violation in
Section D (Q23), and the full commit/rollback transaction in Section E
(Q27). Expected results are noted as comments directly beneath each query.

## Section Summary

| Section | Topic | Questions |
|---|---|---|
| A | SQL Basics — SELECT, Constraints, Primary Keys | Q1–Q6 |
| B | Filtering & Optimization — WHERE, Indexes | Q7–Q12 |
| C | Aggregation — GROUP BY, SUM, COUNT, AVG, MIN, MAX | Q13–Q18 |
| D | Joins & Relationships | Q19–Q23 |
| E | Advanced Concepts — CASE, ACID, Transactions | Q24–Q27 |

## Author

Raj Chaudhary
