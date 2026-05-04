WITH employee_sales_by_category AS (
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        c.category_name,
        SUM(od.unit_price * od.quantity) AS total_sales_incl_discount
    FROM 
        employees e
    JOIN 
        orders o ON e.employee_id = o.employee_id
    JOIN 
        order_details od ON o.order_id = od.order_id
    JOIN 
        products p ON od.product_id = p.product_id
    JOIN 
        categories c ON p.category_id = c.category_id
    GROUP BY 
        e.employee_id, e.first_name, e.last_name, c.category_name
),
employee_total_sales AS (
    SELECT 
        e.employee_id,
        SUM(od.unit_price * od.quantity) AS total_sales_all_categories
    FROM 
        employees e
    JOIN 
        orders o ON e.employee_id = o.employee_id
    JOIN 
        order_details od ON o.order_id = od.order_id
    GROUP BY 
        e.employee_id
),
category_total_sales AS (
    SELECT
        c.category_name,
        SUM(od.unit_price * od.quantity) AS total_sales_by_category
    FROM 
        order_details od
    JOIN 
        products p ON od.product_id = p.product_id
    JOIN 
        categories c ON p.category_id = c.category_id
    GROUP BY
        c.category_name
)
SELECT 
    esc.category_name,
    esc.full_name,
    ROUND(esc.total_sales_incl_discount::numeric, 2) AS total_sales_incl_discount,
    ROUND((esc.total_sales_incl_discount / ets.total_sales_all_categories * 100)::numeric, 5) AS pct_of_employee_sales,
    ROUND((esc.total_sales_incl_discount / cts.total_sales_by_category * 100)::numeric, 5) AS pct_of_category_sales
FROM 
    employee_sales_by_category esc
JOIN 
    employee_total_sales ets ON esc.employee_id = ets.employee_id
JOIN 
    category_total_sales cts ON esc.category_name = cts.category_name
ORDER BY 
    esc.category_name ASC,
    esc.total_sales_incl_discount DESC;
