--Derived tables and common table expressions in sql server
create table tbldepartment
(deptid int identity(1,1),
deptname varchar(100))

insert into tbldepartment
values
('IT'),
('Payroll'),
('HR'),
('Admin')

create table tblEmployee(
id int identity(1,1),
name varchar(100),
Gender varchar(10),
departmentid int)

insert into tblEmployee
values
('John','Male',3),
('Mike','Male',2),
('Pam','Female',1),
('Todd','Male',4),
('Sara','Female',1),
('Ben','Male',3)

insert into tbldepartment
values
('Pantry')
insert into tblEmployee
values
('Brad','Male',5)


select * from tblEmployee
select * from tbldepartment

create view VwEmployeeCount
as
select tbldepartment.deptname,tbldepartment.deptid,count(*) as TotalEmployee
from tblEmployee
join
tbldepartment
on
tblEmployee.departmentid = tbldepartment.deptid
group by tbldepartment.deptid,tbldepartment.deptname

select * from VwEmployeeCount

select deptname,totalemployee
from VwEmployeeCount
--order by deptid
where TotalEmployee>=2

--Table Variable

Declare @tblEmployeeCount table(DeptName varchar(100),DepartmentID int,TotalEmployees int)

insert @tblEmployeeCount
select tbldepartment.deptname,tbldepartment.deptid,count(*) as TotalEmployee
from tblEmployee
join
tbldepartment
on
tblEmployee.departmentid = tbldepartment.deptid
group by tbldepartment.deptid,tbldepartment.deptname

select deptname,totalemployees
from @tblEmployeeCount
where TotalEmployees>=2

--Derived Tables

select DeptName, TotalEmployees
from
	(
	select tbldepartment.deptname,tbldepartment.deptid,count(*) as TotalEmployees
	from tblEmployee
	join
	tbldepartment
	on
	tblEmployee.departmentid = tbldepartment.deptid
	group by tbldepartment.deptid,tbldepartment.deptname
	)
as EmployeeCount
where TotalEmployees>=2

--CTE
/*
A CTE can be thought of as a temporart result set that is defined within the execution scope of a single SELECT, INSERT, UPDATE, DELETE, or CREATE VIEW
statement. A CTE is similar to a derived table in that it is not stored as an object and last only for the duration of the query.
*/

With EmployeeCount(DeptName, Departmentidm, TotalEmployees)
as
(
	select tbldepartment.deptname,tbldepartment.deptid,count(*) as TotalEmployees
	from tblEmployee
	join
	tbldepartment
	on
	tblEmployee.departmentid = tbldepartment.deptid
	group by tbldepartment.deptid,tbldepartment.deptname
)
Select DeptName, TotalEmployees
From EmployeeCount
where TotalEmployees>=2


--CTE
with EmployeeCount(DeptId, Total)
as
(
	select Departmentid, count(*) as TotalEmployees
	from tblEmployee
	group by departmentid
)

select DepartmentName,DeptId,Total
from tbldepartment
join EmployeeCount
on tbldepartment.ID = EmployeeCount.DeptId
order by Total

select * from tblEmployee
select * from tblDepartment

--multiple CTE's using a single WITH clause
with EmployeesCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
(
	select DepartmentName, COUNT(DepartmentId) as TotalEmployees
	from tblEmployee
	join tblDepartment
	on tblEmployee.DepartmentId = tblDepartment.ID
	where DepartmentName in('Payroll','IT')
	group by DepartmentName
),
EmployeesCountBy_HR_Other_Dept(DepartmentName, Total)
as
(
	select DepartmentName, COUNT(DepartmentId) as TotalEmployees
	from tblEmployee
	join tblDepartment
	on tblEmployee.DepartmentId = tblDepartment.ID
	where DepartmentName in('HR','Other Department')
	group by DepartmentName
)
select * from EmployeesCountBy_Payroll_IT_Dept
union
select * from EmployeesCountBy_HR_Other_Dept