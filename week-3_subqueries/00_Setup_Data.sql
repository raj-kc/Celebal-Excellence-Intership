-- WEEK-3(Subqueries)
-- Step 1: Setup Data
-- creating database
use superstore_db;


-- Import the Superstore dataset into a table named superstore_raw. 
CREATE TABLE `superstore_raw` (
  `Row ID` int DEFAULT NULL,
  `Order ID` text,
  `Order Date` text,
  `Ship Date` text,
  `Ship Mode` text,
  `Customer ID` text,
  `Customer Name` text,
  `Segment` text,
  `Country` text,
  `City` text,
  `State` text,
  `Postal Code` int DEFAULT NULL,
  `Region` text,
  `Product ID` text,
  `Category` text,
  `Sub-Category` text,
  `Product Name` text,
  `Sales` double DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Discount` double DEFAULT NULL,
  `Profit` double DEFAULT NULL
);

-- load data from csv file to superstore_raw table

LOAD DATA INFILE "C:\Users\RAJ\Celebal-Excellence-Internship\week-3_subqueries\Sample - Superstore.csv"
INTO TABLE superstore_raw 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES;

-- load data through MySQL Workbench Visual Wizard
-- 1. Right-click  'superstore_raw' table in the left Schemas panel.
-- 2. Click 'Table Data Import Wizard'.
-- 3. Click 'Browse...', select your CSV file, and click 'Next'.
-- 4. Choose 'Use existing table' (superstore_raw) and click 'Next'.
-- 5. Set Encoding to 'utf8', check that column names line up, and click 'Next'.
-- 6. Click 'Next' to run the import, wait for it to load, then click 'Finish'.


-- verify that all records are inserted
select * from superstore_raw;


-- Create Customer table
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);

-- insert records
INSERT INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT
       `Customer ID`,
       `Customer Name`,
       Segment
FROM superstore_raw;

-- create products table
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Automatically generates 1, 2, 3...
    excel_product_id VARCHAR(15),
    product_name VARCHAR(150),
    category VARCHAR(30),
    sub_category VARCHAR(20)
);

-- insert records into product table
INSERT INTO product (excel_product_id, product_name, category, sub_category)
SELECT DISTINCT 
    `Product ID`, 
    `Product Name`, 
    `Category`, 
    `Sub-Category`
FROM superstore_raw;


-- create orders table 
CREATE TABLE orders (
    row_id INT PRIMARY KEY, -- Preserves the original Excel row index
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    product_id_fk INT, -- Links to our clean product auto-increment ID
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(100),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id_fk) REFERENCES product(id)
);


-- insert records into orders table
INSERT INTO orders (
    row_id, order_id, order_date, ship_date, ship_mode, 
    customer_id, product_id_fk, 
    country, city, state, postal_code, region,
    sales, quantity, discount, profit
)
SELECT 
    r.`Row ID`,
    r.`Order ID`, 
    STR_TO_DATE(r.`Order Date`, '%m/%d/%Y'), -- Safeguard against text dates
    STR_TO_DATE(r.`Ship Date`, '%m/%d/%Y'),  -- Safeguard against text dates
    r.`Ship Mode`,
    r.`Customer ID`, 
    p.id, -- Fetches the correct database integer key
    r.`Country`, 
    r.`City`, 
    r.`State`, 
    r.`Postal Code`, 
    r.`Region`,
    r.`Sales`, 
    r.`Quantity`, 
    r.`Discount`, 
    r.`Profit`
FROM superstore_raw r
INNER JOIN product p 
  ON r.`Product ID` = p.excel_product_id 
  AND r.`Product Name` = p.product_name; -- Perfect tie-breaker join    


-- verify that all records are inserted successfully without any loss
SELECT 
    CASE 
        WHEN COUNT(*) = (SELECT COUNT(*) FROM superstore_raw) THEN 'TRUE: All rows match perfectly (Decimal truncation accounted for)!'
        ELSE 'FALSE: Discrepancy still found!'
    END AS verification_result
FROM superstore_raw r
INNER JOIN orders o    ON r.`Row ID` = o.row_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN product p   ON o.product_id_fk = p.id
WHERE r.`Order ID` = o.order_id
  AND STR_TO_DATE(r.`Order Date`, '%m/%d/%Y') = o.order_date
  AND r.`Customer Name` = c.customer_name
  AND r.`Product Name` = p.product_name
  -- Variance Test: Checks if the difference is less than 1 cent ($0.01)
  AND ABS(CAST(r.`Sales` AS DECIMAL(10,4)) - o.sales) < 0.01
  AND ABS(CAST(r.`Profit` AS DECIMAL(10,4)) - o.profit) < 0.01;
