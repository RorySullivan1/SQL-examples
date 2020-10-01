#Procedure Creation

USE employees;

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN

		SELECT * FROM employees
        LIMIT 1000;
        
END $$

DELIMITER ;

CALL employees.select_employees();

DROP PROCEDURE IF EXISTS average_salary;

DELIMITER $$
CREATE PROCEDURE average_salary()
BEGIN

	SELECT
		round(avg(salary),2)
	FROM
		salaries;
	
END $$
DELIMITER ;


#INPUT PARAMETER ----------

DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN

	SELECT
		e.first_name, e.last_name, s.salary, s.from_date, s.to_date
	FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE
		e.emp_no = p_emp_no;
END $$
DELIMITER ;

CALL emp_salary(11300);

#INPUT with Aggregates --------------

DROP PROCEDURE IF EXISTS in_avg_emp_salary;

DELIMITER $$
USE employees $$
CREATE PROCEDURE in_avg_emp_salary(IN p_emp_no INTEGER)
BEGIN

	SELECT
		e.first_name, e.last_name, round(avg(s.salary),2) as avg_salary
	FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE
		e.emp_no = p_emp_no;
END $$
DELIMITER ;

CALL in_avg_emp_salary(11300);


#OUTPUT PARAMTER -----

DROP PROCEDURE IF EXISTS out_avg_emp_salary;

DELIMITER $$
USE employees $$
CREATE PROCEDURE out_avg_emp_salary(IN p_emp_no INTEGER, OUT p_avg_salary DECIMAL(10,2))
BEGIN

	SELECT
		round(avg(s.salary),2) as avg_salary INTO p_avg_salary
	FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE
		e.emp_no = p_emp_no;
END $$
DELIMITER ;

CALL out_avg_emp_salary(11300);

#FIRST / LAST NAME EXAMPLE

DROP PROCEDURE IF EXISTS find_emp_no;

DELIMITER $$
USE employees $$
CREATE PROCEDURE find_emp_no(IN p_emp_fname VARCHAR(255), IN p_emp_lname VARCHAR(255), OUT @v_emp_no INT)
BEGIN
	SELECT
		e.emp_no
	INTO p_emp_no FROM
		employees e
	WHERE
		p_emp_fname = e.first_name AND p_emp_lname = e.last_name;
END $$
DELIMITER ;

SET @v_emp_no = 0;
CALL find_emp_no('Aruna','Journel',@v_emp_no);
SELECT @v_emp_no;

##VARIABLES

SET @v_average_salary = 0;
CALL employees.out_avg_emp_salary(11300, @v_average_salary);
SELECT @v_average_salary;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

	DECLARE v_avg_salary DECIMAL(10,2);

	SELECT 
		AVG(s.salary)
	INTO v_avg_salary FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE
		p_emp_no = e.emp_no;

RETURN v_avg_salary;
END $$
DELIMITER ;

SELECT f_emp_avg_salary(11300);


#USER DEFINED FUNCTIONS

DROP FUNCTION emp_info_1;

DELIMITER $$
CREATE FUNCTION emp_info_1 (p_emp_fname VARCHAR(255), p_emp_lname VARCHAR(255)) RETURNS DECIMAL(10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN

#Declaring variables
	DECLARE v_max_date date;
    DECLARE v_salary decimal(10,2);

#FINDING LAST CONTRACT DATE
	SELECT
		MAX(s.from_date)
	INTO v_max_date 
    FROM employees e
		JOIN
		salaries s ON e.emp_no = s.emp_no
    WHERE
		p_emp_fname = e.first_name
        and
        p_emp_lname = e.last_name;

#Yielding related salary
	SELECT
		s.salary
	INTO v_salary
    FROM
		employees e
        JOIN
        salaries s ON e.emp_no = s.emp_no
	WHERE
		p_emp_fname = e.first_name
        and
        p_emp_lname = e.last_name
        and
        v_max_date = s.from_date;

#RETURN
	RETURN v_salary;
END $$
DELIMITER ;

SELECT EMP_INFO_1('Aruna', 'Journel');



SELECT *
FROM employees e
	JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE e.first_name = 'Aruna' AND e.last_name = 'Journel'
GROUP BY s.from_date
ORDER BY s.from_date DESC;