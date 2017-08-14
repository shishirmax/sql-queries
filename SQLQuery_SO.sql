create table employee(
empno int,
ename varchar(100),
job varchar(100),
mgr varchar(100),
hiredate datetime,
sal int,
commission int,
deptno int)

insert into employee
values
(001,'John Doe','Dev','Bruce Wayne',getdate(),4500,100,101),
(002,'Donald Duck','Test','Superman',getdate(),6500,80,102),
(003,'Mickey Mouse','IT','Batman',getdate(),7000,70,103)

select * from employee

select 
	ename,
	commission,
	increased_commission = (commission*1.1) 
from employee