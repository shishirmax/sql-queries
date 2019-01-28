CREATE TABLE SampleEmployee
(
	employee_id INT,
	[name] VARCHAR(100),
	months INT,
	salary INT
)

INSERT INTO SampleEmployee
VALUES
(56118,'Patrick',7,1345)
,(59725,'Lisa',11,2330)
,(74197,'Kimberly',16,4372)
,(78454,'Bonnie',8,1771)
,(83565,'Michael',6,2017)
,(98607,'Todd',5,3396)
,(99989,'Joe',9,3573)

SELECT * FROM SampleEmployee

SELECT CAST(MAX(Earnings) AS VARCHAR)+'  '+CAST(Query.EmployeeCount AS VARCHAR)
FROM
(
SELECT (months*Salary) As Earnings,COUNT(employee_id) As EmployeeCount
FROM SampleEmployee
GROUP BY employee_id,months,Salary) As Query
GROUP BY EmployeeCount

--rounded to a scale of 2 decimal places
SELECT ROUND(60.67896,2)