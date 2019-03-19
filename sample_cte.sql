SELECT AddressID,AddressLine1,AddressLine2,City FROM Person.Address
--WHERE AddressID = 12037

SELECT COUNT(1) FROM Person.Address
SELECT COUNT(DISTINCT AddressLine1) FROM Person.Address


SELECT COUNT(1),AddressLine1,AddressLine2,City
FROM Person.Address
GROUP BY AddressLine1,AddressLine2,City
ORDER BY 1 DESC

WITH CTE AS
(
SELECT 
	AddressID
	,AddressLine1
	,AddressLine2
	,City
	,ROW_NUMBER() OVER(PARTITION BY AddressLine1,City ORDER BY City) AS RN
FROM Person.Address
)
SELECT * FROM CTE WHERE RN>1

--###########################################################################
CREATE TABLE [dbo].[Employee](  
    [EMPID] [nvarchar](30) NOT NULL,  
    [Name] [nvarchar](150) NULL,  
    [Salary] [money] NULL  
)   

INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP101', 'Vishal', 15000)  
INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP102', 'Sam', 20000)  
INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP105', 'Ravi', 10000)  
INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP106', 'Mahesh', 18000)  

SELECT * FROM Employee

SELECT 
	EMPID, 
	Name,
	Salary,  
	RANK() OVER (ORDER BY Salary DESC) AS _Rank,  
	DENSE_RANK () OVER (ORDER BY Salary DESC) AS DenseRank ,  
	ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber 
FROM Employee  

INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP108', 'Rahul', 20000)  
INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP109', 'menaka', 15000)  
INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP111', 'akshay', 20000)  

INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP102', 'Sam', 20000)  
INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP102', 'Sam', 20000)  
INSERT [dbo].[Employee] ([EMPID], [Name], [Salary]) VALUES ('EMP105', 'Ravi', 10000)  



WITH empCTE AS  
(  
SELECT *, ROW_NUMBER() OVER(PARTITION BY EMPID ORDER BY EMPID) AS rowno FROM Employee  
)  
SELECT *  FROM empCTE WHERE rowno>1  


SELECT * FROM Employee

SELECT COUNT(*),Salary FROM Employee
GROUP BY Salary
HAVING COUNT(*)>4