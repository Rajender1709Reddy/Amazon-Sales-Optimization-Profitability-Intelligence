-- Day 6 amazon sales optimization & profitability Intelligence 

USE project_sql;
-- aggregate qty and amount 

SELECT
    ship_state,
    SUM(qty) AS total_quantity,
    ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY ship_state
ORDER BY total_revenue DESC;

-- aggregate orders ,qty and revenue by state 
SELECT
    ship_state,
    COUNT(*) AS total_orders,
    SUM(qty) AS total_quantity,
    ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY ship_state
ORDER BY total_orders DESC;

-- top 5 ststes with highest shipping density 
SELECT
    ship_state,
    COUNT(*) AS shipping_density,
    SUM(qty) AS total_quantity,
    ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY ship_state
ORDER BY shipping_density DESC
LIMIT 5


SELECT
    ship_state,
    ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY ship_state
ORDER BY total_revenue DESC
LIMIT 5;

-- grographical clusters with high fulfillment
SELECT
    ship_state,
    COUNT(*) AS total_orders,
    SUM(qty) AS total_quantity,
    ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY ship_state
HAVING COUNT(*) > 1000
ORDER BY total_orders DESC;

-- fullfilemnt volume by state 
SELECT
    ship_state,
    fulfilment,
    COUNT(*) AS total_orders,
    SUM(qty) AS total_quantity,
    ROUND(SUM(amount),2) AS total_revenue
FROM amazon_sales_db
GROUP BY ship_state, fulfilment
ORDER BY ship_state, total_revenue DESC;

-- create view 
CREATE OR REPLACE VIEW vw_regional_market_density AS
SELECT
    ship_state,
    COUNT(*) AS total_orders,
    SUM(qty) AS total_quantity,
    ROUND(SUM(amount),2) AS total_revenue,
    ROUND(AVG(amount),2) AS average_order_value
FROM amazon_sales_db
GROUP BY ship_state;


SELECT *
FROM vw_regional_market_density
ORDER BY total_revenue DESC;