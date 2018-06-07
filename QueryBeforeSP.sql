SELECT TOP 10 * FROM [rba].[tblPopulationSummary_MA] --3482798 
WHERE INDID IN (SELECT INDID FROM rba.Score_MA)
Score IS NOT NULL

Invalid object name 'rba.tblPopulationSummary_MN'.
SELECT TOP 10 * FROM [rba].[tblPopulationSummary_NJ] --3633274

SELECT * 
INTO 
[rba].[tblPopulationSummary_MA_BAK]
FROM [rba].[tblPopulationSummary_MA]

SELECT * FROM [rba].[tblPopulationSummary_MA]
WHERE HHID = 'UM090655420-120068213'

--ALTER TABLE [rba].[tblPopulationSummary_MA]
--ADD  Score NUMERIC(30,20)

--ALTER TABLE [rba].[tblPopulationSummary_MA]
--ADD  ScoreDecile_ASC INT	

--ALTER TABLE [rba].[tblPopulationSummary_MA]
--ADD  ScoreDecile_DESC INT	

--ALTER TABLE [rba].[tblPopulationSummary_MA]
--ADD  IsProspect_ASC BIT	

--ALTER TABLE [rba].[tblPopulationSummary_MA]
--ADD  IsProspect_DESC BIT	

-------------------------------------------------------
--ALTER TABLE [rba].[tblPopulationSummary_NJ]
--ADD  Score NUMERIC(30,20)

--ALTER TABLE [rba].[tblPopulationSummary_NJ]
--ADD  ScoreDecile_ASC INT	

--ALTER TABLE [rba].[tblPopulationSummary_NJ]
--ADD  ScoreDecile_DESC INT	

--ALTER TABLE [rba].[tblPopulationSummary_NJ]
--ADD  IsProspect_ASC BIT	

--ALTER TABLE [rba].[tblPopulationSummary_NJ]
--ADD  IsProspect_DESC BIT	

--Score				NUMERIC(30,20)
--ScoreDecile_ASC		INT	
--ScoreDecile_DESC	INT	
--IsProspect_ASC		BIT	
--IsProspect_DESC		BIT	

SELECT TOP 10 * FROM [rahul].[tblpopulationsummary]

DECLARE @tblName NVARCHAR(MAX)
DECLARE @SubPart NVARCHAR(MAX)
SET @tblName =  LEFT('Score_MN.csv',8)
SET @SubPart = RIGHT(@tblName,2)
PRINT @tblName
PRINT @SubPart

SELECT 1 FROM information_schema.tables WHERE TABLE_SCHEMA = 'homespotter' AND TABLE_NAME = @tblName

DECLARE @TableRename NVARCHAR(MAX)
SET @TableRename=''+@tblName+''+REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 0),' ',''),':','')
PRINT @TableRename
DECLARE @TableName NVARCHAR(MAX)
SET @TableName = 'rba.'+@tblName
PRINT @TableName

DECLARE @sql NVARCHAR(MAX)
SET @sql= 'CREATE TABLE rba.'+@tblName+'
				(            
				   HHID		VARCHAR(254)          
				  ,INDID	VARCHAR(254)          
				  ,Score	VARCHAR(254)                  
				)'
PRINT(@sql)
EXEC(@sql)

--exec sp_rename 'rba.Score_MN', 'new_table_name'
SET @SQL ='SP_RENAME  '+''''+@TableName+''''+','+''''+@TableRename+''''          
PRINT @SQL 
EXEC(@SQL)

SELECT * FROM rba.Score_MA
SELECT * FROM [rba].[Score_MNJun72018955AM]
DROP TABLE rba.Score_MN
DROP TABLE [rba].[Score_MNJun72018955AM]

SP_RENAME  'rba.Score_MN','Score_MNJun72018954AM'

SELECT SYSUTCDATETIME () 
SELECT TRANSLATE(CONVERT(VARCHAR,GETDATE(),103),'/','_')

SELECT REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 0),' ',''),':','')
exec sp_rename 'rba.Score_MN', 'new_table_name'

SELECT * FROM dbo.LogError
ORDER BY ErrorID DESC

EXEC rba.[usp_AutomatedScore] '/rba/Score_MA.csv','Score_MA.csv'

SELECT * FROM rba.tempScoreDecile

DECLARE @container NVARCHAR(MAX) = '/rba/Score_MN.csv'
DECLARE @SourceContainerURL NVARCHAR(MAX)
DECLARE @sql NVARCHAR(MAX)
SET  @container    = SUBSTRING(RIGHT(@Container, LEN(@Container) - 1) ,1,CHARINDEX('/',RIGHT(@Container, LEN(@Container) - 1))- 1 )
SET  @SourceContainerURL  = 'https://contata.blob.core.windows.net/' + @Container 
IF EXISTS(SELECT 1 FROM sys.external_data_sources WHERE NAME = @container)                              
			SET @sql ='DROP EXTERNAL DATA SOURCE '+ @container                              
			EXEC SP_EXECUTESQL @sql
			PRINT 2.0
			SET @sql = 'CREATE EXTERNAL DATA SOURCE '+@container+ '                           
			WITH ( TYPE = BLOB_STORAGE, LOCATION = '''+ @SourceContainerURL+''');' 
			PRINT 2.1
			EXEC SP_EXECUTESQL @sql
			PRINT 2.3                

