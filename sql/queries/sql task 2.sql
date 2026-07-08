USE project_sql;
SELECT DISTINCT status
FROM amazon_sales_db
ORDER BY status;

-- segment orders usin case 
SELECT
    order_id,
    status,
    amount,

    CASE
        WHEN status IN ('Shipped','Delivered') THEN 'Realized'
        WHEN status = 'Cancelled' THEN 'Lost'
        ELSE 'At Risk'
    END AS revenue_status

FROM amazon_sales_db;

--  count orders in each segment 
SELECT

CASE

WHEN status IN ('Shipped','Delivered')
THEN 'Realized Revenue'

WHEN status='Cancelled'
THEN 'Lost Revenue'

ELSE 'At Risk'

END AS revenue_status,

COUNT(*) AS total_orders

FROM amazon_sales_db

GROUP BY revenue_status;

-- calculate revenue by segment 
SELECT
CASE
WHEN status IN ('Shipped','Delivered')
THEN 'Realized Revenue'

WHEN status='Cancelled'
THEN 'Lost Revenue'

ELSE 'At Risk'

END AS revenue_status,

COUNT(*) AS orders,

SUM(amount) AS total_revenue,

AVG(amount) AS average_order_value

FROM amazon_sales_db

GROUP BY revenue_status;

-- calculate true cash flow by fulfillment 
SELECT

fulfilment,

SUM(

CASE

WHEN status IN ('Shipped','Delivered')

THEN amount

ELSE 0

END

) AS true_cash_flow

FROM amazon_sales_db

GROUP BY fulfilment;

-- revenue lost due to calculation 
SELECT

SUM(amount) AS cancelled_revenue

FROM amazon_sales_db

WHERE status='Cancelled';

-- cancellation counts 
SELECT

COUNT(*) AS cancelled_orders

FROM amazon_sales_db

WHERE status='Cancelled';

-- cancellation analysis 
SELECT

fulfilment,

COUNT(*) AS cancelled_orders,

SUM(amount) AS revenue_loss

FROM amazon_sales_db

WHERE status='Cancelled'

GROUP BY fulfilment;

-- view 

CREATE OR REPLACE VIEW vw_revenue_segmentation AS

SELECT

*,

CASE

WHEN status IN ('Shipped','Delivered')

THEN 'Realized Revenue'

WHEN status='Cancelled'

THEN 'Lost Revenue'

ELSE 'At Risk'

END AS revenue_status

FROM amazon_sales_db;

SELECT *
FROM vw_revenue_segmentation
LIMIT 10;