WITH category_performance AS (
    SELECT 
        c.category_name,
        CASE 
            WHEN p.unit_price < 20 THEN '1. Below $20'
            WHEN p.unit_price BETWEEN 20 AND 50 THEN '2. $20 - $50'
            ELSE '3. Over $50'
        END AS price_range,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_amount,
        COUNT(DISTINCT od.order_id) AS volume_of_orders
    FROM 
        categories c
    JOIN 
        products p ON c.category_id = p.category_id
    JOIN 
        order_details od ON p.product_id = od.product_id
    GROUP BY 
        c.category_name, price_range
)
SELECT 
    category_name,
    price_range,
    ROUND(total_amount)::integer AS total_amount,
    volume_of_orders
FROM 
    category_performance
ORDER BY 
    category_name ASC, price_range ASC;