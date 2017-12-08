
select TOP 100 * from tblecrvaddress
where AddressLine1 like 'c/o%'



Select * from edina.cs_200k_sample_universe_20171023

select count(*) from edina.cs_200k_sample(vdbs) --200000
select count(*) from Trulia_Property_Info_V3 --1789188
select count(*) from tblEcrvAddress --1953017

select TOP 100 AddressLine1,AddressLine2,Zip,Sale_Date,crvNumberId,tblEcrvAddressId from tblEcrvAddress
/*
======================================================================================================= 
Matching Query between VDBS and eCRV Starts
======================================================================================================= 
*/

select
A.CASS_Address_Property+' '+A.CASS_Zip_Property As VDBS_Address,
B.AddressLine1+' '+B.Zip As Trulia_Address,
--YEAR(CAST(CONVERT(VARCHAR,A.PRIOR_SALE_DATE_Property,101) AS DATETIME)) As PRIOR_SALE_DATE_Property ,
YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) As SALE_DATE_Property,
YEAR(B.Sale_Date) As Sale_Date,
B.crvNumberId As crvNumberId,
Case
	when YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) > YEAR(B.Sale_Date)
		Then 'VDBS_Sale_Date is Greater'
	when YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) = YEAR(B.Sale_Date)
		Then 'Both Equal'
	When YEAR(B.Sale_Date) IS NULL
		Then 'eCRV Sale Date is NULL'
	Else 'eCRV Sale Date is Greater'
End As DateCompare
into #DateCompareTemp
from edina.cs_200k_sample A
join tblEcrvAddress B
on A.CASS_Address_Property like '%'+AddressLine1+'%'
and A.CASS_Zip_Property = B.Zip
where 
ISDATE(A.PRIOR_SALE_DATE_Property) = 1
and ISDATE(A.SALE_DATE_Property) = 1
and A.CASS_Address_Property IS NOT NULL
--and A.CASS_Address_Property like '%221%'
--and A.CASS_Address_Property like '%SEIFERT ST%'
and A.SALE_DATE_Property IS NOT NULL
and A.PRIOR_SALE_DATE_Property IS NOT NULL
and B.AddressLine1 <> ''

/*
======================================================================================================= 
Matching Query between VDBS and eCRV Ends
======================================================================================================= 
*/

Select top 5 * from edina.cs_200k_sample
select top 50
HHID_Appended,
CASS_Address_Property,
CASS_Zip_Property,
Address_Appended,
Zip_Appended
from edina.cs_200k_sample(NOLOCK)

select top 10 * from tblEcrvAddress
select count(1) from tblEcrvAddress --1953017
select count(1) from tblEcrvAddress where AddressLine2 = 'NA' --1864109

select COUNT(*) from tblEcrvAddress where AddressLine2 <> 'NA' --88908

select TOP 10 * from tblEcrvAddress where AddressLine2 <> 'NA'


/*
======================================================================================================= 
Matching Query between VDBS and Trulia Starts
======================================================================================================= 
*/
select
A.CASS_Address_Property+' '+A.CASS_Zip_Property As VDBS_Address,
B.StreetNumber+' '+B.Street+' '+B.Zip As Trulia_Address,
--YEAR(CAST(CONVERT(VARCHAR,A.PRIOR_SALE_DATE_Property,101) AS DATETIME)) As PRIOR_SALE_DATE_Property ,
YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) As SALE_DATE_Property,
YEAR(B.PriceHistory_1_date) As PriceHistoryDate_1,
B.propertyId As TruliaPropertyID,
B.ID As TruliaID,
Case
	when YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) > YEAR(B.PriceHistory_1_date)
		Then 'VDBS_Sale_Date is Greater'
	when YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) = YEAR(B.PriceHistory_1_date)
		Then 'Both Equal'
	When YEAR(B.PriceHistory_1_date) IS NULL
		Then 'Trulia_PricehistoryDate is NULL'
	Else 'Trulia_PricehistoryDate is Greater'
End As DateCompare
into #DateCompareTemp
from edina.cs_200k_sample A
left join Trulia_Property_Info_V3 B
on A.CASS_Address_Property like '%'+StreetNumber+'%'
and A.CASS_Address_Property like '%'+Street+'%'
and A.CASS_Zip_Property = B.Zip
where 
ISDATE(A.PRIOR_SALE_DATE_Property) = 1
and ISDATE(A.SALE_DATE_Property) = 1
and A.CASS_Address_Property IS NOT NULL
--and A.CASS_Address_Property like '%221%'
--and A.CASS_Address_Property like '%SEIFERT ST%'
and A.SALE_DATE_Property IS NOT NULL
and A.PRIOR_SALE_DATE_Property IS NOT NULL
and B.StreetNumber <> ''
and B.Street <> ''
/*
======================================================================================================= 
Matching Query between VDBS and Trulia Ends
======================================================================================================= 
*/
select * from #DateCompareTemp

/*
======================================================================================================= 
Matching Query between VDBS , Trulia and eCRV Starts
======================================================================================================= 
*/

select
A.CASS_Address_Property+' '+A.CASS_Zip_Property As VDBS_Address,
B.AddressLine1+' '+B.Zip As eCRV_Address,
C.StreetNumber+' '+C.Street+' '+C.Zip As Trulia_Address,
--YEAR(CAST(CONVERT(VARCHAR,A.PRIOR_SALE_DATE_Property,101) AS DATETIME)) As PRIOR_SALE_DATE_Property ,
YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) As SALE_DATE_Property,
YEAR(B.Sale_Date) As Sale_Date,
YEAR(C.PriceHistory_1_date) As PriceHistoryDate_1,
A.RecordID_Appended,
B.crvNumberId As crvNumberId,
C.propertyId As TruliaPropertyID,
Case
	when YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) > YEAR(B.Sale_Date) and YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) > YEAR(C.PriceHistory_1_date)
		Then 'VDBS_Sale_Date is Greater'
	when YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) = YEAR(B.Sale_Date) and YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) = YEAR(C.PriceHistory_1_date)
		Then 'Both Equal'
	when YEAR(B.Sale_Date) > YEAR(C.PriceHistory_1_date) and YEAR(B.Sale_Date) > YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME))
		Then 'eCRV Sale Date is Greater'
	When YEAR(B.Sale_Date) IS NULL
		Then 'eCRV Sale Date is NULL'
	When YEAR(C.PriceHistory_1_date) IS NULL
		Then 'Trulia_PricehistoryDate is NULL'
	Else 'Trulia_PricehistoryDate is Greater'
End As DateCompare
into #DateCompareTemp
from edina.cs_200k_sample A
left join tblEcrvAddress B
on A.CASS_Address_Property like '%'+AddressLine1+'%'
and A.CASS_Zip_Property = B.Zip
left join Trulia_Property_Info_V3 C
on A.CASS_Address_Property like '%'+C.StreetNumber+'%'
and A.CASS_Address_Property like '%'+C.Street+'%'
and A.CASS_Zip_Property = C.Zip
where 
ISDATE(A.PRIOR_SALE_DATE_Property) = 1
and ISDATE(A.SALE_DATE_Property) = 1
and A.CASS_Address_Property IS NOT NULL
and A.SALE_DATE_Property IS NOT NULL
and A.PRIOR_SALE_DATE_Property IS NOT NULL
and B.AddressLine1 <> ''
and C.StreetNumber <> ''
and C.Street <> ''

/*
======================================================================================================= 
Matching Query between VDBS , Trulia and eCRV Ends
======================================================================================================= 
*/



DROP table #DateCompareTemp

select DateCompare,COUNT(1) As TotalCount from #DateCompareTemp
GROUP BY DateCompare

select count(*) from #DateCompareTemp

Select * from #DateCompareTemp
where TruliaPropertyID = 'MN1000777786'

Select
StreetNumber+' '+Street+' '+Zip As Trulia_Address,
propertyId
from Trulia_Property_Info_V3
where propertyId = 'MN1000777786'

select 
AddressLine1+' '+Zip As eCRV_Address,
crvNumberId
from tblEcrvAddress
where crvNumberId = '204211'

select *,
CASS_Address_Property+' '+CASS_Zip_Property As VDBS_Address
from edina.cs_200k_sample
where CASS_Address_Property+' '+CASS_Zip_Property = '15400 CHIPPENDALE AVE W UNIT 204 55068'

RecordID_Appended
110755068-100646757-110755068-X900618316



select * from Trulia_Property_Info_V3

select count(DISTINCT propertyId) from Trulia_Property_Info_V3

--9255 WINDSOR TER
--425 CENTER AVE
--221 SEIFERT ST

select TOP 10 *
--PriceHistory_1_date,
--PriceHistory_2_date,
--PriceHistory_3_date,
--PriceHistory_4_date
from Trulia_Property_Info_V3
WHERE --YEAR(PriceHistory_1_date) > = 2017 AND 
StreetNumber like '%221%'  AND Street LIKE '%SEIFERT ST%' --AND StreetNumber = '701'
ORDER BY StreetNumber DESC


SELECT TOP 10 * FROM tblEcrvAddress
WHERE recordtype = 'eCRV_property_add' AND AddressLine1 LIKE '%CENTER AVE%' AND AddressLine1 LIKE '%425%'  --OR AddressLine1 LIKE '%8919%' ) --OR AddressLine2 LIKE '%9994%'  
ORDER BY AddressLine1

select TOP 10 TRY_CAST(SALE_DATE_Property AS DATETIME) from  edina.cs_200k_sample
where SALE_DATE_Property IS NOT NULL

select TOP 100 YEAR(TRY_CAST(PRIOR_SALE_DATE_Property AS DATETIME)) from  edina.cs_200k_sample

select top 10 * from tblEcrvPropertyForm_DT
select top 10 * from tblEcrvSalesAgreementForm_DT

select TOP 10 *
--PriceHistory_1_date,
--PriceHistory_2_date,
--PriceHistory_3_date,
--PriceHistory_4_date
from Trulia_Property_Info_V3

select TOP 10  StreetNumber,street, ApartmentNumber,zip from Trulia_Property_Info_V3
WHERE Zip = '55008' AND street LIKE '%carriage%' AND StreetNumber = '1575'

SELECT * FROM tblEdinaSales_DT
WHERE Address  = '1082 Prior Avenue S' AND city = 'Saint Paul' AND Zip = '55116' AND state = 'MN' AND Latitude = '44.909103000' AND Longitude = '-93.181953000'

--SELECT * FROM tblEcrvPropertyForm_DT

SELECT *
FROM tblEcrvBuyersForm_DT
WHERE FirstName LIKE '%Stephen%' AND LastName LIKE '%Helmstetter%'

SELECT * FROM tblEcrvSalesAgreementForm_DT WHERE XMLFormId IN (51999, 437116)



SELECT * FROM tblEcrvPropertyForm_DT
WHERE XMLFormId IN (27508, 407564)

SELECT * FROM tblEcrvSalesAgreementForm_DT
WHERE XMLFormId IN (27508, 407564)

SELECT Address, city, zip, state, latitude, longitude, count(1) FROM tblEdinaSales_DT
WHERE YEAR(Sale_date) >=2015 
GROUP BY Address, city, zip, state, latitude, longitude
HAVING COUNT(1) > 1



select ID,ApartmentNumber from Trulia_Property_Info_V3
where ApartmentNumber IS NOT NULL 
and ApartmentNumber <> ''

select TOP 1000 (StreetNumber+' '+Street+' Apt '+ApartmentNumber) As Address
from Trulia_Property_Info_V3
where ApartmentNumber IS NOT NULL 
and ApartmentNumber <> ''

--####################### HomeSpotter Daily Data ###################################################################

/*
--BCP Script
bcp dbo.tblHomeSpotter in D:\Edina\HomeSpotterFeed\06Dec17\edina_contata_sessions.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -a 16384 -b 20000 -q -c -t","
*/

select count(*) from tblHomeSpotter --175042

--29Nov --01Dec --02Dec --03Dec  --04Dec  --05Dec  --06Dec
--42586 --63911 --89088 --114929 --136078 --155966 --175042

select count(*) from tblHomeSpotter_FF --42586

select try_cast(replace(session_start_utc,'"','') as datetime) from tblHomeSpotter

Select count(1) TotalRecords, DAY(try_cast(replace(session_start_utc,'"','') as datetime)) As Dates from tblHomeSpotter
group by DAY(try_cast(replace(session_start_utc,'"','') as datetime))

select TOP 10 UPPER(DATENAME(D,EOMONTH(try_cast(replace(session_start_utc,'"','') as datetime))))+' '+CONVERT(VARCHAR(50),DATEPART(YEAR,EOMONTH(try_cast(replace(session_start_utc,'"','') as datetime))))
from tblHomeSpotter

select TOP 50 * from tblHomeSpotter
where [user] IS NOT NULL
and agent_name IS NOT NULL

--DELETE 
----SELECT *
--FROM tblHomeSpotter
--WHERE [user_id] = 'user_id'

select count(*) from tblHomeSpotter --42586

--********************* user_id Starts ********************************************
select [user_id], count(1) from tblHomeSpotter
where [user_id] is null
group by [user_id]
select MAX(LEN([user_id])) from tblHomeSpotter
select count(1),count(try_cast([user_id] as varchar)) from tblHomeSpotter
where [user_id] IS NOT NULL

--18 NULL
-- No Unique Column.
-- Max Length : 36
-- DataType Suggested: Varchar

select [user_id], count(1) from tblHomeSpotter
where [user_id] like '%@%'
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
select [user], count(1) from tblHomeSpotter
where [user] is null
group by [user]
select MAX(LEN([user])) from tblHomeSpotter
select count(1),count(try_cast([user] as varchar)) from tblHomeSpotter
where [user] IS NOT NULL
--19083 NULL Records
--Email type data, Not unique.
-- Max Length: 33
-- DataType Suggested: Varchar

select * from tblHomeSpotter
where [user] = 'ash.abrego@gmail.com'
-- user_id is equal to user when user column contains email id

select * from tblHomeSpotter
where [user] like '%aaron%'
or [user_id] like '%aaron%'

select * from tblHomeSpotter
where [user] IS NULL
-- user_id is equivalent to device_id when there is user column is null.

--********************* user Ends ********************************************

--********************* hs_agent_id Starts ********************************************
select hs_agent_id, count(1) from tblHomeSpotter
--where hs_agent_id is null
group by hs_agent_id
select MAX(LEN(hs_agent_id)) from tblHomeSpotter
select count(1),count(try_cast(hs_agent_id as INT)) from tblHomeSpotter
where hs_agent_id IS NOT NULL
--19686 NULL Records
--Integer type data
--Max length : 6
-- DataType Suggested: INT

select * from tblHomeSpotter
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
--39077 NULL Records
--No Unique Column
--String  type data
--Max length : 36
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
select device_id, count(1) from tblHomeSpotter
where device_id IS NULL
group by device_id
select MAX(LEN(device_id)) from tblHomeSpotter
select count(1),count(try_cast(device_id as varchar)) from tblHomeSpotter
where device_id IS NOT NULL
--23 NULL Records
--No Unique Column
--GUID type data
--Max length : 36
-- DataType Suggested: varchar


--device_Id is of 2 type:
--1. 00092A5A-5919-4931-89DD-F17490EC13FF
--2. 355301070635951

select len('00092A5A-5919-4931-89DD-F17490EC13FF')
select * from tblHomeSpotter
where device_id = '355301072091294'

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
--Max length : 15
-- DataType Suggested: varchar

select * from tblHomeSpotter
where ip_address = '104.129.196.110'

--for every unique ip_address there is single user_id, hs_agent_id, agent_name and device_id


--********************* ip_address Ends ********************************************

--********************* session_start_utc Start ********************************************
select session_start_utc, count(1) from tblHomeSpotter
--where session_start_utc IS NULL
group by session_start_utc
select MAX(LEN(replace(session_start_utc,'"',''))) from tblHomeSpotter
select count(1),count(try_cast(replace(session_start_utc,'"','') as datetime)) from tblHomeSpotter
where session_start_utc IS NOT NULL
--No NULL Records
--No Unique Column
--DateTime type data
--Max length : 19
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
where session_end_guess_utc IS NULL
group by session_end_guess_utc
having count(1)>1

select MAX(LEN(replace(session_end_guess_utc,'"',''))) from tblHomeSpotter
select count(1),count(try_cast(replace(session_end_guess_utc,'"','') as datetime)) from tblHomeSpotter
where session_end_guess_utc IS NOT NULL
--15628 NULL Records
--No Unique Column
--DateTime type data
--Max length : 19
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
--Max length : 1
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
--Max length : 3
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
--Max length : 1
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
--Max length : 2
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
--Max length : 2
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
--Max length : 1
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
--Max length : 1
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
--Max length : 1
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
--Max length : 1
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
--and agent_name IS NOT NULL

/*
======================================================================================================= 
Matching Query between VDBS and Trulia Starts
======================================================================================================= 
*/
select
A.HHID_Appended,
A.Address_Appended+' '+A.Zip_Appended As VDBS_Address,
B.StreetNumber+' '+B.Street+' '+B.ApartmentNumber+' '+B.Zip As Trulia_Address,
B.[Address]+' '+B.Zip As Trulia_Address_Combined,
YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) As SALE_DATE_Property,
YEAR(B.PriceHistory_1_date) As PriceHistoryDate_1,
B.propertyId As TruliaPropertyID,
B.ID As TruliaID,
ROW_NUMBER() OVER (PARTITION BY A.HHID_Appended ORDER BY A.HHID_Appended) AS rownumber,
Case
	when YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) > YEAR(B.PriceHistory_1_date)
		Then 'VDBS_Sale_Date is Greater'
	when YEAR(CAST(CONVERT(VARCHAR,A.SALE_DATE_Property,101) AS DATETIME)) = YEAR(B.PriceHistory_1_date)
		Then 'Both Equal'
	When YEAR(B.PriceHistory_1_date) IS NULL
		Then 'Trulia_PricehistoryDate is NULL'
	Else 'Trulia_PricehistoryDate is Greater'
End As DateCompare
into #DateCompareTemp
from edina.cs_200k_sample A
left join Trulia_Property_Info_V3_UniqueRecords B
on A.Zip_Appended = B.Zip
--and A.Address_Appended =  B.StreetNumber+' '+B.Street+' Apt '+B.ApartmentNumber
and A.Address_Appended = B.[Address]
where 
ISDATE(A.PRIOR_SALE_DATE_Property) = 1
and ISDATE(A.SALE_DATE_Property) = 1
--and A.SALE_DATE_Property IS NOT NULL
--and A.PRIOR_SALE_DATE_Property IS NOT NULL
--and B.StreetNumber <> ''
--and B.Street <> ''
--and B.ApartmentNumber <> ''
/*
======================================================================================================= 
Matching Query between VDBS and Trulia Ends
======================================================================================================= 
*/



Select top 50 *
select count(*) 
from edina.cs_200k_sample
select top 50
CASS_Address_Property,
CASS_Zip_Property,
Address_Appended,
Zip_Appended
from edina.cs_200k_sample

select TOP 100 * from Trulia_Property_Info_V3 where ApartmentNumber <> ''

select count(*) from #DateCompareTemp
where Trulia_Address_Combined IS NOT NULL
and rownumber = 1 --8394


select * from #DateCompareTemp
where Trulia_Address_Combined IS NOT NULL --8495
and rownumber >1 --101

/*
HHID_Appended found Duplicate, but PropertyId against them is different, address is also same.
110755441-900697789
110755706-102437776
110755746-102509065
14Q1-48BF4206-8B86-4339-837E-1F5D2AB7CACD
14Q1-5D55EBAC-DC8B-478C-971A-C2F47083C3FC
110755014-900105264
110755014-900106317
*/


select DateCompare,COUNT(1) As TotalCount from #DateCompareTemp
--where rownumber = 1
where Trulia_Address_Combined IS NOT NULL
and rownumber = 1
GROUP BY DateCompare



drop table #DateCompareTemp

--Trulia
select * from Trulia_Property_Info_V3_UniqueRecords
where propertyid in ('40863666','MN86746')

select count(*) from Trulia_Property_Info_V3_UniqueRecords --1210633


select count(*) from Trulia_Property_Info_V3 --1789188
select count(distinct propertyId) from Trulia_Property_Info_V3 --1214064

--select (1789188 - 1214064) --575124
select *,
row_number() over(partition by propertyId order by propertyId) as rownum
into #TempTrulia
from Trulia_Property_Info_V3

select count(*) from #TempTrulia
where rownum = 1 --1214065

select StreetNumber,Street,ApartmentNumber,propertyId,count(*) as recount
into #TempGroupBy
from Trulia_Property_Info_V3
where StreetNumber<>'' and Street <>'' and ApartmentNumber <> ''
group by StreetNumber,Street,ApartmentNumber,propertyId
having count(*)>1

select count(*) from #TempGroupBy --14370 record found duplicate when used with grouping the column StreetNumber,Street,ApartmentNumber,propertyId
--sample propertyId: MN1000131738,MN1000154316,MN21128786,MN1000225814,MN21126200

select TOP 50 * from #TempGroupBy

select * from Trulia_Property_Info_V3
where propertyId = 'MN21126200'

select count(*) from #TempTrulia
where rownum>2 --140591

select TOP 50 * from #TempTrulia
where rownum>2


select * from Trulia_Property_Info_V3
where propertyId = '3230662967' --4 Duplicate record found, only change in EstimatedPrice

select * from Trulia_Property_Info_V3
where propertyId = '1000178262' 
--2 Duplicate record on basis of propertyid, address but both record have different Price_Hitory_Date and Price_History_Price
--ID:284003 contains NULL value over  Price_Hitory_Date and Price_History_Price columns
--ID:839342 contains proper values

select * from Trulia_Property_Info_V3
where Id IN ('491550','349258')
and propertyId = 'MN244245'

/*
Duplicate Record in Trulia_Property_Info_V3
ID('491550','349258')
propertyId = 'MN244245'

Different FileName: 
ID(349258) FileName(508672_587.txt)
ID(491550) FileName(509087_436.txt)
*/

select count(1) from Trulia_Property_Info_V3 --1789188

select TOP 10 *
--count(1) 
from Trulia_Check --12130