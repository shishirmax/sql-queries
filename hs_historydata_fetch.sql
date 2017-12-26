         
        SELECT   
			 HS_ID
			,NULLIF(NULLIF(REPLACE([user_id],'"',''), ''),'NULL') As [user_id]
			,NULLIF(NULLIF(REPLACE([user],'"',''), ''),'NULL') As [user]
			,NULLIF(NULLIF(num_sessions, ''),'NULL') As num_sessions
			,NULLIF(NULLIF(agent_id, ''),'NULL') As agent_id
			,NULLIF(NULLIF(REPLACE(agent_name,'"',''), ''),'NULL') As agent_name
			,NULLIF(NULLIF(sum_event_count_listing_view, ''),'NULL') As sum_event_count_listing_view
			,NULLIF(NULLIF(sum_event_count_run_saved_search, ''),'NULL') As sum_event_count_run_saved_search
			,NULLIF(NULLIF(sum_event_count_add_saved_listing, ''),'NULL') As sum_event_count_add_saved_listing
			,NULLIF(NULLIF(sum_event_count_search_for_agent, ''),'NULL') As sum_event_count_search_for_agent
			,NULLIF(NULLIF(sum_event_count_share_app, ''),'NULL') As sum_event_count_share_app
			,NULLIF(NULLIF(sum_event_count_app_feedback, ''),'NULL') As sum_event_count_app_feedback
			,NULLIF(NULLIF(sum_event_count_call_company, ''),'NULL') As sum_event_count_call_company
			,NULLIF(NULLIF(sum_event_count_open_mortgage_calc, ''),'NULL') As sum_event_count_open_mortgage_calc
			,ModifiedDate     
        FROM tblHomeSpotterHistory_FF_BAK  
		ORDER BY HS_ID

		select TOP 50 * FROM tblHomeSpotterHistory_FF_BAK
		--SELECT * FROM tblHomeSpotterHistory_DT_BAK