-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Joining departments and dept_manager tables
SELECT d.dept_no, 
	dm.emp_no, 
	dm.from_date, 
	dm.to_date 
FROM departments AS d
INNER JOIN dept_manager AS dm
	ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
	ON ri.emp_no = de.emp_no;

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp as de
	ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

--Employee Count by Department Number
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_count_by_dept_no
FROM current_emp AS ce
LEFT JOIN dept_emp AS de
	ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- List 1: Employee Information
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
	INNER JOIN salaries AS s
		ON (e.emp_no = s.emp_no)
	INNER JOIN dept_emp AS de
		ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List 2: Management
SELECT d.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments as d
		ON (d.dept_no = dm.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);

-- List 3: Department Retirees
SELECT ce.emp_no, 
	ce.first_name, 
	ce.last_name, 
	ce.to_date,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

-- Sales Team List
-- Requested list includes: employee numbers, first name, last name, department name
SELECT ce.emp_no, 
	ce.first_name, 
	ce.last_name, 
	d.dept_name
FROM current_emp AS ce
INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales';

-- Create a query that returns the following info for the Sales & Development Teams
-- Requested list includes: employee numbers, first name, last, department name
SELECT ce.emp_no, 
	ce.first_name, 
	ce.last_name, 
	d.dept_name
FROM current_emp AS ce
INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');