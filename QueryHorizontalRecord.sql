create table usertable(
userid int,
name varchar(50),
postid int)

insert into usertable
values
(1,'John',1),
(2,'Peter',2),
(3,'Susan',2),
(4,'Ben',3),
(5,'Ken',4),
(6,'Mary',5)

create table postTable(
postid int,
postTitle varchar(50),
managerPostId int)

insert into postTable
values
(1,'AO',2),
(2,'SSM',3),
(3,'CSM',NULL),
(4,'AP',5),
(5,'SA',6),
(6,'PM',NULL)

select * from usertable
select * from postTable

select UT.userid,UT.name,PT.posttitle,PT.managerPostId
from usertable UT
join
postTable PT on UT.postid = PT.postid

