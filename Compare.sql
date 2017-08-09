create table tableA(
columnA varchar(50)
)

create table tableB(
columnB varchar(50)
)

select * from tableA
select * from tableB

insert into tableA
values
('Steve'),
('Jane'),
('Mary'),
('Peter'),
('Ed'),
('Scott'),
('Ted')

insert into tableB
values
('Peter'),
('Scott'),
('David'),
('Nancy')

select b.columnB, a.columnA,
case
	when a.columnA is NULL then 'False'
	else 'True'
end as Condition		
from tableB b
left join 
tableA a
on b.columnB = a.columnA


select 
   b.columnb,
   case when a.columna is null then 'FALSE' else 'TRUE' end 
from
   tableb b left outer join
   tablea a on b.columnb = a.columna