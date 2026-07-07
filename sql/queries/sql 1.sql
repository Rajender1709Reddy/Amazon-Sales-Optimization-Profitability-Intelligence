-- Enable LOCAL INFILE (run once if needed)
SET GLOBAL local_infile = 1;

-- Select database
USE project_sql;

-- Drop existing table
DROP TABLE IF EXISTS amazon_sales_db;

-- Create table
CREATE TABLE amazon_sales_db (
    idx INT,
    order_id VARCHAR(50),
    order_date VARCHAR(20),
    status VARCHAR(100),
    fulfilment VARCHAR(50),
    sales_channel VARCHAR(50),
    ship_service_level VARCHAR(50),
    style VARCHAR(100),
    sku VARCHAR(100),
    category VARCHAR(100),
    size VARCHAR(20),
    asin VARCHAR(30),
    courier_status VARCHAR(50),
    qty INT,
    currency VARCHAR(10),
    amount DECIMAL(10,2),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50),
    promotion_ids TEXT,
    b2b BOOLEAN,
    fulfilled_by VARCHAR(50),
    unnamed_22 VARCHAR(50)
);

-- Load CSV
LOAD DATA LOCAL INFILE
'C:/Users/YourName/Desktop/Amazon_Sales_Cleaned.csv'
INTO TABLE amazon_sales_db
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
idx,
order_id,
@order_date,
status,
fulfilment,
sales_channel,
ship_service_level,
style,
sku,
category,
size,
asin,
courier_status,
qty,
currency,
amount,
ship_city,
ship_state,
ship_postal_code,
ship_country,
promotion_ids,
b2b,
fulfilled_by,
unnamed_22
)
SET order_date = @order_date;

-- Check total rows
SELECT COUNT(*) AS total_rows
FROM amazon_sales_db;

-- Preview data
SELECT *
FROM amazon_sales_db
LIMIT 10;