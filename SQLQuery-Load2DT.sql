CREATE PROCEDURE sp_LoadToDt
AS
BEGIN

	DECLARE @modifiedDate DATETIME
	SET @modifiedDate = GETDATE()

	INSERT INTO tblHomeSpotter_DT_BAK(
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
		,ModifiedDate
	)
	SELECT
		[user_id]
		,[user]
		,hs_agent_id
		,REPLACE(agent_name,'"','')
		,device_id
		,ip_address
		,REPLACE(session_start_utc,'"','')
		,REPLACE(session_end_guess_utc,'"','')
		,session_end_is_guess
		,event_count_listing_view
		,event_count_run_saved_search
		,event_count_add_saved_listing
		,event_count_search_for_agent
		,event_count_share_app
		,event_count_app_feedback
		,event_count_call_company
		,event_count_open_mortgage_calc
		,@modifiedDate
	FROM tblHomeSpotter_BAK
END