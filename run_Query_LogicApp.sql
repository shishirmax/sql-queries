SELECT TOP 10 * FROM dbo.tblHomeSpotter_FF
SELECT TOP 10 * FROM dbo.tblHomeSpotter_AE
SELECT TOP 10 * FROM dbo.tblHomeSpotter_DT

TRUNCATE TABLE tblHomeSpotter_FF
TRUNCATE TABLE tblHomeSpotter_AE
TRUNCATE TABLE tblHomeSpotter_DT

select * from logTaskControlFlow
order by 1 desc

select * from logerror
order by 1 desc

--select * from logTaskControlFlow
--order by 1 desc
----where groupID = 329

--select * from logerror
----where ErrorCode = 7330
--order by ErrorGenerationTime desc
--ErrorCode:7330
--ErrorDescription: For File sourcehomespotter HS_DataFeed20171213.csv Error of Severity: 16 and State: 2 occured in Line: 1 with following Message: Cannot fetch a row from OLE DB provider "BULK" for linked server "(null)".

select * from tblIntermediate_FF
 
select * from vwSourcehomespotter

select * from tblHomeSpotter_FF
truncate table tblHomeSpotter

create view vwSourcehomespotter
as select * from tblHomeSpotter


select * from vwSourcehomespotter
drop view vwSourcehomespotter
drop table tblHomeSpotter

--exec [usp_LoadHSFlatToFF] @Container='/sourcehomespotter/HS_DataFeed_20171217.csv',@FileName='HS_DataFeed_20171217.csv',@GroupId=380         
--exec [usp_LoadHSFlatToFF]'/sourcehomespotter/HS_DataFeed_20171217.csv','HS_DataFeed_20171217.csv',380


SELECT LEFT('HS_DataFeed_20171213.csv',11) 

select SUBSTRING(RIGHT('/sourcehomespotter', LEN('/sourcehomespotter') - 1) ,1,CHARINDEX('/',RIGHT('/sourcehomespotter', LEN('/sourcehomespotter') - 1))- 1 )   

declare @num int;
set @num =( next value for GetGroupId);
select @num as groupId

select recordType,count(1) from tbleCRVStandardAddressApi
group by recordType

tblHomeSpotter_FF
tblHomeSpotter_DT
tblHomeSpotter_AE

ALTER TABLE tblHomeSpotter_AE
ADD LogTaskID BIGINT;


LogTaskID BIGINT