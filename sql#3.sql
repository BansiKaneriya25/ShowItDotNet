--Operators

--Union - Combine two or more results sets into single set without duplicates

select * from [dbo].[EmplyoeeIND]  
UNION
select * from [dbo].[EmployeeCND] order by Name 

--Union All - - Combine two or more results sets into single set with all duplicates
select  Name,Gender from [dbo].[EmplyoeeIND]  
UNION ALL
select  Name,GenderOfPerson from [dbo].[EmployeeCND]  

--Intersect - takes the data from both result sets which are in common
select  Name,Gender from [dbo].[EmplyoeeIND]  
INTERSECT  
select  Name,GenderOfPerson from [dbo].[EmployeeCND]  

--Except - Takes the data from first result set but not in the second result set
select  Name,Gender from [dbo].[EmplyoeeIND]  
EXCEPT  
select  Name,GenderOfPerson from [dbo].[EmployeeCND] 

--Points to Remember
--1# same number of col
--2# same data type of each col
--3# order by clause should be part of last select statement


-- EXISTS Operator
-- used to checks to existence if result of subquery

IF NOT EXISTS(SELECT Name FROM [dbo].[EmplyoeeIND] WHERE Name = 'Bansi')
BEGIN
	--insert statement 
END

IF EXISTS(SELECT 1 FROM [dbo].[EmplyoeeIND] WHERE Name = 'Bansi1')
BEGIN
	SELECT * FROM Employees WHERE Name IN (SELECT Name FROM [dbo].[EmplyoeeIND] WHERE Name = 'Bansi')
END

Select * from Employees WHERE 
EXISTS(Select * from EmployeeDetails WHERE EmployeeDetails.EmployeeId = Employees.EmployeeId) 


--##SQL JOINS####

-- * all tables col return
-- tablename.* perticular table col return (Employees.* , EmployeeDetails.* )
-- tablename.colname1, tablename.colname2 .... 
SELECT Employees.* , EmployeeDetails.*  FROM Employees 
INNER JOIN EmployeeDetails ON Employees.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN [dbo].[EmplyoeeIND] ON EmployeeDetails.EmployeeDetailId = EmplyoeeIND.ID

--1# INNER JOIN
-- Return only matching rows from both the tables
SELECT *  FROM Employees 
INNER JOIN EmployeeDetails ON Employees.EmployeeId = EmployeeDetails.EmployeeId

--#2 LEFT JOIN / LEFT OUTER JOIN
--  Return all records from left side table and matched records from right side table. 
--  If not match then return NULL
SELECT *  FROM Employees 
LEFT JOIN EmployeeDetails ON Employees.EmployeeId = EmployeeDetails.EmployeeId

--#3 RIGHT JOIN / RIGHT OUTER JOIN
-- Return all records from right side table and march records from left side table
-- If not match then return NULL
SELECT *  FROM Employees 
RIGHT JOIN EmployeeDetails ON Employees.EmployeeId = EmployeeDetails.EmployeeId

--#4 FULL OUTER JOIN
-- Return all the matching records from both table and including non-matching records
-- If not match then return NULL
SELECT *  FROM Employees 
FULL OUTER JOIN EmployeeDetails ON Employees.EmployeeId = EmployeeDetails.EmployeeId

--#5 CROSS JOIN 
-- each records of the table is joined with each records of other table
-- should not use ON condition
-- called as cartesian join
-- 12 * 7
Select * from Employees
CROSS JOIN EmployeeDetails

-- #6 Self Join
-- when you have some relation btw the col of same table

-- find all employee data which having assing into manager

SELECT t1.Name as EmpName, t2.Name as ManagerName 
FROM [EmplyoeeIND] t1
LEFT JOIN [EmplyoeeIND] t2 ON t1.ManagerId = t2.ID
WHERE t2.ID IS NOT NULL

SELECT t1.Name as EmpName, t2.Name as ManagerName 
FROM [EmplyoeeIND] t1
INNER JOIN [EmplyoeeIND] t2 ON t1.ManagerId = t2.ID

-- Two col concate as return single col
SELECT Name  + Address as [FullName]  from Employees

--#View 
-- view is virtual table
-- must be return only single table
-- we can alter view once created anytime

--DROP View [dbo].[vw_table_new]

CREATE VIEW [vw_table]
AS
SELECT *  FROM Employees 
LEFT JOIN EmployeeDetails ON Employees.EmployeeId = EmployeeDetails.EmployeeId

select * from [vw_table]
INNER JOIN EmployeeDetails ON [vw_table].EmployeeId = EmployeeDetails.EmployeeId
