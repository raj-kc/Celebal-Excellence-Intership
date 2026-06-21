-- ShopEase E-Commerce Database
-- Section A: SQL Basics (SELECT, Constraints, Primary Keys)


-- Q1. Display all columns and rows from the customers table.
SELECT *
FROM customers;


-- Q2. Retrieve only first_name, last_name, and city of all customers.
SELECT first_name, last_name, city
FROM customers;


-- Q3. List all unique categories available in the products table.
SELECT DISTINCT category
FROM products;


-- Q4. Identify the Primary Key of each table. Explain why a
--     Primary Key must be unique and NOT NULL.
/*
Primary Keys in this schema:
customers -> customer_id
products -> product_id
orders -> order_id
order_items -> item_id

Why a Primary Key must be UNIQUE:
A Primary Key is the value used to identify exactly one row in a
table. If duplicate values were allowed, the database (and any
query, JOIN, or FOREIGN KEY referencing that key) would no longer
be able to tell which specific row is being referred to. For
example, if two rows in `customers` shared customer_id = 101, a
JOIN from `orders` on customer_id = 101 would incorrectly match
both rows, producing duplicated/incorrect results.

Why a Primary Key must be NOT NULL:
NULL means "unknown value." If a Primary Key could be NULL, it
would no longer guarantee a way to uniquely locate that row,
since NULL is not comparable to anything (NULL = NULL is not
TRUE in SQL). Every row must have a definite, known identity for
relationships (Foreign Keys) and lookups to work reliably.

Together, "UNIQUE + NOT NULL" is what allows a Primary Key to serve
as a stable, reliable identifier referenced safely from other
tables via Foreign Keys.
*/



/*
Q5. What constraints are applied to the email column in the
customers table? What would happen if you tried to insert
a duplicate email?

Constraints on `email`:
VARCHAR(100) -> data type / max length
UNIQUE -> no two rows can have the same email value
NOT NULL -> every customer must have an email on record

If you tried to insert a duplicate email, e.g.:

INSERT INTO customers VALUES
(199, 'Test', 'User', 'aarav.s@email.com', 'Pune', 'Maharashtra', '2024-09-01', FALSE);

(note: 'aarav.s@email.com' already belongs to customer_id 101)

The database engine rejects the INSERT and raises a UNIQUE
constraint violation error. The row is NOT inserted.

Actual error observed when tested:
Error: UNIQUE constraint failed: customers.email

(MySQL would report something equivalent, e.g.:
ERROR 1062 (23000): Duplicate entry 'aarav.s@email.com' for key 'customers.email')
*/



-- Q6. Try inserting a product with unit_price = -50.
-- What happens and which constraint prevents it?

-- INSERT statement attempted:
INSERT INTO products (product_id, product_name, category, brand, unit_price, stock_qty)
VALUES (299, 'Bad Product', 'Electronics', 'Test', -50.00, 10);

/*
Explanation:
The `unit_price` column has the constraint: CHECK (unit_price > 0)
Since -50.00 is not greater than 0, this CHECK constraint is
violated and the database rejects the INSERT entirely — no row
is added to the products table.

Actual error observed when tested:
Error: CHECK constraint failed: unit_price > 0

(MySQL 8.0+ would report something equivalent, e.g.:
ERROR 3819 (HY000): Check constraint 'products_chk_1' is violated.)
*/
