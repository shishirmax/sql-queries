DROP TABLE IF EXISTS dbo.Employee
 
SELECT
    P.BusinessEntityID AS EmpID, P.Title, P.FirstName, P.MiddleName, P.LastName, 
    E.Gender, E.MaritalStatus, E.BirthDate AS DOB, E.HireDate AS DOJ, E.JobTitle, 
    D.Name AS DeptName, S.Rate
INTO dbo.Employee -- Create a new table here and load query data
FROM [Person].[Person] P
INNER JOIN [HumanResources].[Employee] E 
        ON E.BusinessEntityID = P.BusinessEntityID
CROSS APPLY (
    SELECT TOP 1 DepartmentID
    FROM [HumanResources].[EmployeeDepartmentHistory] DH 
    WHERE DH.BusinessEntityID = E.BusinessEntityID 
    ORDER BY StartDate DESC) EDH
INNER JOIN [HumanResources].[Department] D 
        ON D.DepartmentID = EDH.DepartmentID
INNER JOIN [HumanResources].[EmployeePayHistory] S 
        ON S.BusinessEntityID = P.BusinessEntityID
 
SELECT * FROM dbo.Employee -- 316
GO

SELECT * FROM [HumanResources].[EmployeePayHistory]

SELECT
    MIN(Salary) as minSal, 
    MAX(Salary) as maxSal, 
    AVG(Salary) as avgSal
FROM dbo.Employee




SELECT
     P.BusinessEntityID AS EmpID
    ,P.Title
    ,CONCAT(P.FirstName, ' ', P.MiddleName, ' ', P.LastName) AS EmployeeName
    ,P.Suffix
    ,E.BirthDate
    ,CASE
        WHEN E.Gender = 'M' THEN 'Male'
        ELSE 'Female'
     END as Gender
	,IIF(E.Gender = 'M','Male','Female') as Gender2
    ,IIF(E.MaritalStatus = 'S', 'Single', 'Married') as MaritalStatus
FROM Person.Person P
JOIN [HumanResources].[Employee] E
ON E.BusinessEntityID = P.BusinessEntityID

CREATE VIEW dbo.vwPersonEmployee
AS
SELECT
     P.BusinessEntityID AS EmpID
    ,P.Title
    ,CONCAT(P.FirstName, ' ', P.MiddleName, ' ', P.LastName) AS EmployeeName
    ,P.Suffix
    ,E.BirthDate
    ,CASE
        WHEN E.Gender = 'M' THEN 'Male'
        ELSE 'Female'
     END as Gender
    ,IIF(E.MaritalStatus = 'S', 'Single', 'Married') as MaritalStatus
FROM Person.Person P
JOIN [HumanResources].[Employee] E
ON E.BusinessEntityID = P.BusinessEntityID
GO

SELECT * FROM dbo.vwPersonEmployee
--WHERE Title IS NOT NULL


SELECT MaritalStatus FROM [HumanResources].[Employee]