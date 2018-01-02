SELECT TOP 10 * FROM dbo.tblHomeSpotter_FF
SELECT TOP 10 * FROM dbo.tblHomeSpotter_AE
SELECT TOP 10 * FROM dbo.tblHomeSpotter_DT

TRUNCATE TABLE tblHomeSpotter_FF
TRUNCATE TABLE tblHomeSpotter_AE
TRUNCATE TABLE tblHomeSpotter_DT

select * from logTaskControlFlow(NOLOCK)-- where FeedName = 'HS_DataFeed'
order by 1 desc

select * from logerror(NOLOCK)
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

select count(1) from tblHomeSpotter_FF
select count(1) from tblHomeSpotter_DT
select count(1) from tblHomeSpotter_AE

select * from tblHomeSpotter_DT
ALTER TABLE tblHomeSpotter_AE
ADD LogTaskID BIGINT;


LogTaskID BIGINT

"Container": "/sourcehomespotter/HS_DataFeed_20171219.csv",
"FileName": "HS_DataFeed_20171219.csv",
"GroupId": 402
exec [usp_LoadHSFlatToFF]'/sourcehomespotter/HS_DataFeed_20171224.csv','HS_DataFeed_20171224.csv',380 

BULK INSERT tblIntermediate_FF FROM 'HS_DataFeed_20171224.csv' WITH (DATA_SOURCE = 'sourcehomespotter');

declare
	@Container NVARCHAR(127) = '/sourcehomespotter/HS_DataFeed_20171219.csv',
	@FileName NVARCHAR(127) = 'HS_DataFeed_20171224.csv',
	@SqlInter  				NVARCHAR(MAX),
	@Sql     				NVARCHAR(MAX),  
	@SourceContainerURL		NVARCHAR(MAX),
	@ArchiveContainerURL	NVARCHAR(MAX),   
	@ViewName				NVARCHAR(127),
	@countInter	 			BIGINT,
	@TableName				NVARCHAR(127)

	SET @container = SUBSTRING(RIGHT(@Container, LEN(@Container) - 1) ,1,CHARINDEX('/',RIGHT(@Container, LEN(@Container) - 1))- 1 )
	PRINT 'Container: '+@container
	SELECT @ViewName = ViewName ,@TableName=TableName_FF  FROM TableMapping WHERE SourceContainerName = @Container
	PRINT 'ViewName: '+@Viewname 
	PRINT 'TableName: '+@TableName
	PRINT 'FileName: '+@FileName
	SET  @SourceContainerURL  = 'https://contata.blob.core.windows.net/' + @Container  
	PRINT 'SourceContainerURL: '+@SourceContainerURL
	SET  @ArchiveContainerURL = 'https://contata.blob.core.windows.net/' + REPLACE(@Container,'source','archive')
	PRINT 'ArchiveContainerURL: '+@ArchiveContainerURL 
	 IF EXISTS(SELECT 1 FROM sys.external_data_sources WHERE name = @container)          
		SET @sql ='DROP EXTERNAL DATA SOURCE '+ @container          
        EXEC SP_EXECUTESQL @sql
		PRINT '@sql_1: '+@sql

		SET @sql = 'CREATE EXTERNAL DATA SOURCE '+@container+ '       
		WITH ( TYPE = BLOB_STORAGE, LOCATION = '''+ @SourceContainerURL+''');'                          
		EXEC SP_EXECUTESQL @sql
		PRINT '@sql_2: '+@sql
		  
		SET @SqlInter= 'BULK INSERT tblIntermediate_FF FROM '''+ @FileName + ''' WITH (DATA_SOURCE = '''+@container+''', FORMAT = ''CSV'',FIRSTROW = 2);'
		EXEC SP_EXECUTESQL @SqlInter	
		PRINT @SqlInter

		SET @SqlInter='Select @cnt=count(1) from tblIntermediate_FF'        
		EXECUTE sp_executesql  @SqlInter,N'@cnt int OUTPUT',@countInter OUTPUT 
		PRINT @SqlInter
		PRINT @countInter

		SET @sql= 'BULK INSERT ' + @ViewName + ' FROM '''+ @FileName + ''' WITH (DATA_SOURCE = '''+@container+''', FORMAT = ''CSV'', FIELDTERMINATOR  = '','', FIRSTROW = 2);'          
		EXEC SP_EXECUTESQL @sql
		PRINT '@sql_3: '+@sql 

		BULK INSERT homeSpotter.tblHomeSpotter_bcp FROM 'HS_DataFeed_20171224.csv' WITH (DATA_SOURCE = 'sourcehomespotter', FORMAT = 'CSV', FIELDTERMINATOR  = ',', FIRSTROW = 2);

		BULK INSERT tblIntermediate_FF FROM 'HS_DataFeed_20171224.csv' WITH (DATA_SOURCE = 'sourcehomespotter', FORMAT = 'CSV',FIRSTROW = 2);
	
/*
#### ERROR
Msg 4879, Level 16, State 1, Line 69
Bulk load failed due to invalid column value in CSV data file HS_DataFeed_20171219.csv in row 2, column 1.
Msg 7399, Level 16, State 1, Line 69
The OLE DB provider "BULK" for linked server "(null)" reported an error. The provider did not give any information about the error.
Msg 7330, Level 16, State 2, Line 69
Cannot fetch a row from OLE DB provider "BULK" for linked server "(null)".
*/
	--TRUNCATE TABLE tblHomeSpotter
	SELECT TOP 10 * FROM tblHomeSpotter
	SELECT * FROM tblIntermediate_FF
	SELECT TOP 10 * FROM tblEdinaEmailResults_FF
	--https://contata.blob.core.windows.net/sourcehomespotter
	--https://contata.blob.core.windows.net/archivehomespotter
	SELECT 1 FROM sys.external_data_sources WHERE name = 'sourcehomespotter'
	SELECT * FROM sys.external_data_sources
	DROP EXTERNAL DATA SOURCE sourcehomespotter 

	CREATE EXTERNAL DATA SOURCE sourcehomespotter
	WITH ( 
		TYPE = BLOB_STORAGE, 
		LOCATION = 'https://contata.blob.core.windows.net/sourcehomespotter'
		)     


select * from Edina.TableMapping 
select count(1) from vwSourceedinawebsitedata
select count(1) from vwSourcehomespotter


CREATE VIEW vwSourcehomespotter
AS
SELECT 
	[user_id]
	,[user]
	,hs_agent_id
	,agent_name
	,device_id
	,ip_address
	,session_start_utc
	,session_end_guess_utc
	,session_end_is_guess
	,event_count_listing_view
	,event_count_run_saved_search
	,event_count_add_saved_listing
	,event_count_search_for_agent
	,event_count_share_app
	,event_count_app_feedback
	,event_count_call_company
	,event_count_open_mortgage_calc
FROM tblHomeSpotter_FF
select count(1) from tblHomeSpotter_FF

 "status": 504,
 "message": "Execution Timeout Expired.  The timeout period elapsed prior to completion of the operation or the server is not responding.\r\nclientRequestId: 5e8aefbf-a786-49f7-98d6-23c94649bbaf",
 "source": "sql-logic-cp-eastus.logic-ase-eastus.p.azurewebsites.net"

 --HomeSpotter data load failed with error: Cannot fetch a row from OLE DB provider "BULK" for linked server "(null)".


 /*
 Container: sourcehomespotter
ViewName: vwSourcehomespotter
TableName: tblHomeSpotter_FF
FileName: HS_DataFeed_20171224.csv
SourceContainerURL: https://contata.blob.core.windows.net/sourcehomespotter
ArchiveContainerURL: https://contata.blob.core.windows.net/archivehomespotter
@sql_1: DROP EXTERNAL DATA SOURCE sourcehomespotter
@sql_2: CREATE EXTERNAL DATA SOURCE sourcehomespotter       
		WITH ( TYPE = BLOB_STORAGE, LOCATION = 'https://contata.blob.core.windows.net/sourcehomespotter');

(17043 rows affected)
@sql_3: BULK INSERT vwSourcehomespotter FROM 'HS_DataFeed_20171224.csv' WITH (DATA_SOURCE = 'sourcehomespotter', FORMAT = 'CSV', FIELDTERMINATOR  = ',', FIRSTROW = 2);
 */

 TRUNCATE TABLE homeSpotter.tblHomeSpotter_bcp

select TOP 100 * from homeSpotter.tblHomeSpotter_bcp

SELECT COUNT(1) As tblHomeSpotter_bcp FROM homeSpotter.tblHomeSpotter_bcp(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_FF FROM homeSpotter.tblHomeSpotter_FF(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_DT FROM homeSpotter.tblHomeSpotter_DT(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_AE FROM homeSpotter.tblHomeSpotter_AE(NOLOCK)

SELECT COUNT(1) As DimAgent					FROM homeSpotter.DimAgent
SELECT COUNT(1) As DimDevice				FROM homeSpotter.DimDevice
SELECT COUNT(1) As DimSession				FROM homeSpotter.DimSession
SELECT COUNT(1) As DimUser					FROM homeSpotter.DimUser
SELECT COUNT(1) As FactHomeSpotter			FROM homeSpotter.FactHomeSpotter
SELECT COUNT(1) As FactHomeSpotterSummary	FROM homeSpotter.FactHomeSpotterSummary


SELECT  * FROM homeSpotter.DimAgent
SELECT  * FROM homeSpotter.DimDevice
SELECT  * FROM homeSpotter.DimSession
SELECT  * FROM homeSpotter.DimUser
SELECT  * FROM homeSpotter.FactHomeSpotter
SELECT  * FROM homeSpotter.FactHomeSpotterSummary

SELECT * FROM (
                             SELECT ROW_NUMBER() OVER(ORDER BY crvNumberId, ID, recordType) AS Number,
                               crvNumberId AS crvNumberId,
                               ID   AS ID,
                               recordType AS recordType,
                               REPLACE(CASE WHEN AddressLine1 = 'NA'
												THEN ' '
											WHEN AddressLine1 LIKE 'c/o%'
												THEN 
													CASE WHEN PATINDEX('%[0-9]%',AddressLine1) > 0 THEN SUBSTRING (  AddressLine1,PATINDEX('%[0-9]%',AddressLine1) , LEN(AddressLine1) ) ELSE ' ' END
											ELSE AddressLine1
										END+' '+
                               CASE WHEN AddressLine2 = 'NA' THEN ' ' ELSE AddressLine2 END +' '+
                               CASE WHEN City   = 'NA' THEN ' ' ELSE City  END +', '+
                               CASE WHEN State   = 'NA' THEN ' ' ELSE State   END+', '+
                               CASE WHEN Zip   = 'NA' THEN ' ' ELSE Zip  END,'#','') [Address]
                             FROM tblEcrvAddress (NOLOCK)
                             WHERE crvNumberId >= 655366 AND recordType != 'eCRV_property_add'
                            ) AS TBL
                        WHERE Number BETWEEN ((' + PageNumber + ' - 1)  500 + 1) AND (' + PageNumber + '   500)
                        ORDER BY TBL.Number
                             

select max(crvNumberId) from tbleCRVStandardAddressApi
where recordType != 'eCRV_property_add' --485483

select TOP 10 * from tblEcrvAddress
where crvNumberId >= 294012 AND recordType != 'eCRV_property_add'

select count(1) from tbleCRVStandardAddressApi -- 3024560
where recordType != 'eCRV_property_add' --2542308

select * from tbleCRVStandardAddressApi
where crvNumberId = 485484 and recordType != 'eCRV_property_add'

Select *,ROW_NUMBER() OVER(PARTITION BY [Address] ORDER BY [Address]) as rNumber		
into #tempTbl
from tbleCRVStandardAddressApi --26sec
--where recordType != 'eCRV_property_add'
order by recordType

select count(1) from #tempTbl

select TOP 100 * from #tempTbl
where recordType = 'eCRV_buyer1_property_add'

select COUNT(1) from #tempTbl
where formatted_address = 'NA' --1581550

select * from tblEcrvAddress
where crvNumberId = 120649


SELECT recordType,count(1) as TCount from tblEcrvAddress
group by recordType

/* records in tblEcrvAddress
|recordType					|TCount	|
|---------------------------|-------|
|eCRV_buyer1_property_add	|718940	|
|eCRV_property_add			|482257	|
|eCRV_seller1_property_add	|751820	|
*/

SELECT recordType,count(1) as TCount from tbleCRVStandardAddressApi
group by recordType

/* records in tbleCRVStandardAddressApi
|recordType					|TCount	 |
|---------------------------|--------|
|eCRV_buyer1_property_add	|1240168 |
|eCRV_property_add			|482252	 |
|eCRV_seller1_property_add	|1302140 |
*/

SELECT recordType,count(1) as TCount from tbleCRVStandardAddressApi
where formatted_address = 'NA'
group by recordType

/* records in tbleCRVStandardAddressApi when formatted_address = 'NA'
|recordType					|TCount	|
|---------------------------|-------|
|eCRV_buyer1_property_add	|718648	|
|eCRV_property_add			|100875	|
|eCRV_seller1_property_add	|762027	|
*/

SELECT recordType,count(1) as TCount from tbleCRVStandardAddressApi
where formatted_address != 'NA'
group by recordType

/* records in tbleCRVStandardAddressApi when formatted_address != 'NA'
|recordType					|TCount	|
|---------------------------|-------|
|eCRV_buyer1_property_add	|521520	|
|eCRV_property_add			|381377	|
|eCRV_seller1_property_add	|540113	|
*/


select count(*)  from #tempTbl
where recordType = 'eCRV_seller1_property_add' and formatted_address <> 'NA'

select TOP 5 * from tbleCRVStandardAddressApi
where recordType != 'eCRV_property_add'
order by 1 desc 



select count(1) from tblEcrvAddress  --1953017
where recordType != 'eCRV_property_add' --1470760

select max(crvNumberId) from tblEcrvAddress --655366
where recordType != 'eCRV_property_add'

select max(crvNumberId) from tbleCRVStandardAddressApi --655366
where recordType != 'eCRV_property_add' --485483


drop table #tempTbl