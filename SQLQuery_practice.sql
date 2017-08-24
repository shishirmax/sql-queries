/*
URL: http://a4academics.com/interview-questions/53-database-and-sql/397-top-100-database-sql-interview-questions-and-answers-examples-queries
*/

--fetch the tables present in the database selected
select * from sys.tables

create table tblEmployee(
Employee_id int identity(1,1),
First_Name varchar(100),
Last_Name varchar(100),
Salary bigint,
Joining_date datetime,
Department varchar(100))

insert into tblEmployee
values
('John','Abraham',10000,'01-JAN-13','Banking'),
('Michael','Clarke',80000,'01-JAN-13','Insurance'),
('Roy','Thomas',70000,'01-FEB-13','Banking'),
('Tom','Jose',60000,'01-FEB-13','Insurance'),
('Jerry','Pinto',65000,'01-FEB-13','Insurance'),
('Philip','Mathew',75000,'01-JAN-13','Services'),
('Bruce','Wayne',65000,'01-JAN-13','Services'),
('Demi','Lovato',60000,'01-FEB-13','Insurance')
truncate table tblEmployee

select MONTH(joining_date) from tblEmployee

create table tblIncentives(
Employee_ref_id int,
Incentive_date datetime,
Incentive_amount int)

insert into tblIncentives
values
(1,'01-FEB-13',5000),
(2,'01-FEB-13',3000),
(3,'01-FEB-13',4000),
(1,'01-JAN-13',4500),
(2,'01-JAN-13',3500)

select * from tblEmployee
--select * from tblIncentives

select top 5 First_Name
from tblEmployee
order by Joining_date asc

select * from tblEmployee
join tblIncentives
on
tblEmployee.Employee_id = tblIncentives.Employee_ref_id
order by tblIncentives.Incentive_date

--selecting employee details from employee table if data exist in incentive table
select * from tblEmployee where exists(select * from tblIncentives)

--Select 20 % of salary from John , 10% of Salary for Roy and for other 15 % of salary from employee table
SELECT FIRST_NAME, 
	CASE FIRST_NAME WHEN 'John' 
			THEN SALARY * .2 
		WHEN 'Roy' 
			THEN SALARY * .10 
		ELSE SALARY * .15 
	END "Deduced_Amount",
	Salary,
	Department 
FROM tblEmployee

--Select Banking as 'Bank Dept', Insurance as 'Insurance Dept' and Services as 'Services Dept' from employee table

SELECT *,
	case DEPARTMENT 
		when 'Banking' then 'Bank Dept' 
		when 'Insurance' then 'Insurance Dept' 
		when 'Services' then 'Services Dept' 
	end 
FROM tblEmployee