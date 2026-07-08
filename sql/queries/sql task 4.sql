-- b2b vs b2c profitability audit 

USE project_sql;

-- verify b2b values 
SELECT DISTINCT b2b
FROM amazon_sales_db;

-- avg order value for b2b vs b2c 
SELECT
    b2b,
    COUNT(*) AS total_orders,
    ROUND(SUM(amount),2) AS total_revenue,
    ROUND(AVG(amount),2) AS average_order_value
FROM amazon_sales_db
GROUP BY b2b;

-- return rate % 

SELECT
    b2b,
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN status='Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_orders,

    ROUND(
        SUM(
            CASE
                WHEN status='Cancelled' THEN 1
                ELSE 0
            END
        ) *100.0 / COUNT(*),2
    ) AS return_rate_percentage

FROM amazon_sales_db

GROUP BY b2b;

-- comparative margin audit 
SELECT b2b,
COUNT(*) AS total_orders,
SUM(qty) AS total_quantity,
ROUND(SUM(amount),2) AS total_revenue,
ROUND(AVG(amount),2) AS average_order_value,
ROUND(MIN(amount),2) AS minimum_order_value,
ROUND(MAX(amount),2) AS maximum_order_value
FROM amazon_sales_db
GROUP BY b2b;

-- revenue lost through cancellation 
SELECT b2b,
ROUND(SUM(amount),2) AS revenue_lost
FROM amazon_sales_db
WHERE status='Cancelled'
GROUP BY b2b;

-- fulfilment comparision 
SELECT b2b, fulfilment,
COUNT(*) AS total_orders,
ROUND(SUM(amount),2) AS total_revenue,
ROUND(AVG(amount),2) AS average_order_value
FROM amazon_sales_db
GROUP BY b2b, fulfilment
ORDER BY b2b, total_revenue DESC;

-- create view 
CREATE OR REPLACE VIEW vw_b2b_b2c_profitability AS
SELECT b2b,
COUNT(*) AS total_orders,
SUM(qty) AS total_quantity,
ROUND(SUM(amount),2) AS total_revenue,
ROUND(AVG(amount),2) AS average_order_value,
ROUND(
SUM(
CASE
WHEN status='Cancelled'
THEN 1
ELSE 0
END
)*100/COUNT(*),2) AS return_rate_percentage
FROM amazon_sales_db
GROUP BY b2b;