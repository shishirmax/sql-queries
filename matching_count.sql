-- ~~~~~~~~~ For eCRV ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
select count(distinct email) from tblEcrvBuyersForm_DT 
where email is not null --10077

select count(distinct email) from tblEcrvSellersForm_DT
where email is not null --5651

-- ~~~~~~~~~ For Edina ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

select count(distinct Email) from [dbo].[tblEdinaWebsiteData_DT]
where Email is not null --57868

select count(distinct BuyerEmail) from [dbo].[tblEdinaSales_DT]
where BuyerEmail is not null --60152

select count(distinct Email) from [dbo].[tblEdinaEmailResults_DT]
where Email is not null --342584

-- ~~~~~~~~~ For HomeSpotter ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
	,CreatedDate = GETDATE()
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
into #tempPerson
from [dbo].[DimPerson]
where HomeSpotterPersonId is not null

select * from #tempPerson

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