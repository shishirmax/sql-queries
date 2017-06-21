ALTER PROCEDURE SP_GetDetailReportTest
--Parameter
--Declare

--@System varchar(max) = 'Ocensa',
--@Shipper varchar(max) = NULL,
--@Program_Window_month datetime,
@ReportDate datetime,
--@System_Shutdown_Month datetime = NULL,
@Product varchar(max)
--@SenderContact varchar(max) = null,
--@ReportContact varchar(max) = null

As
Begin

Select 
	CO.ADDRESS_ID as Contact_AddressID,
	AD.ADDRESS_ID as Address_AddressID,
	MBE.ADDRESS_ID as MBE_AddressID,
	CO.CONTACT_ID as Contact_ContactID,
	MBE.CONTACT_ID as MBE_ContactID, 
	CO.BILL_ATTN as ATTN, 
	CO.PHONE, 
	CO.FAX,
	AD.STREET_ADDRESS_1,
	AD.STREET_ADDRESS_2,
	AD.CITY, 
	AD.COUNTRY, 
	AD.PHONE,
	MBE.SHORT_NAME as MBE_ShipperName,
	MP.PRODUCT_NAME,
	BSD.COMMENT,
	BSD.START_TIME,
	cast(day(BSD.START_TIME) as varchar(2)) + ' - ' + cast(day(BSD.END_TIME) as varchar(2)) as Fecha, --Getting (Fecha) Date
	REPLACE(SUBSTRING(BSD.COMMENT,CHARINDEX(':',BSD.COMMENT)+1,LEN(BSD.COMMENT)),'>','')as CARGUE, --Getting CARGUE(LOAD ID)
	'TBN/'+MBE.DISPLAY_VALUE as VESSEL_EXP, --Getting Value for VESSEL/EXP
	ML.LOCATION_NAME as TLU,--Getting Value for TLU
	CAST(CAST(ROUND(BSD.QUANTITY/1000,0) as int) as varchar(50)) +' KB' as Volume --Getting value for Volume
from Contact CO
join ADDRESS AD 
	on CO.ADDRESS_ID = AD.ADDRESS_ID
join MASTER_BUSINESS_ENTITY MBE 
	on CO.MASTER_BUSINESS_ENTITY_ID = MBE.MASTER_BE_ID
join BATCH_SCHEDULE_DETAIL BSD 
	on MBE.MASTER_BE_ID = BSD.SHIPPER_ID 
	and (BSD.COMMENT like '%K%' or BSD.COMMENT like '%M%')
	and MONTH(BSD.START_TIME) = MONTH(@ReportDate)
join MASTER_LOCATION ML 
	on BSD.LOCATION_ID = ML.MASTER_LOCATION_ID
join MASTER_PRODUCT MP 
	on MP.MASTER_PRODUCT_ID = BSD.PRODUCT_ID
	and  MP.PRODUCT_NAME = @Product  

 --MBE.MASTER_BE_ID IN(Select BSD.SHIPPER_ID from BATCH_SCHEDULE_DETAIL)
 --ML.MASTER_LOCATION_ID IN(select BSD.LOCATION_ID from BATCH_SCHEDULE_DETAIL)
-- 'MEZCLA' 'CASTILLA'
END