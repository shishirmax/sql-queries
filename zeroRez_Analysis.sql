/*
Split_AE_Tables:
SELECT * FROM			ZeroRez.tblAddress_AE
SELECT * FROM			ZeroRez.tblClientTags_AE
SELECT * FROM			ZeroRez.tblEmail_AE
SELECT * FROM			ZeroRez.tblNetPromoterLabels_AE
SELECT * FROM			ZeroRez.tblPhone_AE
SELECT * FROM			ZeroRez.tblProducts_AE
SELECT COUNT(*) FROM	ZeroRez.tblSource_AE
SELECT COUNT(*) FROM	ZeroRez.tblZeroRez_AE
*/




/*
Split_FF_Tables:
SELECT * FROM			ZeroRez.tblAddress_FF
SELECT * FROM			ZeroRez.tblClientTags_FF 
SELECT TOP 10 * FROM			ZeroRez.tblEmail_FF
SELECT TOP 10 * FROM			ZeroRez.tblNetPromoterLabels_FF 
SELECT TOP 10 * FROM			ZeroRez.tblPhone_FF  where PhoneNumber is not null and PhoneNumber <> ''
SELECT * FROM			ZeroRez.tblProducts_FF 
SELECT COUNT(*) FROM	ZeroRez.tblSource_FF 
SELECT COUNT(*) FROM	ZeroRez.tblZeroRez_FF
*/



/*
Split_DT_Tables:
SELECT TOP 10 *  FROM			ZeroRez.tblAddress_DT			where Street1 IS NULL and Street2 is NULL and City IS NULL and State is NULL and Postal_Code is NULL
SELECT count(*)  FROM			ZeroRez.tblClientTags_DT		where clientTags = ''
SELECT count(*) FROM			ZeroRez.tblEmail_DT				where email is null or email = '' *****************
SELECT count(*) FROM			ZeroRez.tblNetPromoterLabels_DT where NetPromoterLabels = ''
SELECT TOP 10 * FROM			ZeroRez.tblPhone_DT
SELECT count(*) FROM			ZeroRez.tblProducts_DT	where Products = ''
SELECT count(1) FROM			ZeroRez.tblSource_DT	where source = ''
SELECT COUNT(*) FROM			ZeroRez.tblZeroRez_DT 
*/


select * from ZeroRez.DimClient where FirstName IS NULL or LastName IS NULL --4

select * from ZeroRez.ZeroRez_bcp
where last_name in 
(
	'Mathew'
	,'McCurdy'
	,'Plunkett''s'
)


select cast(last_service_date as date) lsd,Street1,street2,city,state,postal_code,ISNULL(street1,' ')+','+ISNULL(street2,' ')+','+ISNULL(city,' ')+','+ISNULL(state,' ')+','+ISNULL(postal_code,' ') As originalAddress, count(1) As rc
from ZeroRez.ZeroRez_bcp
group by cast(last_service_date as date),Street1,street2,city,state,postal_code
having count(1)>1
order by 7

select cast(last_service_date as date),first_name,last_name,count(1) from ZeroRez.ZeroRez_bcp
group by cast(last_service_date as date),first_name,last_name
having count(1)>1
order by 2


SELECT * FROM [ZeroRez].[DimClient]
WHERE iClientId = 65397
--AND FirstName = 'Roxanne'
--AND LastName = 'McGraw'

SELECT * FROM [ZeroRez].tblZeroRez_DT(NOLOCK)
WHERE First_Name = 'Roxanne'
AND Last_Name = 'McGraw'

select * from ZeroRez.ZeroRez_bcp
where
first_name = 'Roxanne' and last_name = 'McGraw'
street1 = '843 Lois Lane'
and street2 is null
and city = 'Lino Lakes'
and state = 'MN'
and postal_code = '55014'

select * from zerorez.zerorez_bcp where 
first_name is null or last_name is null

select count(1) from zerorez.DimClient

select firstname,count(1) as rc from zerorez.DimClient
where firstname is not null and lastname is not null and firstname like '%&%'
group by firstname
having count(1)>1
order by 2 desc

--439 records found with firstname column in Dim Client table where two person name is available combined with &

select * from zerorez.DimClient where firstname in
(
'Amy L'
,'Amy L.'
)
--there are data in DimClient firstname column as ('Amy M' and 'Amy M.') but both have different lastname and different address (not to be confused with same name)

select * from zerorez.zerorez_bcp where first_name in 
(
'Amy & John'
,'Amy & Jon'
)
select * from zerorez.zerorez_bcp where first_name in 
(
'Amy L'
,'Amy L.'
)

ALTER TABLE ZeroRez.tblZeroRez_DT
DROP COLUMN ModifiedBy, CreatedBy

ALTER TABLE ZeroRez.tblZeroRez_DT
ADD CreatedBy BIGINT, ModifiedBy BIGINT

select count(*) from ZeroRez.DimClient where firstname is null and lastname is null
select TOP 10 * from ZeroRez.DimProductGroup

select * from ZeroRez.ZeroRez_bcp
where IzeroRezId IN  ('92757','92758')

select * from ZeroRez.ZeroRez_split
where IzeroRezId IN  ('92757','92758')

select TOP 10 * from ZeroRez.DimAddress
select TOP 10 * from ZeroRez.DimClient
select TOP 10 * from ZeroRez.DimClientTags
select * from ZeroRez.DimEmail
select * from ZeroRez.DimEmailGroup
select * from ZeroRez.DimNetPromoterLabels
select * from ZeroRez.DimPerson
select * from ZeroRez.DimPhone
select * from ZeroRez.DimPhoneGroup
select * from ZeroRez.DimProduct
select TOP 50 * from ZeroRez.DimProductGroup
select * from ZeroRez.DimSource
select * from ZeroRez.DimSourceGroup
select * from ZeroRez.DimZones

CREATE FUNCTION dbo.udf_GetNumeric
(@strAlphaNumeric VARCHAR(256))
RETURNS VARCHAR(256)
AS
BEGIN
DECLARE @intAlpha INT
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric)
BEGIN
WHILE @intAlpha > 0
BEGIN
SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric )
END
END
RETURN ISNULL(@strAlphaNumeric,0)
END
GO
replace(replacedollar,onlynumber,'')

SELECT 
	IProductId,
	Product,
	replace(replace(product,'$',''),'--','') as replacedolar,
	dbo.udf_GetNumeric(Product) as onlynumber,
	replace(replace(replace(product,'$',''),'--',''),dbo.udf_GetNumeric(Product),'')
from ZeroRez.DimProduct
--where Product like '%102%'
--where try_cast(left(product,1) as int) is null
WHERE product LIKE '[0-9]%[a-Z]%' and product not like '%$%'--'[a-Z]%'

select * from ZeroRez.DimProduct
where try_cast(left(product,1) as int) is null



select IProductId,Product,replace(product,'$','') from ZeroRez.DimProduct --236
select IProductId,Product,PATINDEX('%[^0-9]%', Product) from ZeroRez.DimProduct
select patindex('%[^0-9]%','1000--$117 Three Room Special')
select * from ZeroRez.DimProduct
where Product not like '%[^0-9]%'

select
izerorezid,products,source,count(1)
from ZeroRez.ZeroRez_split A
where A.Products like '%'+A.source+'%' --1262
group by A.source,A.products,A.izerorezid

'IZeroRezId = 2418	products = 401a--Air Duct Promo Discount	source = Air Duct'
		


select * from ZeroRez.DimSource
where Source like '[0-9]%' and source like '%$%'


select IZeroRezId,first_name,last_name,products from ZeroRez.ZeroRez_split
select FirstName, LastName from ZeroRez.DimClient

select TOP 10 IProductId,ClientID,count(1) from ZeroRez.DimProductGroup(NOLOCK)
group by IProductId,ClientID
having count(1)>1


INSERT INTO ZeroRez.DimProductGroup
(
 IProductId,
 ClientID,
 CreatedDate,
 CreatedBy
)
SELECT DISTINCT
  IProductId, 
  IClientId,
  GETDATE(),
  P.LogtaskId
FROM ZeroRez.DimProduct (NOLOCK) P
INNER JOIN ZeroRez.ZeroRez_split (NOLOCK) Z
 ON ISNULL(P.Product, '') = ISNULL(Z.Products, '')
INNER JOIN ZeroRez.DimClient (NOLOCK) DC
 ON  LTRIM(RTRIM(ISNULL(Z.First_Name, '')))= ISNULL(DC.FirstName, '')
AND LTRIM(RTRIM(ISNULL(Z.Last_Name, ''))) = ISNULL(DC.LastName, '')

select
(select count(1) from zerorez.tblZerorezStandardAddressApi(NOLOCK) where formatted_address <> 'NA')+
(select count(1) from zerorez.tblZerorezStandardAddressApiAfter50K(NOLOCK) where formatted_address <> 'NA')

select
(select count(1) from zerorez.tblZerorezStandardAddressApi(NOLOCK) where formatted_address = 'NA')+
(select * from zerorez.tblZerorezStandardAddressApiAfter50K(NOLOCK) where formatted_address = 'NA')
select IZeroRezId,OriginalAddress from zerorez.tblZerorezStandardAddressApi(NOLOCK) where formatted_address = 'NA' order by izerorezid

select originalAddress,count(*) as rc into #tempAdd from zerorez.tblZerorezStandardAddressApi(NOLOCK) 
group by originalAddress
having count(1)>1

select * from #tempAdd where rc>3

select * from zerorez.tblZerorezStandardAddressApi
where originaladdress = '843 Lois Lane   Lino Lakes, MN, 55014'

select * from zerorez.ZeroRez_bcp
where IZeroRezId = 92432 IN 
(
	'81598'
	,'81599'
	,'81600'
	,'81601'
	,'81602'
	,'81603'
)

declare @num int;
set @num =( next value for GetGroupId);
select @num as groupId

select * from Edina.tableMapping