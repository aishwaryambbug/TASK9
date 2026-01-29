CREATE DATABASE task9_star_schema;
USE task9_star_schema;
CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);

CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(30),
    product_name VARCHAR(150),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

CREATE TABLE dim_region (
    region_key INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(50),
    region VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20)
);

CREATE TABLE dim_date (
    date_key INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(15),
    day INT,
    weekday VARCHAR(15)
);
INSERT INTO dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT `Customer ID`, `Customer Name`, Segment
FROM globalsuperstore;

INSERT INTO dim_product (product_id, product_name, category, sub_category)
SELECT DISTINCT `Product ID`, `Product Name`, Category, `Sub-Category`
FROM globalsuperstore;

INSERT INTO dim_region (country, region, state, city, postal_code)
SELECT DISTINCT Country, Region, State, City, `Postal Code`
FROM globalsuperstore;

INSERT INTO dim_date (order_date, year, quarter, month, month_name, day, weekday)
SELECT DISTINCT 
    STR_TO_DATE(`Order Date`, '%d-%m-%Y'),
    YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    QUARTER(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    MONTHNAME(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    DAY(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    DAYNAME(STR_TO_DATE(`Order Date`, '%d-%m-%Y'))
FROM globalsuperstore;
USE task9_star_schema;
CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);
INSERT INTO dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT `Customer ID`, `Customer Name`, Segment
FROM globalsuperstore;
SHOW TABLES;
INSERT INTO dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT `Customer ID`, `Customer Name`, Segment
FROM Global_Superstore(CSV)
RENAME TABLE `Global_Superstore(CSV)` TO globalsuperstore;
RENAME TABLE `global_superstore(csv) (2)` TO globalsuperstore;
INSERT INTO dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT `Customer ID`, `Customer Name`, Segment
FROM globalsuperstore;
INSERT INTO dim_product (product_id, product_name, category, sub_category)
SELECT DISTINCT `Product ID`, `Product Name`, Category, `Sub-Category`
FROM globalsuperstore;
INSERT INTO dim_region (country, region, state, city, postal_code)
SELECT DISTINCT Country, Region, State, City, `Postal Code`
FROM globalsuperstore;
INSERT INTO dim_date (order_date, year, quarter, month, month_name, day, weekday)
SELECT DISTINCT 
    STR_TO_DATE(`Order Date`, '%d-%m-%Y'),
    YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    QUARTER(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    MONTHNAME(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    DAY(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    DAYNAME(STR_TO_DATE(`Order Date`, '%d-%m-%Y'))
FROM globalsuperstore;
INSERT INTO dim_date (order_date, year, quarter, month, month_name, day, weekday)
SELECT DISTINCT 
    STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
    YEAR(STR_TO_DATE(`Order Date`, '%m/%d/%Y')),
    QUARTER(STR_TO_DATE(`Order Date`, '%m/%d/%Y')),
    MONTH(STR_TO_DATE(`Order Date`, '%m/%d/%Y')),
    MONTHNAME(STR_TO_DATE(`Order Date`, '%m/%d/%Y')),
    DAY(STR_TO_DATE(`Order Date`, '%m/%d/%Y')),
    DAYNAME(STR_TO_DATE(`Order Date`, '%m/%d/%Y'))
FROM globalsuperstore;
INSERT INTO fact_sales (
    row_id, order_id, customer_key, product_key, region_key, date_key,
    sales, quantity, discount, profit
)
SELECT 
    g.`Row ID`,
    g.`Order ID`,
    c.customer_key,
    p.product_key,
    r.region_key,
    d.date_key,
    g.Sales,
    g.Quantity,
    g.Discount,
    g.Profit
FROM globalsuperstore g
JOIN dim_customer c ON g.`Customer ID` = c.customer_id
JOIN dim_product p ON g.`Product ID` = p.product_id
JOIN dim_region r 
  ON g.Country = r.country
 AND g.Region = r.region
 AND g.State = r.state
 AND g.City = r.city
JOIN dim_date d 
  ON STR_TO_DATE(g.`Order Date`, '%d-%m-%Y') = d.order_date;



CREATE TABLE fact_sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,
    row_id INT,
    order_id VARCHAR(20),
    customer_key INT,
    product_key INT,
    region_key INT,
    date_key INT,
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),

    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (region_key) REFERENCES dim_region(region_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);
INSERT INTO fact_sales (
    row_id, order_id, customer_key, product_key, region_key, date_key,
    sales, quantity, discount, profit
)
SELECT 
    g.`Row ID`,
    g.`Order ID`,
    c.customer_key,
    p.product_key,
    r.region_key,
    d.date_key,
    g.Sales,
    g.Quantity,
    g.Discount,
    g.Profit
FROM globalsuperstore g
JOIN dim_customer c ON g.`Customer ID` = c.customer_id
JOIN dim_product p ON g.`Product ID` = p.product_id
JOIN dim_region r 
  ON g.Country = r.country
 AND g.Region = r.region
 AND g.State = r.state
 AND g.City = r.city
JOIN dim_date d 
  ON STR_TO_DATE(g.`Order Date`, '%m/%d/%Y') = d.order_date;


DESCRIBE globalsuperstore;
INSERT INTO fact_sales (
    row_id, order_id, customer_key, product_key, region_key, date_key,
    sales, quantity, discount, profit
)
SELECT 
    g.Row_ID,
    g.`Order ID`,
    c.customer_key,
    p.product_key,
    r.region_key,
    d.date_key,
    g.Sales,
    g.Quantity,
    g.Discount,
    g.Profit
FROM globalsuperstore g
JOIN dim_customer c ON g.`Customer ID` = c.customer_id
JOIN dim_product p ON g.`Product ID` = p.product_id
JOIN dim_region r 
  ON g.Country = r.country
 AND g.Region = r.region
 AND g.State = r.state
 AND g.City = r.city
JOIN dim_date d 
  ON STR_TO_DATE(g.`Order Date`, '%m/%d/%Y') = d.order_date;


DROP TABLE IF EXISTS fact_sales;

CREATE TABLE fact_sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(20),
    customer_key INT,
    product_key INT,
    region_key INT,
    date_key INT,
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (region_key) REFERENCES dim_region(region_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);
INSERT INTO fact_sales (
    order_id, customer_key, product_key, region_key, date_key,
    sales, quantity, discount, profit
)
SELECT 
    g.`Order ID`,
    c.customer_key,
    p.product_key,
    r.region_key,
    d.date_key,
    g.Sales,
    g.Quantity,
    g.Discount,
    g.Profit
FROM globalsuperstore g
JOIN dim_customer c ON g.`Customer ID` = c.customer_id
JOIN dim_product p ON g.`Product ID` = p.product_id
JOIN dim_region r 
  ON g.Country = r.country
 AND g.Region = r.region
 AND g.State = r.state
 AND g.City = r.city
JOIN dim_date d 
  ON STR_TO_DATE(g.`Order Date`, '%m/%d/%Y') = d.order_date;
ALTER TABLE fact_sales 
MODIFY order_id VARCHAR(50);
INSERT INTO fact_sales (
    order_id, customer_key, product_key, region_key, date_key,
    sales, quantity, discount, profit
)
SELECT 
    g.`Order ID`,
    c.customer_key,
    p.product_key,
    r.region_key,
    d.date_key,
    g.Sales,
    g.Quantity,
    g.Discount,
    g.Profit
FROM globalsuperstore g
JOIN dim_customer c ON g.`Customer ID` = c.customer_id
JOIN dim_product p ON g.`Product ID` = p.product_id
JOIN dim_region r 
  ON g.Country = r.country
 AND g.Region = r.region
 AND g.State = r.state
 AND g.City = r.city
JOIN dim_date d 
  ON STR_TO_DATE(g.`Order Date`, '%m/%d/%Y') = d.order_date;
SELECT COUNT(*) FROM fact_sales;
SELECT COUNT(*) AS fact_rows FROM fact_sales;
SELECT COUNT(*) 
FROM Sales_Fact f
LEFT JOIN Customer_Dim c ON f.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;
-- Product
SELECT COUNT(*)
FROM Sales_Fact f
LEFT JOIN Product_Dim p ON f.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- Region
SELECT COUNT(*)
FROM Sales_Fact f
LEFT JOIN Region_Dim r ON f.RegionID = r.RegionID
WHERE r.RegionID IS NULL;

-- Date
SELECT COUNT(*)
FROM Sales_Fact f
LEFT JOIN Date_Dim d ON f.OrderDateID = d.DateID
WHERE d.DateID IS NULL;


