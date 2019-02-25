create table ranking
(
	item varchar(10)
)

insert into ranking
values
('a')
,('a')
,('a')
,('b')
,('b')
,('c')
,('d')
,('d')

select * from ranking

select 
	item
	,row_number() over(order by item)
	,rank() over(order by item)
	,dense_rank() over(order by item)
from ranking