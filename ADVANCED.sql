#VARIABLES
SET @v_var1 = 3;
SET @v_var2 = 2;


#Triggers

DELIMITER $$

CREATE TRIGGER trig_hire_date  

BEFORE INSERT ON employees

FOR EACH ROW  

BEGIN  

                IF NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') THEN     
                                SET NEW.hire_date = date_format(sysdate(), '%Y-%m-%d');
                END IF;  
END $$  
DELIMITER ;  


INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  
SELECT  
    *  
FROM  
    employees
ORDER BY emp_no DESC;

#INDICIES ---------------------

SELECT 
    *
FROM
    salaries
WHERE
    salary > 89000;

ALTER TABLE salaries
DROP INDEX i_salary;

CREATE INDEX i_salary
ON salaries (salary);


#CASE STATEMENTS

SELECT
	emp_no,
	first_name,
    last_name,
    CASE
		WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
	END AS gender
FROM employees;
    
SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
	END AS is_manager
FROM
	employees e
		LEFT JOIN
	dept_manager dm ON dm.emp_no = e.emp_no
WHERE 
	e.emp_no > 109990;

USE employees;
    
SELECT 
	de.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
        WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 'Salary was raised by more than $20,000 but less than $30,000'
        ELSE 'Salary was raised by less than $20,000'
	END as Salary_Increase
FROM 
	dept_manager de
		LEFT JOIN
	salaries s ON s.emp_no = de.emp_no
		LEFT JOIN
	 employees e ON de.emp_no = e.emp_no
GROUP BY s.emp_no;
		
#CASE EX1

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN de.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
	END AS 'Employee Type'
FROM
	employees e
		JOIN
	Dept_manager de on de.emp_no = e.emp_no
WHERE e.emp_no > 109990
GROUP BY e.emp_no;

#CASE EX2

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
        ELSE 'Salary was less than 30000'
    END AS 'Salary Statement'
FROM
	dept_manager de
		JOIN
    employees e ON de.emp_no = e.emp_no
		JOIN
	salaries s ON de.emp_no = s.emp_no
GROUP BY e.emp_no;

#CASE EX3

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN max(de.to_date) > sysdate() THEN 'Employed'
        ELSE 'Not Employed'
    END AS 'Employee Status'
FROM Employees e
		LEFT JOIN
	dept_emp de ON e.emp_no = de.emp_no
GROUP BY de.emp_no
LIMIT 100;

SELECT * FROM dept_emp;