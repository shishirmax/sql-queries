--**** HomeSpotter History **************************************************************
bcp homeSpotter.tblHomeSpotterHistory_bcp in D:\Edina\HomeSpotterFeed\HistoryData\contata_history-11-30-17.csv -S tcp:<server>.database.windows.net -d <database> -U <username> -P <password>  -b 20000 -q -c -t","

--EXEC homeSpotter.usp_InsertHomeSpotterHistory

--EXEC homeSpotter.usp_MergeHomeSpotterHistory

SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_bcp
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_FF
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_DT
SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_AE

SELECT * FROM homeSpotter.tblHomeSpotterHistory_AE

select * FROM homeSpotter.tblHomeSpotterHistory_AE
truncate table homeSpotter.tblHomeSpotterHistory_bcp

--**** HomeSpotter **************************************************************

bcp homeSpotter.tblHomeSpotter_bcp in D:\Edina\HomeSpotterFeed\From_FTP\edina_contata_sessions_09_11_2018.csv -S tcp:<server>.database.windows.net -d <database> -U <username> -P <password>  -b 5000 -q -c -t","

EXEC homeSpotter.usp_InsertHomeSpotter

EXEC homeSpotter.usp_MergeHomeSpotter

sp_helptext 'homeSpotter.usp_InsertHomeSpotter'
sp_helptext 'homeSpotter.usp_MergeHomeSpotter'

select @@TRANCOUNT

SELECT DimAgent					=	COUNT(1)	FROM homeSpotter.DimAgent				(NOLOCK) 
SELECT DimAgentSCD				=	COUNT(1)	FROM homeSpotter.DimAgent_SCD			(NOLOCK) 
SELECT DimDevice				=	COUNT(1)	FROM homeSpotter.DimDevice				(NOLOCK) 
SELECT DimSession				=	COUNT(1)	FROM homeSpotter.DimSession				(NOLOCK) 
SELECT DimUser					=	COUNT(1)	FROM homeSpotter.DimUser				(NOLOCK) 
SELECT FactHomeSpotter			=	COUNT(1)	FROM homeSpotter.FactHomeSpotter		(NOLOCK) 
SELECT FactHomeSpotterSummary	=	COUNT(1)	FROM homeSpotter.FactHomeSpotterSummary (NOLOCK) 

/*
|DimAgent|DimAgentSCD|DimDevice	|DimSession		|DimUser|FactHomeSpotter	|FactHomeSpotterSummary	|
|--------|-----------|----------|---------------|-------|-------------------|-----------------------|
|2156	 |2245		 |68288		|2317338		|14837	|2290109			|17312					|

*/

SELECT COUNT(1) As tblHomeSpotter_bcp FROM homeSpotter.tblHomeSpotter_bcp(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_FF FROM  homeSpotter.tblHomeSpotter_FF (NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_DT FROM  homeSpotter.tblHomeSpotter_DT (NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_AE FROM  homeSpotter.tblHomeSpotter_AE (NOLOCK)


SELECT TOP 100 * FROM homeSpotter.tblHomeSpotter_bcp
WHERE ip_address like '%174.219.19.118%'
--WHERE agent_name LIKE '%Mike Ross%'
--TRUNCATE TABLE homeSpotter.tblHomeSpotter_bcp

TRUNCATE TABLE homeSpotter.DimAgent				
TRUNCATE TABLE homeSpotter.DimAgent_SCD			
TRUNCATE TABLE homeSpotter.DimDevice				
TRUNCATE TABLE homeSpotter.DimSession				
TRUNCATE TABLE homeSpotter.DimUser				
TRUNCATE TABLE homeSpotter.FactHomeSpotter		
TRUNCATE TABLE homeSpotter.FactHomeSpotterSummary


--COUNTING RECORD IN FILE DATE WISE
SELECT COUNT(1) TotalRecords, CAST(REPLACE(session_start_utc,'"','') As DATE) As Dates
from homeSpotter.tblHomeSpotter_bcp
group by CAST(REPLACE(session_start_utc,'"','') As DATE)
order by CAST(REPLACE(session_start_utc,'"','') As DATE)







SELECT TOP 10 * FROM homeSpotter.FactHomeSpotter		
SELECT TOP 100 * FROM homeSpotter.FactHomeSpotterSummary
SELECT * FROM homeSpotter.DimAgent

SELECT COUNT(1),CreatedBy  FROM homeSpotter.DimSession
--WHERE DAY(CreatedDate) = 11 and DAY(SessionnStart) = 08
GROUP BY CreatedBy

SELECT TOP 10 * FROM homeSpotter.DimSession
WHERE CreatedBy = 1699 

SELECT * FROM homeSpotter.DimSession
WHERE IpAddress = '104.129.196.125'

--WHERE ISessionId = 35498

SELECT TOP 10 * FROM homeSpotter.tblHomeSpotter_AE order by ModifiedDate desc

delete from homeSpotter.tblHomeSpotter_bcp
where [user_id] = 'user_id'

SELECT * FROM  homeSpotter.tblHomeSpotter_AE
where DAY(modifieddate) <> 28 and MONTH(modifieddate) <> 12

SELECT * FROM homeSpotter.DimAgent
ORDER BY ModifiedDate DESC

SELECT * FROM homeSpotter.DimAgent_SCD
--WHERE AgentId = 25648
--EndDate IS NOT NULL
ORDER BY EndDate DESC

SELECT  COUNT(*),LEN(DeviceId) FROM homeSpotter.DimDevice
GROUP BY LEN(DeviceId)

select TOP 10 * FROM homeSpotter.DimDevice
where  LEN(DeviceId) = 14

SELECT COUNT(DISTINCT IpAddress),COUNT(IpAddress),count(1) FROM homeSpotter.DimSession
WHERE ModifiedDate IS NOT NULL

SELECT TOP 100 * FROM homeSpotter.DimUser
order by 3

select count(1), cast(createddate as date)
from homespotter.DimUser
group by cast(createddate as date)
order by cast(createddate as date)

select top 100 * FROM homeSpotter.DimUser
order by 1

select * from homespotter.DimUser
where [user] = 'leeseeann@gmail.com'

select * FROM homeSpotter.DimUser where cast(createddate as date) = '2018-03-06'
where [User] = '09hannahanderson09@gmail.com'

select COUNT(1),SessionnStart,SessionnEnd,IpAddress from homeSpotter.DimSession
where createdby = 8
group by SessionnStart,SessionnEnd,IpAddress
having count(1)>1

SELECT * FROM homeSpotter.DimSession
where SessionnStart = '2017-11-29 02:39:44.000'


select ipaddress,sessionnstart,count(sessionnstart),sessionnend
from  [homeSpotter].[DimSession]
group by sessionnstart,ipaddress,sessionnend
having count(sessionnstart)>1 and count(sessionnend)>1
order by sessionnstart




select TOP 10 * from homeSpotter.tblHomeSpotter_DT

select * FROM homeSpotter.FactHomeSpotter
where IHomeSpotterId = 3962

SELECT TOP 100 * FROM homeSpotter.DimSession
ORDER BY CreatedDate DESC

SELECT COUNT(1),IpAddress
FROM homeSpotter.DimSession
WHERE IpAddress <> '-1'
GROUP BY IpAddress
ORDER BY 1 DESC

SELECT * FROM homeSpotter.DimSession
WHERE IpAddress = '198.174.108.202'
ORDER BY 1


--DAILY SESSION COUNT
SELECT COUNT(1) TotalRecords, CAST(SessionnStart As DATE) As Dates
from homeSpotter.DimSession
group by CAST(SessionnStart AS DATE)
order by CAST(SessionnStart AS DATE) DESC

--MONTHLY SESSION COUNT


SELECT COUNT(1) TotalRecords, 
CASE 
	WHEN MONTH(CAST(SessionnStart As DATE)) = 1
	THEN 'January' 
	WHEN MONTH(CAST(SessionnStart As DATE)) = 2
	THEN 'February'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 3
	THEN 'March'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 4
	THEN 'April'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 5
	THEN 'May'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 6
	THEN 'June'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 7
	THEN 'July'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 8
	THEN 'August'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 9
	THEN 'September'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 10
	THEN 'October'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 11
	THEN 'November'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 12
	THEN 'December'
END
	AS Month,YEAR(CAST(SessionnStart As DATE)) AS Year
FROM homespotter.DimSession
WHERE YEAR(CAST(SessionnStart AS DATE)) BETWEEN 2017 AND 2019
--WHERE YEAR(CAST(SessionnStart As DATE)) = 2019 OR YEAR(CAST(SessionnStart As DATE)) = 2018 OR YEAR(CAST(SessionnStart As DATE)) = 2017
GROUP BY MONTH(CAST(SessionnStart As DATE)),YEAR(CAST(SessionnStart As DATE))
ORDER BY YEAR(CAST(SessionnStart As DATE))

 SELECT CONVERT(VARCHAR(MAX),GETDATE(),103)

SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'

SELECT * FROM HomeSpotterMatchEdinaEcrv


--TRUNCATE TABLE   homeSpotter.DimAgent 
--TRUNCATE TABLE   homeSpotter.DimDevice
--TRUNCATE TABLE   homeSpotter.DimSession
--TRUNCATE TABLE   homeSpotter.DimUser
--TRUNCATE TABLE   homeSpotter.FactHomeSpotter
--TRUNCATE TABLE   homeSpotter.FactHomeSpotterSummary

--##### INITIAL INSERT START
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
--##### INITIAL INSERT END

sp_RENAME 'homeSpotter.tblHomeSpotterHistory_DT.HS_DT_ID','HSHistoryId','COLUMN' --Done
sp_RENAME 'homeSpotter.tblHomeSpotterHistory_FF.HS_FF_ID','HSHistoryId','COLUMN' --Done
sp_RENAME 'homeSpotter.tblHomeSpotterHistory_AE.HS_AE_ID','HSHistoryId','COLUMN' --Done

select * from logTaskControlFlow(NOLOCK)-- where FeedName = 'HS_DataFeed'
order by 1 desc

SELECT * FROM [dbo].[LogTaskControlFlowDetails]

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

sp_helptext 'homeSpotter.usp_MergeHomeSpotter'

--zerorez
select * from [ZeroRez].[FactZeroRezDedupData] 
where 
	EmailGroupId				IS NULL
or	PhoneGroupId				IS NULL
or	ClientTagGroupId			IS NULL
or	NetPromoterLabelsGroupID	IS NULL
or	ProductGroupId				IS NULL