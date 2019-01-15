--Department with highest number of employees
SELECT TOP 1 DepartmentName, COUNT(1) AS EmployeeCount
FROM Employees
JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY DepartmentName
ORDER BY EmployeeCount DESC
--This gives the Department Name with Employee Count.
--If only Department Name is required:
SELECT TOP 1 DepartmentName
FROM Employees
JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY DepartmentName
ORDER BY COUNT(1) DESC