Create table Worker
(
     ID int primary key identity,
     FirstName nvarchar(50),
     LastName nvarchar(50),
     Gender nvarchar(50),
     Salary int
)

Insert into Worker values 
('Ben', 'Hoskins', 'Male', 70000),
('Mark', 'Hastings', 'Male', 60000),
('Steve', 'Pound', 'Male', 45000),
('Ben', 'Hoskins', 'Male', 70000),
('Philip', 'Hastings', 'Male', 45000),
('Mary', 'Lambeth', 'Female', 30000),
('Valarie', 'Vikings', 'Female', 35000),
('John', 'Stanmore', 'Male', 80000),
('Bruce', 'Wayne', 'Male', 95000),
('Leeds', 'Sean','Female', 35000)
GO

--use MAX() function to get the maximum salary
select * from Worker

select max(salary) as salary from Worker

-- get second highest salary using sub query

select max(salary) from Worker
where Salary <(select MAX(salary) from Worker)

-- get nth highest salary using sub query
-- replace N with the number

select * from Worker
order by salary desc
Go

declare @n int
set @n = 3 
select top 1 salary from
(select distinct top (@n) salary
from Worker
order by salary desc) result
order by Salary

-- using CTE(Common Table Expression)
select salary,DENSE_RANK() over(order by salary desc) as denserank
from Worker
Go

with result as
(select salary,DENSE_RANK() over(order by salary desc) as denserank
from Worker)
select top 1 salary
from result
where denserank = 2

--3rd highest salary
--The below query will only work if there are no duplicates.
with result as
(
select salary,
	ROW_NUMBER() over(order by salary desc) as rownumber
	from Worker
)
select salary
from result
where rownumber = 3