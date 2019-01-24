SELECT * FROM tblEmployee

SELECT AVG(Salary) FROM tblEmployee
SELECT CEILING(AVG(Salary)-AVG(CAST(REPLACE(Salary,'0','') AS INT))) FROM tblEmployee

CREATE TABLE hEmployees
(
	ID INT,
	Name VARCHAR(100),
	Salary INT
)

INSERT INTO hEmployees
VALUES
(1,'Kristeen',1420)
,(2,'Ashley',2006)
,(3,'Julia',2210)
,(4,'Maria',3000)

SELECT * FROM hEmployees

SELECT AVG(Salary) FROM hEmployees
SELECT AVG(CAST(REPLACE(Salary,'0','') AS INT)) FROM hEmployees

SELECT ROUND(AVG(Salary) - AVG(CAST(REPLACE(Salary,'0','') AS INT)),1) FROM hEmployees
