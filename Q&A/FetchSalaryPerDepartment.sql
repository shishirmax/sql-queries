--Fetch the Department Name disbursing the highest/maximum salary to the employee
CREATE TABLE DeptSalary
(
	ID INT IDENTITY(1,1),
	DeptName VARCHAR(100),
	DeptSalary INT
)

INSERT INTO DeptSalary
VALUES
('IT',5000),
('IT',7000),
('Admin',4000),
('Admin',8000),
('Admin',2000),
('HR',4300),
('HR',8700),
('HR',14300),
('IT',12456),
('IT',45800),
('Admin',20800)

SELECT * FROM DeptSalary

;WITH Result AS
(
SELECT SUM(DeptSalary) AS TotalSum,DeptName
FROM DeptSalary
GROUP BY DeptName
)
SELECT DeptName,TotalSum,DENSE_RANK() OVER(ORDER BY TotalSum DESC) AS DENSERANK FROM Result
--WHERE DENSERANK = 1
WHERE TotalSum = (SELECT MAX(TotalSum) FROM Result)


