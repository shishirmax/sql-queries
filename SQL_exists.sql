create table StudentDetail
(
StudentID int PRIMARY KEY,
StudentName Varchar(100)
)

insert into StudentDetail
values(3,'Doe'),(4,'Bruce'),(5,'David'),(6,'Maria')

select * from StudentDetail2

update StudentDetail2
set StudentName = 'Shishir' where studentid = 1

insert into StudentDetail2
select StudentDetail.StudentID as StudentID, StudentDetail.StudentName as StuentName
from StudentDetail
where not exists(select StudentID,StudentName from StudentDetail2 where StudentDetail2.StudentID = StudentDetail.StudentID);

update StudentDetail2
set studentid = 1
where exists(select * from StudentDetail where StudentDetail.StudentID = StudentDetail2.StudentID)




if(not exists(select * from StudentDetail where StudentID = 7)
begin
insert into StudentDetail(StudentID,StudentName)
values(7,'shishir')
end
else
begin
update StudentDetail
set StudentName = 'shishir max'
where StudentID = 7
end




create table StudentTotalMarks
(
StudentID INT PRIMARY KEY,
StuentMarks INT
)

insert into StudentTotalMarks
values
(1,234),
(2,342),
(3,211),
(4,453)

select * from StudentDetail
select * from StudentTotalMarks

merge StudentTotalMarks stm
using StudentDetail sd
on 
stm.StudentID = sd.StudentID
WHEN MATCHED
THEN
UPDATE
SET
stm.StuentMarks = stm.StudentMarks + 10
WHEN NOT MATCHED THEN
INSERT(stm.StudentID,stm.StudentMarks)
VALUES(sd.StudentID,10)

create table baba(
column1 varchar(max),
column2 varchar(max)
)

select * from baba

declare @variable varchar(max)
set @variable = 
'declare @value varchar(max) = ''example''
Insert into baba
values(@value,@value)'
exec(@variable)

declare @variable varchar(max)
declare @value varchar(max) ='Sample Text'
set @variable = 
'
Insert into baba
values(cast(@value as varchar),cast(@value as varchar))'
exec(@variable)

 sp_executesql



 create table table_1(
 city varchar(100),
 country varchar(100),
 region varchar(30),
 load_date datetime
 )

 insert into table_1
 values('Mumbai','India','West',getdate())

 select * from table_1

 create table #temp
 (
 city varchar(100),
 country varchar(100),
 region varchar(30),
 load_date datetime
 );

 insert into #temp
 select
 a.city,
 a.country,
 a.region,a.load_date
 from table_1 a

 select * from #temp
 --select * from table_1
 drop table #temp