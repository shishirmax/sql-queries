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

select * from LogError
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




