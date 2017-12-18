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

bcp homeSpotter.tblHomeSpotter_bcp in D:\Edina\HomeSpotterFeed\16Dec17\edina_contata_sessions_copy.csv -S tcp:contata.database.windows.net -d Edina_QA -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","




SELECT * FROM homeSpotter.tblHomeSpotter_bcp WHERE [session_end_guess_utc] IS NOT NULL AND TRY_CAST([session_end_guess_utc] as datetime) IS NULL; 

EXEC homeSpotter.usp_InsertHomeSpotter

EXEC homeSpotter.usp_MergeHomeSpotter

select * from logtaskControlFlow order by 1 desc --350

SELECT * FROM homeSpotter.tblHomeSpotter_FF
SELECT * FROM homeSpotter.tblHomeSpotter_DT
SELECT * FROM homeSpotter.tblHomeSpotter_AE

select * from logerror order by 1 desc --163

SELECT * FROM homeSpotter.DimAgent
SELECT * FROM homeSpotter.DimDevice
SELECT * FROM homeSpotter.DimSession
SELECT * FROM homeSpotter.DimUser
SELECT * FROM homeSpotter.FactHomeSpotter
SELECT * FROM homeSpotter.FactHomeSpotterSummary

TRUNCATE TABLE homeSpotter.DimAgent
TRUNCATE TABLE homeSpotter.DimDevice
TRUNCATE TABLE homeSpotter.DimSession
TRUNCATE TABLE homeSpotter.DimUser
TRUNCATE TABLE homeSpotter.FactHomeSpotter
TRUNCATE TABLE homeSpotter.FactHomeSpotterSummary


(105 rows affected)
UPDATE [homeSpotter].[tblHomeSpotter_FF] SET GoodToImport = 0, ErrorDescription = CONCAT(ErrorDescription,'| Error Column Name is [session_end_is_guess] ' + 'and value is : ('+ CAST([session_end_is_guess] as nvarchar(max))+')') WHERE [session_end_is_guess] IS NOT NULL AND TRY_CAST([session_end_is_guess] as int) IS NULL; 

(1 row affected)
UPDATE [homeSpotter].[tblHomeSpotter_FF] SET GoodToImport = 0, ErrorDescription = CONCAT(ErrorDescription,'| Error Column Name is [session_end_guess_utc] ' + 'and value is : ('+ CAST([session_end_guess_utc] as nvarchar(max))+')') WHERE [session_end_guess_utc] IS NOT NULL AND TRY_CAST([session_end_guess_utc] as datetime) IS NULL; 

(64 rows affected)
UPDATE [homeSpotter].[tblHomeSpotter_FF] SET GoodToImport = 0, ErrorDescription = CONCAT(ErrorDescription,'| Error Column Name is [ModifiedDate] ' + 'and value is : ('+ CAST([ModifiedDate] as nvarchar(max))+')') WHERE [ModifiedDate] IS NOT NULL AND TRY_CAST([ModifiedDate] as datetime) IS NULL; 