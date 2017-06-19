select * from CONTACT
select BILL_ATTN, PHONE, FAX from CONTACT

select STREET_ADDRESS_1, STREET_ADDRESS_2, CITY, COUNTRY, PHONE from ADDRESS

select * from ADDRESS
where ADDRESS_ID in (select ADDRESS_ID from MASTER_BUSINESS_ENTITY)

select * from CONTACT
where CONTACT_ID in (select CONTACT_ID from MASTER_BUSINESS_ENTITY)

select * from MASTER_BUSINESS_ENTITY

select * from CONTACT
where MASTER_BUSINESS_ENTITY_ID = 5001

select * from MASTER_PRODUCT
where PRODUCT_NAME IN ('mezcla','castilla')
go

sp_help master_product
go

select * from BATCH_SCHEDULE_DETAIL

select COMMENT from BATCH_SCHEDULE_DETAIL
where COMMENT like '%K%' 
or COMMENT like '%M%'

select LEN('<buqueid:K-0001>')
select * from MASTER_PRODUCT_GROUP

select * from BATCH_SCHEDULE_DETAIL

select * from BATCH_SCHEDULE

select * from MASTER_LOCATION

select * from
select* from BATCH_SCHEDULE_DETAIL

sp_help BATCH_SCHEDULE_DETAIL
select * from BATCH_SCHEDULE_ACTIVITY_TYPE
select * from BATCH_SCHEDULE
select * from MASTER_LOCATION
select * from tank
--Getting Product Name with parameter value
Declare @Product varchar(max) = 'mezcla' 

select * from MASTER_PRODUCT
where PRODUCT_NAME IN (@Product,@Product)

--Getting (Fecha) Date
select Month(START_TIME), Month(END_TIME) from BATCH_SCHEDULE_DETAIL

select cast(day(START_TIME) as varchar(2)) + ' - ' + cast(day(END_TIME) as varchar(2)) as FECHA
from BATCH_SCHEDULE_DETAIL
-----------------------------------------------------------------------------------------------
--Getting CARGUE(LOAD ID)
select REPLACE(SUBSTRING(COMMENT,CHARINDEX(':',COMMENT)+1,LEN(COMMENT)),'>','')
from BATCH_SCHEDULE_DETAIL
where COMMENT like '%K%' 
or COMMENT like '%M%'
------------------------------------------------------------------------------------------

--Getting Value for VESSEL/EXP
select 'TBN / '+DISPLAY_VALUE from MASTER_BUSINESS_ENTITY
where MASTER_BE_ID IN(Select SHIPPER_ID from BATCH_SCHEDULE_DETAIL)
-------------------------------------------------------------------

--Getting Value for TLU
Select LOCATION_NAME from MASTER_LOCATION
where MASTER_LOCATION_ID IN (select LOCATION_ID from BATCH_SCHEDULE_DETAIL)
---------------------------------------------------------------------------

--Getting value for Volume
select CAST(CAST(ROUND(QUANTITY/1000,0) as int) as varchar(50)) +' KB' from BATCH_SCHEDULE_DETAIL
-------------------------------------------------------------------------------------------------

--Getting the BPD Volume
--select sum(QUANTITY) from Batch_schedule_detail
select CAST(CAST(ROUND(sum(QUANTITY)/1000,0) as int) as varchar(50)) +' BPD' from BATCH_SCHEDULE_DETAIL
-------------------------------------------------------------------------------------------------------


--insert into BATCH_SCHEDULE_DETAIL
--(
--BATCH_SCHEDULE_ID,
--BATCH_ID,
--ACTIVITY_TYPE_ID,
--ACCOUNTING_ID,
--PRODUCT_ID,
--SA_REQ_ID,
--START_TIME,
--END_TIME,
--QUANTITY,
--INCREMENTAL_QTY,
--TOTAL_BATCH_QTY,
--BLEND,
--FIXED_RATE,
--LOCATION_ID,
--ROUTE,
--TANK_ID,
--SHIPPER_ID,
--CONSIGNEE,
--CARRIER_FROM,
--CARRIER_TO,
--COMMENT,
--DESTINATION_ID,
--DESTINATION_TANK_ID,
--RECORD_ACTION_TYPE,
--BATCH_SCHEDULE_PART_ID)
--VALUES
--(
--1000,
--'BA123',
--32,
--'BA123',
--123456,
--123456,
--'12/01/16',
--'12/02/16',
--123,
--123,
--123,
--'ABCD',
--120,
--18026,
--'ABCD',
--60386,
--422087,
--422087,
--422087,
--422087,
--'TestData',
--18026,
--60386,
--12345,
--'TestData'
--)


sp_help batch_schedule

sp_help contact
sp_help address

sp_help master_product
sp_help master_product_group

sp_help MASTER_BUSINESS_ENTITY
select * from MASTER_BUSINESS_ENTITY
where DISPLAY_VALUE like 'C%'

select * from INV_REQUEST_ITEM

select * from MASTER_PRODUCT
--where PRODUCT_CODE = 'CA'
order by PRODUCT_CODE

Contact A
Address B
Master_Business_Entity C
Batch_Schedule_Detail D

select
A.ADDRESS_ID as Contact_AddressID,
B.ADDRESS_ID as Address_AddressID,
C.ADDRESS_ID as MBE_AddressID,
A.CONTACT_ID as Contact_ContactID,
C.CONTACT_ID as MBE_ContactID, 
A.BILL_ATTN as ATTN, 
A.PHONE, 
A.FAX,
B.STREET_ADDRESS_1,
B.STREET_ADDRESS_2,
B.CITY, 
B.COUNTRY, 
B.PHONE,
C.SHORT_NAME as MBE_ShipperName,
cast(day(D.START_TIME) as varchar(2)) + ' - ' + cast(day(D.END_TIME) as varchar(2)) as BSD_Date
,D.COMMENT as BSD_Load,
'TBN/'+C.DISPLAY_VALUE as Vessel_Exp
,D.LOCATION_ID as TLU,
CAST(D.QUANTITY as varchar(50))+' KB' as Volume
from Contact A
join ADDRESS B on A.ADDRESS_ID = B.ADDRESS_ID
join MASTER_BUSINESS_ENTITY C on A.ADDRESS_ID = C.ADDRESS_ID
join BATCH_SCHEDULE_DETAIL D on C.MASTER_BE_ID = D.SHIPPER_ID
--order by A.BILL_ATTN


select * from CONTACT
select * from MASTER_BUSINESS_ENTITY
select * from BATCH_SCHEDULE_DETAIL

select * from 
MASTER_BUSINESS_ENTITY A
join 
BATCH_SCHEDULE_DETAIL B
on 
A.MASTER_BE_ID = B.SHIPPER_ID

select * from CONTACT A
join 
MASTER_BUSINESS_ENTITY B
on A.ADDRESS_ID = B.ADDRESS_ID
join 
BATCH_SCHEDULE_DETAIL C
on B.MASTER_BE_ID = C.SHIPPER_ID
