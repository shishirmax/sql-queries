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

-----------------

drop table EstimationData
Go
create table EstimationData(
    EstChargeCode varchar(100),
    EstAmount numeric(10,0))
    
insert into EstimationData
values
('CNFS0001',43250000.00),
('CNIH0001',0.00),
('CNIH0001',2625000.00),
('CNIP0001',4500000.00),
('CNIP0005',2250000.00),
('CNOH0001',20484690.00),
('CNOP0001',0.00)

select * from EstimationData

create table ActualData(
ActChargeCode varchar(100),
ActAmount numeric(9,0))

insert into ActualData
values
('CNFS0001',39950000.00),
('CNIH0001',1300000.00),
('CNIH0001',950000.00),
('CNIH0001',-950000.00),
('CNIH0001',950000.00),
('CNIP0001',4500000.00),
('CNIP0005',2250005.00),
('CNOH0001',20484690.00),
('CNOP0001',3300000.00)

select * from EstimationData
select * from ActualData

Select 
	ActualData.ActChargeCode As ChargeCode,
	CAST(EstimationData.EstAmount as decimal(10,2)) As EstimatedAmount,
	CAST(ActualData.ActAmount as decimal(10,2)) As ActualAmount
	from EstimationData
join ActualData
on EstimationData.EstChargeCode = ActualData.ActChargeCode

--MERGE EstimationData AS TARGET
--USING ActualData AS SOURCE 
--ON (TARGET.EstChargeCode = SOURCE.ActChargeCode)

--WHEN MATCHED AND TARGET.EstAmount <> SOURCE.ActAmount Then
--UPDATE SET TARGET.EstAmount = SOURCE.ActAmount

--WHEN NOT MATCHED BY TARGET THEN 
--INSERT (EstChargeCode, EstAmount) 
--VALUES (SOURCE.ActChargeCode, SOURCE.ActAmount)

--WHEN NOT MATCHED BY SOURCE THEN
--DELETE

--OUTPUT $action,
--DELETED.EstChargeCode As TargetEstChargeCode,
--DELETED.EstAmount As TargetEstAmount,
--INSERTED.EstChargeCode As SourceActChargeCode,
--INSERTED.EstAmount As SourceActAmount;
--SELECT @@ROWCOUNT;
--Go


--select numbervalue from string_split('6,7,8',',')

-----------------------------------------
--SPLIT STRING

CREATE FUNCTION [dbo].[fnSplitString] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END

select * from dbo.fnSplitString('6,7,8',',')

select patindex('%hi%','shishir')

select PATINDEX('%hir%','shishir')

select PATINDEX('%l%','I am a rockstar.')

select CHARINDEX('hi','shishir')

select * from tblEmployee
where name like 'To__'

select * from Production.Document

select CHARINDEX('arm',Title)
from Production.Document

select PATINDEX('%arm%',Title)
from Production.Document

--Query that return all the product name which are supplied by more than one vendors.

create table product(
pid int,
pname varchar(100),
vendorid int,
price int,
vendorName varchar(100))

insert into product
values
(1,'Notebook',2,25,'ITC'),
(2,'Dove',1,50,'HUL'),
(1,'Notebook',1,22,'Godrej'),
(3,'Minto',2,1,'ITC'),
(4,'Locks',3,190,'Godrej'),
(4,'Locks',1,180,'HUL'),
(3,'Minto',2,1,'ITC')

select * from product
Go

select 'There are'+cast(count(pname) as varchar)+pname from product
group by pname
order by pname

select p1.pname,p2.* from product p1
join product p2 
on p1.pname = p2.pname
and p1.vendorName<>p2.vendorName

select * from tblEmployee
cross join tblDepartment
where tblEmployee.DepartmentId = 1

select ABS(-1) as AbsoluteValue

select LEN('shishir')
select DATALENGTH('shishir')

select top 1 max(pname),LEN(max(pname)) from product  group by pname order by LEN(max(pname)) desc,pname
select top 1 min(pname),LEN(min(pname)) from product group by pname order by LEN(min(pname)),pname

select * from product for XML auto

--HackerRank
--N represents the node in Binary Tree
--P is the parent of N
create table BST(
N int,
P int)

insert into BST
values
(1,2),
(3,2),
(6,8),
(9,8),
(2,5),
(8,5),
(5,NULL)

select * from BST

select N,
case 
	when P is NULL
		then 'Root'
	when (select count(*) from BST where P=B.N)>0
		then 'Inner'
	Else 'Leaf'
end
from bst as B order by N

-----------------------------
SELECT  COALESCE(TRY_CONVERT(DATETIME, x, 105), TRY_CONVERT(DATETIME, x, 120))
FROM    (VALUES('25-10-2016'), ('2016-10-13')) a(x)

select cast('25-10-2016' as date)
SELECT CAST ('20161025' as datetime) 
select CAST('2016-10-13' as datetime)

declare @date varchar(100)
--set @date = '25-10-2016'
set @date = '2016-10-13'
select LEN(@date)
select CHARINDEX('-',@date,0)
select SUBSTRING(@date,CHARINDEX('-',@date,0)-5,LEN(@date))
select SUBSTRING(@date,charindex('-',@date,0)+1,LEN(@date))
select cast(YEAR(@date) as varchar(10))

select cast(substring(@date,charindex('-',@date,0)-5,LEN(@date))+substring(@date, charindex('-',@date,0)+1, LEN(@date))+cast(YEAR(GETDATE())as varchar(10)) as datetime)