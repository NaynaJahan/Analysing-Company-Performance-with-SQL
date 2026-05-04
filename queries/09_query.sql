WITH employee_sales AS (
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        e.title AS job_title,
        COUNT(DISTINCT o.order_id) AS total_unique_orders,
        COUNT(od.order_id) AS total_orders,
        ROUND(SUM(CAST(od.unit_price * od.quantity AS NUMERIC)), 2) AS total_sales_excl_discount,
        ROUND(AVG(CAST(od.unit_price * od.quantity AS NUMERIC)), 2) AS avg_product_amount_excl_discount,
        ROUND(SUM(CAST(od.unit_price * od.quantity * (1 - od.discount) AS NUMERIC)), 2) AS total_sales_incl_discount,
        ROUND(SUM(CAST(od.unit_price * od.quantity * od.discount AS NUMERIC)), 2) AS total_discount_amount
    FROM
        employees e
    JOIN orders o ON e.employee_id = o.employee_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY
        e.employee_id, full_name, e.title
)
SELECT
    full_name,
    job_title,
    total_sales_excl_discount,
    total_unique_orders,
    total_orders,
    avg_product_amount_excl_discount,
    ROUND(total_sales_excl_discount / total_unique_orders, 2) AS avg_order_amount_excl_discount,
    total_discount_amount,
    total_sales_incl_discount,
    ROUND((total_discount_amount / total_sales_excl_discount) * 100, 2) AS total_discount_percentage
FROM
    employee_sales
ORDER BY
    total_sales_incl_discount DESC;