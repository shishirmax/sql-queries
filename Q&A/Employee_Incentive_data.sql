CREATE TABLE Employee
(
	Employee_id INT
	,First_name VARCHAR(100)
	,Last_name VARCHAR(100)
	,Salary INT
	,Joining_date DATETIME
	,Department VARCHAR	
)

INSERT INTO Employee
VALUES
(1,'John','Abraham',1000000,'01-JAN-13','Banking')
,(2,'Michael','Clarke',800000,'01-JAN-13','Insurance')
,(3,'Roy','Thomas',700000,'01-FEB-13','Banking')
,(4,'Tom','Jose',600000,'01-FEB-13','Insurance')
,(5,'Jerry','Pinto',650000,'01-FEB-13','Insurance')
,(6,'Philip','Mathew',750000,'01-JAN-13','Services')
,(7,'TestName1','123',650000,'01-JAN-13','Services')
,(8,'TestName2','Lname',600000,'01-FEB-13','Insurance')


CREATE TABLE Incentives
(
	Employee_ref_id INT
	,Incentive_date DATETIME
	,Incentive_amount INT
)

INSERT INTO Incentives
VALUES
(1,'01-FEB-13',5000)
,(2,'01-FEB-13',3000)
,(3,'01-FEB-13',4000)
,(1,'01-JAN-13',4500)
,(2,'01-JAN-13',3500)

SELECT TRY_CAST('01-JAN-13' AS DATETIME)

ALTER TABLE Employee
ALTER COLUMN Department VARCHAR(100)

SELECT * FROM Employee
SELECT * FROM Incentives

select * from EMPLOYEE where exists (select * from INCENTIVES)

SELECT 
	FIRST_NAME, 
	CASE FIRST_NAME 
		WHEN 'John' 
			THEN SALARY * .2 
		WHEN 'Roy' 
			THEN SALARY * .10 
		ELSE SALARY * .15 
	END "Deduced_Amount",
	Salary 
FROM EMPLOYEE

--Write a query to rank employees based on their incentives for a month
SELECT * FROM Employee
SELECT * FROM Incentives

SELECT E.Employee_id,E.Salary,I.Incentive_amount,I.Incentive_date,DENSE_RANK() OVER(PARTITION BY I.Incentive_date ORDER BY I.Incentive_amount DESC) As EmpRank
FROM Employee E
JOIN Incentives I
ON E.Employee_id = I.Employee_ref_id


--Select first_name, incentive amount from employee and incentives table for those employees who have incentives

SELECT E.First_name,I.Incentive_amount
FROM Employee E
INNER JOIN Incentives I
ON E.Employee_id = I.Employee_ref_id

--Select first_name, incentive amount from employee and incentives table for those employees who have incentives and incentive amount greater than 3000

SELECT E.First_name,I.Incentive_amount
FROM Employee E
INNER JOIN Incentives I
ON E.Employee_id = I.Employee_ref_id
AND I.Incentive_amount>3000

SELECT E.First_name,I.Incentive_amount
FROM Employee E
INNER JOIN Incentives I
ON E.Employee_id = I.Employee_ref_id
WHERE I.Incentive_amount>3000