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

select TOP 10 * from tblSales_24102017
order by SalesId desc

select * from tblSales_24102017
where RecordIDs = '1179455'

sp_help tblSales_24102017

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

--select count(*) as tblRowCount, CONVERT(CAST(EOMONTH(CreatedDate) AS VARCHAR(30)), DATETIME, 112) as MonthEndDate from tblWebsiteData_24102017
--group by EOMONTH(CreatedDate)
--order by EOMONTH(CreatedDate)

--Analysis Query
select convert(CAST(EOMONTH(GETDATE()) AS VARCHAR(130)),datetime,112)

select ListingId,CreatedDate,Rating,Type,WebsiteUserId,LastName,FirstName,Email,PhoneNumber from tblWebsiteData_24102017
order by CreatedDate


select min(cast(CreatedDate as date)) from tblWebsiteData_24102017
select max(cast(CreatedDate as date)) from tblWebsiteData_24102017

SELECT COUNT(*) AS tblRowCount,UPPER(DATENAME(M,EOMONTH(sale_date)))+' '+CONVERT(VARCHAR(50),DATEPART(YEAR,EOMONTH(sale_date))) AS Monthly 
	FROM tblSales_24102017
GROUP BY EOMONTH(sale_date)
ORDER BY EOMONTH(sale_date)

sp_help tblSales_24102017
sp_help tblWebsiteData_24102017

select TOP 100 * from tblWebsiteData_24102017

select WebsiteUserId,count(*) from tblWebsiteData_24102017
group by WebsiteUserId

select max(WebsiteUserId) from tblWebsiteData_24102017
group by WebsiteUserId

select *
from (select *, count(*) over (partition by WebsiteUserId) as NumWebsiteUserId
      from tblWebsiteData_24102017	  
     ) t
where NumWebsiteUserId = 4

--and Type = 'Blocked Listing'
--and Rating IS NOT NULL

select * from tblWebsiteData_24102017
where WebsiteUserId IN (
select WebsiteUserId
from (select *, count(*) over (partition by WebsiteUserId) as NumWebsiteUserId
      from tblWebsiteData_24102017	  
     ) t
where NumWebsiteUserId = 1
and Type = 'Saved Listing'
and Rating IS NOT NULL)

select *
from (select *, count(*) over (partition by WebsiteUserId) as NumWebsiteUserId
      from tblWebsiteData_24102017	  
     ) t
where 	NumWebsiteUserId >1
	and PhoneNumber IS NULL
	and Email IS NULL
	and LastName IS NULL
	and FirstName IS NULL

Select * from tblWebsiteData_24102017
where	Email IS NULL
	and PhoneNumber IS NULL



select * from tblWebsiteData_24102017
where ListingId = '2194585'
order by CreatedDate

select * from tblWebsiteData_24102017
where WebsiteUserId = '0021de45-2f98-4339-abf5-1144bdb2b1c5'
order by WebsiteUserId

select type,count(*) from tblWebsiteData_24102017
group by Type
/*
Saved Listing	864527
Blocked Listing	73667
*/
select email,count(*) from tblWebsiteData_24102017
where Email IS NULL
group by Email

select count(Email),type from tblWebsiteData_24102017
group by Type
/*
862096 records having Type:Saved Listing and Email is not NULL
72792 records having Type:Blocked Listing and Email is not NULL
*/

/*
875 records having Type: Blocked Listing and Email is NULL
2431 records having Type: Saved Listing and Email is NULL

*/
select count(*) from tblWebsiteData_24102017
--where Email IS NULL
--and CreatedDate IS NULL
Where Type = 'Saved Listing'
and Email is null
--and Rating IS NOT NULL
order by CreatedDate

select ListingId, count(1) from tblSales --_24102017
group by ListingId
having count(1)>1

select RecordIDs,count(1) from tblSales_24102017
group by RecordIDs
having count(1)>1

select count(ListingId) from tblSales_24102017
where ListingId IS NULL

select * from tblSales_FF
select count(*) from tblSales_24102017

EXEC sp_rename 'tblSales', 'tblSales_FF'