USE employees_mod;

# Do not name rows with strings... shit doesn't work

#Tableau 1 --> Male Vs. Female Employees
Select
	year(de.from_date) AS Calendar_year,
    e.gender,
    count(e.emp_no) as Employee_Count
FROM
	t_employees e
		Join
	t_dept_emp de ON de.emp_no = e.emp_no
GROUP BY Calendar_year, e.gender
HAVING Calendar_year >= '1990'
ORDER BY Calendar_year;

#Tableau Task 2 --> Male vs. Female Manager with the 'Active' column

Select
	d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
		WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year
        THEN 1
        ELSE 0
	END as Employee_Status
FROM
	(Select
		YEAR(hire_date) as calendar_year
        FROM
			t_employees
		GROUP BY calendar_year) e
/* Grouping by the year in this nested query will 
allow us filter the years down to each employee rather than create an entire list
of all years combined with each employee... Meaning 10 years for each employee, when they only were hired once.
*/
	CROSS JOIN
		t_dept_manager dm
	JOIN
		t_departments d ON dm.dept_no = d.dept_no
	JOIN
		t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, e.calendar_year;


#Task 3 Comparing Average Salary of M vs. F employees

SELECT
	d.dept_name,
    e.gender,
    YEAR(s.from_date) AS Calendar_Year,
    round(avg(s.salary),2) as Average_Salary
FROM
	t_salaries s
		JOIN
	t_employees e ON e.emp_no = s.emp_no
		JOIN
	t_dept_emp de ON e.emp_no = de.emp_no
		JOIN
	t_departments d ON de.dept_no = d.dept_no
GROUP BY dept_name, gender, Calendar_Year
HAVING Calendar_Year <= 2002
Order by Calendar_Year, d.dept_no;

# Task 3

DROP PROCEDURE salary_range;

DELIMITER $$
CREATE PROCEDURE salary_range (IN LBound_salary FLOAT, IN UBound_Salary FLOAT)
	BEGIN
		SELECT
			d.Dept_name,
            ROUND(AVG(s.salary),2) as Average_Salary,
            e.gender
		FROM
			t_employees e
				JOIN
			t_dept_emp de ON e.emp_no = de.emp_no
				JOIN
            t_departments d ON de.dept_no = d.dept_no
				JOIN
			t_salaries s ON e.emp_no = s.emp_no
		WHERE s.salary BETWEEN LBound_salary AND UBound_Salary
		GROUP BY d.dept_name, e.gender
        ORDER BY d.dept_name, e.gender;
	END$$
DELIMITER ;

CALL salary_range(50000,70000);
