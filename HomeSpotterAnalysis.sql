sp_who
--####################### HomeSpotter Daily Data ###################################################################

/*
Daily Data Load
--BULK INSERT SCRIPT
BULK INSERT dbo.tblHomeSpotter_BAK
FROM 'D:\Edina\HomeSpotterFeed\From_FTP\edina_contata_sessions_06_06_2018.csv'
WITH
(
FIELDTERMINATOR=',',
FIRSTROW=2,
ROWTERMINATOR='\n'
)

--BCP Script
Step 1
bcp dbo.tblHomeSpotter_BAK in D:\Edina\HomeSpotterFeed\From_FTP\edina_contata_sessions_06_20_2018.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123  -b 10000 -q -c -t","

Step 2: (Remove the header)
DELETE 
FROM tblHomeSpotter_BAK
WHERE [user_id] = 'user_id'

Step 3: (Load Data from tblHomeSpotter_BAK to tblHomeSpotter_DT_BAK)
EXEC sp_LoadToDt

Step 4: (Truncate Data from tblHomeSpotter_BAK)
truncate table tblHomeSpotter_BAK

SELECT COUNT(1) TotalRecords, CAST(session_start_utc As DATE) As Dates
from tblHomeSpotter_DT_BAK
group by CAST(session_start_utc AS DATE)
order by CAST(session_start_utc AS DATE)

SELECT COUNT(1) 
--DELETE 
FROM tblHomeSpotter_DT_BAK
WHERE CAST(session_start_utc As DATE) = '2018-05-16'

SELECT COUNT(1)
DELETE FROM tblHomeSpotter_BAK
WHERE CAST(session_start_utc As DATE) = '2018-05-16'

SELECT TOP 100 * FROM tblHomeSpotter_DT_BAK
WHERE [user] IS NOT NULL
AND hs_agent_id IS NOT NULL

*/

select count(*) from dbo.tblHomeSpotter_DT_BAK(NOLOCK)
order by HomeSpotterId

select COUNT(1),session_start_utc,session_end_guess_utc,ip_address from dbo.tblHomeSpotter_DT_BAK
group by session_start_utc,session_end_guess_utc,ip_address
having count(1)>1

select * from tblHomeSpotter_DT_BAK
where ip_address = '68.63.219.208' and session_start_utc = '2018-02-11 00:28:15.000'

select TOP 10 * from dbo.tblHomeSpotter_DT_BAK --481376 
where [user] is not null

bcp "select TOP 10 * from dbo.tblHomeSpotter_DT_BAK" queryout D:\Edina\HomeSpotterFeed\Complete.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t","

select count(*) from tblHomeSpotter_BAK 
--select count(*) from tblHomeSpotter_FF_BAK


EXEC sp_LoadToDt
truncate table tblHomeSpotter_BAK
--truncate table tblHomeSpotter_FF_BAK

DELETE 
FROM tblHomeSpotter_BAK
WHERE [user_id] = 'user_id'

--29Nov --01Dec --02Dec --03Dec  --04Dec  --05Dec  --06Dec	--08Dec
--42586 --63911 --89088 --114929 --136078 --155966 --175041	--195334

select count(*) from tblHomeSpotter_FF
select count(1) from tblHomeSpotter

select try_cast(replace(session_start_utc,'"','') as datetime) from tblHomeSpotter

Select count(1) TotalRecords, DAY(try_cast(replace(session_start_utc,'"','') as datetime)) As Dates from tblHomeSpotter
group by DAY(try_cast(replace(session_start_utc,'"','') as datetime))

select count(*) from tblHomeSpotter_DT_BAK
where CAST(session_start_utc AS DATE) = '2018-02-06'
and CAST(ModifiedDate AS DATE) = '2018-02-26'

WITH CTE AS
(
SELECT *--,ROW_NUMBER() OVER (PARTITION BY session_start_utc ORDER BY session_start_utc) AS RN
FROM tblHomeSpotter_DT_BAK
where DAY(session_start_utc) = '07' and MONTH(session_start_utc) = '01' and DAY(ModifiedDate) = '09' and MONTH(ModifiedDate) = '01'

)
SELECT * FROM CTE WHERE RN<>1

DELETE FROM CTE WHERE RN<>1

select top 10 * from tblHomeSpotter_DT_BAK
where [user] is not null

SELECT [user],CAST(session_start_utc As DATE) As Dates
from tblHomeSpotter_DT_BAK
where [user] is not null
group by [user],CAST(session_start_utc As DATE)
order by CAST(session_start_utc AS DATE)

select count(1) As RCount,[user],cast(session_start_utc as date) As Dates
into #tempcount
from tblHomeSpotter_DT_BAK
where [user] is not null
group by [user],cast(session_start_utc as date)
order by  [user]

select * from #tempcount
drop table #tempcount

select * from tblHomeSpotter_DT_BAK 
where [user] = 'pols0036@gmail.com'

select top 100 * from tblHomeSpotter_DT_BAK
where 
[user] is not null
and hs_agent_id is not null
order by newid()
order by ModifiedDate desc

select distinct [user] from tblHomeSpotter_DT_BAK
where cast(ModifiedDate as date) = '2018-03-05'
and [user]  like '%_@_%_.__%'

-- RECORD COUNT DAILY
SELECT COUNT(1) TotalRecords, CAST(session_start_utc As DATE) As Dates
from tblHomeSpotter_DT_BAK(NOLOCK)
group by CAST(session_start_utc AS DATE)
order by CAST(session_start_utc AS DATE)

select distinct [user] from tblHomeSpotter_DT_BAK(NOLOCK)
where CAST(session_start_utc AS DATE) = '2018-03-25'

select 
top 100 
count(1) As recordCount 
--[user_id],
,[user]
,device_id
--,ip_address
,session_start_utc
,session_end_guess_utc
from tblHomeSpotter_DT_BAK(NOLOCK)
where [user] is not null
group by 
[user]
,device_id
--,ip_address
,session_start_utc
,session_end_guess_utc

select 
top 100 
ip_address,
cast(session_start_utc as date),
cast(session_end_guess_utc as date)
from tblHomeSpotter_DT_BAK(NOLOCK)
where [user] is not null
group by 
ip_address,
cast(session_start_utc as date),
cast(session_end_guess_utc as date)


select count(1) from tblHomeSpotter_DT_BAK(NOLOCK)
where ip_address = '68.168.169.52'

select max(tbl.reCount),ip_address from 
(select count(1) as reCount,ip_address from tblHomeSpotter_DT_BAK(NOLOCK)
group by ip_address) tbl

SELECT	DISTINCT ISNULL([user], '-1') [user]
FROM tblHomeSpotter_DT_BAK

SELECT	COUNT(DISTINCT [user])
FROM tblHomeSpotter_DT_BAK

select sum(cnt)
from (select distinct [user],count(*) as cnt
    from tblHomeSpotter_DT_BAK
    group by [user]
    having count(*) = 1) T

	select distinct [user],count(*) as cnt
    from tblHomeSpotter_DT_BAK
    group by [user]
	order by 2 desc

	select * from tblHomeSpotter_DT_BAK
	where [user] = 'leeseeann@gmail.com'
	order by session_start_utc desc

select count(*) as COUNT_EMAIL,sum(cnt) as COUNT_ROWS
from (select count(*) as cnt
    from tblHomeSpotter_DT_BAK
    group by [user]
    having count(*) > 1) T

--select max(CAST(ModifiedDate as DATE)) from tblHomeSpotter_DT_BAK
--select count(*)  delete from tblHomeSpotter_DT_BAK
--where CAST(ModifiedDate as DATE) = '2018-01-19'
/*
|*******HomeSpotter*********|
|TotalRecords	|Dates		|
|---------------|-----------|
|21460			|2017-11-28	|
|21126			|2017-11-29	|
|20005			|2017-11-30	|
|21324			|2017-12-01	|
|25176			|2017-12-02	|
|25840			|2017-12-03	|
|21148			|2017-12-04	|
|19887			|2017-12-05	|
|19080			|2017-12-06	|
|19037			|2017-12-07	|
|20293			|2017-12-08	|
|24192			|2017-12-09	|
|24068			|2017-12-10	|
|19569			|2017-12-11	|
|19661			|2017-12-12	|
|19390			|2017-12-13	|
|19100			|2017-12-14	|
|19264			|2017-12-15	|
|22666			|2017-12-16	|
|23076			|2017-12-17	|
|18855			|2017-12-18	|
|18950			|2017-12-19	|
|18209			|2017-12-20	|
|17797			|2017-12-21	|
|18040			|2017-12-22	|
|18495			|2017-12-23	|
|17043			|2017-12-24	|
|14790			|2017-12-25	|
|19772			|2017-12-26	|
|21343			|2017-12-27	|
|21268			|2017-12-28	|
|21883			|2017-12-29	|
|22862			|2017-12-30	|
|20951			|2017-12-31	|
|21112			|2018-01-01	|
|20743			|2018-01-02	|
*/

'dculbertson.65@ icloud.com'

select count([user]) from tblHomeSpotter_DT_BAK --828740


select * from tblHomeSpotter_DT_BAK
where [user_id] = 'lloken@sovran.com'


SELECT  COUNT(*),LEN(device_id) FROM tblHomeSpotter_DT_BAK
GROUP BY LEN(device_id)

SELECT DISTINCT device_id FROM tblHomeSpotter_DT_BAK

select TOP 10 UPPER(DATENAME(D,EOMONTH(session_start_utc)))+' '+CONVERT(VARCHAR(50),DATEPART(YEAR,EOMONTH(session_start_utc)))
from tblHomeSpotter_DT

select TOP 1550 * from tblHomeSpotter_DT_BAK
where [user] IS NOT NULL
and agent_name IS NOT NULL

select TOP 1000 * from tblHomeSpotter
where  DAY(try_cast(replace(session_start_utc,'"','') as datetime)) = 9
and [user] IS NOT NULL
and agent_name IS NOT NULL

select 
--TOP 10 *
count(1) 
from tblHomeSpotterHistory_FF_BAK

select COUNT(DISTINCT [user]) from tblHomeSpotter_DT_BAK where [user] is not null
select COUNT(DISTINCT [user_id]) from tblHomeSpotter_DT_BAK where [user_id] is not null

SELECT COUNT(1) As tblHomeSpotter_bcp FROM homeSpotter.tblHomeSpotter_bcp(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_FF FROM homeSpotter.tblHomeSpotter_FF(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_DT FROM homeSpotter.tblHomeSpotter_DT(NOLOCK)
SELECT COUNT(1) As tblHomeSpotter_AE FROM homeSpotter.tblHomeSpotter_AE(NOLOCK)




--********************* user_id Starts ********************************************
select [user_id], count(1) from tblHomeSpotter
where [user_id] is null
group by [user_id]
select MAX(LEN([user_id])) from tblHomeSpotter
select count(1),count(try_cast([user_id] as varchar)) from tblHomeSpotter
where [user_id] IS NOT NULL

--18 NULL
-- No Unique Column.
-- Max Len : 36
-- DataType Suggested: Varchar

select [user_id], count(1) from tblHomeSpotter_DT_BAK
--where [user_id] like '%@%'
group by [user_id]
-- Email value is also available : 1713 records

select * from tblHomeSpotter
where [user_id] = '1988gmp@gmail.com'
-- Device_id for similar user_id is same, sometime having different ip_address and some times same.
-- different ip_adress for user_id = 1988gmp@gmail.com
-- same email is available under user column if user_id contains email value.


select * from tblHomeSpotter
where [user_id] = 'abigail1026@gmail.com'
--abigail1026@gmail.com
select * from tblHomeSpotter
where [user_id] = '00092A5A-5919-4931-89DD-F17490EC13FF'
--00092A5A-5919-4931-89DD-F17490EC13FF
--00242139-A3B4-4EF6-9A39-AB89E1B7F79B
--user_id is equivalent to device_id when no email id is provided

--********************* user_id Ends********************************************

--********************* user Starts ********************************************
select distinct [user] from tblHomeSpotter_DT_BAK
where [user] IS NOT NULL

select [user], count(1) from [dbo].[tblHomeSpotter_DT_BAK]
where [user] is not null
group by [user]

select MAX(LEN([user])) from tblHomeSpotter
select count(1),count(try_cast([user] as varchar)) from tblHomeSpotter
where [user] IS NOT NULL
--173017 NULL Records
--Email type data, Not unique.
-- Max Len: 38
-- DataType Suggested: Varchar

select * from tblHomeSpotter
where [user] = 'ash.abrego@gmail.com'
-- user_id is equal to user when user column contains email id

select * from tblHomeSpotter
where [user] like '%aaron%'
or [user_id] like '%aaron%'

select count(*) from tblHomeSpotter_DT
--where [user] IS NULL --232756
--where [user] IS NOT NULL --29875(email type available)
--where [user_id] like '%_@_%_.__%' --40491(email type available)
--where [user_id] not like '%_@_%_.__%' --221999
--where [user] like '%_@_%_.__%' --29820(email type)
--where [user] not like '%_@_%_.__%' --55(email type)

select 
	[user]
	,[user_id]
	,[device_id]
	,hs_agent_id
	,agent_name
	,ip_address
	,CAST(session_start_utc As DATE) As Dates
	,count(1) As RecCount from tblHomeSpotter_DT_BAK
where [user] not like '%_@_%_.__%'
group by 
	[user]
	,[user_id]
	,[device_id]
	,hs_agent_id
	,agent_name
	,ip_address
	,CAST(session_start_utc As DATE)
order by CAST(session_start_utc As DATE)


-- user_id is equivalent to device_id when there is user column is null.

select count(*) from [dbo].[tblHomeSpotter_DT_BAK]
where [user] is null --1852338

select count(*) from [dbo].[tblHomeSpotter_DT_BAK]
where [user] is not null --240339

select (1852338+240339)

select distinct[user] from [dbo].[tblHomeSpotter_DT_BAK] --7513 DISTINCT user
where [user] is not null --240339
order by 1 desc

select * from [dbo].[tblHomeSpotter_DT_BAK]
where [user] = 'gmmabaxter03@yahoo.com'
--********************* user Ends ********************************************

--********************* hs_agent_id Starts ********************************************
select hs_agent_id, count(1) from tblHomeSpotter
--where hs_agent_id is null
group by hs_agent_id
select MAX(LEN(hs_agent_id)) from tblHomeSpotter
select count(1),count(try_cast(hs_agent_id as INT)) from tblHomeSpotter
where hs_agent_id IS NOT NULL
--179282 NULL Records
--Integer type data
--Max Len : 6
-- DataType Suggested: INT

select * from dbo.tblHomeSpotter_DT_BAK
where hs_agent_id = '25865'
-- there is unique user_id, agent_name,device_id for same hs_agent_id.
-- for few hs_agent_id there is user(email) also available(hs_agent_id: 25865)

select COUNT(*) from tblHomeSpotter
where hs_agent_id IS NULL
--39077

select COUNT(*) from tblHomeSpotter
where hs_agent_id IS NOT NULL
--3509

--********************* hs_agent_id Ends ********************************************

--********************* agent_name Starts ********************************************
select agent_name, count(1) from tblHomeSpotter
where agent_name IS NULL
group by agent_name
select MAX(LEN(agent_name)) from tblHomeSpotter
select count(1),count(try_cast(agent_name as varchar)) from tblHomeSpotter
where agent_name IS NOT NULL
--179282 NULL Records
--No Unique Column
--String  type data
--Max Len : 36
-- DataType Suggested: varchar

select * from tblHomeSpotter
where agent_name = '"Jay Docken"'

select * from tblHomeSpotter
where agent_name is null 
and device_id is null
--23
select * from tblHomeSpotter
where agent_name is null 
and [user_id] is null
--23

select * from tblHomeSpotter
where ip_address = '24.131.183.40'

--********************* agent_name Ends ********************************************

--********************* device_id Starts ********************************************
select device_id, count(1) from tblHomeSpotter_dt
where device_id IS NULL
group by device_id
select MAX(LEN(device_id)) from tblHomeSpotter
select count(1),count(try_cast(device_id as varchar)) from tblHomeSpotter
where device_id IS NOT NULL
--23 NULL Records
--No Unique Column
--GUID type data
--Max Len : 36
-- DataType Suggested: varchar


--device_Id is of 2 type:
--1. 00092A5A-5919-4931-89DD-F17490EC13FF
--2. 355301070635951

select len('00092A5A-5919-4931-89DD-F17490EC13FF')
select * from tblHomeSpotter_dt
where device_id is null--= '355301072091294'

--for same device_id there is same user_id.
--there may be same & different ip_address for differen session

--********************* device_id End ********************************************

--********************* ip_address Start ********************************************

select ip_address, count(1) from tblHomeSpotter
--where ip_address IS NULL
group by ip_address
select MAX(LEN(ip_address)) from tblHomeSpotter
select count(1),count(try_cast(ip_address as VARCHAR)) from tblHomeSpotter
where ip_address IS NOT NULL
--No NULL Records
--No Unique Column
--IP Address type data
--Max Len : 15
-- DataType Suggested: varchar

select * from tblHomeSpotter
where ip_address = '104.129.196.110'

--for every unique ip_address there is single user_id, hs_agent_id, agent_name and device_id


--********************* ip_address Ends ********************************************

--********************* session_start_utc Start ********************************************
select session_start_utc, count(1) from tblHomeSpotter
where session_start_utc IS NULL
group by session_start_utc
select MAX(LEN(replace(session_start_utc,'"',''))) from tblHomeSpotter
select count(1),count(try_cast(replace(session_start_utc,'"','') as datetime)) from tblHomeSpotter
where session_start_utc IS NOT NULL
--No NULL Records
--No Unique Column
--DateTime type data
--Max Len : 19
-- DataType Suggested: DateTime

select  count(year(try_cast(replace(session_start_utc,'"','') as datetime))) from tblHomeSpotter
-- all data is of 2017 year only
select * from tblHomeSpotter
where session_start_utc = '"2017-11-28 00:00:04"'

select COUNT(*) from tblHomeSpotter
where session_start_utc IS NULL --0
-- Session_Start_utc is never NULL
--********************* session_start_utc Ends ********************************************

--********************* session_end_guess_utc Start ********************************************
select session_end_guess_utc, count(1) from tblHomeSpotter
--where session_end_guess_utc IS NULL
group by session_end_guess_utc
having count(1)>1

select MAX(LEN(replace(session_end_guess_utc,'"',''))) from tblHomeSpotter
select count(1),count(try_cast(replace(session_end_guess_utc,'"','') as datetime)) from tblHomeSpotter
where session_end_guess_utc IS NOT NULL
--15628 NULL Records
--No Unique Column
--DateTime type data
--Max Len : 19
-- DataType Suggested: DateTime

select  TOP 50 (year(try_cast(replace(session_end_guess_utc,'"','') as datetime))) from tblHomeSpotter

select * from tblHomeSpotter
where session_end_guess_utc = '"2017-11-28 00:01:29"'
--session_end_guess_utc can have NULL values 

select TOP 10 * from tblHomeSpotter
where session_end_guess_utc IS NULL
--********************* session_end_guess_utc Ends ********************************************


--********************* session_end_is_guess Starts ********************************************
select session_end_is_guess, count(1) from tblHomeSpotter
--where session_end_guess_utc IS NULL
group by session_end_is_guess
select MAX(LEN(session_end_is_guess)) from tblHomeSpotter
select count(1),count(try_cast(session_end_is_guess as int)) from tblHomeSpotter
where session_end_is_guess IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 1
-- DataType Suggested: int


select TOP 10 * from tblHomeSpotter
where session_end_is_guess = '1'
and [user_id] = '01BDD4C1-5912-4D26-82CB-E826DD63EF1C'

--For every record session_end_is_guess value is 1

--********************* session_end_is_guess Ends ********************************************


--********************* event_count_listing_view Starts ********************************************
select event_count_listing_view, count(1) from tblHomeSpotter
--where event_count_listing_view IS NULL
group by event_count_listing_view

select MAX(LEN(event_count_listing_view)) from tblHomeSpotter
select count(1),count(try_cast(event_count_listing_view as int)) from tblHomeSpotter
where event_count_listing_view IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 3
-- DataType Suggested: int

select count(*) ,[user_id]from tblHomeSpotter
where event_count_listing_view = '34'
group by [user_id]

--different numeric value for different records,event_count_listing_view values are same for many records

--********************* event_count_listing_view Ends ********************************************

--********************* event_count_run_saved_search Starts ********************************************

select event_count_run_saved_search, count(1) from tblHomeSpotter
--where event_count_run_saved_search IS NULL
group by event_count_run_saved_search
select MAX(LEN(event_count_run_saved_search)) from tblHomeSpotter
select count(1),count(try_cast(event_count_run_saved_search as int)) from tblHomeSpotter
where event_count_run_saved_search IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 1
-- DataType Suggested: int

select * from tblHomeSpotter
where event_count_run_saved_search = '2'

--different numeric value for different records, event_count_run_saved_search values are also same for many records.

--********************* event_count_run_saved_search Ends ********************************************

--********************* event_count_add_saved_listing Starts ********************************************
select event_count_add_saved_listing, count(1) from tblHomeSpotter
--where event_count_add_saved_listing IS NULL
group by event_count_add_saved_listing
select MAX(LEN(event_count_add_saved_listing)) from tblHomeSpotter
select count(1),count(try_cast(event_count_add_saved_listing as int)) from tblHomeSpotter
where event_count_add_saved_listing IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 2
-- DataType Suggested: int


select * from tblHomeSpotter
where event_count_add_saved_listing = '3'

--different numeric value for different records, event_count_add_saved_listing values are also same for many records.

--********************* event_count_add_saved_listing Ends ********************************************

--********************* event_count_search_for_agent Starts ********************************************

select event_count_search_for_agent, count(1) from tblHomeSpotter
--where event_count_search_for_agent IS NULL
group by event_count_search_for_agent
select MAX(LEN(event_count_search_for_agent)) from tblHomeSpotter
select count(1),count(try_cast(event_count_search_for_agent as int)) from tblHomeSpotter
where event_count_search_for_agent IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 2
-- DataType Suggested: int

select * from tblHomeSpotter
where event_count_search_for_agent = '3'
--different numeric value for different records, event_count_search_for_agent values are also same for many records.

--********************* event_count_search_for_agent Ends ********************************************

--********************* event_count_share_app Starts ********************************************

select event_count_share_app, count(1) from tblHomeSpotter
--where event_count_share_app IS NULL
group by event_count_share_app
select MAX(LEN(event_count_share_app)) from tblHomeSpotter
select count(1),count(try_cast(event_count_share_app as int)) from tblHomeSpotter
where event_count_share_app IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 1
-- DataType Suggested: int


select * from tblHomeSpotter
where event_count_share_app = '1'
-- Only 3 value type available 0,1,2
--3 different numeric value for different records, event_count_share_app values are also same for many records.

--********************* event_count_share_app Ends ********************************************

--********************* event_count_app_feedback Starts ********************************************

select event_count_app_feedback, count(1) from tblHomeSpotter
--where event_count_app_feedback IS NULL
group by event_count_app_feedback
select MAX(LEN(event_count_app_feedback)) from tblHomeSpotter
select count(1),count(try_cast(event_count_app_feedback as int)) from tblHomeSpotter
where event_count_app_feedback IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 1
-- DataType Suggested: int
-- Only 3 value type available 0,1,2
-- 3 different numeric value for different records, event_count_app_feedback values are also same for many records.

--********************* event_count_app_feedback Ends ********************************************


--********************* event_count_call_company Starts ********************************************

select event_count_call_company, count(1) from tblHomeSpotter
--where event_count_call_company IS NULL
group by event_count_call_company
select MAX(LEN(event_count_call_company)) from tblHomeSpotter
select count(1),count(try_cast(event_count_call_company as int)) from tblHomeSpotter
where event_count_call_company IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 1
-- DataType Suggested: int
-- Only 2 value type available 0,1
--2 different numeric value for different records, event_count_call_company values are also same for many records.

--********************* event_count_call_company Ends ********************************************

--********************* event_count_open_mortgage_calc Starts ********************************************

select event_count_open_mortgage_calc, count(1) from tblHomeSpotter
--where event_count_open_mortgage_calc IS NULL
group by event_count_open_mortgage_calc
order by event_count_open_mortgage_calc
select MAX(LEN(event_count_open_mortgage_calc)) from tblHomeSpotter
select count(1),count(try_cast(event_count_open_mortgage_calc as int)) from tblHomeSpotter
where event_count_open_mortgage_calc IS NOT NULL
--No NULL Records
--No Unique Column
--int type data
--Max Len : 1
-- DataType Suggested: int
-- 10 value type available (0-9)
--different numeric value for different records, event_count_call_company values are also same for many records.

--********************* event_count_open_mortgage_calc Ends ********************************************

--select TOP 50 * from tblHomeSpotter_FF
--where [user] IS NOT NULL
--and agent_name IS NOT NULL

--select count(distinct [user]) from tblHomeSpotter_FF --1593
--where [user] IS NOT NULL
--and agent_name IS NOT NULL --291

--select distinct [user] from tblHomeSpotter_FF --1593
--where [user] IS NOT NULL
--and [user] NOT like '%@%.%'
--and agent_name IS NOT NU


select count(DISTINCT [user_id]) from tblHomeSpotter_DT --34781
SELECT COUNT(DISTINCT [user]) from tblHomeSpotter_DT --3908
SELECT COUNT(DISTINCT hs_agent_id) from tblHomeSpotter_DT --1016
SELECT COUNT(DISTINCT device_id) from tblHomeSpotter_DT --30819
SELECT COUNT(DISTINCT ip_address) from tblHomeSpotter_DT --40418
WHERE [user_id] IS NOT NULL
	and [user] IS NOT NULL
	and hs_agent_id IS NOT NULL
	and device_id IS NOT NULL
--1590
select count(distinct DAY(session_start_utc)) from tblHomeSpotter_DT --11

SELECT COUNT(DISTINCT device_id),[user],[user_id],device_id from tblHomeSpotter_DT
where [user] IS NOT NULL --4101
--where [user] IS NULL --30569
--and [user_id] not like '%@%'
--and [user_id] like '%@%'
group by [user],[user_id],device_id
order by [user]

select LEN('353411068570466') --15
select LEN('897C99DB-770E-4DE7-8B0C-A6A06BD0BE97') --36

select count(1) from tblhomespotter_dt
--where len(device_id) = 15 --15018
--where len(device_id) = 36 --263880
--15018 records available whose device_id Len is 15(seems like android device users)
--263880 records avilable whose device_id Len is 36(seems like apple device users)

SELECT COUNT(DISTINCT device_id) from tblHomeSpotter_DT
where len(device_id) = 15
--1466

SELECT COUNT(DISTINCT device_id) from tblHomeSpotter_DT
where len(device_id) = 36
--29042

select device_id,count(distinct device_id) from tblhomespotter_dt
group by device_id
--30819

select * from tblhomespotter_dt
where [user] not like '%_@__%.__%'

SELECT COUNT(DISTINCT device_id),[user],[user_id],device_id from tblHomeSpotter_DT
group by [user],[user_id],device_id
order by [user]
--36675 records with distinct device_id, containing null user column, email value in user column, containing email value in user_id column and device_id value in user_id column

SELECT [user],[user_id],device_id,COUNT(DISTINCT device_id) as RecCount from tblHomeSpotter_DT
where [user] IS NOT NULL
group by [user],[user_id],device_id
order by [user]
--4102 records, where users are registered with email have distinct device_id

SELECT [user],[user_id],device_id,COUNT(DISTINCT device_id) as RecCount from tblHomeSpotter_DT
where [user] IS NULL
and [user_id] like '%@%'
group by [user],[user_id],device_id
order by [user]
--2716 records, where user column do not have email but user_id consist email having distinct device_id

SELECT COUNT(DISTINCT device_id),[user],[user_id],device_id from tblHomeSpotter_DT
where [user] IS NULL
and [user_id] not like '%@%'
group by [user],[user_id],device_id
order by [user]
--29856 records, where users are not registered with there email having ditinct device_id


SELECT COUNT(DISTINCT device_id)
	,[user]
	,[user_id]
	,device_id 
	,row_number() over(partition by device_id order by device_id) as rn
	from tblHomeSpotter_DT
where [user] is null
--and [user_id] is null
group by [user],[user_id],device_id





select count(1) from tblhomespotter_dt
where session_end_guess_utc IS NULL --86180

select distinct DAY(session_start_utc),
		[user_id]
		,[user]
		,hs_agent_id
		,device_id
		,ip_address from tblHomeSpotter_DT

select 
	[user_id]
	,[user]
	,hs_agent_id
	,agent_name
	,device_id
	,ip_address
	,CAST(session_start_utc as DATE)
	,count(1) as Total
	,row_number() over(partition by ip_address order by ip_address ) as rn
from tblHomeSpotter_DT
where 
	[user_id] IS NOT NULL
	and [user] IS NOT NULL
	and hs_agent_id IS NOT NULL
	and device_id IS NOT NULL
group by
	[user_id]
	,[user]
	,hs_agent_id
	,agent_name
	,device_id
	,ip_address
	,CAST(session_start_utc as DATE)
--having count(1)>1
order by CAST(session_start_utc as DATE) 
--1680 detailed records with distinct IP address(same user can be found with same device_id, email, agent but with different ip_address)

--DISTINCT Device_ID Daily
select 
	CAST(session_start_utc as DATE) As RecDate,
	COUNT(DISTINCT device_id) as DicDeviceCount 	
from tblHomeSpotter_DT
group by 
	CAST(session_start_utc as DATE)
order by CAST(session_start_utc as DATE)


--Disinct Email ID Daily
select 
	CAST(session_start_utc as DATE) As RecDate,
	COUNT(DISTINCT [user]) as EmailId
from tblHomeSpotter_DT
group by 
	CAST(session_start_utc as DATE)
order by CAST(session_start_utc as DATE)


select distinct day(session_start_utc) from tblhomespotter_dt

SELECT COUNT(1) TotalRecords, DAY(session_start_utc) As Dates
from tblHomeSpotter_DT
group by DAY(session_start_utc)

select 
	agent_name
	,hs_agent_id
	, count(1)
from tblHomeSpotter_DT
where agent_name is not null
group by 
	agent_name
	,hs_agent_id
order by agent_name

select * from tblhomespotter_dt
where agent_name = 'Albie Kuschel Jr.'
--Same Agent_Name and Agent_ID can have different user_id, user
--e.g agent_name: Albie Kuschel Jr. agent_id: 26483

select 
	agent_name,
	[user],
	count([user]) as RecCount
from tblHomeSpotter_dt
where agent_name is not null
and [user] is not null
group by agent_name, [user]
order by agent_name

select 
	[user],
	agent_name,
	count(agent_name) as RecCount
from tblHomeSpotter_dt
where agent_name is not null
and [user] is not null
group by [user],agent_name
order by [user]


select * from tblhomespotter_dt
where hs_agent_id = 124720

select * from tblhomespotter_dt
where hs_agent_id = 303226

select TOP 100 * from tblHomeSpotter_DT
where [user_id] IS NOT NULL
and [user] IS NOT NULL
and hs_agent_id IS NOT NULL
and agent_name IS NOT NULL


select count(distinct [user_id]) from tblHomeSpotter_DT
where [user_id] like '%@%' --3515
SELECT count(distinct [user_id]) FROM tblHomeSpotter_DT WHERE [user_id] NOT LIKE '%_@__%.__%' --25454

SELECT count(distinct [user_id]) FROM tblHomeSpotter_DT WHERE [user_id] LIKE '%@%.%' --3507

select distinct [user_id] FROM tblHomeSpotter_DT WHERE [user_id] LIKE '%@%.%' 
select TOP 10 * from tblEcrvBuyersForm_DT

--******************* Join Query between tblHomeSpotter_DT and tblEcrvBuyersForm_DT ***************
select 
	A.HomeSpotterId
	,A.[user_id]
	,A.[user]
	,A.hs_agent_id
	,A.agent_name
	,A.ip_address
	,A.session_start_utc
	,A.session_end_guess_utc
	,B.email
	,B.BuyersFormId
	,B.XMLFormId
	,B.crvNumberId
	,B.firstName
	,B.LastName
from tblHomeSpotter_DT A
join tblEcrvBuyersForm_DT B
on
A.[user] = B.email
order by A.session_start_utc
--where A.hs_agent_id is not null
--101 records where some records having NULL value for hs_agent_id and agent_name


--******************* Join Query between tblHomeSpotter_DT and tblEcrvSellersForm_DT ***************
select 
	A.HomeSpotterId
	,A.[user_id]
	,A.[user]
	,A.hs_agent_id
	,A.agent_name
	,A.ip_address
	,A.session_start_utc
	,A.session_end_guess_utc
	,B.email
	,B.BuyersFormId
	,B.XMLFormId
	,B.crvNumberId
	,B.firstName
from tblHomeSpotter_DT A
join tblEcrvSellersForm_DT B
on
A.[user] = B.email
order by A.session_start_utc
--where A.hs_agent_id is not null
--49 records where some records having NULL value for hs_agent_id and agent_name

--******************* Join Query between tblHomeSpotter_DT and tblEdinaEmailResults_DT ***************
select 
	A.HomeSpotterId
	,A.[user_id]
	,A.[user]
	,A.hs_agent_id
	,A.agent_name
	,A.ip_address
	,A.session_start_utc
	,A.session_end_guess_utc
	,B.email
	,B.EmailResultsId
	,B.mdmContactId
	,B.FirstName
	,B.resultDate
	,ROW_NUMBER() OVER(PARTITION BY A.device_id ORDER BY A.device_id) as RowNum
	into #tempresult
from tblHomeSpotter_DT A
join tblEdinaEmailResults_DT B
on
A.[user] = B.email
order by A.session_start_utc
--where A.hs_agent_id is not null
--353668 records where some records having NULL value for hs_agent_id and agent_name
drop table #tempresult

select count(1) from #tempresult

select * from #tempresult
where RowNum = 1 --2682 distinct record 
order by session_start_utc

select TOP 10 * from #tempresult

select 
	* from #tempresult
	where RowNum = 1
where firstname is not null

where mdmContactId = '{13CF37E9-16BE-E511-8100-FC15B4289E14}'

select TOP 5 * from tblEdinaEmailResults_DT
where mdmContactId = '{13CF37E9-16BE-E511-8100-FC15B4289E14}'

--******************* Join Query between tblHomeSpotter_DT and tblEdinaWebsiteData_DT ***************
select 
	A.HomeSpotterId
	,A.[user_id]
	,A.[user]
	,A.hs_agent_id
	,A.agent_name
	,A.ip_address
	,A.device_id
	,A.session_start_utc
	,A.session_end_guess_utc
	,B.email
	,B.ListingId
	,B.WebsiteDataId
	,B.WebsiteUserId
	,B.FirstName
	,B.LastName
	,ROW_NUMBER() OVER(PARTITION BY A.device_id ORDER BY A.device_id) as RowNum
	into #tempresult
from tblHomeSpotter_DT A
join tblEdinaWebsiteData_DT B
on
A.[user] = B.email
order by A.session_start_utc
--where A.hs_agent_id is not null
--1485389 records where some records having NULL value for hs_agent_id and agent_name


drop table #tempresult

select TOP 100 * from #tempresult
order by session_start_utc

select * from #tempresult
where RowNum = 1 --3318 distinct record 
order by session_start_utc
--where device_id = 'C92FBA9D-7BBE-4052-A872-67ADD89D68C9'

select count(1) from #tempresult

select top 10 * from tblEdinaWebsiteData_DT
where email is not null

select count(1) from tblEcrvSellersForm_DT --751820





select TOP 100 * from tblHomeSpotter_DT
where  DAY(session_start_utc) = 9
and [user] IS NOT NULL
and agent_name IS NOT NULL

select count(1) from tblHomeSpotter_DT_bak

select top 10 * from tblHomeSpotter_DT_bak order by 1 desc

select distinct 
	hs_agent_id
	,agent_name
	,count(1)
	,row_number() over(partition by hs_agent_id,agent_name order by hs_agent_id,agent_name) as rNumber
from tblHomeSpotter_DT_BAK
where hs_agent_id is not null
and agent_name is not null
group by hs_agent_id,agent_name

CREATE TABLE DimZipCode
(
	ZipCode BIGINT,
	City	VARCHAR(63),
	County	VARCHAR(63)
)
SELECT COUNT(*) FROM DimZipCode --1031
Columns: 
ZipCode 
City	
County	



bcp dbo.DimZipCode in D:\Edina\SharedOnSkype\zip_codes.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","

declare @num int
set @num = (next value for getgroupid)
print @num

select * from LogTaskControlFlow(NOLOCK)
order by 1 desc

select * from logerror(NOLOCK)
order by 1 desc

SELECT LogTaskId FROM LogtaskControlFlow (NOLOCK)WHERE FeedName = 'HS_DataFeed' AND GroupId = 45 

sp_who