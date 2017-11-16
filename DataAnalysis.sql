
select count(*) from tblEdinaWebsiteData_DT -- 938194
select count(*) from tblEdinaEmailResults_DT -- 8424034
select count(*) from tblEdinaSales_DT --134336


-------------------------------------------------------------------------------------------------
-- EDINA
-------------------------------------------------------------------------------------------------
-- EmailResults 
SELECT COUNT(1) FROM [dbo].[tblEdinaEmailResults_DT] -- 8424034
SELECT COUNT(1) FROM [dbo].[tblEdinaEmailResults_DT] WHERE Email IS NOT NULL -- 8203909
SELECT COUNT(DISTINCT Email) FROM [dbo].[tblEdinaEmailResults_DT] WHERE Email IS NOT NULL -- 342584

-- james_roloff@yahoo.com, 13440
SELECT Email, COUNT(1) FROM [dbo].[tblEdinaEmailResults_DT] 
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(1)>1
ORDER BY 2 DESC

SELECT * from tblEdinaEmailResults_DT
WHERE email = 'mjwelch62@gmail.com'
order by resultdate 

-- 2 ; only CampaignName is different in the two rows, rest of the information are same
SELECT DISTINCT MdmContactId, LastName, FirstName, IsActive, Email, CampaignName, Result FROM [dbo].[tblEdinaEmailResults_DT] WHERE Email = 'james_roloff@yahoo.com'

-- 1112 
SELECT COUNT(DISTINCT ED.Email)
FROM [tblEdinaEmailResults_DT] ED
INNER JOIN [tblEcrvBuyersForm_DT] EC
	ON ED.Email = EC.Email
	
SELECT DISTINCT Email INTO #tempEdinaEmail FROM [tblEdinaEmailResults_FF]
SELECT DISTINCT Email, daytimePhone INTO #tempEcrvEmail FROM [tblEcrvBuyersForm_DT]

SELECT TOP 100 *
FROM #tempEdinaEmail (NOLOCK) ED
INNER JOIN #tempEcrvEmail (NOLOCK) EC
	ON ED.Email = EC.Email

-- Differences in name between edina and xml buyer name for same email
SELECT DISTINCT MdmContactId, LastName, FirstName, IsActive, Email, CampaignName, Result 
FROM [tblEdinaEmailResults_FF]
WHERE Email IN 
(
	'bardonaghy@gmail.com'
	,'baueranderson@aol.com'
	,'bcrane2323@yahoo.com'
	,'bdsully63@hotmail.com'
	,'chad.grunewald@yahoo.com'
	,'chad@pedersonrealty.com'
	,'chenap2000@gmail.com'
	,'dehnelec@charter.net'
)
ORDER BY  EMail

SELECT DISTINCT firstName,middleName,lastName,nameSuffix,email,buyerType 
FROM [tblEcrvBuyersForm_DT]
WHERE Email IN 
(
	'bardonaghy@gmail.com'
	,'baueranderson@aol.com'
	,'bcrane2323@yahoo.com'
	,'bdsully63@hotmail.com'
	,'chad.grunewald@yahoo.com'
	,'chad@pedersonrealty.com'
	,'chenap2000@gmail.com'
	,'dehnelec@charter.net'
)
ORDER BY  EMail

-- WebsiteData

SELECT COUNT(1) FROM [dbo].tblEdinaWebsiteData_DT -- 844967
SELECT COUNT(1) FROM [dbo].tblEdinaWebsiteData_DT WHERE Email IS NOT NULL -- 841872
SELECT COUNT(DISTINCT Email) FROM [dbo].tblEdinaWebsiteData_DT WHERE Email IS NOT NULL -- 57042

SELECT COUNT(1) FROM [dbo].tblEdinaWebsiteData_DT WHERE PhoneNumber IS NOT NULL -- 103902
SELECT COUNT(DISTINCT Email) FROM [dbo].tblEdinaWebsiteData_DT WHERE PhoneNumber IS NOT NULL -- 6104

SELECT DISTINCT PhoneNumber, Email INTO #tempEdinaWebsiteEmailPhone FROM [dbo].tblEdinaWebsiteData_DT

SELECT top 100 * 
FROM #tempEcrvEmail EC
INNER JOIN #tempEdinaWebsiteEmailPhone ED
	ON EC.daytimePhone = ED.PhoneNumber

SELECT DISTINCT LastName, FirstName, Email, PhoneNumber FROM [dbo].tblEdinaWebsiteData_DT
WHERE PhoneNumber IN
(
	'2188384416',
	'3202673482',
	'3208158339',
	'3208286099',
	'7637446828',
	'9522502851',
	'9522506870',
	'9522617678',
	'9522701700',
	'1234567890',
	'2183914556',
	'2188393699',
	'3202907512'
)
ORDER BY PhoneNumber

SELECT DISTINCT lastName, firstName, email, daytimePhone FROM [dbo].[tblEcrvBuyersForm_DT]
WHERE daytimePhone IN
(
	'2188384416',
	'3202673482',
	'3208158339',
	'3208286099',
	'7637446828',
	'9522502851',
	'9522506870',
	'9522617678',
	'9522701700',
	'1234567890',
	'2183914556',
	'2188393699',
	'3202907512'
)
ORDER BY daytimePhone

-- Email And Phone 

SELECT DISTINCT LastName, FirstName, PhoneNumber, Email INTO #tempEdinaWebsite FROM [dbo].tblEdinaWebsiteData_DT -- 57502
SELECT DISTINCT LastName, FirstName, Email, IsActive INTO #tempEdinaEmail FROM [dbo].tblEdinaEmailResults_FF -- 192684
SELECT DISTINCT [Last], [first], [Middle], BuyerEmail, [Address], city, [state], zip, Sale_Date, Sale_Price, Seller_name, SellerEmail, zoning INTO #tempEdinaSales FROM [tblEdinaSales_DT] -- 133051

SELECT DISTINCT lastName, firstName, email, daytimePhone INTO #tempEcrvBuyer FROM [dbo].[tblEcrvBuyersForm_DT] -- 650435
SELECT DISTINCT lastName, firstName, email, daytimePhone INTO #tempEcrvSeller FROM [dbo].[tblEcrvSellersForm_DT] -- 618314
SELECT DISTINCT PropertyAddressesStreet1, PropertyAddressescity, PropertyAddressesZip, PlannedUsesId, PlannedUsesTier1Cde into #tempEcrvProperty FROM [dbo].[tblEcrvPropertyForm_DT]

-- data Exists|| 29702 matching email
SELECT *
FROM #tempEdinaWebsite W
INNER JOIN #tempEdinaEmail E
	ON E.Email = W.Email
	AND (
			ISNULL(E.LastName, '') <> ISNULL( W.LastName, '')
			AND 
			ISNULL(E.firstName, '') <> ISNULL( W.firstName, '')
		)

-- data Exists for non matching name with matching email
SELECT *
FROM #tempEdinaWebsite W
INNER JOIN #tempEcrvBuyer E
	ON E.Email = W.Email
	AND (
			ISNULL(E.LastName, '') <> ISNULL( W.LastName, '')
			AND 
			ISNULL(E.firstName, '') <> ISNULL( W.firstName, '')
		)

-- data Exists for non matching name with matching email
SELECT *
FROM #tempEdinaWebsite W
INNER JOIN #tempEcrvSeller E
	ON E.Email = W.Email
	AND (
			ISNULL(E.LastName, '') <> ISNULL( W.LastName, '')
			AND 
			ISNULL(E.firstName, '') <> ISNULL( W.firstName, '')
		)

-- data Exists for non matching name with matching email
SELECT *
FROM #tempEdinaEmail W
INNER JOIN #tempEcrvBuyer E
	ON E.Email = W.Email
	AND (
			ISNULL(E.LastName, '') <> ISNULL( W.LastName, '')
			AND 
			ISNULL(E.firstName, '') <> ISNULL( W.firstName, '')
		)

-- data Exists for non matching name with matching email
SELECT *
FROM #tempEdinaEmail W
INNER JOIN #tempEcrvSeller E
	ON E.Email = W.Email
	AND (
			ISNULL(E.LastName, '') <> ISNULL( W.LastName, '')
			AND 
			ISNULL(E.firstName, '') <> ISNULL( W.firstName, '')
		)

-- data Exists for invalid phone numbers only
SELECT *
FROM #tempEdinaWebsite W
INNER JOIN #tempEcrvBuyer E
	ON E.daytimePhone = W.PhoneNumber
	AND (
			ISNULL(E.LastName, '') <> ISNULL( W.LastName, '')
			AND 
			ISNULL(E.firstName, '') <> ISNULL( W.firstName, '')
		)

-- data Exists for invalid phone numbers only
SELECT *
FROM #tempEdinaWebsite W
INNER JOIN #tempEcrvSeller E
	ON E.daytimePhone = W.PhoneNumber
	AND (
			ISNULL(E.LastName, '') <> ISNULL( W.LastName, '')
			AND 
			ISNULL(E.firstName, '') <> ISNULL( W.firstName, '')
		)

-- Sales

-- Different addresses|| Different zoning and PlannedUsesTier1Cde
SELECT PropertyAddressesStreet1, PropertyAddressescity, PropertyAddressesZip, PlannedUsesId, PlannedUsesTier1Cde, [Address], city, [state], zip, zoning
FROM #tempEdinaSales ED
INNER JOIN #tempEcrvProperty EC
	On PropertyAddressesZip = zip
	AND PropertyAddressescity = city
WHERE PlannedUsesTier1Cde IS NOT NULL

-- 1. starts-- different address even for buyer and seller || Sales price do not match
SELECT * FROM [tblEcrvPropertyForm_DT]
WHERE PropertyAddressesStreet1 = '1350 Highway 73' 
AND PropertyAddressescity = 'Cromwell' 
AND PropertyAddressesZip = '55726'

SELECT * FROM [tblEcrvBuyersForm_DT] WHERE XmlFormId = 262857
SELECT * FROM [tblEcrvSellersForm_DT] WHERE XmlFormId = 262857
SELECT * FROM [tblEcrvSalesAgreementForm_DT] WHERE XmlFormId = 262857

SELECT *--PropertyAddressesStreet1, PropertyAddressescity, PropertyAddressesZip, PlannedUsesId, PlannedUsesTier1Cde, [Address], city, [state], zip, zoning
FROM #tempEdinaSales ED
INNER JOIN #tempEcrvProperty EC
	On PropertyAddressesZip = zip
	AND PropertyAddressescity = city
WHERE PropertyAddressesStreet1 = '1350 Highway 73' 
AND PropertyAddressescity = 'Cromwell' 
AND PropertyAddressesZip = '55726'
--1. ends

-- Data exists|| bolan001@umn.edu
SELECT  *
FROM #tempEdinaSales ED
INNER JOIN #tempEcrvBuyer EC
	ON ED.BuyerEmail = EC.Email
EXCEPT
SELECT  *
FROM #tempEdinaSales ED
INNER JOIN #tempEcrvBuyer EC
	ON ED.BuyerEmail = EC.Email
	AND [Last] = LastName 
	AND [First] = firstName

-- Data exists|| blhjelle@hotmail.com
SELECT  *
FROM #tempEdinaSales ED
INNER JOIN #tempEcrvSeller EC
	ON ED.SellerEmail = EC.Email
EXCEPT
SELECT  *
FROM #tempEdinaSales ED
INNER JOIN #tempEcrvSeller EC
	ON ED.BuyerEmail = EC.Email
	AND [Last] = LastName 
	AND [First] = firstName