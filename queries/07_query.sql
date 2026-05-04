SELECT
    CASE
        WHEN s.country IN ('US', 'Brazil', 'Canada') THEN 'America'
        WHEN s.country IN ('UK', 'Germany', 'France', 'Spain', 'Italy', 'Sweden', 'Norway', 'Netherlands', 'Denmark', 'Finland') THEN 'Europe'
        ELSE 'Asia-Pacific'
    END AS supplier_region,
    c.category_name,
    SUM(p.unit_in_stock) AS total_units_in_stock,
    SUM(p.unit_on_order) AS total_units_on_order,
    SUM(p.reorder_level) AS total_reorder_level
FROM suppliers AS s
INNER JOIN products AS p
    ON s.supplier_id = p.supplier_id
INNER JOIN categories AS c
    ON p.category_id = c.category_id
GROUP BY 
    c.category_name,
    supplier_region
ORDER BY 
    c.category_name ASC,
    supplier_region ASC,
    total_reorder_level ASC;