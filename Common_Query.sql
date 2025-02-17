CREATE TABLE tblHomeSpotter_DT
(
	HomeSpotterId				BIGINT IDENTITY(1,1) NOT NULL,
	[user_id]					VARCHAR(127),
	account_email_address		VARCHAR(127),
	account_hs_agent_agent_id	BIGINT,
	account_broker_agent_id		BIGINT,
	account_agent				VARCHAR(127),
	account_mobile_phone_id		VARCHAR(127),
	account_ip_address			VARCHAR(127),
	session_login				DATETIME,
	session_duration			BIGINT,
	session_pages_visited		INT,
	session_saved_searches		INT,
	session_saved_homes			INT,
	session_agent_search		INT,
	session_share_app			INT,
	session_app_feedback		INT,
	session_call_company		INT,
	session_mortgage_calculator	INT,
	GoodToImport				BIT,
	ErrorDescription			NVARCHAR(MAX),
	ModifiedDate				DATETIME DEFAULT(GETDATE())
)

sp_helptext usp_LoadFlatToFF

tblEdinaEmailResults

sp_helptext usp_getDataTypeErrors
sp_helptext usp_LoadEdinaToDT
usp_getDataTypeErrors

sp_helptext usp_LoadHSFlatToFF
sp_helptext usp_LoadHomeSpotterToDT

select TRY_CAST('10/2/2017 5:03:10' AS DATETIME)

truncate table tblHomeSpotter_DT

select * from tblHomeSpotter_DT
select * from tblHomeSpotter_AE
select * from tblHomeSpotter_FF
ALTER TABLE tblHomeSpotter_DT DROP COLUMN GoodToImport --Dropping an existing column

ALTER TABLE tblHomeSpotter_FF ADD CONSTRAINT DF_tblHomeSpotter_FF DEFAULT 1 FOR GoodToImport -- Adding default Value to existing column


sp_who 
select * from LogError
order by ErrorID desc
select * from logTaskControlFlow
order by logtaskid desc

SELECT 1 FROM sys.external_data_sources WHERE name = 'contata'

select * from database
select * from tblIntermediate_FF
SELECT LEFT('HS_DataFeed.csv',11)

SELECT LEN('HS_DataFeed')

select * from TableMapping

insert into TableMapping
values
('tblHomeSpotter_FF','sourcehomespotter','vwSourcehomespotter')


select * from vwSourceedinaemailresults

DECLARE @TableName    NVARCHAR(127)
DECLARE @Container	  NVARCHAR(127)
SET @Container = 'sourcehomespotter'

SELECT @TableName = ViewName FROM TableMapping WHERE ContainerName = @Container   


declare @num int;
set @num =( next value for GetGroupId);
select @num as groupId


select 
	count(*) 
	--*
from tbleCRVStandardAddressApi
where --address like '%-%'
--and 
formatted_address = 'NA'


select * from tbleCRVStandardAddressApi where ErrorCode='500'


CREATE TABLE tblHomeSpotter_DT(
	HomeSpotterId						BIGINT IDENTITY(1,1) NOT NULL,
	[user_id]							VARCHAR(63) NULL, 
	[user]								VARCHAR(63) NULL, 
	hs_agent_id							INT NULL, 
	agent_name							VARCHAR(127) NULL, 
	device_id							VARCHAR(63) NULL, 
	ip_address							VARCHAR(31) NULL, 
	session_start_utc					DATETIME NULL, 
	session_end_guess_utc				DATETIME NULL, 
	session_end_is_guess				INT NULL, 
	event_count_listing_view			INT NULL, 
	event_count_run_saved_search		INT NULL, 
	event_count_add_saved_listing		INT NULL, 
	event_count_search_for_agent		INT NULL, 
	event_count_share_app				INT NULL, 
	event_count_app_feedback			INT NULL, 
	event_count_call_company			INT NULL, 
	event_count_open_mortgage_calc		INT NULL,
	ModifiedDate						DATETIME DEFAULT(GETDATE())
)

select * from tblHomeSpotter
select * from tblHomeSpotter_FF
select * from tblHomeSpotter_DT

DECLARE @modifiedDate DATETIME
SET @modifiedDate = GETDATE()

INSERT INTO tblHomeSpotter_DT(
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
	 NULLIF([user_id],'')
	,NULLIF([user],'')
	,NULLIF(hs_agent_id,'')
	,NULLIF(REPLACE(agent_name,'"',''),'')
	,NULLIF(device_id,'')
	,NULLIF(ip_address,'')
	,NULLIF(REPLACE(session_start_utc,'"',''),'')
	,NULLIF(REPLACE(session_end_guess_utc,'"',''),'')
	,NULLIF(session_end_is_guess,'')
	,NULLIF(event_count_listing_view,'')
	,NULLIF(event_count_run_saved_search,'')
	,NULLIF(event_count_add_saved_listing,'')
	,NULLIF(event_count_search_for_agent,'')
	,NULLIF(event_count_share_app,'')
	,NULLIF(event_count_app_feedback,'')
	,NULLIF(event_count_call_company,'')
	,NULLIF(event_count_open_mortgage_calc,'')
	,@modifiedDate
from tblHomeSpotter_FF

Select count(1) from tblHomeSpotter_DT

select system_type_id,object_id  from sys.columns
--********************************************************************************************
--DECLARE @sql NVARCHAR(MAX);

--SET @sql = N'';

--SELECT @sql = @sql + '
--  ' + QUOTENAME(name) + ' = CASE
--  WHEN ' + QUOTENAME(name) + ' = ''NULL'' THEN NULL ELSE '
--  + QUOTENAME(name) + ' END,'
--FROM sys.columns
--WHERE [object_id] = OBJECT_ID('dbo.tblHomeSpotterFeed')
--AND system_type_id IN (35,99,167,175,231,239);

--SELECT @sql = N'UPDATE dbo.tblHomeSpotterFeed SET ' + LEFT(@sql, LEN(@sql)-1) + ';';

--PRINT @sql;
--********************************************************************************************

select TOP 10 * from tblPopScore_FF
select TOP 10 * from tblPopScore_DT