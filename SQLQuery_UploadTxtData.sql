select * from tblEmailResults -- Total Records 1669600
select * from tblWebsiteData -- Total Records 844867
select * from tblSales -- Total Records 133052

Select * from EmailResults -- Total records inserted 8424034
select * from [Website-Data] -- Total records inserted 938194
select * from Sales -- Total records inserted 134336

--New Table with imported data on 24-10-2017
select * from tblEmailResults_24102017
select * from tblWebsiteData_24102017
select * from tblSales_24102017

select * from tblSales_24102017
where RecordIDs = '1179455'

sp_help tblsales

truncate table tblEmailResults_24102017

select Sales.RecordIDs
from Sales
inner join
tblSales
on Sales.RecordIDs = tblSales.RecordIDs

--truncate table EmailResults
--truncate table [Website-Data]
--truncate table Sales

--Insert data through bulk insert in EmailResults table
bulk insert EdinaLocal.dbo.EmailResults
from 'D:\Edina\FromFTP\email-results\email-results.txt'
with
(
FIELDTERMINATOR='||',
FIRSTROW=2,
ROWTERMINATOR='\n'
)

--Insert data through bulk insert in Sales table
bulk insert EdinaLocal.dbo.Sales
from 'D:\Edina\FromFTP\sales.txt'
with
(
FIELDTERMINATOR='||',
FIRSTROW=2,
ROWTERMINATOR='\n'
)

--Insert data through bulk insert in [Website-Data] table
bulk insert EdinaLocal.dbo.[Website-Data]
from 'D:\Edina\FromFTP\website-data.txt'
with
(
FIELDTERMINATOR='||',
FIRSTROW=2,
ROWTERMINATOR='\n'
)

--Analysis Query
select convert(CAST(EOMONTH(GETDATE()) AS VARCHAR(130)),datetime,112)

select ListingId,CreatedDate,Rating,Type,WebsiteUserId,LastName,FirstName,Email,PhoneNumber from tblWebsiteData_24102017
order by CreatedDate


select min(cast(CreatedDate as date)) from tblWebsiteData_24102017
select max(cast(CreatedDate as date)) from tblWebsiteData_24102017

select count(*) as tblRowCount, CONVERT(CAST(EOMONTH(CreatedDate) AS VARCHAR(30)), DATETIME, 112) as MonthEndDate from tblWebsiteData_24102017
group by EOMONTH(CreatedDate)
order by EOMONTH(CreatedDate)