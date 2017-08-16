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

------------------------------------------------------------------
create table UserTransactions(
    WinnerWeek   varchar(50),
    UserGSM  varchar(100))
    
insert into UserTransactions
values
('w1','1000000001'),
('w2','1000000002'),
('w2','1000000003 '),
('w2','1000000002'),
('w2','1000000003 '),
('w2','1000000003 '),
('w2','1000000003 '),
('w3','1000000004'),
('w3','1000000005'),
('w3','1000000005'),
('w3','1000000005'),
('w4','1000000005'),
('w4','1000000002')

select * from UserTransactions

SELECT WinnerWeek,UserGSM, COUNT( * ) AS WeeklyCount
FROM UserTransactions
GROUP BY UserGSM,WinnerWeek