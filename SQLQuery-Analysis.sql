select count(1) from tblWebsiteData --(844867)
select COUNT(1) from tblSales(NOLOCK) --(133052)
select count(1) from tblEmailResults --(1669600)


select count(1) from sales

truncate table tblSales

insert into tblSales
(

sp_help tblWebsiteData
sp_help tblSales
sp_help tblEmailResults

select PhoneNumber,count(*) from tblWebsiteData
where PhoneNumber IS NULL
group by PhoneNumber

select count(PhoneNumber) from tblWebsiteData

select RecordIDs,count(*) from tblSales
group by RecordIDs

select MdmContactId,count(*) from tblEmailResults
group by MdmContactId

select ListingId,CreatedDate,Rating,Type,WebsiteUserId,LastName,FirstName,Email,PhoneNumber from tblWebsiteData
order by CreatedDate


select min(cast(CreatedDate as date)) from tblWebsiteData
select max(cast(CreatedDate as date)) from tblWebsiteData

select count(*) as tblRowCount,YEAR(CreatedDate) as tblYear,MONTH(CreatedDate) as tblMonth,cast(CreatedDate as date) CreatedDate from tblWebsiteData
group by YEAR(CreatedDate),MONTH(CreatedDate),cast(CreatedDate as date)
order by YEAR(CreatedDate),MONTH(CreatedDate)

/*
select count(*) as tblRowCount,UPPER(DATENAME(M,EOMONTH(CreatedDate)))+' '+CONVERT(VARCHAR(50),DATEPART(YEAR,EOMONTH(CreatedDate))) as Monthly from tblWebsiteData_24102017
group by EOMONTH(CreatedDate)
order by EOMONTH(CreatedDate)


select UPPER(DATENAME(M,EOMONTH(CreatedDate)))+' '+CONVERT(VARCHAR(50),DATEPART(YEAR,EOMONTH(CreatedDate))) from tblWebsiteData_24102017
*/
2016: 536875
2017: 307992
--2016-10-17 to 2017-09-13
select PhoneNumber,count(*) from tblWebsiteData
--where phoneNumber is NULL
group by PhoneNumber



select  max(LEN(PhoneNumber)) from tblWebsiteData

select LEN('a412edee7d9631e69aabfbdc917038b0efa7ddb6')
--YYYY-MM-DDThh:mm:ss[.mmm]
sp_help tblEmailResults
select * from tblEmailResults
select IsActive,count(*) as totalCount from tblEmailResults
where IsActive is NULL
group by IsActive

select LastName,count(*) as totalCount from tblEmailResults
where LastName is NULL
group by LastName

select  max(LEN(MdmContactId)) from tblEmailResults


select min(cast(ResultDate as date)) from tblEmailResults
select max(cast(ResultDate as date)) from tblEmailResults

2015-09-02 to 2017-09-13

select count(*) as tblRowCount,YEAR(ResultDate) as tblYear,MONTH(ResultDate) as tblMonth from tblEmailResults
group by YEAR(ResultDate),MONTH(ResultDate)
order by YEAR(ResultDate),MONTH(ResultDate)

--tblSales Analysis

sp_help tblSales

select * from tblSales
select RECORDING_DATE,sale_date from tblSales

select SALES_TRANSACTION_CODE,count(*) as totalCount from tblSales
--where SALES_TRANSACTION_CODE is NULL
group by SALES_TRANSACTION_CODE


SELECT replace(right(convert(varchar, getdate(), 106), 8), ' ', '-')
select convert(varchar, GETDATE(),106)

select count(*) as tblRowCount,YEAR(sale_date) as tblYear,MONTH(sale_date) as tblMonth from tblSales
group by YEAR(sale_date),MONTH(sale_date)
order by YEAR(sale_date),MONTH(sale_date)



select min(cast(sale_date as date)) from tblSales
select max(cast(sale_date as date)) from tblSales
2007-01-25 to 2017-09-12