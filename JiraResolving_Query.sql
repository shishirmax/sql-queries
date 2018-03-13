SELECT * FROM [ZeroRez].[DimClient] 
WHERE 
FirstName LIKE '%[^a-z,A-Z, ]%' 
OR
lastName LIKE '%[^a-z,A-Z, ]%'

/*
Characters Found 
1. (.)Dot e.g: Eric M., Emily.
2. (&) e.g: Eric & Allie, Ericka & Adam
3. (') e.g: O'Brien, O'Kane
4. () Name inside bracket e.g: James (Jim), James (Peter)
5. ("") e.g: James Jim""
6. (/) Name seperated using / e.g: Jana/ Linda/Norleen
7. (-) Name seperated using - e.g: Adamson-Waitley
*/

SELECT * FROM [ZeroRez].[DimClient] 
WHERE FirstName LIKE '%[0-9]%'
OR
LastName LIKE '%[0-9]%'

SELECT * FROM [ZeroRez].[DimClient] 
WHERE FirstName LIKE '%"%' or LastName LIKE '%"%'

DECLARE @str VARCHAR(400)
DECLARE @expres  VARCHAR(50) = '%[0-9]%'
SET @str = 'Hoang Van-63'
WHILE PATINDEX( @expres, @str ) > 0
SET @str = Replace(REPLACE( @str, SUBSTRING( @str, PATINDEX( @expres, @str ), 1 ),''),'-',' ')
SELECT @str

select REPLACE(REPLACE('Mary @ Dan','@',''),'  ',' ')

select top 10 * from ZeroRez.ZeroRez_bcp 

select replace('Hoang Van-63',substring('Hoang Van-63',PATINDEX('%[0-9]%','Hoang Van-63'),1),'')

SELECT REPLACE('Cindy A2')

select * from [dbo].[LogError]
select * from [dbo].[LogTaskControlFlow]
order by 2 desc

DECLARE @txt VARCHAR(100)
SET @txt = 'Ann M. & Jim'
SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@txt,'.',''),'"',''),'0',''),'1',''),'2',''),'3',''),'4',''),'5',''),'6',''),'7',''),'8',''),'9','')


--ERA-132
select * from [ZeroRez].[FactZeroRezDedupData] where EmailGroupId is NULL 
or EmailGroupId =''

--ERA-133
select * from [ZeroRez].[FactZeroRezDedupData] where PhoneGroupId is NULL 
or PhoneGroupId =''

select abs(checksum(NewId()) % 10)

select CAST(RAND(CHECKSUM(NEWID())) * 10  as INT)

select RAND(convert(varbinary, newid())) magic_number 

SELECT table_name, 1.0 + floor(14 * RAND(convert(varbinary, newid()))) magic_number 
FROM information_schema.tables

set nocount on;

if object_id('dbo.Tally') is not null drop table dbo.tally
go

select top 10 identity(int,1,1) as ID
into dbo.Tally from SysColumns

alter table dbo.Tally
add constraint PK_ID primary key clustered(ID)
go

select * from dbo.Tally

select top 10 * FROM SysColumns


--ERA 231
select count(1),
OrderNumber,
ClosingStart,
ClosingEnd,
AddressId,
BuyerAccountID,
SellerAccountID,
OwnersPolicySold,
SellingAgentCodeID,
ListingAgentCodeID,
GrossCommision,
LastModifiedOn from edina.facttitle
group by
OrderNumber,
ClosingStart,
ClosingEnd,
AddressId,
BuyerAccountID,
SellerAccountID,
OwnersPolicySold,
SellingAgentCodeID,
ListingAgentCodeID,
GrossCommision,
LastModifiedOn 
having count(1)>1 

--ERA 229
select TOP 100 * from Edina.FactTitle 
where 
		ClosingStart	is null --Will Get Fixed as soon older dated will be uploaded in DimDate table
and		ClosingEnd		is null --Will Get Fixed as soon older dated will be uploaded in DimDate table
and		BuyerAccountID	is null
and		SellerAccountID	is null

SELECT COUNT(1) FROM Edina.FactTitle
WHERE BuyerAccountID IS NULL --6354

SELECT COUNT(1) FROM Edina.FactTitle
WHERE SellerAccountID IS NULL --43145

Usp_EdinaMergeFact
Usp_EdinaMergeFactSales
Usp_MergeTitleFact


 SELECT T.OrderNumber as OrderNumberID  
  ,T.OwnersPolicySold as OwnerPolicySoldID  
  ,DT.ITitleID  
  ,DT.orderNumber  
  ,DT.propertyAddress  
  ,DT.propertyCity  
  ,DT.propertyState  
  ,DT.propertyZip  
  ,DT.buyer  
  ,DT.seller  
  ,DT.ownersPolicySold  
  ,DT.sellingAgentCode  
  ,DT.listingAgentCode  
  INTO #TempTable  
  FROM Edina.FactTitle T  
  INNER JOIN Edina.DimOrderNumber DO ON DO.IOrderNumberID=T.OrderNumber  
  INNER JOIN Edina.DimPolicySold PD ON PD.IPolicySoldId=T.OwnersPolicySold  
  INNER JOIN Edina.[tblEdinaTitle_DT] DT     
   ON  ISNULL(DT.OrderNumber,'')  = DO.OrderNumber  
   AND ISNULL(DT.ownersPolicySold,'') = PD.PolicySold 

DROP TABLE #TempTable
select * from #TempTable


select * from Edina.[tblEdinaTitle_DT]

--UPDATE T SET BuyerAccountID=AccountID --(166235 rows affected) ON Updating BuyerAccountID
SELECT COUNT(1),DA.AccountID,DT.ITitleID,DT.OrderNumberID,DT.OwnerPolicySoldID,T.OrderNumber,T.OwnersPolicySold,DA.PersonRoleId
  FROM Edina.FactTitle T  
	INNER JOIN #TempTable DT  
		ON DT.OrderNumberID=T.OrderNumber  
		AND DT.OwnerPolicySoldID=T.OwnersPolicySold  
	INNER JOIN Edina.DimAccount DA    
		ON DA.AccountId=DT.ITitleID  
		AND DA.PersonRoleId=4
	GROUP BY DA.AccountID,DT.ITitleID,DT.OrderNumberID,DT.OwnerPolicySoldID,T.OrderNumber,T.OwnersPolicySold,DA.PersonRoleId
	HAVING COUNT(1)>1
  -- WHERE DA.AccountId IS NULL
		--OR DT.ITitleID IS NULL

SELECT COUNT(1)
FROM #TempTable
WHERE ITitleID IS NULL

   UPDATE T SET SellerAccountID=AccountID  --(129444 rows affected) On Updating SellerAccountID
  FROM Edina.FactTitle T  
  INNER JOIN #TempTable DT   
   ON DT .OrderNumberID=T.OrderNumber  
   AND DT .OwnerPolicySoldID=T.OwnersPolicySold  
  INNER JOIN Edina.DimAccount DA    
   ON DA.AccountId=DT.ITitleID  
   AND DA.PersonRoleId=5  


SELECT TOP 10 * FROM Edina.DimAccount

SELECT    
  DO.IOrderNumberID as IOrderNumber ,      
  DD.DateId,      
  DD2.DateId,      
  PD.IPolicySoldId,   
  DT.grossCommission ,   
  DD3.DateId,  
  GETDATE(),  
  @logTaskId  
  FROM Edina.[tblEdinaTitle_DT] DT      
  INNER JOIN Edina.DimOrderNumber DO ON DO.OrderNumber=ISNULL(DT.OrderNumber,'')  
  INNER JOIN Edina.DimPolicySold PD ON PD.PolicySold=ISNULL(DT.ownersPolicySold,'')  
  LEFT JOIN DimDate DD ON DD.Date=ISNULL(CAST(DT.ClosingStart AS DATE),'1990-01-01')  
  LEFT JOIN DimDate DD2 ON DD2.Date=ISNULL(CAST(DT.ClosingEnd AS DATE),'1990-01-01')  
  LEFT JOIN DimDate DD3 ON DD3.Date=ISNULL(CAST(DT.LastModifiedOn AS DATE),'1990-01-01')  
  LEFT JOIN Edina.FactTitle T   
  ON DO.IOrderNumberID=T.OrderNumber      
  AND PD.IPolicySoldId=T.OwnersPolicySold  
  WHERE T.ITitleID IS NULL

SELECT DD.Date,DT.ClosingStart,DateId FROM 
Edina.[tblEdinaTitle_DT] DT 
LEFT JOIN DimDate DD ON DD.Date=ISNULL(CAST(DT.ClosingStart AS DATE),'1990-01-01') 
WHERE DateId IS NULL



SELECT * FROM DimDate
WHERE DateId IS NULL


----Title
--1. Load from flat file to FF
EXEC [Edina].[usp_LoadFlatToFF] '/sourceedinasales/Title-updated2015.csv','Title-updated2015.csv',  9999
EXEC [Edina].[usp_LoadFlatToFF] '/sourceedinasales/Title-updated2016.csv','Title-updated2016.csv',  9999
EXEC [Edina].[usp_LoadFlatToFF] '/sourceedinasales/Title-updated2017.csv','Title-updated2017.csv',  9999

--2. Cleanup of data
EXEC [Edina].[usp_CleanTitleRules]
EXEC [dbo].[usp_getDataTypeErrors] 'Edina','tblEdinaTitle_DT','tblEdinaTitle_FF'

--3. Load data to DT Tables
EXEC [Edina].[usp_LoadEdinaToDT] 9999

--4. Load One time data
EXEC [Edina].[OneTimeDataLoad]
--5. load Dimensions
[Edina].[Usp_MergeTitleData]
--6. Load Fact
EXEC [Edina].[Usp_MergeTitleFact]



	DROP EXTERNAL DATA SOURCE contata 
	CREATE EXTERNAL DATA SOURCE contata        
	WITH ( TYPE = BLOB_STORAGE, LOCATION = 'https://contata.blob.core.windows.net/sourceedinasales')


	--BULK INSERT  lubetech.tbl_StPaulFinalBCP FROM 'St Paul - Final.CSV' 
	--WITH (DATA_SOURCE = 'contata', FORMAT = 'CSV', FIELDTERMINATOR  = ',',FIRSTROW = 2, ROWTERMINATOR = '\n'); 

	BULK INSERT  lubetech.tbl_Final421BCP FROM 'Final - 421.csv' 
	WITH (DATA_SOURCE = 'contata', FORMAT = 'CSV', FIELDTERMINATOR  = ',',FIRSTROW = 2, ROWTERMINATOR = '\n'); 

select * from Edina.tblEdinaTitle_DT

select * from Edina.DimOrderNumber
select * from DimDate


--bcp "select * from lubetech.tblFileImport" queryout D:\Edina\lubetechData.csv -S tcp:contata.database.windows.net -d Edina_dev -U contata.admin@contata -P C@ntata123 -q -c -t"|"


--ERA-150 
--Data is getting inserted into Edina.DimAddress table through Usp_MergeMortgage SP
--RTRIM and LTRIM hass been added to the column for removing the Leading and Trailing Spaces, If Data will be uploaded again, all Issue with the leading and trailing spaces will get resolved.
select * from [Edina].[DimAddress] 
where --AddressLine1 like ' %'
City like '% '

select * from [Edina].[DimAddress] 
where State LIKE '% '

update [Edina].[DimAddress] set StandardAddress = LTRIM(RTRIM(StandardAddress))
AddressLine1
AddressLine2
City
State
Zip
OriginalAddress
StandardAddress

select count(1) from [Edina].[DimAddress] --239757

select TOP 100 * from [Edina].[DimAddress] 
where datalength(City) <> 0 --check if a SQL Server text column is empty

select * from [Edina].[DimAddress] 
where StandardAddress = 'NA' --2546



/*
Edina.DimAddress Dependencies
1. Usp_EdinaMergeFact
2. usp_MergeEdinaPropertyToDW
3. Usp_MergeMortgage
4. Usp_MergeMortgageFact
5. Usp_MergeSalesData
6. Usp_MergeSalesFact
7. Usp_MergeTitleData
8. Usp_MergeTitleFact
*/

SELECT RTRIM(LTRIM('Waseca '))
'Waseca'
'mn'
'Blaine '

'3925 200th St E,Farmington ,MN,55024'

--ERA-200
/*
Dependencies of SP on Edina.DimPerson table
1. Usp_MergeCampaignFact
2. usp_MergeEdinaToDW
3. Usp_MergeEmailData
4. Usp_MergeMortgage
5. Usp_MergeSalesData
6. Usp_MergeSalesFact
7. Usp_MergeTitleData
8. Usp_MergeWebsiteData
9. Usp_MergeWebsiteFact
*/
Select * from edina.DimPerson where SUBSTRING (Email,CHARINDEX('@', Email)+1,Len(Email)) like '%..%'


/*
cheryl@spacetables..com
snickers94@yahoo..com
eklone@gmail..com
shfranko@usfamily..net
bartoncherri@yaho..com

These emails getting inserted through Edina.tblEdinaSales_DT table
*/


select top 10 * from Edina.DimPerson
where datalength(Email) <> 0 

select count(1),Email
from Edina.DimPerson
group by Email

select * from Edina.tblEdinaEmailResults_DT
where Email = 'cheryl@spacetables..com'

select top 10 * from Edina.tblPerson_DT

select * from Edina.tblEdinaSales_DT
where BuyerEmail IN
(
'cheryl@spacetables..com'
,'snickers94@yahoo..com'
,'eklone@gmail..com'
,'shfranko@usfamily..net'
,'bartoncherri@yaho..com'
)

select * from Edina.tblEdinaSales_DT
where
SUBSTRING (BuyerEmail,CHARINDEX('@', BuyerEmail)+1,Len(BuyerEmail)) like '%..%'

select * from Edina.tblEdinaSales_DT
WHERE ISNULL(BuyerEmail, '') <> ''     
     AND     
     (    
      CHARINDEX(' ', LTRIM(RTRIM(BuyerEmail)))  <> 0 OR    
      CHARINDEX('/', LTRIM(RTRIM(BuyerEmail)))  <> 0 OR    
      CHARINDEX(':', LTRIM(RTRIM(BuyerEmail)))  <> 0 OR    
      CHARINDEX(';', LTRIM(RTRIM(BuyerEmail)))  <> 0 OR    
      (LEN(LTRIM(RTRIM(BuyerEmail)))-1 <= CHARINDEX('.', LTRIM(RTRIM(BuyerEmail)))) OR    
      (LTRIM(RTRIM(BuyerEmail)) like '%@%@%')OR     
      (LTRIM(RTRIM(BuyerEmail)) Not Like '_%@_%.__%')OR
	  SUBSTRING (LTRIM(RTRIM(BuyerEmail)),CHARINDEX('@', LTRIM(RTRIM(BuyerEmail)))+1,Len(LTRIM(RTRIM(BuyerEmail)))) like '%..%'    
     )

select * from Edina.tblEdinaSales_DT
--where CHARINDEX(' ', LTRIM(RTRIM(BuyerEmail)))  <> 0
where BuyerEmail = '+16514103796@tmomail.net'


select top 10 * from Edina.tblEdinaSales_AE
|Invalid Zip provided
'nick_ehalt@hotmail.com 
j_leier@hotmail.com '
'pshane@ faegre.com'


--ERA-202
select * from [dbo].[tblHomeSpotter_DT_BAK]
where [user] = 'brian+tester@homespotter.com'

 select * from edina.DimPerson where Email like '%[#!$&*?+/\;:]%' 