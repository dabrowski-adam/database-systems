-- SQL - part 1
-- Creating database using SQL statements

-- 1. Choose New Query option for opening SQL worksheet window.

-- 2. Define new database named test_yourname using CREATE DATABASE statement.
CREATE DATABASE test_mackiewicz;

-- 3. Refresh Object Explorer panel to see your new database.

-- 4. Check the name of the database you are connected to. You can change a current database using the statement:
-- USE database_name
SELECT DB_NAME() AS DBName;
USE test_mackiewicz;

-- 5. Define table named BANDS, which consists of the following columns: band_id – integer, primery key,  name – varchar limited to 40 characters, origin_country -  varchar limited to 50 characters, formed_year – integer.
CREATE TABLE BANDS (
	band_id int PRIMARY KEY,
	name varchar(40),
	origin_country varchar(50),
	formed_year int
);

-- 6. Check the number of records in that table using SELECT count(*) … statement.
SELECT count(*) FROM BANDS

-- 7. Insert into the table one record: name: The Beatles, origin_country: England, formed_year 1960
INSERT INTO BANDS VALUES (1, 'The Beatles', 'England', 1960);

-- 8. Display all the data using SELECT statement.
SELECT * FROM BANDS

-- 9. Check the number of records in that table again.
SELECT count(*) FROM BANDS

-- 10. Create another table named MEMBERS consisted of: memeber_id - integer incremental from 100 by 1, band_id - int, surname - varchar limited to 60 characters, name varchar limited to 50 characters.

CREATE TABLE MEMBERS (
	member_id int IDENTITY(100,1),
	band_id int,
	surname varchar(60),
	name varchar(50)
);

-- 11. Add foreign key on band_id column of MEMBERS table, which references BANDS table.
ALTER TABLE MEMBERS 
ADD FOREIGN KEY (band_id) REFERENCES BANDS(band_id);

-- 12. Insert into that table 2 records for The Beatles band: John Lennon and Paul McCartney.
INSERT INTO MEMBERS (band_id, surname, name) VALUES (1, 'Lennon', 'John'), (1, 'McCartney', 'Paul');

-- 13. Insert into BANDS table another record: name: Queen, origin_country: Great Britain, formed_year: 1971
INSERT INTO BANDS VALUES (2, 'Queen', 'Great Britain', 1971);

-- 14. Insert another member: Freddie Mercury.
INSERT INTO MEMBERS (band_id, surname, name) VALUES (2, 'Mercury', 'Freddie');

-- 15. Add constraint, which doesn’t allow entering year earlier than 1920.
ALTER TABLE BANDS ADD CONSTRAINT CHK_formed_year CHECK (formed_year >= 1920);

-- 16. Add another record to ensure that the constraint works properly. 
INSERT INTO BANDS VALUES (3, 'A', 'B', 1919);


-- SQL - part 2
-- 1. Create a database named LIBRARY (as shown at schema on the next page). Give names to all the constraints (except NULL constraints). The properties of the tables are defined as follows:

CREATE DATABASE library;
GO
USE library;
GO
SELECT DB_NAME() AS DBName;

-- 2. Create database diagram and check it correctness (compare with a diagram above).
CREATE TABLE members (
	CardNo char(5) PRIMARY KEY,
	Surname varchar(15) NOT NULL,
	Name varchar(15) NOT NULL,
	Address varchar(150),
	Birthday_date date NOT NULL,
	Gender char(1),
	Phone_No varchar(15),
	CONSTRAINT CHK_Gender CHECK (Gender='F' OR Gender='M')
);

CREATE TABLE employees (
	emp_id int identity(1,1) PRIMARY KEY,
	Surname varchar(15) NOT NULL,
	Name varchar(15) NOT NULL,
	Birthday_date date NOT NULL,
	Emp_date date,
	CONSTRAINT CHK_date CHECK (Birthday_date < Emp_date)
);

CREATE TABLE publishers (
	pub_id int PRIMARY KEY IDENTITY(1,1),
	Name varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	Phone_No varchar(15)
);

CREATE TABLE books (
	BookID char(5) PRIMARY KEY,
	Pub_ID int FOREIGN KEY REFERENCES publishers(pub_id),
	Title varchar(40) NOT NULL,
	Price money NOT NULL,
	PagesNo int,
	BookType varchar(20),
	CONSTRAINT CHK_Type CHECK (BookType IN ('novel', 'historical', 'for kids', 'poems', 'crime story', 'science fiction', 'science'))
);

CREATE TABLE book_loans (
	LoanID int IDENTITY(1,1) PRIMARY KEY,
	BookID char(5) FOREIGN KEY REFERENCES books(BookID),
	CardNo char(5) FOREIGN KEY REFERENCES members(CardNo),
	emp_id int FOREIGN KEY REFERENCES employees(emp_id),
	DateOut date,
	DueDate date,
	Penalty int DEFAULT 0,
	CONSTRAINT CHK_Loan_Date CHECK (DateOut < DueDate)
);

-- 3. Add data from the script (library_eng_data.sql). In case of errors, check the defined structure again..

-- 4. There is Gender field in Employees table omitted (it should contain 'F' or "M' value). Correct this mistake.
ALTER TABLE employees ADD 
Gender char(1),
CONSTRAINT CHK_Emp_Gender CHECK (Gender='F' OR Gender='M');

-- 5. Change Book_loans table - add another constraint, that enforces uniqueness of  a pair of values : BookID and DateOut.
ALTER TABLE book_loans ADD CONSTRAINT CHK_Unique UNIQUE (BookID, DateOut);

-- Additional Practice
-- Create a database according to the diagram and requirements.

CREATE TABLE member (
	member_id int PRIMARY KEY IDENTITY,
	last_name varchar(25) NOT NULL,
	first_name varchar(25),
	address varchar(100),
	city varchar(30),
	phone varchar(15),
	join_date datetime NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE TITLE (
	title_id int PRIMARY KEY IDENTITY,
	title varchar(60) NOT NULL,
	description varchar(400) NOT NULL,
	rating varchar(4),
	category varchar(20),
	release_date datetime,

	CONSTRAINT CHK_rating CHECK (rating in ('G', 'PG', 'R', 'NC17', 'NR')),
	CONSTRAINT CHK_category CHECK (category in ('DRAMA', 'COMEDY', 'ACTION', 'CHILD', 'SCIFI', 'DOCUMENTARY'))
);

CREATE TABLE title_copy (
	copy_id int,
	title_id int FOREIGN KEY REFERENCES TITLE(title_id),
	status varchar(15) NOT NULL,

	PRIMARY KEY (copy_id, title_id),
	CONSTRAINT CHK_status CHECK (status in ('AVAILABLE', 'DESTROYED', 'RENTED', 'RESERVED'))
);

CREATE TABLE rental (
	book_date date DEFAULT GETDATE(),
	member_id int FOREIGN KEY REFERENCES member(member_id),
	copy_id int,
	act_ret_date datetime,
	exp_ret_date datetime DEFAULT DATEADD(day, 2, GETDATE()),
	title_id int,

	PRIMARY KEY (book_date, member_id, copy_id, title_id),
	FOREIGN KEY (copy_id, title_id) REFERENCES title_copy(copy_id, title_id)
);

CREATE TABLE reservation (
	res_date datetime,
	member_id int FOREIGN KEY REFERENCES member(member_id),
	title_id int NOT NULL FOREIGN KEY REFERENCES TITLE(title_id),

	PRIMARY KEY (res_date, member_id, title_id)
);

-- Populate database using popul_video.sql script. In case of errors, correct the structure.
DROP TABLE rental;
GO

CREATE TABLE rental (
	book_date date DEFAULT GETDATE(),
	copy_id int,
	member_id int FOREIGN KEY REFERENCES member(member_id),
	title_id int,
	act_ret_date datetime,
	exp_ret_date datetime DEFAULT DATEADD(day, 2, GETDATE()),

	PRIMARY KEY (book_date, copy_id, member_id, title_id),
	FOREIGN KEY (copy_id, title_id) REFERENCES title_copy(copy_id, title_id)
);
GO


-- SQL - part 3
-- Use HR schema: Run hr_schema.sql script to create the database and tables. Then run hr_data.sql to populate this database with data.
USE HR;
GO

-- 1. Determine the structure of all database's tables.
SELECT * FROM information_schema.columns;
SELECT TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM information_schema.columns;

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS;

-- 2. Display names and salaries of employees.
SELECT first_name, last_name, salary FROM employees;

-- 3. Display the last name and salary of employees earning more than $12,000.
SELECT last_name, salary FROM employees WHERE salary > 12000;

-- 4. Display the last name and department number for employee number 176.
SELECT last_name, department_id FROM employees WHERE employee_id = 176;

-- 5. Display the last name and salary for all employees whose salary is not in the range of $5,000 to $12,000.
SELECT last_name, salary FROM employees WHERE salary < 5000 OR salary > 12000;

-- 6. Display the last name, job ID, and start date (hire date) for the employees with the last names of Matos and Taylor. Order the query in ascending order by start date.
SELECT last_name, job_id, hire_date FROM employees
WHERE last_name = 'Matos' OR last_name = 'Taylor'
ORDER BY hire_date ASC;

-- 7. Display the last name and department number of all employees in departments 20 or 50 in ascending alphabetical order by name.
SELECT last_name, department_id FROM employees
WHERE department_id = 20 OR department_id = 50
ORDER BY last_name ASC;

-- 8. Display the last name and job title of all employees who do not have a manager.
SELECT last_name, job_title
FROM
	jobs
	JOIN
	(
		SELECT last_name, job_id
		FROM employees
	  WHERE manager_id IS NULL
	) AS unmanaged
	ON jobs.job_id = unmanaged.job_id;

-- 9. Display the last name, salary, and commission for all employees who earn commissions. Sort data in descending order of salary and commissions.
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary, commission_pct DESC;

-- 10. Find the highest, lowest, sum, and average salary of all employees. Label the columns Maximum, Minimum, Sum, and Average, respectively.
SELECT
	MAX(salary) AS 'Maximum',
	MIN(salary) AS 'Minimum',
	AVG(salary) AS 'Average'
FROM employees;

-- 11. Modify the previous query to display the minimum, maximum, sum, and average salary for each job type (job_id).
SELECT
	job_id,
	MAX(salary) AS 'Maximum',
	MIN(salary) AS 'Minimum',
	AVG(salary) AS 'Average'
FROM employees
GROUP BY job_id;

-- 12. Display the number of people with the same job.
SELECT job_id, COUNT(job_id)
FROM employees
GROUP BY job_id;

-- 13. Determine the number of managers without listing them. Label the column Number of Managers. Hint: Use the MANAGER_ID column to determine the number of managers.
SELECT COUNT(manager_id) AS 'Number of Managers'
FROM (SELECT DISTINCT manager_id FROM employees) AS managers;

-- 14. Find the difference between the highest and lowest salaries. Label the column DIFFERENCE.
SELECT MAX(salary) - MIN(salary) AS 'DIFFERENCE'
FROM employees;

-- 15. Find the addresses of all the departments. Use the LOCATIONS and COUNTRIES tables. Show the location ID, street address, city, state or province, and country in the output.
SELECT location_id, street_address, city, state_province, country_name FROM
(
	SELECT dep.location_id, street_address, city, state_province, country_id FROM
	(SELECT location_id FROM departments) AS dep 
	JOIN 
	locations ON dep.location_id = locations.location_id
) AS tmp
JOIN
countries ON tmp.country_id = countries.country_id;

-- 16. Display the last name and department name for all employees.
SELECT last_name, department_name FROM
	(SELECT last_name, department_id from employees) AS adam
	JOIN 
	departments ON adam.department_id=departments.department_id;

-- 17. Display the last name, job, department number, and department name for all employees who work in Toronto.
SELECT last_name, job_id, employees.department_id, department_name FROM
	employees
	JOIN
	(SELECT department_id, department_name FROM departments WHERE location_id IN 
		(SELECT location_id FROM locations WHERE city = 'Toronto')) AS tmp
	ON employees.department_id = tmp.department_id;


-- If you have time, complete the following exercises:
-- 1A. Create a report to display the manager number and the salary of the lowest-paid employee for that manager. Exclude and groups where the minimum salary is $6000 or less. Sort the output in descending order of salary.
SELECT manager_id, MIN(salary) AS Minimum
FROM employees
WHERE (manager_id IS NOT NULL) AND salary > 6000 
GROUP BY manager_id
ORDER BY Minimum DESC;

-- 2A. The HR department wants to determine the names of all employees who were hired after Davies. Create a query to display the name and hire date of any employee hired after employee Davies.
SELECT last_name, hire_date FROM employees 
WHERE hire_date > (SELECT hire_date FROM employees WHERE last_name='Davies');

-- 3A. The HR department needs to find the names and hire dates for all employees who were hired before their managers, along with their managers' names and hire dates
SELECT employees.last_name, employees.hire_date, managers.last_name, managers.hire_date FROM
	employees
	JOIN
	employees AS managers
	ON employees.manager_id = managers.employee_id;

-- 4A. Create a report that displays the employee number, last name, and salary of all employees who earn more than the avarage salary. Sort the results in order of ascending salary.
SELECT employee_id, last_name, salary FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary ASC;

-- 5A. Write a query that displays the employee number and last name of all employees who work in a depatrment with any employee whose last name starts with "U"
SELECT employee_id, last_name FROM employees
WHERE department_id IN (SELECT department_id FROM EMPLOYEES WHERE last_name LIKE 'u%');

-- 6A. Create a report for HR that displays the last name and salary of every employee who reports to King.
SELECT last_name, salary FROM employees
WHERE manager_id IN (SELECT employee_id FROM employees WHERE last_name='King');

-- 7A. For budgeting purposes, the HR department needs a report on projected 10% raises. The report shoud display those employees who have no commisions
SELECT 'The salary of ' + last_name + ' after a 10% raise is ' + CONVERT(varchar, (TRY_CONVERT(int, salary) * 1.1)) AS "Report"
FROM employees
WHERE commission_pct IS NULL;


-- SQL - part 4
-- Use HR schema: Run hr_schema.sql script to create the database and tables. Then run hr_data.sql to populate this database with data.

-- 1. Show last names and numbers of all managers together with the number of employees that are his / her subortinates.
SELECT last_name, employee_id, managers.employees FROM
	employees
	JOIN
(SELECT manager_id, COUNT(manager_id) AS employees
	FROM employees
	WHERE manager_id IS NOT NULL
	GROUP BY manager_id) AS managers
ON employees.employee_id = managers.manager_id;

-- 2. Create a report that displays the department name, location name, job title and salary of those employeses who work in a specific (given) location.
SELECT department_name, location_id, last_name, job_title, salary
FROM
	jobs
	JOIN
	(
		SELECT department_name, location_id, last_name, job_id, salary
		FROM
			employees
			JOIN
			departments
			ON employees.department_id = departments.department_id
	) AS data
	ON jobs.job_id = data.job_id
WHERE location_id = 1400;
-- as a table-valued function
CREATE FUNCTION GenerateReport(@location INT)
	RETURNS TABLE
	AS
	RETURN
		SELECT department_name, location_id, last_name, job_title, salary
		FROM
			jobs
			JOIN
			(
				SELECT department_name, location_id, last_name, job_id, salary
				FROM
					employees
					JOIN
					departments
					ON employees.department_id = departments.department_id
			) AS data
			ON jobs.job_id = data.job_id
		WHERE location_id = @location;

GO;

SELECT * FROM GenerateReport(1400);

-- 3. Find the number of employees who have a last name that ends with the letter n.
SELECT COUNT(last_name) AS 'Nr of employees whose last name ends with n'
FROM employees
WHERE last_name LIKE '%n';

-- 4. Create a report that shows the name, location and the number of employees for each department. Make sure that report also includes departments without employees.
SELECT department_name, location_id, ISNULL(employees, 0)
FROM
	departments
	LEFT JOIN
	(
		SELECT department_id, COUNT(department_id) AS employees
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id
	) AS emp_count
	ON departments.department_id = emp_count.department_id;

-- 5. Show all employees who were hired in the first five days of the month (before the 6th of the month).
SELECT last_name, hire_date
FROM employees
WHERE DAY(hire_date) < 6;

-- 6. Create a report to display the department number and lowest salary of the department with the highest average salary.
-- TODO: Check
SELECT TOP 1 department_id, salary
FROM employees
WHERE department_id IN
	(
		SELECT TOP 1 department_id, avg_salary FROM
		(
			SELECT department_id, AVG(salary) AS avg_salary
			FROM employees
			WHERE department_id IS NOT NULL
			GROUP BY department_id
		) AS department_earnings
		ORDER BY avg_salary DESC
	)
ORDER BY salary ASC;

-- 7. Create a report that displays department where no sales representatives work. Include the deprtment number, department name and location in the output.
SELECT department_id, department_name, location_id
FROM departments
WHERE department_id NOT IN
	(
		SELECT DISTINCT d.department_id
		FROM
			departments d
			JOIN
			employees e
			ON d.department_id = e.department_id
		WHERE job_id = 'SA_REP'
	);

-- 8. Display the depatrment number, department name and the number of employees for the department:
-- a. with the highest number of employees.
WITH dep_employees AS (
	SELECT department_id, COUNT(employee_id) AS employed
	FROM employees
	WHERE department_id IS NOT NULL
	GROUP BY department_id
)
SELECT departments.department_id, department_name, employed
FROM
	departments
	JOIN
	(SELECT *
	 	FROM dep_employees
		WHERE employed = (SELECT MAX(employed) FROM dep_employees)) AS data
	ON departments.department_id = data.department_id;
-- if only one department is needed one could use a simpler query
SELECT TOP 1 d.department_id, department_name, employed
FROM
	departments d
	JOIN
	(SELECT department_id, COUNT(employee_id) AS employed
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id) AS data
	ON d.department_id = data.department_id
ORDER BY employed DESC;

-- b. with the lowest number of employees
WITH dep_employees AS (
	SELECT department_id, COUNT(employee_id) AS employed
	FROM employees
	WHERE department_id IS NOT NULL
	GROUP BY department_id
)
SELECT departments.department_id, department_name, employed
FROM
	departments
	JOIN
	(
		SELECT *
	 	FROM dep_employees
		WHERE employed = (SELECT MIN(employed) FROM dep_employees)
	) AS data
	ON departments.department_id = data.department_id;

-- c. that employs fewer than three employees.
SELECT d.department_id, department_name, employed
FROM
	departments d
	JOIN
	(
		SELECT department_id, COUNT(employee_id) AS employed
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id
	) AS data
	ON d.department_id = data.department_id
WHERE employed < 3;
-- or
SELECT d.department_id, department_name, employed
FROM
	departments d
	JOIN
	(
		SELECT department_id, COUNT(employee_id) AS employed
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id
		HAVING COUNT(employee_id) < 3
	) AS data
	ON d.department_id = data.department_id;

-- 9. Display years and total numbers of employees that were employed in that year.
SELECT year, COUNT(employee_id)
FROM
	(
		SELECT YEAR(hire_date) AS year, employee_id
		FROM employees
	) AS years
GROUP BY year
ORDER BY year DESC;

-- 10. Display countries and number of locations in that country.
SELECT country_name, ISNULL(number, 0) AS locations
FROM
	countries
	LEFT JOIN
	(
		SELECT country_id, COUNT(country_id) AS number
		FROM locations
		GROUP BY country_id
	) AS data
	ON countries.country_id = data.country_id
ORDER BY locations DESC;


-- If you have time, complete the following exercises:
-- A1. Create a query to display the employees who earn a salary that is higher than the salary of all the sales managers (JOB_ID = 'SA_MAN'). Sort the results from the highest to the lowest.

-- A2. Display details such as the employee ID, last name, and department ID of those employees who works in cities the names of which begin with 'T'.

-- A3. Write a query to find all employees who earn more than the average salary in their

-- A4. Find all employees who are not sumervisors (managers). Do this using the NOT EXISTS operator.

-- Can it be done using NOT IN operator?

-- A5. Display the last names of the employees who earn less than the average salary in their departments.

-- A6. Display the last names of the employees who have one or more coworkers in their departments with later hire dates but higher salaries.

-- A7. Display the department names of those depatrments whose total salary cost is above one-eight (1/8) of the total salary cost od the whole company. Use the WITH clause to write this query. Name the query SUMMARY.

-- A8. Delete the oldest JOB_HISTORY row of an employee by looking up the JOB_HISTORY table for the MIN(START_DATE) for the employee. Delete the records of only those employees who have changed at least two jobs.

