--SO LINK
--https://stackoverflow.com/questions/45691537/dynamic-pivot-not-displaying-right-output


create table SOHelp(
YearMonth varchar(50),
Users int)

insert into SOHelp
values
('1996-06',1256),
('1997-07',1243)

Select [ ]='User',*
 From  (
          SELECT [YearMonth], Users
           FROM dbo.SOHelp
       ) A
 Pivot (max(Users) For [YearMonth] in ([1996-06],[1997-07]) ) p

 select * from SOHelp

 select [ ]='User',*
		from
		(
		select users,yearmonth from SOHelp
		)as PivotData
		pivot
		(
		max(users) for yearmonth in
		([1996-06],[1997-07]))as Pivoting

--https://stackoverflow.com/questions/53273744/how-to-create-data-become-column

CREATE TABLE SOPivot(
	Room INT
	,Block VARCHAR
	,Data INT
	)

INSERT INTO SOPivot
VALUES
(1,'A',12),
(2,'A',13),
(1,'B',14),
(3,'B',15)

SELECT * FROM SOPivot

select [Room],
		[A] as A,
		[B] as B
from
--Step2 get the actual data
(
select Room,
		Block,
		Data
		From SOPivot
) as PivotData

--step3 pivot function
pivot
(
sum(Data) for Block in 
(A,B))as Pivoting
order by Room 

