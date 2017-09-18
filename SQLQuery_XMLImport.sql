--create table tblXMLData(
--id int identity,
--XMLData xml,
--loadedDate datetime)

insert into tblXMLData(XMLData,loadedDate)
select CONVERT(xml,BulkColumn) As BulkColumn, GETDATE()
from openrowset(BULK 'D:\Edina\DataExtract\Generated Error\13_607265.xml',SINGLE_BLOB)As x

select * from tblXMLData

select ASCII('�')
select ASCII('�')
select ASCII('�')
select ASCII('�')
select ASCII('�')
--truncate table tblxmlData
--drop table tblxmlData

--declare @xml as xml,@hDoc as int, @sql nvarchar(max)
--select @xml = xmldata from tblXMLData
--exec sp_xml_preparedocument @hDoc output, @xml

--exec sp_xml_removedocument @hDoc


--create table tblXMLDataWithFileName(
--id int identity(1,1),
--XMLData xml,
--loadedDate datetime,
--XMLFilename varchar(max))

--select * from tblXMLDataWithFileName

--alter procedure sp_ImportXMLFileWithFilename
--@filename varchar(max)
--as
--begin
--declare @query varchar(max)
--set @query = 
--N'insert into tblXMLDataWithFileName(XMLData,loadedDate,'''+@filename+''')
--select CONVERT(xml,BulkColumn) As BulkColumn, GETDATE()
--from openrowset(BULK ''D:\Edina\DataExtract\Generated Error\' + @filename + ''',SINGLE_BLOB)As x'
--execute (@query)
--end

--sp_ImportXMLFileWithFilename 'testXml.xml'


--declare @XMLDoc XML
--declare @XMLDocId int
--set @XMLDoc = (select XMLData from tblXMLData where id = 14)

--exec sys.sp_xml_preparedocument @XMLDocId output, @XMLDoc

--select * from openxml(@XMLDocId,'/us.mn.state.mdor.ecrv.extract.form.EcrvForm/') ox;

--FOR EmailResult file
CREATE VIEW tblEmailResultsView AS 
    SELECT 
		MdmContactId,
		LastName,
		FirstName,
		IsActive,
		Email,
		CampaignName,
		Result,
		ResultDate
    FROM tblEmailResults
GO

select * from tblEmailResultsView

select * from tblEmailResults
sp_help tblEmailResults

bulk insert EdinaLocal.dbo.EmailResults
from 'D:\Edina\FromFTP\email-results.txt'
with
(
FIELDTERMINATOR='||',
FIRSTROW=2,
ROWTERMINATOR='\n'
)

insert into tblEmailResults
(MdmContactId,
		LastName,
		FirstName,
		IsActive,
		Email,
		CampaignName,
		Result,
		ResultDate)
select MdmContactId,
		LastName,
		FirstName,
		IsActive,
		Email,
		CampaignName,
		Result,
		ResultDate
from EdinaLocal.dbo.EmailResults

--FOR Sales File
sp_help tblSales
CREATE VIEW tblSalesView As
	SELECT
RecordIDs,
Company,
Prefix,
First,
Middle,
Last,
BuyerEmail,
Suffix,
Title,
PROPERTY_INDICATOR,
MUNICIPALITY_NAME,
OWNER_CORPORATE_INDICATOR,
LAND_USE,
OWNER_NAME,
OWNER_NAME_2,
OWNER_NAME_3,
ABSENTEE_OWNER,
Address,
City,
State,
Zip,
Zip4,
Latitude,
Longitude,
SCF,
ADDRESS_INDICATOR,
HOUSE_NUMBER_PREFIX,
HOUSE_NUMBER,
HOUSE_NUMBER_SUFFIX,
DIRECTION,
STREET_NAME,
MODE,
QUADRANT,
CARRIER_CODE,
HOUSE_NUMBER_PREFIX2,
HOUSE_NUMBER2,
HOUSE_NUMBER_SUFFIX2,
DIRECTION2,
STREET_NAME2,
MODE2,
QUADRANT2,
CARRIER_CODE2,
APT_UNIT_NUMBER2,
CITY2,
STATE2,
ZIP_CODE2,
TOTAL_VALUE_CALCULATED,
LAND_VALUE_CALCULATED,
IMPROVEMENT_VALUE_CALCULATED,
TOTAL_VALUE_CALCULATED_IND,
LAND_VALUE_CALCULATED_IND,
IMPROVEMENT_VALUE_CALCULATED_IND,
ASSD_TOTAL_VALUE,
ASSD_LAND_VALUE,
ASSD_IMPROVEMENT_VALUE,
ASSD_YEAR,
MKT_TOTAL_VALUE,
MKT_LAND_VALUE,
MKT_IMPROVEMENT_VALUE,
APPR_TOTAL_VALUE,
APPR_LAND_VALUE,
APPR_IMPROVEMENT_VALUE,
TAX_AMOUNT,
TAX_YEAR,
DOCUMENT_YEAR,
SALES_DEED_CATEGORY_TYPE,
RECORDING_DATE,
SALE_DATE,
SALE_PRICE,
SALE_CODE,
SELLER_NAME,
SellerEmail,
SALES_TRANSACTION_CODE,
RESIDENTIAL_MODEL_INDICATOR,
PRIOR_DOCUMENT_YEAR,
PRIOR_SLS_DEED_CATEGORY_TYPE,
PRIOR_RECORDING_DATE,
PRIOR_SALE_DATE,
PRIOR_SALE_PRICE,
PRIOR_SALE_CODE,
PRIOR_DEED_TYPE,
FRONT_FOOTAGE,
DEPTH_FOOTAGE,
ACRES,
LAND_SQUARE_FOOTAGE,
UNIVERSAL_BUILDING_SQUARE_FEET,
BUILDING_SQUARE_FEET_IND,
BUILDING_SQUARE_FEET,
LIVING_SQUARE_FEET,
GROUND_FLOOR_SQUARE_FEET,
GROSS_SQUARE_FEET,
ADJUSTED_GROSS_SQUARE_FEET,
BASEMENT_SQUARE_FEET,
GARAGE_PARKING_SQUARE_FEET,
YEAR_BUILT,
EFFECTIVE_YEAR_BUILT,
BEDROOMS,
TOTAL_ROOMS,
TOTAL_BATHS_CALCULATED,
TOTAL_BATHS,
FULL_BATHS,
HALF_BATHS,
QTR_BATHS1,
QTR_BATHS3,
BATH_FIXTURES,
AIR_CONDITIONING,
BASEMENT_FINISH,
BLDG_CODE,
BLDG_IMPV_CODE,
CONDITION,
CONSTRUCTION_TYPE,
EXTERIOR_WALLS,
FIREPLACE_IND,
FIREPLACE_NUMBER,
FIREPLACE_TYPE,
FOUNDATION,
FLOOR,
FRAME,
GARAGE,
HEATING,
MOBILE_HOME_IND,
PARKING_SPACES,
PARKING_TYPE,
POOL,
POOL_CODE,
QUALITY,ROOF_COVER,ROOF_TYPE,STORIES_CODE,STORIES_NUMBER,STYLE,UNITS_NUMBER,ELECTRIC_ENERGY,FUEL,SEWER,WATER,OWNER_OWNERSHIP_RIGHTS_CODE,SUBDIVISION_NAME,HOMESTEAD_EXEMPT2,VETERANS_EXEMPTION,DISABLED_EXEMPTION,WIDOW_EXEMPTION,AGED_EXEMPTION,CONSTRUCTION_CD,STYLE_CODE,SELLER_CARRY_BACK,SITUS_LATITUDE,SITUS_LONGITUE,LOAN_TO_VALUE,CENSUS_TRACT,ZONING,RANGE,TOWNSHIP,SECTION,QUARTER_SECTION,HOMESTEAD_EXEMPT1,COUNTY_USE_1,COUNTY_USE_2,NUMBER_OF_BUILDINGS,ListingId
from tblSales

bulk insert EdinaLocal.dbo.Sales
from 'D:\Edina\FromFTP\sales.txt'
with
(
FIELDTERMINATOR='||',
FIRSTROW=2,
ROWTERMINATOR='\n'
)


insert into tblSales
(RecordIDs,
Company,
Prefix,
First,
Middle,
Last,
BuyerEmail,
Suffix,
Title,
PROPERTY_INDICATOR,
MUNICIPALITY_NAME,
OWNER_CORPORATE_INDICATOR,
LAND_USE,
OWNER_NAME,
OWNER_NAME_2,
OWNER_NAME_3,
ABSENTEE_OWNER,
Address,
City,
State,
Zip,
Zip4,
Latitude,
Longitude,
SCF,
ADDRESS_INDICATOR,
HOUSE_NUMBER_PREFIX,
HOUSE_NUMBER,
HOUSE_NUMBER_SUFFIX,
DIRECTION,
STREET_NAME,
MODE,
QUADRANT,
CARRIER_CODE,
HOUSE_NUMBER_PREFIX2,
HOUSE_NUMBER2,
HOUSE_NUMBER_SUFFIX2,
DIRECTION2,
STREET_NAME2,
MODE2,
QUADRANT2,
CARRIER_CODE2,
APT_UNIT_NUMBER2,
CITY2,
STATE2,
ZIP_CODE2,
TOTAL_VALUE_CALCULATED,
LAND_VALUE_CALCULATED,
IMPROVEMENT_VALUE_CALCULATED,
TOTAL_VALUE_CALCULATED_IND,
LAND_VALUE_CALCULATED_IND,
IMPROVEMENT_VALUE_CALCULATED_IND,
ASSD_TOTAL_VALUE,
ASSD_LAND_VALUE,
ASSD_IMPROVEMENT_VALUE,
ASSD_YEAR,
MKT_TOTAL_VALUE,
MKT_LAND_VALUE,
MKT_IMPROVEMENT_VALUE,
APPR_TOTAL_VALUE,
APPR_LAND_VALUE,
APPR_IMPROVEMENT_VALUE,
TAX_AMOUNT,
TAX_YEAR,
DOCUMENT_YEAR,
SALES_DEED_CATEGORY_TYPE,
RECORDING_DATE,
SALE_DATE,
SALE_PRICE,
SALE_CODE,
SELLER_NAME,
SellerEmail,
SALES_TRANSACTION_CODE,
RESIDENTIAL_MODEL_INDICATOR,
PRIOR_DOCUMENT_YEAR,
PRIOR_SLS_DEED_CATEGORY_TYPE,
PRIOR_RECORDING_DATE,
PRIOR_SALE_DATE,
PRIOR_SALE_PRICE,
PRIOR_SALE_CODE,
PRIOR_DEED_TYPE,
FRONT_FOOTAGE,
DEPTH_FOOTAGE,
ACRES,
LAND_SQUARE_FOOTAGE,
UNIVERSAL_BUILDING_SQUARE_FEET,
BUILDING_SQUARE_FEET_IND,
BUILDING_SQUARE_FEET,
LIVING_SQUARE_FEET,
GROUND_FLOOR_SQUARE_FEET,
GROSS_SQUARE_FEET,
ADJUSTED_GROSS_SQUARE_FEET,
BASEMENT_SQUARE_FEET,
GARAGE_PARKING_SQUARE_FEET,
YEAR_BUILT,
EFFECTIVE_YEAR_BUILT,
BEDROOMS,
TOTAL_ROOMS,
TOTAL_BATHS_CALCULATED,
TOTAL_BATHS,
FULL_BATHS,
HALF_BATHS,
QTR_BATHS1,
QTR_BATHS3,
BATH_FIXTURES,
AIR_CONDITIONING,
BASEMENT_FINISH,
BLDG_CODE,
BLDG_IMPV_CODE,
CONDITION,
CONSTRUCTION_TYPE,
EXTERIOR_WALLS,
FIREPLACE_IND,
FIREPLACE_NUMBER,
FIREPLACE_TYPE,
FOUNDATION,
FLOOR,
FRAME,
GARAGE,
HEATING,
MOBILE_HOME_IND,
PARKING_SPACES,
PARKING_TYPE,
POOL,
POOL_CODE,
QUALITY,ROOF_COVER,ROOF_TYPE,STORIES_CODE,STORIES_NUMBER,STYLE,UNITS_NUMBER,ELECTRIC_ENERGY,FUEL,SEWER,WATER,OWNER_OWNERSHIP_RIGHTS_CODE,SUBDIVISION_NAME,HOMESTEAD_EXEMPT2,VETERANS_EXEMPTION,DISABLED_EXEMPTION,WIDOW_EXEMPTION,AGED_EXEMPTION,CONSTRUCTION_CD,STYLE_CODE,SELLER_CARRY_BACK,SITUS_LATITUDE,SITUS_LONGITUE,LOAN_TO_VALUE,CENSUS_TRACT,ZONING,RANGE,TOWNSHIP,SECTION,QUARTER_SECTION,HOMESTEAD_EXEMPT1,COUNTY_USE_1,COUNTY_USE_2,NUMBER_OF_BUILDINGS,ListingId)
select RecordIDs,
Company,
Prefix,
First,
Middle,
Last,
BuyerEmail,
Suffix,
Title,
PROPERTY_INDICATOR,
MUNICIPALITY_NAME,
OWNER_CORPORATE_INDICATOR,
LAND_USE,
OWNER_NAME,
OWNER_NAME_2,
OWNER_NAME_3,
ABSENTEE_OWNER,
Address,
City,
State,
Zip,
Zip4,
Latitude,
Longitude,
SCF,
ADDRESS_INDICATOR,
HOUSE_NUMBER_PREFIX,
HOUSE_NUMBER,
HOUSE_NUMBER_SUFFIX,
DIRECTION,
STREET_NAME,
MODE,
QUADRANT,
CARRIER_CODE,
HOUSE_NUMBER_PREFIX2,
HOUSE_NUMBER2,
HOUSE_NUMBER_SUFFIX2,
DIRECTION2,
STREET_NAME2,
MODE2,
QUADRANT2,
CARRIER_CODE2,
APT_UNIT_NUMBER2,
CITY2,
STATE2,
ZIP_CODE2,
TOTAL_VALUE_CALCULATED,LAND_VALUE_CALCULATED,IMPROVEMENT_VALUE_CALCULATED,TOTAL_VALUE_CALCULATED_IND,LAND_VALUE_CALCULATED_IND,IMPROVEMENT_VALUE_CALCULATED_IND,ASSD_TOTAL_VALUE,ASSD_LAND_VALUE,ASSD_IMPROVEMENT_VALUE,ASSD_YEAR,MKT_TOTAL_VALUE,MKT_LAND_VALUE,MKT_IMPROVEMENT_VALUE,APPR_TOTAL_VALUE,APPR_LAND_VALUE,APPR_IMPROVEMENT_VALUE,
TAX_AMOUNT,TAX_YEAR,DOCUMENT_YEAR,SALES_DEED_CATEGORY_TYPE,RECORDING_DATE,SALE_DATE,SALE_PRICE,SALE_CODE,SELLER_NAME,SellerEmail,SALES_TRANSACTION_CODE,RESIDENTIAL_MODEL_INDICATOR,PRIOR_DOCUMENT_YEAR,PRIOR_SLS_DEED_CATEGORY_TYPE,PRIOR_RECORDING_DATE,PRIOR_SALE_DATE,PRIOR_SALE_PRICE,PRIOR_SALE_CODE,PRIOR_DEED_TYPE,FRONT_FOOTAGE,DEPTH_FOOTAGE,ACRES,LAND_SQUARE_FOOTAGE,UNIVERSAL_BUILDING_SQUARE_FEET,BUILDING_SQUARE_FEET_IND,BUILDING_SQUARE_FEET,LIVING_SQUARE_FEET,GROUND_FLOOR_SQUARE_FEET,GROSS_SQUARE_FEET,ADJUSTED_GROSS_SQUARE_FEET,BASEMENT_SQUARE_FEET,GARAGE_PARKING_SQUARE_FEET,YEAR_BUILT,EFFECTIVE_YEAR_BUILT,BEDROOMS,TOTAL_ROOMS,TOTAL_BATHS_CALCULATED,TOTAL_BATHS,FULL_BATHS,HALF_BATHS,QTR_BATHS1,QTR_BATHS3,
BATH_FIXTURES,AIR_CONDITIONING,BASEMENT_FINISH,BLDG_CODE,BLDG_IMPV_CODE,CONDITION,CONSTRUCTION_TYPE,EXTERIOR_WALLS,FIREPLACE_IND,FIREPLACE_NUMBER,FIREPLACE_TYPE,FOUNDATION,FLOOR,FRAME,GARAGE,HEATING,MOBILE_HOME_IND,PARKING_SPACES,PARKING_TYPE,POOL,POOL_CODE,
QUALITY,ROOF_COVER,ROOF_TYPE,STORIES_CODE,STORIES_NUMBER,STYLE,UNITS_NUMBER,ELECTRIC_ENERGY,FUEL,SEWER,WATER,OWNER_OWNERSHIP_RIGHTS_CODE,SUBDIVISION_NAME,HOMESTEAD_EXEMPT2,VETERANS_EXEMPTION,DISABLED_EXEMPTION,WIDOW_EXEMPTION,AGED_EXEMPTION,CONSTRUCTION_CD,STYLE_CODE,SELLER_CARRY_BACK,SITUS_LATITUDE,SITUS_LONGITUE,LOAN_TO_VALUE,CENSUS_TRACT,ZONING,RANGE,TOWNSHIP,SECTION,QUARTER_SECTION,HOMESTEAD_EXEMPT1,COUNTY_USE_1,COUNTY_USE_2,NUMBER_OF_BUILDINGS,ListingId
from EdinaLocal.dbo.Sales

--FOR Website-data Files



sp_help tblWebsiteData

create view tblWebsiteDataView As
Select
ListingId,
CreatedDate,
Rating,
Type,
WebsiteUserId,
LastName,
FirstName,
Email,
PhoneNumber
from tblWebsiteData

bulk insert EdinaLocal.dbo.[Website-Data]
from 'D:\Edina\FromFTP\website-data.txt'
with
(
FIELDTERMINATOR='||',
FIRSTROW=2,
ROWTERMINATOR='\n'
)

--truncate table tblWebsiteData
insert into tblWebsiteData
		(ListingId,
		CreatedDate,
		Rating,
		Type,
		WebsiteUserId,
		LastName,
		FirstName,
		Email,
		PhoneNumber)
select 
		ListingId,
		CreatedDate,
		Rating,
		Type,
		WebsiteUserId,
		LastName,
		FirstName,
		Email,
		PhoneNumber
from [website-data]

select * from [website-data]
select * from sales


select * from tblWebsiteData
select * from tblSales
select * from tblEmailResults


select * from tblWebsiteDataView
select * from tblsalesView
select * from tblEmailResultsView