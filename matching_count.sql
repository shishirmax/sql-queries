select top 10 * from [eCRV].[DimPerson]
select top 10 * from [edina].[DimPerson]

--################################### Data for Edina IsWebsite #########################################

select count(1) from [edina].[DimPerson]
where IsWebsite = 1 --69879

select
IpersonId,
FirstName,
LastName,
Email
INTO tempEdinaIsWebsite
FROM edina.DimPerson
where IsWebsite = 1

select top 10 * from tempEdinaIsWebsite
where FirstName LIKE '%[@&]%'



bcp "SELECT IpersonId, FirstName, LTRIM(RTRIM(LastName)) As LastName,LTRIM(RTRIM(value)) As UpdatedFirstName  FROM tempEdinaIsWebsite CROSS APPLY STRING_SPLIT(FirstName, '&') ORDER BY IpersonId" queryout D:\Edina\HomeSpotterFeed\tempEdinaIsWebsite.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t"|"
SELECT IpersonId, FirstName, LTRIM(RTRIM(LastName)) As LastName,LTRIM(RTRIM(value)) As UpdatedFirstName  FROM tempEdinaIsWebsite CROSS APPLY STRING_SPLIT(FirstName, '&') ORDER BY IpersonId

--################################### Data for Edina IsCampaign #########################################

select count(1) from [edina].[DimPerson]
where IsCampaign = 1 --478674

select
IpersonId,
FirstName,
LastName,
Email
INTO tempEdinaIsCampaign
FROM edina.DimPerson
where IsCampaign = 1


select count(1) from tempEdinaIsCampaign --478674
select count(distinct IpersonId ) from tempEdinaIsCampaign --478674

select count(1),FirstName,LastName,Email from tempEdinaIsCampaign
group by FirstName,LastName,Email
having count(1)>1

select * from tempEdinaIsCampaign
where FirstName = 'Bob' and lastName = 'Hill'

select count(*) from tempEdinaIsCampaign
where FirstName LIKE '%[&]%' --19386

select top 10 * from tempEdinaIsCampaign
where FirstName LIKE '% and %' 

select replace('Heather and Carson',' and ',' & ')
SELECT IpersonId, FirstName, LTRIM(RTRIM(LastName)) As LastName,LTRIM(RTRIM(value)) As UpdatedFirstName FROM tempEdinaIsCampaign CROSS APPLY STRING_SPLIT(REPLACE(FirstName,' and ' ,' & '), '&') ORDER BY IpersonId

bcp "SELECT IpersonId, FirstName, LTRIM(RTRIM(LastName)) As LastName,LTRIM(RTRIM(value)) As UpdatedFirstName FROM tempEdinaIsCampaign CROSS APPLY STRING_SPLIT(REPLACE(FirstName,' and ' ,' & '), '&') ORDER BY IpersonId" queryout D:\Edina\HomeSpotterFeed\tempEdinaIsCampaign.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t"|"
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
		,C.AddressLine1
		,C.AddressLine2
		,C.City
		,C.[State]
		,C.Zip
		,ROW_NUMBER() OVER(PARTITION BY IUserId ORDER BY IUserId) AS RowNumber
		INTO #tempHomeSpottereCRVDimPerson
		FROM homeSpotter.DimUser(NOLOCK) A
		INNER JOIN eCRV.DimPerson(NOLOCK) B		
		ON A.[User] = B.Email
		INNER JOIN eCRV.DimAddress(NOLOCK) C
		ON B.AddressId = C.IAddressId
)tbl
WHERE tbl.RowNumber =1

SELECT *
--,row_number() over(partition by IuserId,[User],FirstName Order by IuserId,[User],FirstName) as rnn  
FROM #tempHomeSpottereCRVDimPerson --135 records matched 

SELECT * FROM #tempHomeSpottereCRVDimPerson WHERE RowNumber = 1

bcp "" queryout D:\Edina\HomeSpotterFeed\MatchedRecords.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t"|"

DROP TABLE #tempHomeSpottereCRVDimPerson

--###################################### Find Duplicate ########################################
select A.[User],A.FirstName,A.LastName,A.IPersonId, B.dupeCount, A.IUserId
from #tempHomeSpottereCRVDimPerson A
inner join (
    SELECT [User], COUNT(*) AS dupeCount
    FROM #tempHomeSpottereCRVDimPerson
    GROUP BY [User]
    HAVING COUNT(*) = 1
) B on A.[User] = B.[User]


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
ON A.[User] = B.Email --20179



SELECT * FROM #tempHomeSpotterEdinaDimPerson WHERE ISNULL(FirstName,'') = '' RowNumber = 1  and ISNULL(FirstName,'') <> ''--12656

DROP TABLE #tempHomeSpotterEdinaDimPerson

--SELECT COUNT(*) FROM #tempHomeSpotterEdinaDimPerson 
--WHERE IsSales = 1 --1487

--SELECT COUNT(*) FROM #tempHomeSpotterEdinaDimPerson 
--WHERE IsWebsite = 1 --13822

--SELECT COUNT(*) FROM #tempHomeSpotterEdinaDimPerson 
--WHERE IsCampaign = 1 --14834

--SELECT COUNT(*) FROM #tempHomeSpotterEdinaDimPerson 
--WHERE IsTitle = 1 --0

--SELECT COUNT(*) FROM #tempHomeSpotterEdinaDimPerson 
--WHERE IsMortgage = 1 --0

--#################### tempHomeSpotterEdinaDimPersonIsSales ###############################
CREATE TABLE tempHomeSpotterEdinaDimPersonIsSales
(
IUserId			BIGINT
,[User]			VARCHAR(155)
,IPersonId		BIGINT
,FirstName		VARCHAR(155)
,MiddleName		VARCHAR(155)
,LastName		VARCHAR(155)
,Email			VARCHAR(155)
,RowNumber		BIGINT
)

INSERT INTO tempHomeSpotterEdinaDimPersonIsSales
SELECT
IUserId		
,[User]		
,IPersonId	
,FirstName	
,MiddleName	
,LastName	
,Email		
,RowNumber
FROM #tempHomeSpotterEdinaDimPerson 
WHERE IsSales = 1 

SELECT * FROM tempHomeSpotterEdinaDimPersonIsSales
bcp "SELECT * FROM tempHomeSpotterEdinaDimPersonIsSales" queryout D:\Edina\HomeSpotterFeed\HomeSpotterEdinaDimPersonIsSales.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t"|"

--#################### tempHomeSpotterEdinaDimPersonIsCampaign ###############################
CREATE TABLE tempHomeSpotterEdinaDimPersonIsCampaign
(
IUserId			BIGINT
,[User]			VARCHAR(155)
,IPersonId		BIGINT
,FirstName		VARCHAR(155)
,MiddleName		VARCHAR(155)
,LastName		VARCHAR(155)
,Email			VARCHAR(155)
,RowNumber		BIGINT
)

INSERT INTO tempHomeSpotterEdinaDimPersonIsCampaign
SELECT
IUserId		
,[User]		
,IPersonId	
,FirstName	
,MiddleName	
,LastName	
,Email		
,RowNumber
FROM #tempHomeSpotterEdinaDimPerson 
WHERE IsCampaign = 1 

SELECT * FROM tempHomeSpotterEdinaDimPersonIsCampaign
bcp "SELECT * FROM tempHomeSpotterEdinaDimPersonIsCampaign" queryout D:\Edina\HomeSpotterFeed\HomeSpotterEdinaDimPersonIsCampaign.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t"|"

--#################### tempHomeSpotterEdinaDimPersonIsWebsite ###############################
CREATE TABLE tempHomeSpotterEdinaDimPersonIsWebsite
(
IUserId			BIGINT
,[User]			VARCHAR(155)
,IPersonId		BIGINT
,FirstName		VARCHAR(155)
,MiddleName		VARCHAR(155)
,LastName		VARCHAR(155)
,Email			VARCHAR(155)
,RowNumber		BIGINT
)

INSERT INTO tempHomeSpotterEdinaDimPersonIsWebsite
SELECT
IUserId		
,[User]		
,IPersonId	
,FirstName	
,MiddleName	
,LastName	
,Email		
,RowNumber
FROM #tempHomeSpotterEdinaDimPerson 
WHERE IsWebsite = 1 

SELECT * FROM tempHomeSpotterEdinaDimPersonIsWebsite
bcp "SELECT * FROM tempHomeSpotterEdinaDimPersonIsWebsite" queryout D:\Edina\HomeSpotterFeed\HomeSpotterEdinaDimPersonIsWebsite.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t"|"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


--######## EXPORTING DATA ##################################################
CREATE TABLE HomeSpotterMatchEdinaEcrv
(
IUserId			BIGINT
,[User]			VARCHAR(155)
,IPersonId		BIGINT
,FirstName		VARCHAR(155)
,MiddleName		VARCHAR(155)
,LastName		VARCHAR(155)
,Email			VARCHAR(155)
,RowNumber		BIGINT
)

INSERT INTO HomeSpotterMatchEdinaEcrv
SELECT * FROM #tempHomeSpottereCRVDimPerson
UNION
SELECT * FROM #tempHomeSpotterEdinaDimPerson 

select count(1) from HomeSpotterMatchEdinaEcrv --20294
SELECT count(distinct IpersonId) from HomeSpotterMatchEdinaEcrv --20293
select count(1) from HomeSpotterMatchEdinaEcrv Where RowNumber = 1 --HomeSpotterMatchEdinaEcrv
bcp "SELECT * from HomeSpotterMatchEdinaEcrv" queryout D:\Edina\HomeSpotterFeed\HomeSpotterMatchEdinaEcrv.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -q -c -t"|"

/*
Total 20154 records matched HomeSpotter and Edina
12638 Distinct records matched.
The records from HomeSpotter is getting matched with multiple records in other table as the record in other table have same email id associated with Different indivisuals.




*/

DROP TABLE #tempHomeSpotterEdinaDimPerson
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
from dbo.DimPerson
where HomeSpotterPersonId is not null

select * from #tempPerson
--where day(CreatedDate) = 23 
Where FirstName is not null and LastName is not null
order by HomeSpotterPersonId

drop table #tempPerson
--###################################### Find Duplicate #tempPerson ########################################
select A.[User],A.FirstName,A.LastName,A.IPersonId, B.dupeCount, A.IUserId
from #tempHomeSpottereCRVDimPerson A
inner join (
    SELECT [User], COUNT(*) AS dupeCount
    FROM #tempHomeSpottereCRVDimPerson
    GROUP BY [User]
    HAVING COUNT(*) = 1
) B on A.[User] = B.[User]

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

/*
#####################Rematching Count#############################
*/
select top 1 * from eCRV.FactSales
select top 1 * from ecrv.DimAccount

select top 1 * from ecrv.DimPerson
select top 1 * from ecrv.DimAddress where ISNULL(AddressLIne2,'') <> ''

select * from Edina.DimPerson where IPersonId IN (
select PersonId from [edina].[DimAccount] where AccountId = 22002)

select top 1 * from Edina.DimAddress
select top 1 * from Edina.DimPerson 

select top 1 * from [edina].[DimAccount]
select PersonId from [edina].[DimAccount] where AccountId = 22002

select top 10 * from [edina].[DimPersonRole]

select *
from homespotter.dimuser  join edina.dimperson
on homespotter.dimuser.[User]=edina.dimperson.email