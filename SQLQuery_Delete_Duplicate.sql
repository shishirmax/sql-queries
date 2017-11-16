CREATE TABLE tblGrade(
Id int identity(1,1),
StudentName varchar(50),
Subject1 int,
Subject2 int,
Subject3 int,
Subject4 int,
Subject5 int,
Subject6 int)

insert into tblGrade
values
('Sally',3,3,3,3,3,3)
('John',1,1,1,1,1,1),
('Sally',3,3,3,3,3,3),
('John',1,1,1,1,1,1),
('Sally',3,3,3,3,3,3)

select * from tblGrade

with cte as
(select *,row_number() over (partition by subject1, subject2 order by subject1,subject2)as rn
from tblGrade)

delete from cte where rn>1

drop table tblGrade


select StudentName,subject1,count(*)
from tblGrade
group by subject1,StudentName
having count(*)>1