use SampleDB
GO
if exists (select * from sys.objects where OBJECT_ID = OBJECT_ID(N'[Employee]') and type in (N'U'))
begin
	drop table [Employee]
end
GO

if exists(select * from sys.objects where OBJECT_ID = OBJECT_ID(N'[Department]') and type in(N'U'))
begin
	drop table [Department]
end
GO

create table Department(
DepartmentID int not null primary key,
Name varchar(100) not null,)on [primary]

insert Department
values
(1,N'Engineering'),
(2,N'Administration'),
(3,N'Sales'),
(4,N'Marketing'),
(5,N'Finance')
Go

create table Employee(
EmployeeID int not null primary key,
FirstName varchar(50) not null,
LastName varchar(50) not null,
DepartmentID int not null references Department (DepartmentID),)on [primary]
GO
Insert Employee
values
(1,N'Shishir',N'Max',1),
(2,N'John',N'Doe',2),
(3,N'Paul',N'John',3),
(4,N'Katlin',N'Duff',3)

-- Cross Apply and Inner Join --
select * from Department D
cross apply
(
	select * from Employee E
	where E.DepartmentID = D.DepartmentID
)A
Go

select * from Department D
inner join Employee E on D.DepartmentID = E.DepartmentID
Go

-- Outer Apply and Left Outer Join

select * from Department D
outer apply
(
	select * from Employee E
	where E.DepartmentID = D.DepartmentID
)A
Go

select * from Department D
left outer join Employee E
ON D.DepartmentID = E.DepartmentID
Go

-- Apply with table-valued function
if exists (select * from sys.objects where OBJECT_ID = OBJECT_ID(N'[fn_GetAllEmpOfADept]') and type IN (N'IF'))
begin
	Drop function dbo.fn_GetAllEmpOfADept
End
Go

create function dbo.fn_GetAllEmpOfADept(@DeptID as int)
returns table
as
return
(
	select * from Employee E
	where E.DepartmentID = @DeptID
)
Go

Select * from Department D
cross apply dbo.fn_GetAllEmpOfADept(D.DepartmentID)
GO

Select * from Department D
outer apply dbo.fn_GetAllEmpOfADept(D.DepartmentID)
GO
