SELECT COUNT(1) FROM homeSpotter.DimAgent
SELECT COUNT(1) FROM homeSpotter.DimDevice
SELECT COUNT(1) FROM homeSpotter.DimSession
SELECT COUNT(1) FROM homeSpotter.DimUser
SELECT COUNT(1) FROM homeSpotter.FactHomeSpotter
SELECT COUNT(1) FROM homeSpotter.FactHomeSpotterSummary
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotter_AE
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotter_bcp
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotter_DT
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotter_FF
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_AE
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_bcp
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_DT
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_FF

--CREATE SEQUENCE [dbo].[GetGroupId] 
-- AS [int]
-- START WITH 1
-- INCREMENT BY 1
-- MINVALUE -2147483648
-- MAXVALUE 2147483647
-- CACHE 

--HomeSpotter
bcp homeSpotter.tblHomeSpotter_bcp in D:\Edina\HomeSpotterFeed\17Dec17\edina_contata_sessions.csv -S tcp:contata.database.windows.net -d Edina_QA -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","

--HomeSpotterHistory
bcp homeSpotter.tblHomeSpotterHistory_bcp in D:\Edina\HomeSpotterFeed\HistoryData\contata_history-11-30-17_TestCopy.csv -S tcp:contata.database.windows.net -d Edina_QA -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","


--SELECT * FROM homeSpotter.tblHomeSpotter_bcp WHERE [session_end_guess_utc] IS NOT NULL AND TRY_CAST([session_end_guess_utc] as datetime) IS NULL; 

EXEC homeSpotter.usp_InsertHomeSpotter

EXEC homeSpotter.usp_MergeHomeSpotter

select * from logtaskControlFlow order by 1 desc --365

SELECT * FROM homeSpotter.tblHomeSpotter_bcp
SELECT * FROM homeSpotter.tblHomeSpotter_FF
SELECT * FROM homeSpotter.tblHomeSpotter_DT
SELECT * FROM homeSpotter.tblHomeSpotter_AE ORDER BY 1 DESC



select * from logerror order by 1 desc --176

SELECT * FROM homeSpotter.DimAgent
SELECT * FROM homeSpotter.DimDevice
SELECT * FROM homeSpotter.DimSession
SELECT * FROM homeSpotter.DimUser
SELECT * FROM homeSpotter.FactHomeSpotter
SELECT * FROM homeSpotter.FactHomeSpotterSummary

--TRUNCATE TABLE homeSpotter.DimAgent
--TRUNCATE TABLE homeSpotter.DimDevice
--TRUNCATE TABLE homeSpotter.DimSession
--TRUNCATE TABLE homeSpotter.DimUser
--TRUNCATE TABLE homeSpotter.FactHomeSpotter
--TRUNCATE TABLE homeSpotter.FactHomeSpotterSummary


EXEC homeSpotter.usp_InsertHomeSpotterHistory

EXEC homeSpotter.usp_MergeHomeSpotterHistory

SELECT * FROM homeSpotter.tblHomeSpotterHistory_bcp
SELECT * FROM homeSpotter.tblHomeSpotterHistory_FF
SELECT * FROM homeSpotter.tblHomeSpotterHistory_DT
SELECT * FROM homeSpotter.tblHomeSpotterHistory_AE

--TRUNCATE TABLE homeSpotter.tblHomeSpotterHistory_bcp
--TRUNCATE TABLE homeSpotter.tblHomeSpotterHistory_FF
--TRUNCATE TABLE homeSpotter.tblHomeSpotterHistory_DT
--TRUNCATE TABLE homeSpotter.tblHomeSpotterHistory_AE

--(105 rows affected)
--UPDATE [homeSpotter].[tblHomeSpotter_FF] SET GoodToImport = 0, ErrorDescription = CONCAT(ErrorDescription,'| Error Column Name is [session_end_is_guess] ' + 'and value is : ('+ CAST([session_end_is_guess] as nvarchar(max))+')') WHERE [session_end_is_guess] IS NOT NULL AND TRY_CAST([session_end_is_guess] as int) IS NULL; 

--(1 row affected)
--UPDATE [homeSpotter].[tblHomeSpotter_FF] SET GoodToImport = 0, ErrorDescription = CONCAT(ErrorDescription,'| Error Column Name is [session_end_guess_utc] ' + 'and value is : ('+ CAST([session_end_guess_utc] as nvarchar(max))+')') WHERE [session_end_guess_utc] IS NOT NULL AND TRY_CAST([session_end_guess_utc] as datetime) IS NULL; 

--(64 rows affected)
--UPDATE [homeSpotter].[tblHomeSpotter_FF] SET GoodToImport = 0, ErrorDescription = CONCAT(ErrorDescription,'| Error Column Name is [ModifiedDate] ' + 'and value is : ('+ CAST([ModifiedDate] as nvarchar(max))+')') WHERE [ModifiedDate] IS NOT NULL AND TRY_CAST([ModifiedDate] as datetime) IS NULL; 

--sp_helptext sp_RENAME
--sp_RENAME 'homeSpotter.tblHomeSpotterHistory_DT.HS_DT_ID','HSHistoryId','COLUMN' --Done
--sp_RENAME 'homeSpotter.tblHomeSpotterHistory_FF.HS_FF_ID','HSHistoryId','COLUMN' --Done
--sp_RENAME 'homeSpotter.tblHomeSpotterHistory_AE.HS_AE_ID','HSHistoryId','COLUMN' --Done
select * from sys.tables t
where t.name = 'tblHomeSpotter_DT'

DECLARE @ctr int;  
DECLARE @temp AS TABLE
		(
			colname			NVARCHAR(255)
			,datatype		NVARCHAR(255)
			,datatypeLength INT
			,rownum			INT
		); 
INSERT INTO @temp 
SELECT  
			c.name AS colname, 
			CAST(u.name AS NVARCHAR(MAX))+     
			CASE      
				WHEN u.name like 'NVARCHAR'							THEN '('+CAST(c.max_length/2 AS NVARCHAR(MAX))+')'     
				WHEN u.name like 'VARCHAR'							THEN '('+CAST(c.max_length AS NVARCHAR(MAX))+')'     
				WHEN u.name like 'DECIMAL' OR u.name LIKE 'NUMERIC' THEN '('+ CAST(c.[precision] AS NVARCHAR(MAX))+',' + CAST(c.scale AS NVARCHAR(MAX)) +')'        else ''    
			END AS datatype,
			CASE
				WHEN u.name LIKE 'NVARCHAR' THEN c.max_length/2
				WHEN u.name LIKE 'VARCHAR' THEN c.max_length
				WHEN u.name LIKE 'DECIMAL' OR u.name LIKE 'NUMERIC' THEN (c.[precision] + 1)
			END AS datatypeLength, 
			ROW_NUMBER() OVER (ORDER BY c.name ASC) rowNum 
		FROM sys.columns c 
		INNER JOIN sys.tables t 
			ON		c.OBJECT_ID=t.OBJECT_ID 
				AND t.name='tblHomeSpotterHistory_DT'
				AND c.name NOT IN ('GoodToImport', 'ErrorDescription') 
				AND t.schema_id = 9
		INNER JOIN sys.types u 
			ON c.user_type_id=u.user_type_id 
		ORDER BY c.name ASC;
SELECT * FROM @temp
SELECT MAX(rowNum) FROM @temp; 