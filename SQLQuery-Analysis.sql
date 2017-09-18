select count(1) from tblWebsiteData --(1689734)
select COUNT(1) from tblSales(NOLOCK) --(266104)
select count(1) from tblEmailResults --(3339200)

sp_help tblWebsiteData
sp_help tblSales
sp_help tblEmailResults

select ListingId,count(*) from tblWebsiteData
group by ListingId

select RecordIDs,count(*) from tblSales
group by RecordIDs

select MdmContactId,count(*) from tblEmailResults
group by MdmContactId

select ListingId,CreatedDate,Rating,Type,WebsiteUserId,LastName,FirstName,Email,PhoneNumber from tblWebsiteData
order by CreatedDate


select min(cast(CreatedDate as date)) from tblWebsiteData
select max(cast(CreatedDate as date)) from tblWebsiteData

select count(*) as tblRowCount,YEAR(CreatedDate) as tblYear,MONTH(CreatedDate) as tblMonth from tblWebsiteData
group by YEAR(CreatedDate),MONTH(CreatedDate)
order by YEAR(CreatedDate)

2016: 536875
2017: 307992
--2016-10-17 to 2017-09-13
select PhoneNumber,count(*) from tblWebsiteData
--where phoneNumber is NULL
group by PhoneNumber



select  max(LEN(PhoneNumber)) from tblWebsiteData

select LEN('a412edee7d9631e69aabfbdc917038b0efa7ddb6')
--YYYY-MM-DDThh:mm:ss[.mmm]

select min(cast(ResultDate as date)) from tblEmailResults
select max(cast(ResultDate as date)) from tblEmailResults

2015-09-02 to 2017-09-13

select count(*) as tblRowCount,YEAR(ResultDate) as tblYear,MONTH(ResultDate) as tblMonth from tblEmailResults
group by YEAR(ResultDate),MONTH(ResultDate)
order by YEAR(ResultDate)

sp_help tblSales
select RECORDING_DATE,sale_date from tblSales

select count(*) as tblRowCount,YEAR(sale_date) as tblYear,MONTH(sale_date) as tblMonth from tblSales
group by YEAR(sale_date),MONTH(sale_date)
order by YEAR(sale_date),MONTH(sale_date)


select min(cast(sale_date as date)) from tblSales
select max(cast(sale_date as date)) from tblSales
2007-01-25 to 2017-09-12