--**** HomeSpotter History **************************************************************
bcp homeSpotter.tblHomeSpotterHistory_bcp in D:\Edina\HomeSpotterFeed\HistoryData\contata_history-11-30-17.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","

--EXEC homeSpotter.usp_InsertHomeSpotterHistory

--EXEC homeSpotter.usp_MergeHomeSpotterHistory

SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_bcp
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_FF
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_DT
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_AE

select * FROM homeSpotter.tblHomeSpotterHistory_AE
truncate table homeSpotter.tblHomeSpotterHistory_bcp

--**** HomeSpotter **************************************************************

bcp homeSpotter.tblHomeSpotter_bcp in D:\Edina\HomeSpotterFeed\From_FTP\edina_contata_sessions_02_24_2018.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","

EXEC homeSpotter.usp_InsertHomeSpotter

EXEC homeSpotter.usp_MergeHomeSpotter
select @@TRANCOUNT

SELECT COUNT(1) As DimAgent					FROM homeSpotter.DimAgent				(NOLOCK) 
SELECT COUNT(1) As DimAgentSCD				FROM homeSpotter.DimAgent_SCD			(NOLOCK) 
SELECT COUNT(1) As DimDevice				FROM homeSpotter.DimDevice				(NOLOCK) 
SELECT COUNT(1) As DimSession				FROM homeSpotter.DimSession				(NOLOCK) 
SELECT COUNT(1) As DimUser					FROM homeSpotter.DimUser				(NOLOCK) 
SELECT COUNT(1) As FactHomeSpotter			FROM homeSpotter.FactHomeSpotter		(NOLOCK) 
SELECT COUNT(1) As FactHomeSpotterSummary	FROM homeSpotter.FactHomeSpotterSummary (NOLOCK) 

/*
|DimAgent|DimAgentSCD|DimDevice	|DimSession		|DimUser|FactHomeSpotter	|FactHomeSpotterSummary	|
|--------|-----------|----------|---------------|-------|-------------------|-----------------------|
|2113	 |2193		 |57338		|1414971		|14171	|1387736			|16496					|

*/

SELECT COUNT(1) As tblHomeSpotter_bcp FROM homeSpotter.tblHomeSpotter_bcp(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_FF FROM  homeSpotter.tblHomeSpotter_FF (NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_DT FROM  homeSpotter.tblHomeSpotter_DT (NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_AE FROM  homeSpotter.tblHomeSpotter_AE (NOLOCK)

TRUNCATE TABLE  homeSpotter.tblHomeSpotter_bcp
TRUNCATE TABLE  homeSpotter.tblHomeSpotter_FF
TRUNCATE TABLE  homeSpotter.tblHomeSpotter_DT
SELECT TOP 10 * FROM homeSpotter.tblHomeSpotter_bcp order by ModifiedDate desc

delete from homeSpotter.tblHomeSpotter_bcp
where [user_id] = 'user_id'

SELECT * FROM  homeSpotter.tblHomeSpotter_AE
where DAY(modifieddate) = 28

SELECT * FROM homeSpotter.DimAgent
SELECT * FROM homeSpotter.DimAgent_SCD where EndDate IS NOT NULL

SELECT  COUNT(*),LEN(DeviceId) FROM homeSpotter.DimDevice
GROUP BY LEN(DeviceId)

select TOP 10 * FROM homeSpotter.DimDevice
where  LEN(DeviceId) = 14

SELECT COUNT(DISTINCT IpAddress),COUNT(IpAddress),count(1) FROM homeSpotter.DimSession
WHERE ModifiedDate IS NOT NULL

SELECT count(distinct [User]) FROM homeSpotter.DimUser

select top 100 * FROM homeSpotter.DimUser
order by 1
where [User] = 'a.greenheck@gmail.com'

select count(1) from homeSpotter.DimSession
where createdby = 8


select TOP 10 * from homeSpotter.tblHomeSpotter_DT

select * FROM homeSpotter.FactHomeSpotter
where IHomeSpotterId = 3962

SELECT COUNT(1) TotalRecords, CAST(SessionnStart As DATE) As Dates
from homeSpotter.DimSession
group by CAST(SessionnStart AS DATE)
order by CAST(SessionnStart AS DATE)

TRUNCATE TABLE homeSpotter.tblHomeSpotter_bcp

--TRUNCATE TABLE   homeSpotter.DimAgent 
--TRUNCATE TABLE   homeSpotter.DimDevice
--TRUNCATE TABLE   homeSpotter.DimSession
--TRUNCATE TABLE   homeSpotter.DimUser
--TRUNCATE TABLE   homeSpotter.FactHomeSpotter
--TRUNCATE TABLE   homeSpotter.FactHomeSpotterSummary

--SET IDENTITY_INSERT homeSpotter.DimUser ON 
 
-- INSERT homeSpotter.DimUser (IUserId, [User], CreatedDate, CreatedBy) 
-- VALUES (1, '-1', GETDATE(), -1)
 
-- SET IDENTITY_INSERT homeSpotter.DimUser OFF

-- SET IDENTITY_INSERT homeSpotter.DimDevice ON 
 
-- INSERT homeSpotter.DimDevice (IDeviceId, DeviceId, CreatedDate, CreatedBy) 
-- VALUES (1, '-1', GETDATE(), -1)
 
-- SET IDENTITY_INSERT homeSpotter.DimDevice OFF

-- SET IDENTITY_INSERT homeSpotter.DimAgent ON 
 
-- INSERT homeSpotter.DimAgent (IAgentId, AgentId, AgentName, CreatedDate, CreatedBy) 
-- VALUES (1, -1, '-1', GETDATE(), -1)
 
-- SET IDENTITY_INSERT homeSpotter.DimAgent OFF

-- SET IDENTITY_INSERT homeSpotter.DimSession ON 
 
-- INSERT homeSpotter.DimSession (ISessionId, IpAddress, SessionnStart, SessionnEnd, CreatedDate, CreatedBy) 
-- VALUES (1, '-1', '1900-01-01 00:00:00', '1900-01-01 00:00:00', GETDATE(), -1)
 
-- SET IDENTITY_INSERT homeSpotter.DimSession OFF


sp_RENAME 'homeSpotter.tblHomeSpotterHistory_DT.HS_DT_ID','HSHistoryId','COLUMN' --Done
sp_RENAME 'homeSpotter.tblHomeSpotterHistory_FF.HS_FF_ID','HSHistoryId','COLUMN' --Done
sp_RENAME 'homeSpotter.tblHomeSpotterHistory_AE.HS_AE_ID','HSHistoryId','COLUMN' --Done

select * from logTaskControlFlow(NOLOCK)-- where FeedName = 'HS_DataFeed'
order by 1 desc

select * from logerror(NOLOCK)
order by 1 desc

homeSpotter.[tblHomeSpotter_DT]



-- Find an existing index named IX_tblHomeSpotter_DT and delete it if found.   
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_tblHomeSpotter_DT')   
    DROP INDEX IX_tblHomeSpotter_DT ON homeSpotter.tblHomeSpotter_DT;   
GO  
-- Create a nonclustered index called IX_tblHomeSpotter_DT   
-- on the Purchasing.ProductVendor table using the BusinessEntityID column.   
CREATE NONCLUSTERED INDEX IX_tblHomeSpotter_DT   
    ON homeSpotter.tblHomeSpotter_DT ([user],hs_agent_id,device_id,ip_address,session_start_utc,session_end_guess_utc,LogTaskID);   
GO

select DISTINCT DESCRIPTION from t
'Implemantion of the CR systems at dealership level for understanding of the customer concern & faster resolution'
'Trend analysis for Customer Complaint Ratio at Regional / Zonal / Area level both for Sales and Service operations'

SELECT @@TRANCOUNt
Rollback

sp_who

--zerorez
select * from [ZeroRez].[FactZeroRezDedupData] 
where 
	EmailGroupId				IS NULL
or	PhoneGroupId				IS NULL
or	ClientTagGroupId			IS NULL
or	NetPromoterLabelsGroupID	IS NULL
or	ProductGroupId				IS NULL