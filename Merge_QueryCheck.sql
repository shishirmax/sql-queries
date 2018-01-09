bcp homeSpotter.tblHomeSpotter_bcp in D:\Edina\HomeSpotterFeed\From_FTP\edina_contata_sessions_01_07_2018.csv -S tcp:contata.database.windows.net -d Edina_QA -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","

EXEC homeSpotter.usp_InsertHomeSpotter

EXEC homeSpotter.usp_MergeHomeSpotter

SELECT COUNT(1) As tblHomeSpotter_bcp FROM homeSpotter.tblHomeSpotter_bcp(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_FF FROM homeSpotter.tblHomeSpotter_FF(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_DT FROM homeSpotter.tblHomeSpotter_DT(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_AE FROM homeSpotter.tblHomeSpotter_AE(NOLOCK)

SELECT COUNT(1) As DimAgent					FROM homeSpotter.DimAgent				(NOLOCK) 
SELECT COUNT(1) As DimAgentSCD				FROM homeSpotter.DimAgent_SCD			(NOLOCK) 
SELECT COUNT(1) As DimDevice				FROM homeSpotter.DimDevice				(NOLOCK) 
SELECT COUNT(1) As DimSession				FROM homeSpotter.DimSession				(NOLOCK) 
SELECT COUNT(1) As DimUser					FROM homeSpotter.DimUser				(NOLOCK) 
SELECT COUNT(1) As FactHomeSpotter			FROM homeSpotter.FactHomeSpotter		(NOLOCK) 
SELECT COUNT(1) As FactHomeSpotterSummary	FROM homeSpotter.FactHomeSpotterSummary (NOLOCK) 

SELECT COUNT(1) TotalRecords, CAST(SessionnStart As DATE) As Dates
from homeSpotter.DimSession
group by CAST(SessionnStart AS DATE)
order by CAST(SessionnStart AS DATE)

SELECT TOP 100 * from homeSpotter.DimSession
order by SessionnStart desc
TRUNCATE TABLE homeSpotter.tblHomeSpotter_DT
SELECT  COUNT(*),LEN(DeviceId) FROM homeSpotter.DimDevice
GROUP BY LEN(DeviceId)

SELECT DISTINCT DeviceId FROM homeSpotter.DimDevice

ALTER TABLE homeSpotter.DimDevice
ADD IsApple BIT

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_tblHomeSpotter_DT')   
    DROP INDEX IX_tblHomeSpotter_DT ON homeSpotter.tblHomeSpotter_DT;   
GO  


DECLARE 
	 @logTaskId INT
	,@Value INT
	,@Limit INT

DECLARE @counter TABLE  
(  
 RowId  INT,  
 LogTaskId INT  
) 

INSERT INTO @counter  
SELECT ROW_NUMBER() OVER(ORDER BY LogTaskID),LogTaskID  
FROM (SELECT DISTINCT LogTaskID FROM homeSpotter.tblHomeSpotter_DT (NOLOCK)) T 

SELECT @Value = MIN(RowId),@Limit = MAX(RowId) FROM @counter
PRINT @Value
PRINT @Limit
  
SELECT @logTaskId = LogTaskId FROM @counter WHERE RowId = @Value
PRINT @logTaskId
	
	--Insert into DimSession
	INSERT INTO homeSpotter.DimSession (IpAddress, SessionnStart, SessionnEnd, CreatedDate, CreatedBy)  
				SELECT	DISTINCT ISNULL(ip_address, '-1') ip_address,  
						ISNULL(session_start_utc, '1900-01-01 00:00:00') session_start_utc,
						ISNULL(session_end_guess_utc, '1900-01-01 00:00:00') session_end_guess_utc,
						GETDATE(),  
						S.LogTaskID  
				FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) S  
				JOIN homeSpotter.DimSession T 
					ON		
					S.LogTaskID = @logTaskId 
					AND	
					T.IpAddress		= S.ip_address 
					AND T.SessionnStart = S.session_start_utc
					AND T.SessionnEnd	= S.session_end_guess_utc
				WHERE T.ISessionId IS NULL

	--Merge into DimSession
	MERGE INTO homeSpotter.DimSession AS T  
				USING(
						SELECT	DISTINCT ISNULL(ip_address, '-1') ip_address,  
								ISNULL(session_start_utc, '1900-01-01 00:00:00') session_start_utc,
								ISNULL(session_end_guess_utc, '1900-01-01 00:00:00') session_end_guess_utc,
								--ModifiedDate,  
								ER.LogTaskID  
						FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) ER  
						JOIN @counter C 
							ON		ER.LogTaskID = C.LogTaskID  
								AND C.RowId = @Value
					) AS S  
				ON		T.IpAddress		= S.ip_address 
					AND T.SessionnStart = S.session_start_utc
					AND T.SessionnEnd	= S.session_end_guess_utc
				WHEN MATCHED 
				THEN UPDATE   
					SET T.ModifiedDate	= GETDATE(), 
						T.ModifiedBy	= S.LogTaskID  
				WHEN NOT MATCHED THEN INSERT (IpAddress, SessionnStart, SessionnEnd, CreatedDate, CreatedBy)  
				VALUES(S.ip_address, S.session_start_utc, S.session_end_guess_utc, GETDATE(), S.LogTaskID);

	SELECT TOP 10 *  FROM homeSpotter.DimSession WHERE ISessionId IS NULL
	----Merge into FactHomeSpotterSummary
	--			MERGE INTO homeSpotter.FactHomeSpotterSummary AS T  
	--			USING(
	--					SELECT	DU.IUserId,
	--							DA.IAgentId,
	--							COUNT(1) NumberOfSessions,
	--							SUM(ER.event_count_listing_view) TotalCountListingView,
	--							SUM(ER.event_count_run_saved_search) TotalCountRunSavedSearch,
	--							SUM(ER.event_count_add_saved_listing) TotalCountAddSavedListing,
	--							SUM(ER.event_count_search_for_agent) TotalCountSearchForAgent,
	--							SUM(ER.event_count_share_app) TotalCountShareApp,
	--							SUM(ER.event_count_app_feedback) TotalCountAppFeedback,
	--							SUM(ER.event_count_call_company) TotalCountCallCompany,
	--							SUM(ER.event_count_open_mortgage_calc) TotalCountOpenMortgage, 
	--							ER.LogTaskID  
	--					FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) ER  
	--					JOIN @counter C 
	--						ON		ER.LogTaskID = C.LogTaskID  
	--							AND C.RowId = @Value
	--					LEFT JOIN homeSpotter.DimUser DU
	--						ON		DU.[User]= ISNULL(ER.[user], '-1')
	--					LEFT JOIN homeSpotter.DimAgent DA
	--						ON		DA.AgentId	= ISNULL(ER.hs_agent_id, -1)  
	--					GROUP BY DU.IUserId, DA.IAgentId, ER.LogTaskID  
	--				) AS S  
	--			ON		T.UserId		= S.IUserId 
	--				AND T.AgentId		= S.IAgentId
	--			WHEN MATCHED 
	--			THEN UPDATE   
	--				SET T.NumberOfSessions			= ISNULL(T.NumberOfSessions, 0) + S.NumberOfSessions,
	--					T.TotalCountListingView		= ISNULL(T.TotalCountListingView ,0) + S.TotalCountListingView,
	--					T.TotalCountRunSavedSearch	= ISNULL(T.TotalCountRunSavedSearch ,0) + S.TotalCountRunSavedSearch,
	--					T.TotalCountAddSavedListing	= ISNULL(T.TotalCountAddSavedListing ,0) + S.TotalCountAddSavedListing,
	--					T.TotalCountSearchForAgent	= ISNULL(T.TotalCountSearchForAgent ,0) + S.TotalCountSearchForAgent,
	--					T.TotalCountShareApp		= ISNULL(T.TotalCountShareApp ,0) + S.TotalCountShareApp,
	--					T.TotalCountAppFeedback		= ISNULL(T.TotalCountAppFeedback ,0) + S.TotalCountAppFeedback,
	--					T.TotalCountCallCompany		= ISNULL(T.TotalCountCallCompany ,0) + S.TotalCountCallCompany,
	--					T.TotalCountOpenMortgage	= ISNULL(T.TotalCountOpenMortgage ,0) + S.TotalCountOpenMortgage,
	--					T.ModifiedDate				= GETDATE(), 
	--					T.ModifiedBy				= S.LogTaskID  
	--			WHEN NOT MATCHED THEN INSERT 
	--			(	
	--				UserId, 
	--				AgentId,
	--				NumberOfSessions,
	--				TotalCountListingView,
	--				TotalCountRunSavedSearch,
	--				TotalCountAddSavedListing,
	--				TotalCountSearchForAgent,
	--				TotalCountShareApp,
	--				TotalCountAppFeedback,
	--				TotalCountCallCompany,
	--				TotalCountOpenMortgage,
	--				CreatedDate, 
	--				CreatedBy
	--			)  
	--			VALUES
	--			(
	--				S.IUserId,
	--				S.IAgentId,
	--				S.NumberOfSessions,
	--				S.TotalCountListingView,
	--				S.TotalCountRunSavedSearch,
	--				S.TotalCountAddSavedListing,
	--				S.TotalCountSearchForAgent,
	--				S.TotalCountShareApp,
	--				S.TotalCountAppFeedback,
	--				S.TotalCountCallCompany,
	--				S.TotalCountOpenMortgage,
	--				GETDATE(), 
	--				S.LogTaskID  
	--			);

	----Merge into FactHomeSpotter
	--			MERGE INTO homeSpotter.FactHomeSpotter AS T  
	--			USING(
	--					SELECT	DISTINCT DU.IUserId,
	--							DA.IAgentId,
	--							DD.IDeviceId,
	--							DS.ISessionId,
	--							ER.session_end_is_guess,
	--							ER.event_count_listing_view,
	--							ER.event_count_run_saved_search,
	--							ER.event_count_add_saved_listing,
	--							ER.event_count_search_for_agent,
	--							ER.event_count_share_app,
	--							ER.event_count_app_feedback,
	--							ER.event_count_call_company,
	--							ER.event_count_open_mortgage_calc,
	--							ER.LogTaskID  
	--					FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) ER  
	--					JOIN @counter C 
	--						ON		ER.LogTaskID = C.LogTaskID  
	--							AND C.RowId = @Value
	--					LEFT JOIN homeSpotter.DimUser DU
	--						ON	DU.[User]= ISNULL(ER.[user], '-1')
	--					LEFT JOIN homeSpotter.DimAgent DA
	--						ON		DA.AgentId	= ISNULL(ER.hs_agent_id  , -1)
	--					LEFT JOIN homeSpotter.DimDevice DD
	--						ON	DD.DeviceId	= ISNULL(ER.device_id , '-1')
	--					LEFT JOIN homeSpotter.DimSession DS
	--						ON		DS.IpAddress	= ISNULL(ER.ip_address, '-1')  
	--							AND DS.SessionnStart= ISNULL(ER.session_start_utc, '1900-01-01 00:00:00')
	--							AND DS.SessionnEnd	= ISNULL(ER.session_end_guess_utc, '1900-01-01 00:00:00')
	--				) AS S  
	--			ON		T.UserId		= S.IUserId 
	--				AND T.AgentId		= S.IAgentId
	--				AND T.DeviceId		= S.IDeviceId
	--				AND T.SessionId		= S.ISessionId
	--			WHEN MATCHED 
	--			THEN UPDATE   
	--				SET T.SessionEndIsGuess		= S.session_end_is_guess,
	--					T.CountListingView		= S.event_count_listing_view,
	--					T.CountRunSavedSearch	= S.event_count_run_saved_search,
	--					T.CountAddSavedListing	= S.event_count_add_saved_listing,
	--					T.CountSearchForAgent	= S.event_count_search_for_agent,
	--					T.CountShareApp			= S.event_count_share_app,
	--					T.CountAppFeedback		= S.event_count_app_feedback,
	--					T.CountCallCompany		= S.event_count_call_company,
	--					T.CountOpenMortgage		= S.event_count_open_mortgage_calc,
	--					T.ModifiedDate			= GETDATE(), 
	--					T.ModifiedBy			= S.LogTaskID  
	--			WHEN NOT MATCHED THEN INSERT 
	--			(	
	--				UserId, 
	--				AgentId,
	--				DeviceId,
	--				SessionId,
	--				SessionEndIsGuess,
	--				CountListingView,
	--				CountRunSavedSearch,
	--				CountAddSavedListing,
	--				CountSearchForAgent,
	--				CountShareApp,
	--				CountAppFeedback,
	--				CountCallCompany,
	--				CountOpenMortgage,
	--				CreatedDate, 
	--				CreatedBy
	--			)  
	--			VALUES
	--			(
	--				S.IUserId,
	--				S.IAgentId,
	--				S.IDeviceId,
	--				S.ISessionId,
	--				S.session_end_is_guess,
	--				S.event_count_listing_view,
	--				S.event_count_run_saved_search,
	--				S.event_count_add_saved_listing,
	--				S.event_count_search_for_agent,
	--				S.event_count_share_app,
	--				S.event_count_app_feedback,
	--				S.event_count_call_company,
	--				S.event_count_open_mortgage_calc,
	--				GETDATE(), 
	--				S.LogTaskID  
	--			);


	----Merge into DimAgent
	--			MERGE INTO homeSpotter.DimAgent AS T  
	--			USING(
	--					SELECT DISTINCT hs_agent_id, agent_name, rNum, LogTaskID
	--					FROM (
	--							SELECT	DISTINCT ISNULL(hs_agent_id, -1) hs_agent_id,  
	--									ISNULL(agent_name, '-1') agent_name,
	--									ROW_NUMBER() OVER (PARTITION BY hs_agent_id ORDER BY session_start_utc DESC) rNum,
	--									ER.LogTaskID  
	--							FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) ER  
	--							JOIN @counter C 
	--								ON		ER.LogTaskID = C.LogTaskID  
	--									AND C.RowId = @Value
	--						) TT
	--					WHERE rNum = 1
	--				) AS S  
	--			ON		T.AgentId	= S.hs_agent_id 
	--			WHEN MATCHED 
	--			THEN UPDATE   
	--				SET T.AgentName		= S.agent_name,
	--					T.ModifiedDate	= GETDATE(), 
	--					T.ModifiedBy	= S.LogTaskID  
	--			WHEN NOT MATCHED THEN INSERT (AgentId, AgentName, CreatedDate, CreatedBy)  
	--			VALUES(S.hs_agent_id, S.agent_name, GETDATE(), S.LogTaskID);  

	--			INSERT INTO homeSpotter.DimAgent_SCD(AgentId, AgentName, StartDate)
	--			SELECT DISTINCT ISNULL(hs_agent_id, -1) hs_agent_id, ISNULL(agent_name, '-1') agent_name, GETDATE()
	--			FROM homeSpotter.[tblHomeSpotter_DT] DA
	--			LEFT JOIN homeSpotter.DimAgent_SCD SDA
	--				ON		ISNULL(hs_agent_id, -1) = SDA.AgentId
	--					AND ISNULL(agent_name, '-1') = SDA.AgentName
	--			WHERE SDA.AgentId IS NULL

	--			UPDATE SDA
	--			SET EndDate = GETDATE()
	--			FROM homeSpotter.DimAgent DA 
	--			INNER JOIN homeSpotter.DimAgent_SCD SDA
	--				ON		DA.AgentId	= SDA.AgentId
	--					AND DA.AgentName<> SDA.AgentName
	--					AND SDA.EndDate IS NULL
	----Merge into DimDevice
	--			MERGE INTO homeSpotter.DimDevice AS T  
	--			USING(
	--					SELECT	DISTINCT ISNULL(device_id, '-1') device_id,  
	--							ER.LogTaskID  
	--					FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) ER  
	--					JOIN @counter C 
	--						ON		ER.LogTaskID = C.LogTaskID  
	--							AND C.RowId = @Value
	--				) AS S  
	--			ON	T.DeviceId = S.device_id 
	--			WHEN NOT MATCHED THEN INSERT (DeviceId, CreatedDate, CreatedBy)  
	--			VALUES(S.device_id, GETDATE(), S.LogTaskID); 

	----Merge into DimUser
	--			MERGE INTO homeSpotter.DimUser AS T  
	--			USING(
	--					SELECT	DISTINCT ISNULL([user], '-1') [user],    
	--							ER.LogTaskID  
	--					FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) ER  
	--					JOIN @counter C 
	--						ON		ER.LogTaskID = C.LogTaskID  
	--							AND C.RowId = @Value
	--				) AS S  
	--			ON	T.[User]= S.[user]
	--			WHEN NOT MATCHED THEN INSERT ([User], CreatedDate, CreatedBy)  
	--			VALUES(S.[user], GETDATE(), S.LogTaskID); 


	--MERGE INTO homeSpotter.DimDevice
	MERGE INTO homeSpotter.DimDevice AS T  
	USING(
	  SELECT DISTINCT ISNULL(device_id, '-1') device_id,  
		ER.LogTaskID  
	  FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) ER  
	  JOIN @counter C 
	   ON  ER.LogTaskID = C.LogTaskID  
		AND C.RowId = 1
	 ) AS S  
	ON T.DeviceId = S.device_id 
	WHEN NOT MATCHED THEN INSERT (DeviceId, CreatedDate, CreatedBy)  
	VALUES(S.device_id, GETDATE(), S.LogTaskID);

	--INSERT INTO homeSpotter.DimDevice
	INSERT INTO homeSpotter.DimDevice (DeviceId, CreatedDate, CreatedBy)  
	SELECT DISTINCT ISNULL(device_id, '-1') device_id,  
	  GETDATE(),
	  ER.LogTaskID  
	FROM homeSpotter.[tblHomeSpotter_DT] (NOLOCK) ER  
	LEFT JOIN homeSpotter.DimDevice DD
	 ON ISNULL(ER.device_id, '-1') = DD.DeviceId
	WHERE DD.DeviceId IS NULL
	AND ER.LogTaskID = @logTaskId