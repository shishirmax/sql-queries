--Get employee who where hired in last 30 days
SELECT *,DATEDIFF(DAY,HireDate,GETDATE()) AS Diff
FROM Employee
WHERE DATEDIFF(DAY,Hiredate,GETDATE()) BETWEEN 1 AND 30
ORDER BY HireDate DESC