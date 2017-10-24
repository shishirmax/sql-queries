select * from tblEmailResults -- Total Records 1669600
select * from tblWebsiteData -- Total Records 844867
select * from tblSales -- Total Records 133052

Select * from EmailResults -- Total records inserted 8424034
select * from [Website-Data] -- Total records inserted 938194
select * from Sales -- Total records inserted 134336

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