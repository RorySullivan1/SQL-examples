CREATE TABLE emp_manager (
	emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

SELECT * FROM employees;


INSERT INTO emp_manager
		SELECT
			U.*
		FROM
			(SELECT 
				A.*
			FROM
				(SELECT
					e.emp_no as employee_ID,
					MIN(de.dept_no) AS department_code,
					(SELECT
							emp_no
						FROM
							dept_manager
						WHERE
							emp_no = '110022') as manager_ID
				FROM
					employees e
				JOIN dept_emp de ON e.emp_no = de.emp_no
				WHERE
					e.emp_no <= 10020
				GROUP BY e.emp_no
				ORDER BY e.emp_no) as A
			UNION SELECT
				B.*
			FROM
				(SELECT
					e.emp_no as employee_ID,
					MIN(de.dept_no) AS department_code,
					(SELECT
							emp_no
						FROM
							dept_manager
						WHERE
							emp_no = '110039') as manager_ID
				FROM
					employees e
				JOIN dept_emp de ON e.emp_no = de.emp_no
				WHERE
					e.emp_no BETWEEN 10021 AND 10040
				GROUP BY e.emp_no
				ORDER BY e.emp_no) as B
			UNION SELECT
				C.*
			FROM
				(SELECT
					e.emp_no as employee_ID,
					MIN(de.dept_no) AS department_code,
					(SELECT
							emp_no
						FROM
							dept_manager
						WHERE
							emp_no = '110039') as manager_ID
				FROM
					employees e
				JOIN dept_emp de ON e.emp_no = de.emp_no
				WHERE
					e.emp_no = 110022
				GROUP BY e.emp_no
				ORDER BY e.emp_no) as C
			UNION SELECT
				D.*
			FROM
				(SELECT
					e.emp_no as employee_ID,
					MIN(de.dept_no) AS department_code,
					(SELECT
							emp_no
						FROM
							dept_manager
						WHERE
							emp_no = '110022') as manager_ID
				FROM
					employees e
				JOIN dept_emp de ON e.emp_no = de.emp_no
				WHERE
					e.emp_no =110039
				GROUP BY e.emp_no
				ORDER BY e.emp_no) as D
			) as U;