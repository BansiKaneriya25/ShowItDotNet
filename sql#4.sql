--#Store procedure
-- sp sql statement can store in db execute repeatedly.

--exec dbo.spname [param1,param2] like this 1,'name'

CREATE PROCEDURE GetEmployees --ALTER PROCEDURE GetEmployees
AS
BEGIN
	SELECT *  FROM Employees 
	INNER JOIN EmployeeDetails ON Employees.EmployeeId = EmployeeDetails.EmployeeId
END

EXEC GetEmployees

ALTER PROCEDURE [dbo].[GetEmployees]
	@Name NVARCHAR(100) = NULL,
	@ABC NVARCHAR(100) = NULL,
	@Dept NVARCHAR(100) = NULL,
	@Result NVARCHAR(100) OUTPUT
AS
BEGIN
	BEGIN TRY
		SELECT *  FROM Employees 
		INNER JOIN EmployeeDetails ON Employees.EmployeeId = EmployeeDetails.EmployeeId
		WHERE Employees.Name = @Name
		OR Address = @ABC

		EXEC [dbo].[GetEmployeesDetails] @Dept
		EXEC [dbo].[GetEmployeesDetails] 'CE'

		DECLARE @A INT  = 10

		IF(ISNULL(@Name,'') = '' AND ISNULL(@Dept,'') = '') --NULL -> '' = ''
		BEGIN
			--SELECT
			PRINT 1
			SET @Result = 'TEST'
		END

		--SELECT 10/0
	
	END TRY
	BEGIN CATCH
	SELECT ERROR_MESSAGE()
	END CATCH
END

CREATE PROCEDURE [dbo].[GetEmployeesDetails]
	@Dept NVARCHAR(100) = NULL
AS
BEGIN
	SELECT *  FROM EmployeeDetails  WHERE Department = @Dept
	 
END

DECLARE @Result123 NVARCHAR(100) = NULL
EXEC GetEmployees '',NULL,'IT',@Result = @Result123 OUTPUT
SELECT @Result123

-- we can write insert/updtae/delete/select statement in sp
-- we can handle tranction - try & catch
-- we can use view in sp
-- we can execute sp from another sp
-- we can return output param


--#Exception Handling in SP
-- BEGIN TRY
-- END TRY
-- BEGIN CATCH
-- END CATCH

--#Functions

--1# Scalar Functions
--#String func
--LEN,UPPER,LOWER,SUBSTRING 
SELECT LEN('Hello World')
SELECT UPPER('Hello World')
SELECT LOWER('Hello World')
SELECT SUBSTRING('Hello World',1,5)

---Numeric func
--ABS,ROUND,FLOOR,CEILING
SELECT ABS(-123.45)
SELECT ROUND(123.456,2)
SELECT CEILING(123.45) -- smallest int greater then or equal
SELECT FLOOR(123.45) -- largest int less then or equal

-- DATE and TIME func
SELECT GETDATE()
SELECT DATEADD(day,10,'01-01-2025')
SELECT DATEDIFF(day,'2025-01-01','2025-01-25')
SELECT CONVERT(varchar,GETDATE(),101)
SELECT CONVERT(varchar,GETDATE(),102)

-- aggregate func
--SUM,AVG,MIN,MAX,COUNT

SELECT COUNT(1) FROM Employees
SELECT AVG(Salary) FROM EmployeeDetails
SELECT MIN(Salary) FROM EmployeeDetails
SELECT MAX(Salary) FROM EmployeeDetails
SELECT SUM(Salary) FROM EmployeeDetails

--#2 User-Defined function - UDF
-- custom func we can create out own

-- SCALER VALUE - retun one value
SELECT dbo.GetFullName('Bansi','Kaneriya')
CREATE FUNCTION GetFullName(@FirstName nvarchar(100), @LastName nvarchar(100))
RETURNS NVARCHAR(500)
AS 
BEGIN
	RETURN @FirstName + ' ' + @LastName
END


SELECT dbo.GetFullName(Name,Address),EmployeeId,PhoneNumber,Email FROM Employees

--#Table-value

ALTER Function GetEmp (@Id INT)
RETURNS TABLE
AS
RETURN(SELECT * FROM EmployeeCND where ID = @Id);

SELECT * FROM dbo.GetEmp(10)

--Diff btw SP VS Func

-- we can use func inside sp but we can not use sp inside func
-- can't use transaction in func
-- we can use insert update delete inside sp
-- we can't use insert update delete inside func - only select statement use inside func
-- func must retun value
-- sp may not return value

-- Common Table Expression - CTE
-- temporary result set in sql, use for complex query
-- recursive
-- score - cte we can use till next statement of cte define

WITH EmpCTE AS 
(
	SELECT AVG(Salary) as avgSalary from EmployeeDetails
)

SELECT * FROM EmpCTE

select * from EmplyoeeIND

WITH EmpHierarchyCTE as
(
	SELECT ID,Name,Gender,Department,ManagerId FROM [dbo].[EmplyoeeIND] WHERE ManagerId IS NULL

	UNION ALL

	SELECT e.ID,e.Name,e.Gender,e.Department,e.ManagerId FROM EmplyoeeIND e
	INNER JOIN EmpHierarchyCTE eh ON e.ManagerId = eh.ID
)

SELECT * FROM EmpHierarchyCTE

select * from EmployeeDetails

--#Trigger
-- special kind of sp that automatically executes when certain event occur in db (insert update delete operation in table)

--3 types
--1# Before Triggr - 
--#2 After Trigger
--#3 Instead of Trigger

--CREATE TRIGGER #triggerName 
--   ON  #tablename 
   --AFTER #INSERT_DELETE_UPDATE
   --BEFORE #INSERT_DELETE_UPDATE
   --INSERT OF INSERT_DELETE_UPDATE
--AS 
--BEGIN
--    -- Insert statements for trigger here
--END

CREATE TRIGGER dbo.EmpTriggerHistory 
   ON  [dbo].[EmpTrigger]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	INSERT INTO [dbo].[AuditEmp] 
		(EmpId
		,OldFirstName
		,NewFirstName
		,OldLastName
		,NewLastName)
	SELECT d.ID,d.FirstName,i.FirstName,d.LastName,i.LastName FROM inserted i
	INNER JOIN deleted d
	ON i.ID = d.ID

END
GO

--#Index - fast data retrive we can create index for table
--#types 1# Cluster index 2# Non-Cluster index
-- table scan & index
-- Cluster index - physically store inside table
-- nonCluster index - another place in database

SELECT * FROM [dbo].[EmpIndex] WHERE ID = 50
CREATE CLUSTERED INDEX IX_EmpIndex_ID ON [dbo].[EmpIndex](Name)
CREATE NONCLUSTERED INDEX IX_EmpIndex_NAME ON [dbo].[EmpIndex](ID)

--How to improve performance 
-- create index for table
-- select * from table - instead of * we can use colname id,name,salary
-- where clause - where salary > 12000 , id = 5 and name  = 'xyz'
-- id = 5 and name  = 'xyz' and salary > 12000 

--#Buit in func
--1# ROW_NUMBER
--2# Rank
--3# DENSE RANK

-- find nth highest salary by dense rank

select * from (
SELECT ROW_NUMBER() OVER(order by EmployeeDetails.Salary) as rn,
	   RANK() OVER(PARTITION by Department order by EmployeeDetails.Salary) as rank,
	   DENSE_RANK() OVER(PARTITION by Department order by EmployeeDetails.Salary) as dense_rank,
* FROM EmployeeDetails WHERE Department = 'IT') as t
where dense_rank = 3

--diff betw drop, delete and truncate (imp)

--truncate 
-- delete all the records from table and reset identity
-- no where condition

-- drop
-- physical table will be deleted

-- delete
-- delete perticular records from table
-- where condition we can apply
-- if we don't add where condition then all records deleted but identity can't reset