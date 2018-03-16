select 
--count(*) 
top 100 * 
from zerorez.ZeroRezQuickbookDump_FF
where 
--[Type] IS NOT NULL and 
NameType IS NOT NULL
order by FileName 

select top 100 * from zerorez.ZeroRezQuickbookDump_FF

select count(*) from zerorez.ZeroRezQuickbookDump_FF
where [Type] IS NULL

select count(1),NameType
from zerorez.ZeroRezQuickbookDump_FF
group by NameType

select count(1) from zerorez.ZeroRezQuickbookDump_FF
where NameType IS NOT NULL

/*
NameType column consist of two type of record
1. Name only (e.g: Smith, Courtney)
2. Total with Name(e.g: Total Smith, Courtney)
When value of nametype column is name only then all the corresponding column will be always NULL
When value of nametype column is Total with Name then Qty and Amount column will consisit the toltal value of its Qty and Amount.
*/

select count(1),Type from zerorez.ZeroRezQuickbookDump_FF
--where Type is null --203023
group by Type

select top 10 * from zerorez.ZeroRezQuickbookDump_FF
where 
--Type = 'Credit Memo' 
Type = 'Invoice'
/*
203023 NULL records available in Type column
Two type of value available with Type column 
1. Credit Memo(150 records consist of Credit Memo Type)
2. Invoice(743644 records consist of Invoice Type)

The Qty,Amount,Balance column is in negative value when Type is of Credit Memo
When Type = Credit Memo(Qty= -2, Amount= -80.00, Balance= -239.00)
When Type = Invoice(Qty = 1, Amount= 13.11, Balance= 197.11)
*/

select count(1),MONTH(CAST([Date] as DATE)),YEAR(CAST([Date] as DATE)) from zerorez.ZeroRezQuickbookDump_FF
group by MONTH(CAST([Date] as DATE)),YEAR(CAST([Date] as DATE))
order by YEAR(CAST([Date] as DATE)),MONTH(CAST([Date] as DATE))

SELECT COUNT(1) As RecordCount,YEAR(CAST([Date] AS DATE)) As DateYear FROM zerorez.ZeroRezQuickbookDump_FF
GROUP BY YEAR(CAST([Date] AS DATE))
ORDER BY YEAR(CAST([Date] AS DATE))


select count(distinct date) from zerorez.ZeroRezQuickbookDump_FF
where date is not null
/*
203023 NULL records available in Date column

Value is of date type(e.g: 11/08/2017)
953 Distinct value available in Date column

Count of records year wise
RecordCount	DateYear
203023		NULL
198584		2015
267096		2016
278114		2017

*/

select count(1),Num,FileName from zerorez.ZeroRezQuickbookDump_FF
where Num is NOT NULL
group by Num,FileName

select count(1) As RecordCount,Num,FileName from zerorez.ZeroRezQuickbookDump_FF
where Num is NOT NULL
--and Num not like '%[0-9]%'
and Num like '%[^a-z,A-Z,0-9]%'
group by Num,FileName

/*
203036 NULL records avaialble in Num column

Most of the available data is of Integer type.
e.g:
199268
200003
224501
224721
224888
Few varchar data is also available which might needs a cleanup
e.g:
Med-2016
Med-2016Z
Med-2017ST
s2689618.00

RecordCount	Num			FileName
1			DISCOUNT	2015-10.CSV
20			WRITE-OFF	2015-10.CSV

The Amount column coresponding to these are in negative

*/
 select count(1),memo from zerorez.ZeroRezQuickbookDump_FF
 where memo is not null
 group by memo

 /*
 367873 NULL records available on Memo column

 Random data available 
 e.g
$120 topicals
$120 training master bedroom oversized
$120 training plus one
$120 two area rugs
$120 upper bedroom plus one
$120 value
- Lobby area, 3 Offices (1283 sq ft)
 M2 Multisprayer
 shipping
!!!Call in twenty four hour?
!/2 Flight
!0% multi-svc discount

Cleaning Required
 */

 select count(1),Name from zerorez.ZeroRezQuickbookDump_FF
 group by Name
 select count(distinct Name) from zerorez.ZeroRezQuickbookDump_FF

 select * from zerorez.ZeroRezQuickbookDump_FF
 where Name like '%[0-9]%'
 /*
 203023 null records available for name column

 -Heavy cleaning required on Name column 
 -special character and numeric value is also available.
 - where valid Name is available First and Last name is separated using comma

 e.g:
 3515 2nd Ave S c/o YellowTree
44th Street Dental
18300 Minnetonka Blvd, LLC
1300 On The Park Coop, Gayle Lamb
27 LLC
-, -
.Jackson, Sue
.Prestrud, Brandon
?????, Ronita?

Valid Names:
Aamot, Brian
Aamot, Jodi
Aamot, Marge
Aamot, Virginia
Aamoth, Archie
Aanden, Nicole


 */

select count(1),Item from zerorez.ZeroRezQuickbookDump_FF
where Item is not null
group by Item

select count(distinct Item) from zerorez.ZeroRezQuickbookDump_FF

/*
203023 NULL records available in Item column
336 Distinct Item Available
records available with specific number and Item to be covered, few items has cost with them others dont.
e.g(Items with cost)
1. 100--$159 Three Room Special
2. 100--$159 Two Room Special Wit
3. 100--$169 Two Room Special With
4. 1000--$117 Three Room Special
5. 1001--$127 Two Rooms + Steps

e.g(Items without cost)
1. 100--VIP Three Room Special
2. 102--Traffic Area Clean
3. 103--Hallway
4. 108--Bedroom
*/

select count(1) As RecordsCount,Item,[Item Description] from zerorez.ZeroRezQuickbookDump_FF
where [Item Description] is null
group by Item,[Item Description]
order by 1 desc

select count(distinct [Item Description]) from zerorez.ZeroRezQuickbookDump_FF
where [Item Description] is not null and [Item Description] <> 'null'

select count(distinct Item) from zerorez.ZeroRezQuickbookDump_FF

/*
553459 NULL records available for ItemDescription column
77 Distinct Item Description available
218 Items avaiable for which Item Description is not avialble
Description of Items are listed under the column,
For few Items there is null string is available.
For many item there is no descriptions available.
After most used Item(tax), Waste Disposal is the heighest Item used with 87558 count

RecordsCount	Item												Item Description
107158			Tax (Tax)											Tax
87558			120 - Waste Disposal (120--Water and Disposal Fee)	120--Water and Disposal Fee
15197			180--Free Home Service Inspect (null)				null

*/

select top 100 * from zerorez.ZeroRezQuickbookDump_FF
where Qty IS NULL and Type IS NOT NULL

/*
101629 NULL records available for Qty column

Qty column is mostly NULL in those places where Adjustments are made in the Invoices for the customer,
There Respective Item and Item description is also like Adjustment.

e.g:

Num: 363616
Memo: Invoice Adjustments
Name: Campbell, Melissa
Item: Adjustment - Residential (Invoice Adjustments)
Item Description: Invoice Adjustments
Qty: NULL
Sales Price: -0.40
Amount: -0.40
Balance: 426.55
FileName: 2017-08.CSV
*/

select count(1),CAST([Sales Price] as money) from zerorez.ZeroRezQuickbookDump_FF
--where [Sales Price] is not null
group by CAST([Sales Price] as money)
order by 1 desc

select MIN(CAST([SalesPrice] as money)) from zerorez.ZeroRezQuickbookDump_FF -- -2550.00
select MAX(CAST([SalesPrice] as money)) from zerorez.ZeroRezQuickbookDump_FF -- 16643.31

select avg(cast([SalesPrice] as money)) from zerorez.ZeroRezQuickbookDump_FF -- MEAN: 40.9117

select 
((Select Top 1 [SalesPrice]
From (
Select Top 50 Percent CAST([SalesPrice] as money) as [SalesPrice]
From	ZeroRez.ZeroRezQuickbookDump_FF
Where	CAST([SalesPrice] as money) Is NOT NULL
Order By CAST([SalesPrice] as money)
) As A
Order By CAST([SalesPrice] as money) DESC)
+
(Select Top 1 [SalesPrice]
From (
Select Top 50 Percent CAST([SalesPrice] as money) as [SalesPrice]
From	ZeroRez.ZeroRezQuickbookDump_FF
Where	CAST([SalesPrice] as money) Is NOT NULL
Order By CAST([SalesPrice] as money) DESC
) As A
Order By CAST([SalesPrice] as money) Asc))/2 -- MEDIAN: 19.13

SELECT TOP 1 with ties cast([SalesPrice] as money)
FROM ZeroRez.ZeroRezQuickbookDump_FF
WHERE cast([SalesPrice] as money) IS Not NULL
GROUP BY cast([SalesPrice] as money)
ORDER BY COUNT(*) DESC --1 MODE

SELECT STDEV(cast([SalesPrice] as money)) 
FROM ZeroRez.ZeroRezQuickbookDump_FF -- SD: 114.657210109228

select count(distinct [Sales Price]) from ZeroRez.ZeroRezQuickbookDump_FF 
/*
203037 NULL records available
Distinct Records: 10593
Minimum value: -2550.00
Maximum value: 16643.31
Mean: 40.9117
Median: 19.13
Standard Deviation: 114.657210109228

*/

select count(1),CAST(Amount as money) from zerorez.ZeroRezQuickbookDump_FF
group by CAST(Amount as money)
order by 1 desc

select count(Distinct CAST(Amount as money))from zerorez.ZeroRezQuickbookDump_FF

select MIN(CAST(Amount as money)) from zerorez.ZeroRezQuickbookDump_FF -- Min: -2550.00
select MAX(CAST(Amount as money)) from zerorez.ZeroRezQuickbookDump_FF -- Max: 16643.31

select avg(cast(Amount as money)) from zerorez.ZeroRezQuickbookDump_FF -- MEAN: 50.7353

select 
((Select Top 1 Amount
From (
Select Top 50 Percent CAST(Amount as money) as Amount
From	ZeroRez.ZeroRezQuickbookDump_FF
Where	CAST(Amount as money) Is NOT NULL
Order By CAST(Amount as money)
) As A
Order By CAST(Amount as money) DESC)
+
(Select Top 1 Amount
From (
Select Top 50 Percent CAST(Amount as money) as Amount
From	ZeroRez.ZeroRezQuickbookDump_FF
Where	CAST(Amount as money) Is NOT NULL
Order By CAST(Amount as money) DESC
) As A
Order By CAST(Amount as money) Asc))/2 -- MEDIAN: 20.00

SELECT TOP 1 with ties cast(Amount as money)
FROM ZeroRez.ZeroRezQuickbookDump_FF
WHERE cast(Amount as money) IS Not NULL
GROUP BY cast(Amount as money)
ORDER BY COUNT(*) DESC --1 MODE

SELECT STDEV(cast(Amount as money)) 
FROM ZeroRez.ZeroRezQuickbookDump_FF --SD: 127.875503860436

/*
101501 NULL Records available
Distinct records: 31777
Min: -2550.00
Max: 16643.31
Median: 20.00
StandardDeviation: 127.875503860436
MEAN: 50.7353
*/

select  * from zerorez.ZeroRezQuickbookDump_FF

select count(1),CAST(Balance as money) from zerorez.ZeroRezQuickbookDump_FF
group by CAST(Balance as money)
order by 1 desc

select count(Distinct CAST(Balance as money))from zerorez.ZeroRezQuickbookDump_FF

select MIN(CAST(Balance as money)) from zerorez.ZeroRezQuickbookDump_FF -- Min: -2699.46
select MAX(CAST(Balance as money)) from zerorez.ZeroRezQuickbookDump_FF -- Max: 25893.22

select avg(cast(Balance as money)) from zerorez.ZeroRezQuickbookDump_FF -- MEAN: 247.4773

select 
((Select Top 1 Balance
From (
Select Top 50 Percent CAST(Balance as money) as Balance
From	ZeroRez.ZeroRezQuickbookDump_FF
Where	CAST(Balance as money) Is NOT NULL
Order By CAST(Balance as money)
) As A
Order By CAST(Balance as money) DESC)
+
(Select Top 1 Balance
From (
Select Top 50 Percent CAST(Balance as money) as Balance
From	ZeroRez.ZeroRezQuickbookDump_FF
Where	CAST(Balance as money) Is NOT NULL
Order By CAST(Balance as money) DESC
) As A
Order By CAST(Balance as money) Asc))/2 -- MEDIAN: 179.00

SELECT TOP 1 with ties cast(Balance as money)
FROM ZeroRez.ZeroRezQuickbookDump_FF
WHERE cast(Balance as money) IS Not NULL
GROUP BY cast(Balance as money)
ORDER BY COUNT(*) DESC --1 MODE

SELECT STDEV(cast(Balance as money)) 
FROM ZeroRez.ZeroRezQuickbookDump_FF --SD: 404.553767873828


/*
101500 NULL Records available
Distinct Records: 50646
Min: -2699.46
Max: 25893.22
MEDIAN: 179.00
MEAN: 247.4773
SD: 404.553767873828
*/