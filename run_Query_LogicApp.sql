SELECT TOP 10 * FROM dbo.tblHomeSpotter_FF
SELECT TOP 10 * FROM dbo.tblHomeSpotter_AE
SELECT TOP 10 * FROM dbo.tblHomeSpotter_DT

TRUNCATE TABLE tblHomeSpotter_FF
TRUNCATE TABLE tblHomeSpotter_AE
TRUNCATE TABLE tblHomeSpotter_DT

select * from logTaskControlFlow
order by startTime desc
where groupID = 329

select * from logerror
--where ErrorCode = 7330
order by ErrorGenerationTime desc
--ErrorCode:7330
--ErrorDescription: For File sourcehomespotter HS_DataFeed20171213.csv Error of Severity: 16 and State: 2 occured in Line: 1 with following Message: Cannot fetch a row from OLE DB provider "BULK" for linked server "(null)".

select * from tblIntermediate_FF
select * from TableMapping
select * from vwSourcehomespotter

select * from tblHomeSpotter_FF
truncate table tblHomeSpotter

create view vwSourcehomespotter
as select * from tblHomeSpotter


select * from vwSourcehomespotter
drop view vwSourcehomespotter
drop table tblHomeSpotter


SELECT LEFT('HS_DataFeed_20171213.csv',11) 

select SUBSTRING(RIGHT('/sourcehomespotter', LEN('/sourcehomespotter') - 1) ,1,CHARINDEX('/',RIGHT('/sourcehomespotter', LEN('/sourcehomespotter') - 1))- 1 )   

declare @num int;
set @num =( next value for GetGroupId);
select @num as groupId