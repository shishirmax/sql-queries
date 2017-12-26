SELECT TOP 10 * FROM dbo.tblHomeSpotter_FF
SELECT TOP 10 * FROM dbo.tblHomeSpotter_AE
SELECT TOP 10 * FROM dbo.tblHomeSpotter_DT

TRUNCATE TABLE tblHomeSpotter_FF
TRUNCATE TABLE tblHomeSpotter_AE
TRUNCATE TABLE tblHomeSpotter_DT

select * from logTaskControlFlow(NOLOCK)
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

tblHomeSpotter_FF
tblHomeSpotter_DT
tblHomeSpotter_AE

ALTER TABLE tblHomeSpotter_AE
ADD LogTaskID BIGINT;


LogTaskID BIGINT

"Container": "/sourcehomespotter/HS_DataFeed_20171219.csv",
"FileName": "HS_DataFeed_20171219.csv",
"GroupId": 402

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
		  
		--SET @SqlInter= 'BULK INSERT tblIntermediate_FF FROM '''+ @FileName + ''' WITH (DATA_SOURCE = '''+@container+''', FORMAT = ''CSV'');'
		--EXEC SP_EXECUTESQL @SqlInter	
		--PRINT @SqlInter

		--SET @SqlInter='Select @cnt=count(1) from tblIntermediate_FF'        
		--EXECUTE sp_executesql  @SqlInter,N'@cnt int OUTPUT',@countInter OUTPUT 
		--PRINT @SqlInter
		--PRINT @countInter

		SET @sql= 'BULK INSERT ' + @ViewName + ' FROM '''+ @FileName + ''' WITH (DATA_SOURCE = '''+@container+''', FORMAT = ''CSV'', FIELDTERMINATOR  = '','', FIRSTROW = 2);'          
		EXEC SP_EXECUTESQL @sql
		PRINT '@sql_3: '+@sql 
	
/*
#### ERROR
Msg 4879, Level 16, State 1, Line 69
Bulk load failed due to invalid column value in CSV data file HS_DataFeed_20171219.csv in row 2, column 1.
Msg 7399, Level 16, State 1, Line 69
The OLE DB provider "BULK" for linked server "(null)" reported an error. The provider did not give any information about the error.
Msg 7330, Level 16, State 2, Line 69
Cannot fetch a row from OLE DB provider "BULK" for linked server "(null)".
*/
	SELECT * FROM tblIntermediate_FF
	--https://contata.blob.core.windows.net/sourcehomespotter
	--https://contata.blob.core.windows.net/archivehomespotter
	SELECT 1 FROM sys.external_data_sources WHERE name = 'sourcehomespotter'
	DROP EXTERNAL DATA SOURCE sourcehomespotter 

	CREATE EXTERNAL DATA SOURCE sourcehomespotter
	WITH ( 
		TYPE = BLOB_STORAGE, 
		LOCATION = 'https://contata.blob.core.windows.net/sourcehomespotter'
		)     

SELECT * FROM sys.external_data_sources
select * from TableMapping 
select count(1) from vwSourceedinawebsitedata
select count(1) from vwSourcehomespotter
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