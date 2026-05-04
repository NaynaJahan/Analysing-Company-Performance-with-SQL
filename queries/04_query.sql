SELECT 
    TO_CHAR(DATE_TRUNC('month', order_date), 'YYYY-MM-DD') AS year_month,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(freight)) AS total_freight
FROM 
    orders
WHERE 
    order_date BETWEEN '1997-01-01' AND '1998-12-31'
GROUP BY 
    DATE_TRUNC('month', order_date)
HAVING 
    COUNT(order_id) > 35
ORDER BY 
    total_freight DESC;