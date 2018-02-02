select count(*) from Edina.tblEdinaMortgage_FF --5705

--IMortgageID
select TOP 10 * from Edina.tblEdinaMortgage_FF --1915
select * from Edina.tblEdinaMortgage_FF where DispositionDate = ''
select count(1) As RecCount,YEAR(CAST(DispositionDate As DATE)) As DispositionDate from Edina.tblEdinaMortgage_FF
group by YEAR(CAST(DispositionDate As DATE))
order by YEAR(CAST(DispositionDate As DATE))


select count(*) from Edina.tblEdinaMortgage_FF where AccountName IS NULL --906 NULL and 0 Blank
select count(distinct AccountName) from Edina.tblEdinaMortgage_FF --1571
select count(1) As RecCount, AccountName, YEAR(CAST(DispositionDate As DATE)) from Edina.tblEdinaMortgage_FF
where AccountName IS NOT NULL
group by AccountName,YEAR(CAST(DispositionDate As DATE))
order by 2

select count(distinct PropertyAddress) from Edina.tblEdinaMortgage_FF--2890
--2787 NULL Records
select count(*) from Edina.tblEdinaMortgage_FF where PropertyAddress IS NULL --2787

select count(1),PropertyAddress from Edina.tblEdinaMortgage_FF
group by PropertyAddress
order by 1 desc

select PropertyAddress,PATINDEX('%[^a-zA-Z0-9]%',PropertyAddress) from Edina.tblEdinaMortgage_FF
where PATINDEX('%[^a-zA-Z0-9]%',PropertyAddress) >0
order by 2 desc

select count(1),AccountName,PropertyAddress from Edina.tblEdinaMortgage_FF
where PropertyAddress IS NOT NULL
group by AccountName,PropertyAddress
order by 2 desc

select * from Edina.tblEdinaMortgage_FF
where AccountName = 'Tyler Lyndgaard'


select count(distinct Disposition) from Edina.tblEdinaMortgage_FF

select count(distinct ProductType) from Edina.tblEdinaMortgage_FF --114

select count(1),AccountName,PropertyAddress,ProductType from Edina.tblEdinaMortgage_FF
where PropertyAddress IS NOT NULL
group by AccountName,PropertyAddress,ProductType
order by 2 desc

select AccountName,PropertyAddress,ProductType,DispositionDate
from Edina.tblEdinaMortgage_FF
where AccountName = 'Vincent Jung'

select count(distinct ReferringContact) from Edina.tblEdinaMortgage_FF --1571
select count(1),AccountName,ReferringContact from Edina.tblEdinaMortgage_FF
where len(AccountName)<>len(ReferringContact)
group by AccountName,ReferringContact
order by 2 desc


select count(1) from Edina.tblEdinaMortgage_FF --58
where ReferringAgentOffice = ''

select count(1),AccountName,ReferringAgentOffice,YEAR(CAST(DispositionDate As DATE))from Edina.tblEdinaMortgage_FF
where ReferringAgentOffice IS NOT NULL
group by AccountName,ReferringAgentOffice,YEAR(CAST(DispositionDate As DATE))
order by 2

--GoodToImport
--ErrorDescription
--LogTaskId
--ModifiedDate

select count(*) from Edina.tblEdinaTitle_FF --172592

select top 10 * from Edina.tblEdinaTitle_FF

--ITitleID
select count(distinct orderNumber) from Edina.tblEdinaTitle_FF --172447

select count(1),orderNumber from Edina.tblEdinaTitle_FF
where orderNumber = 'NULL'
group by orderNumber
order by 1 desc

select orderNumber,PATINDEX('%[^a-zA-Z0-9]%',orderNumber) from Edina.tblEdinaTitle_FF
where PATINDEX('%[^a-zA-Z0-9]%',orderNumber) >1
order by 2 desc

select * from Edina.tblEdinaTitle_FF
where ordernumber = 'Deleted File P55'

select top 10 * from Edina.tblEdinaTitle_FF
where ordernumber 
	IN 
	(
		select orderNumber from Edina.tblEdinaTitle_FF
		where PATINDEX('%[^a-zA-Z0-9]%',orderNumber) >1
	)

select count(distinct closingStart) from Edina.tblEdinaTitle_FF --30251
select cast(closingStart as date) from Edina.tblEdinaTitle_FF

select * from Edina.tblEdinaTitle_FF
where closingStart = 'NULL'

select YEAR(CAST(NULLIF(closingStart,'NULL') As date)) As [Year],orderNumber,count(1) As RecordCount from Edina.tblEdinaTitle_FF
group by YEAR(CAST(NULLIF(closingStart,'NULL') As date)),orderNumber
having count(1)>1
order by 1


select count(distinct closingEnd) from Edina.tblEdinaTitle_FF --30251
select count(1) from Edina.tblEdinaTitle_FF
where closingEnd = 'NULL'

select count(1),CAST(NULLIF(closingStart,'NULL') As DATETIME) As ClosingStart,CAST(NULLIF(closingEnd,'NULL') As DATETIME) As ClosingEnd from Edina.tblEdinaTitle_FF
group by CAST(NULLIF(closingStart,'NULL') As DATETIME),CAST(NULLIF(closingEnd,'NULL') As DATETIME)
order by 1 desc

propertyAddress
propertyCity
propertyState
propertyZip
buyer
seller
ownersPolicySold
sellingAgentCode
listingAgentCode
grossCommission
select top 10 lastModifiedOn from Edina.tblEdinaTitle_FF
--GoodToImport
--ErrorDescription
--LogTaskId
--ModifiedDate