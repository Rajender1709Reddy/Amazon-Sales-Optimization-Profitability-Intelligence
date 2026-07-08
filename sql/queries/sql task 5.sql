--  Task 5  Loss-Making SKU Analysis using SQL CTEs
USE project_sql;
-- SKU-Region Summary
/*=========================================================
 DAY 8
 Amazon Sales Optimization & Profitability Intelligence
 Task 5 : Loss-Making SKU Analysis using SQL CTEs
=========================================================*/

USE project_sql;

-- =====================================================
-- Step 1 : SKU-Region Summary
-- =====================================================

WITH sku_region_summary AS
(
SELECT sku, ship_state,
COUNT(*) AS total_orders,
SUM(qty) AS total_quantity,
ROUND(SUM(amount),2) AS total_revenue,
SUM(
CASE
WHEN status='Cancelled'
THEN amount
ELSE 0
END
) AS cancelled_revenue,
SUM(
CASE
WHEN status='Cancelled'
THEN 1
ELSE 0
END
) AS cancelled_orders
FROM amazon_sales_db
GROUP BY sku, ship_state
)
SELECT *
FROM sku_region_summary
ORDER BY cancelled_revenue DESC;

-- create reporting table 
DROP TABLE IF EXISTS loss_making_skus;

CREATE TABLE loss_making_skus AS

WITH sku_region_summary AS
(
    SELECT
        sku,
        ship_state,
        COUNT(*) AS total_orders,
        SUM(qty) AS total_quantity,
        ROUND(SUM(amount),2) AS total_revenue,

        SUM(
            CASE
                WHEN status='Cancelled'
                THEN amount
                ELSE 0
            END
        ) AS cancelled_revenue
    FROM amazon_sales_db
    GROUP BY sku, ship_state
),
ranked_loss AS
(
    SELECT
        *,
        NTILE(100) OVER
        (
            ORDER BY cancelled_revenue DESC
        ) AS percentile_rank

    FROM sku_region_summary
)
SELECT *
FROM ranked_loss
WHERE percentile_rank <= 15;

SELECT *
FROM loss_making_skus
ORDER BY cancelled_revenue DESC;

-- Top 15% Loss-Making SKU-Region Combinations
WITH sku_region_summary AS
(
SELECT sku, ship_state,
COUNT(*) AS total_orders,
SUM(qty) AS total_quantity,
ROUND(SUM(amount),2) AS total_revenue,
SUM(
CASE
WHEN status='Cancelled'
THEN amount
ELSE 0
END
) AS cancelled_revenue
FROM amazon_sales_db
GROUP BY sku, ship_state
),
ranked_loss AS
(
SELECT *, NTILE(100) OVER
(
ORDER BY cancelled_revenue DESC
) AS percentile_rank
FROM sku_region_summary
)
SELECT * FROM ranked_loss
WHERE percentile_rank<=15
ORDER BY cancelled_revenue DESC;

-- summary table for reporting 
CREATE OR REPLACE VIEW vw_loss_making_skus AS

WITH sku_region_summary AS
(
SELECT sku, ship_state,
COUNT(*) AS total_orders,
SUM(qty) AS total_quantity,
ROUND(SUM(amount),2) AS total_revenue,
SUM(
CASE
WHEN status='Cancelled'
THEN amount
ELSE 0
END
) AS cancelled_revenue
FROM amazon_sales_db
GROUP BY sku, ship_state
),
ranked_loss AS
(
SELECT *, NTILE(100) OVER
(
ORDER BY cancelled_revenue DESC
) AS percentile_rank
FROM sku_region_summary
)
SELECT * FROM ranked_loss
WHERE percentile_rank<=15;

-- Top 20 Highest Loss-Making SKU-State Combinations
SELECT
sku, ship_state, total_orders, total_quantity, total_revenue, cancelled_revenue
FROM vw_loss_making_skus
ORDER BY cancelled_revenue DESC
LIMIT 20;

-- state wise loss summary 
SELECT ship_state,
COUNT(*) AS loss_skus,
ROUND(SUM(cancelled_revenue),2) AS total_loss
FROM vw_loss_making_skus
GROUP BY ship_state
ORDER BY total_loss DESC;

-- sku wise loss summary 
SELECT sku,
ROUND(SUM(cancelled_revenue),2) AS total_loss
FROM vw_loss_making_skus
GROUP BY sku
ORDER BY total_loss DESC
LIMIT 20;

-- performance optimization 
CREATE INDEX idx_sku
ON amazon_sales_db(sku);
CREATE INDEX idx_ship_state
ON amazon_sales_db(ship_state);
CREATE INDEX idx_status
ON amazon_sales_db(status);
CREATE INDEX idx_b2b
ON amazon_sales_db(b2b);

SHOW INDEX FROM amazon_sales_db;