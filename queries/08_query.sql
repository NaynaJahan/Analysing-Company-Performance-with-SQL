WITH category_stats AS (
    SELECT
        p.category_id,
        ROUND(CAST(AVG(p.unit_price) AS NUMERIC), 2) AS avg_unit_price,
        ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY p.unit_price) AS NUMERIC), 2) AS median_unit_price
    FROM
        products p
    WHERE
        p.discontinued = 0
    GROUP BY
        p.category_id
)
SELECT
    c.category_name,
    p.product_name,
    ROUND(CAST(p.unit_price AS NUMERIC), 2) AS unit_price,
    cs.avg_unit_price,
    cs.median_unit_price,
    CASE
        WHEN p.unit_price < cs.avg_unit_price THEN 'Below Average'
        WHEN p.unit_price = cs.avg_unit_price THEN 'Equal Average'
        ELSE 'Over Average'
    END AS price_vs_avg,
    CASE
        WHEN p.unit_price < cs.median_unit_price THEN 'Below Median'
        WHEN p.unit_price = cs.median_unit_price THEN 'Equal Median'
        ELSE 'Over Median'
    END AS price_vs_median
FROM
    products p
JOIN
    categories c ON p.category_id = c.category_id
JOIN
    category_stats cs ON p.category_id = cs.category_id
WHERE
    p.discontinued = 0  
ORDER BY
    c.category_name ASC,
    p.product_name ASC;