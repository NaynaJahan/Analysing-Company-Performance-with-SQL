WITH price_history AS (
    SELECT
        od.product_id,
        MIN(od.unit_price) AS initial_unit_price,
        MAX(od.unit_price) AS current_unit_price
    FROM 
        order_details od
    GROUP BY 
        od.product_id
)
SELECT 
    p.product_name,
    ROUND(CAST(ph.current_unit_price AS numeric), 2) AS current_unit_price,
    ROUND(CAST(ph.initial_unit_price AS numeric), 2) AS initial_unit_price,
    ROUND((CAST(ph.current_unit_price AS numeric) - CAST(ph.initial_unit_price AS numeric)) / CAST(ph.initial_unit_price AS numeric) * 100) AS percentage_increase
FROM 
    price_history ph
JOIN 
    products p ON p.product_id = ph.product_id
WHERE 
    ROUND((CAST(ph.current_unit_price AS numeric) - CAST(ph.initial_unit_price AS numeric)) / CAST(ph.initial_unit_price AS numeric) * 100) NOT BETWEEN 20 AND 30
ORDER BY 
    percentage_increase ASC;