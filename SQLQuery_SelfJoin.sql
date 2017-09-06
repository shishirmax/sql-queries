Create table tblDepartment
(
     ID int primary key,
     DepartmentName nvarchar(50),
     Location nvarchar(50),
     DepartmentHead nvarchar(50)
)
Go

Insert into tblDepartment values (1, 'IT', 'London', 'Rick')
Insert into tblDepartment values (2, 'Payroll', 'Delhi', 'Ron')
Insert into tblDepartment values (3, 'HR', 'New York', 'Christie')
Insert into tblDepartment values (4, 'Other Department', 'Sydney', 'Cindrella')
Go

Create table tblEmployee
(
     ID int primary key,
     Name nvarchar(50),
     Gender nvarchar(50),
     Salary int,
     DepartmentId int foreign key references tblDepartment(Id)
)
Go

Insert into tblEmployee values (1, 'Tom', 'Male', 4000, 1)
Insert into tblEmployee values (2, 'Pam', 'Female', 3000, 3)
Insert into tblEmployee values (3, 'John', 'Male', 3500, 1)
Insert into tblEmployee values (4, 'Sam', 'Male', 4500, 2)
Insert into tblEmployee values (5, 'Todd', 'Male', 2800, 2)
Insert into tblEmployee values (6, 'Ben', 'Male', 7000, 1)
Insert into tblEmployee values (7, 'Sara', 'Female', 4800, 3)
Insert into tblEmployee values (8, 'Valarie', 'Female', 5500, 1)
Insert into tblEmployee values (9, 'James', 'Male', 6500, NULL)
Insert into tblEmployee values (10, 'Russell', 'Male', 8800, NULL)
Go


create table tblEmpManager(
empId int,
empName varchar(100),
managerId int)

insert into tblEmpManager
values
(1,'Mike',3),
(2,'Rob',1),
(3,'Todd',Null),
(4,'Ben',1),
(5,'Sam',1)
-------------------
--Self Join

select * from tblEmployee
select * from tblDepartment

select * from tblEmpManager

select E.empName As [Employee Name],M.empName As [Manager Name]
from tblEmpManager E
left join tblEmpManager M
on E.managerId = M.empId

select E.empName As [Employee Name],COALESCE(M.empName,'No Manager') As [Manager Name]
from tblEmpManager E
left join tblEmpManager M
on E.managerId = M.empId

select ISNULL(NULL,'Sample Data') as [Sample Data]
select ISNULL('Random Data','Sample Data') as [Sample Data]

select COALESCE('Business Data','My Data') as Sample
select COALESCE(NULL,'My Data') as Sample