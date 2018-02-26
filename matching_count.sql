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

--UPDATE P-- ~14K
--SET HomeSpotterPersonId = IUserId
-- ,ModifiedDate  = GETDATE()
-- ,ModifiedBy   = COALESCE(U.ModifiedBy, U.CreatedBy)
--FROM homeSpotter.DimUser(NOLOCK) U
--INNER JOIN dbo.DimPerson(NOLOCK) P
-- ON P.Email   = U.[User]

--INSERT INTO dbo.DimPerson (Email, HomeSpotterPersonId, CreatedDate, CreatedBy)-- 501
--SELECT DISTINCT U.[User], IUserId, GETDATE(), U.CreatedBy
--FROM homeSpotter.DimUser(NOLOCK) U
--LEFT JOIN dbo.DimPerson(NOLOCK) P
-- ON P.Email   = U.[User]
--WHERE P.Email IS NULL

select * 
into #tempPerson
from [dbo].[DimPerson]
where HomeSpotterPersonId is not null

select * from #tempPerson

select * from [dbo].[DimPerson]
where CAST(ModifiedDate As DATE) = '2018-02-26' --14198

