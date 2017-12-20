--**** HomeSpotter History **************************************************************
--bcp homeSpotter.tblHomeSpotterHistory_bcp in D:\Edina\HomeSpotterFeed\HistoryData\contata_history-11-30-17.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","

--EXEC homeSpotter.usp_InsertHomeSpotterHistory

--EXEC homeSpotter.usp_MergeHomeSpotterHistory

--SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_bcp
--SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_FF
--SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_DT
--SELECT COUNT(1) FROM homeSpotter.tblHomeSpotterHistory_AE

--**** HomeSpotter **************************************************************

bcp homeSpotter.tblHomeSpotter_bcp in D:\Edina\HomeSpotterFeed\18Dec17\edina_contata_sessions.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","

EXEC homeSpotter.usp_InsertHomeSpotter

EXEC homeSpotter.usp_MergeHomeSpotter

SELECT COUNT(1) As DimAgent FROM homeSpotter.DimAgent --2051
SELECT COUNT(1) As DimDevice FROM homeSpotter.DimDevice --36735
SELECT COUNT(1) As DimSession FROM homeSpotter.DimSession --442414
SELECT COUNT(1) As DimUser FROM homeSpotter.DimUser --13416
SELECT COUNT(1) As FactHomeSpotter FROM homeSpotter.FactHomeSpotter --444217
SELECT COUNT(1) As FactHomeSpotterSummary FROM homeSpotter.FactHomeSpotterSummary --15555

SELECT COUNT(1) As tblHomeSpotter_bcp FROM homeSpotter.tblHomeSpotter_bcp
SELECT COUNT(1) As tblHomeSpotter_FF FROM homeSpotter.tblHomeSpotter_FF
SELECT COUNT(1) As tblHomeSpotter_DT FROM homeSpotter.tblHomeSpotter_DT
SELECT COUNT(1) As tblHomeSpotter_AE FROM homeSpotter.tblHomeSpotter_AE

SELECT * FROM  homeSpotter.tblHomeSpotter_AE

SELECT * FROM homeSpotter.DimAgent
SELECT * FROM homeSpotter.DimDevice
SELECT * FROM homeSpotter.DimSession
SELECT * FROM homeSpotter.DimUser


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