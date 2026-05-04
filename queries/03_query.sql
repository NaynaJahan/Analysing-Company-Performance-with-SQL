SELECT
    emp.first_name || ' ' || emp.last_name AS employee_full_name,
    emp.title AS employee_job_title,
    EXTRACT(YEAR FROM AGE(emp.hire_date, emp.birth_date)) AS age_at_hire,
    mng.first_name || ' ' || mng.last_name AS manager_full_name,
    mng.title AS manager_job_title
FROM
    employees emp
LEFT JOIN
    employees mng ON emp.reports_to = mng.employee_id
ORDER BY
    age_at_hire ASC,
    employee_full_name ASC;