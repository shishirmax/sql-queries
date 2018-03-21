select top 10 * from [eCRV].[DimPerson]
select top 10 * from [edina].[DimPerson]

-- ~~~~~~~~~ For eCRV ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--############################### HomeSpotter With [eCRV].[DimPerson] ##########################
SELECT COUNT(1) FROM
(
	SELECT 
		A.IUserId
		,A.[User]
		,B.IPersonId
		,B.FirstName
		,B.MiddleName
		,B.LastName
		,B.Email
		,ROW_NUMBER() OVER(PARTITION BY IUserId ORDER BY IUserId) AS RowNumber
		--INTO #tempHomeSpottereCRVDimPerson
		FROM homeSpotter.DimUser(NOLOCK) A
		INNER JOIN eCRV.DimPerson(NOLOCK) B
		ON A.[User] = B.Email
)tbl
WHERE tbl.RowNumber =1

SELECT * FROM #tempHomeSpottereCRVDimPerson --135 records matched 

SELECT * FROM #tempHomeSpottereCRVDimPerson WHERE RowNumber = 1

DROP TABLE #tempHomeSpottereCRVDimPerson

--############################### HomeSpotter With [edina].[DimPerson] ##########################
SELECT 
A.IUserId
,A.[User]
,B.IPersonId
,B.FirstName
,B.MiddleName
,B.LastName
,B.Email
,B.IsSales
,B.IsWebsite
,B.IsCampaign
,B.IsTitle
,B.IsMortgage
,ROW_NUMBER() OVER(PARTITION BY IUserId ORDER BY IUserId) AS RowNumber
INTO #tempHomeSpotterEdinaDimPerson
FROM homeSpotter.DimUser(NOLOCK) A
INNER JOIN [edina].[DimPerson](NOLOCK) B
ON A.[User] = B.Email --20154

SELECT * FROM #tempHomeSpotterEdinaDimPerson 

SELECT * FROM #tempHomeSpotterEdinaDimPerson WHERE RowNumber = 1 --12638

/*
Total 20154 records matched HomeSpotter and Edina
12638 Distinct records matched.
The records from HomeSpotter is getting matched with multiple records in other table as the record in other table have same email id associated with Different indivisuals.

*/

--DROP TABLE #tempHomeSpotterEdinaDimPerson
--############################### HomeSpotter With eCRV BuyersForm ##########################
select count(distinct email) from tblEcrvBuyersForm_DT 
where email is not null --10077

select 
A.IUserId
,A.[User]
,B.BuyersFormId
,B.firstName
,B.middleName
,B.lastName
,B.email
,row_number() over(partition by IUserId order by IUserId) As RowNumber
into #tempHomeSpotterEcrvBuyersForm
from homeSpotter.DimUser(NOLOCK) A
inner join tblEcrvBuyersForm_DT(NOLOCK) B
on A.[user] = B.Email --58

select count(1) from #tempHomeSpotterEcrvBuyersForm where RowNumber = 1 --45

select * from #tempHomeSpotterEcrvBuyersForm

/*
The records from HomeSpotter is getting matched with multiple records in other table as the record in other table have same email id associated with Different indivisuals.
e.g:
IUserId	User					BuyersFormId	firstName	middleName	lastName	email					RowNumber
1672	cjb4368@gmail.com		529296			Kevin		R.			Anderson	cjb4368@gmail.com		1
1672	cjb4368@gmail.com		646260			Kevin		Richard		Anderson	cjb4368@gmail.com		2
3710	tacmedic50@yahoo.com	524031			Leah		H.			Ebeling		tacmedic50@yahoo.com	1
3710	tacmedic50@yahoo.com	524032			Shawn		R.			Ebeling		tacmedic50@yahoo.com	2
*/


--############################### HomeSpotter With eCRV SellersForm ##########################

select count(distinct email) from tblEcrvSellersForm_DT
where email is not null --5651


select 
A.IUserId
,A.[User]
,B.BuyersFormId
,B.firstName
,B.middleName
,B.lastName
,B.email
,row_number() over(partition by IUserId order by IUserId) As RowNumber
into #tempHomeSpotterEcrvSellerForm
from homeSpotter.DimUser(NOLOCK) A
inner join tblEcrvSellersForm_DT(NOLOCK) B
on A.[user] = B.Email --14

select count(1) from #tempHomeSpotterEcrvSellerForm where RowNumber = 1 --10
select * from #tempHomeSpotterEcrvSellerForm

-- ~~~~~~~~~ For Edina ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--################ HomeSpotter with EdinaWebSiteData #################
select count(distinct Email) from [dbo].[tblEdinaWebsiteData_DT]
where Email is not null --57868

select
--count(1)
--*
A.IUserId
,A.[user]
,B.Email 
,B.FirstName
,B.LastName
,row_number() over(partition by IUserId order by IUserId) as rn
INTO #tempHomeSpotterEdinaWebsite
from homeSpotter.DimUser(NOLOCK) A
inner join tblEdinaWebsiteData_DT(NOLOCK) B
on A.[user] = B.Email --381316 matched count records with HomeSpotter User(Email) to EdinaWebsiteData Email.
--where A.[user] is not null

select count(distinct IUserId ) from #tempHomeSpotterEdinaWebsite --11573

select * from #tempHomeSpotterEdinaWebsite where rn = 1

select *, row_number() over(partition by IUserId order by IUserId) as rn
from #tempHomeSpotterEdinaWebsite
where rn = 1

drop table #tempHomeSpotterEdinaWebsite


--################ HomeSpotter with EdinaSales #################

select 
--count(1)
A.IUserId
,A.[user]
,B.[First]
,B.Middle
,B.[Last]
,B.BuyerEmail
,row_number() over(partition by IUserId order by IUserId) as RowNumber
INTO #tempHomeSpotterEdinaSales
from homespotter.DimUser(NOLOCK) A
inner join dbo.[tblEdinaSales_DT](NOLOCK) B
on A.[User] = B.BuyerEmail --1303 matched count records with HomeSpotter User(Email) to EdinaSales BuyerEmail

select count(1) from #tempHomeSpotterEdinaSales where RowNumber = 1 --1189

select * from #tempHomeSpotterEdinaSales where RowNumber = 1

select count(distinct BuyerEmail) from [dbo].[tblEdinaSales_DT]
where BuyerEmail is not null --60152


--################ HomeSpotter with EdinaEmailResults #################

select 
A.IUserId
,A.[user]
,B.EmailResultsId
,B.FirstName
,B.LastName
,B.Email
,ROW_NUMBER() OVER(PARTITION BY IUserId ORDER BY IUserId) AS RowNumber
INTO #tempHomeSpotterEdinaEmailResults
from homespotter.DimUser(NOLOCK) A
inner join dbo.tblEdinaEmailResults_DT(NOLOCK) B
on A.[User] = B.Email --169687 matched count records with HomeSpotter User(Email) to EdinaEmailResults Email

SELECT COUNT(1) from #tempHomeSpotterEdinaEmailResults WHERE RowNumber = 1 --8966

SELECT * from #tempHomeSpotterEdinaEmailResults WHERE RowNumber = 1

select count(distinct Email) from [dbo].[tblEdinaEmailResults_DT]
where Email is not null --342584

-- ~~~~~~~~~ For HomeSpotter ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/* DimPerson Dependency
1. sp_helptext usp_InsertDWTablesData
2. usp_MergeEdinaToDW
3. usp_MergeHomeSpotterToDW
*/

select top 10 * from DimPerson
select [user], count(1) from tblHomeSpotter_DT_BAK
where [user] is not null
group by [user]

select count(distinct [user]) from tblHomeSpotter_DT_BAK
where [user] is not null

select top 10 * from [dbo].[DimPerson]
order by ModifiedDate desc
--where HomeSpotterPersonId is not null

select top 10 * from [dbo].[tblEcrvAddress]
select top 10 * from [dbo].[DimAddress] where StandardAddress is not null

UPDATE P-- ~14K
SET HomeSpotterPersonId = IUserId
	--,CreatedDate = GETDATE()
 ,ModifiedDate  = GETDATE()
 ,ModifiedBy   = COALESCE(U.ModifiedBy, U.CreatedBy)
FROM homeSpotter.DimUser(NOLOCK) U
INNER JOIN dbo.DimPerson(NOLOCK) P
 ON P.Email   = U.[User]
WHERE HomeSpotterPersonId IS NULL

INSERT INTO dbo.DimPerson (Email, HomeSpotterPersonId, CreatedDate, CreatedBy)-- 501
SELECT DISTINCT U.[User], IUserId, GETDATE(), U.CreatedBy
FROM homeSpotter.DimUser(NOLOCK) U
LEFT JOIN dbo.DimPerson(NOLOCK) P
 ON P.Email   = U.[User]
WHERE P.Email IS NULL

select *
--count(*) 
into #tempPerson
from [edina].[DimPerson]
where HomeSpotterPersonId is not null

select * from #tempPerson 
--Where FirstName is not null
order by HomeSpotterPersonId

drop table #tempPerson

SELECT 
	A.IPersonId
	,A.FirstName
	,A.MiddleName
	,A.LastName
	,A.Email
	,A.HomeSpotterPersonId
	,A.EcrvPersonId
	,A.EcrvAddressId
	,B.AddressLine1
	,B.AddressLine2
	,B.City
	,B.State
	,B.Zip
--INTO #tempOutData
FROM [dbo].[DimPerson] A
INNER JOIN [dbo].[DimAddress] B
ON A.EcrvAddressId = B.EcrvAddressId
WHERE HomeSpotterPersonId IS NOT NULL
order by IPersonId

select * from #tempOutData
--where FirstName is not null
where EcrvAddressId is not null
order by HomeSpotterPersonId asc



drop table #tempOutData
--CAST(ModifiedDate As DATE) = '2018-02-26' --14198

--BCP QUERY OUT
bcp "SELECT A.IPersonId,A.FirstName,A.MiddleName,A.LastName,A.Email,A.HomeSpotterPersonId,A.EcrvPersonId,A.EcrvAddressId,B.AddressLine1,B.AddressLine2,B.City,B.State,B.Zip FROM [dbo].[DimPerson] A INNER JOIN [dbo].[DimAddress] B ON A.EcrvAddressId = B.EcrvAddressId WHERE HomeSpotterPersonId IS NOT NULL order by IPersonId" queryout D:\Edina\HomeSpotterFeed\MatchedRecords.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t"|"