select * from sys.tables

create table myTable(
id int,
time int,
status varchar(10))

insert into myTable
values
(1,10,'B'),
(1,20,'B'),
(1,30,'C'),
(1,70,'C'),
(1,100,'B'),
(1,490,'D')

select * from myTable

select * from 
(select *, RANK() over(partition by status order by time desc) as rn from myTable)T
where rn = 1