SELECT ROUND(ROUND(0.01488,3),2)

SELECT LEFT(DATENAME(MONTH,GETDATE()),3)

select 
	DATENAME(YEAR,GETDATE()) AS YEAR_COLUMN,
	DATENAME(MONTH,GETDATE()) AS MONTH_COLUMN,
	DATENAME(DAY,GETDATE()) AS DAY_COLUMN,
	DATENAME(DAYOFYEAR,GETDATE()) AS DAYOFYEAR_COLUMN,
	DATENAME(WEEKDAY,GETDATE()) AS WEEKDAY_COLUMN
		

create table tblProduct(
	ID int,
	Project_No int,
	OrderDate datetime
)

select * from tblProduct

insert into tblProduct
values
(2581,100,'2012-01-13'),
(2581,101,'2012-01-21'),
(2582,102,'2012-03-04'),
(2583,103,'2012-02-14')


select 
	LEFT(DATENAME(month,OrderDate),3) as DateColumn,
	ID,
	Project_No 
from tblProduct