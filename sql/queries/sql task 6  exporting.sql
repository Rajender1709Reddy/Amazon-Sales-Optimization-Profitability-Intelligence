-- SQL export 
USE project_sql;
--  net revenue  kpi 
SELECT
    ROUND(
        SUM(
            CASE
                WHEN status IN ('Shipped','Delivered')
                THEN amount
                ELSE 0
            END
        ),2
    ) AS net_revenue
FROM amazon_sales_db;

-- gross revenue 
SELECT ROUND(SUM(amount),2) AS gross_revenue
FROM amazon_sales_db;

-- cancelled revenue 
SELECT
    ROUND(
        SUM(
            CASE
                WHEN status='Cancelled'
                THEN amount
                ELSE 0
            END
        ),2
    ) AS cancelled_revenue
FROM amazon_sales_db;

-- net revenue summary 
SELECT
COUNT(*) AS total_orders,
ROUND(SUM(amount),2) AS gross_revenue,
ROUND(
SUM(
CASE
WHEN status='Cancelled'
THEN amount
ELSE 0
END
),2) AS cancelled_revenue,

ROUND(
SUM(
CASE
WHEN status IN ('Shipped','Delivered')
THEN amount
ELSE 0
END
),2) AS net_revenue
FROM amazon_sales_db;

-- revenue by state 
SELECT ship_state,
COUNT(*) AS total_orders,
ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY ship_state
ORDER BY total_revenue DESC;

 -- revenue by category 
 SELECT
category,
COUNT(*) AS total_orders,
ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY category
ORDER BY total_revenue DESC;

-- revenue by fulfillment 
SELECT
fulfilment,
COUNT(*) AS total_orders,
ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY fulfilment;

SELECT *
FROM amazon_sales_db;

SELECT COUNT(*) AS total_rows
FROM amazon_sales_db;

SELECT *
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/amazon_sales_sql.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM amazon_sales_db;