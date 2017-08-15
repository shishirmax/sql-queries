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
		