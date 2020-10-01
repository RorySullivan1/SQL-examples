SELECT
	*
FROM
	dept_emp;
    
SELECT
	emp_no, from_date, to_date, COUNT(emp_no) AS NUM
FROM
	dept_emp
GROUP BY emp_no
HAVING NUM > 1;

CREATE OR REPLACE VIEW V_dept_emp_latest_date AS 
	SELECT
		emp_no, MAX(from_date) as from_date, MAX(to_date) as to_date
	FROM dept_emp
    GROUP BY emp_no;
    
SELECT * FROM V_dept_emp_latest_date;

#Example
CREATE OR REPLACE VIEW V_avg_salary_manager AS
SELECT
	Round(avg(s.salary),2)
FROM
	salaries s
		JOIN
	dept_manager dm ON s.emp_no = dm.emp_no;

SELECT * FROM V_avg_salary_manager;
