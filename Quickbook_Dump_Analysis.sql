select 
--count(*) 
top 100 * 
from zerorez.March_2018_Quickbook_Dump
where 
--[Type] IS NOT NULL and 
NameType IS NOT NULL
order by FileName 

select top 100 * from zerorez.March_2018_Quickbook_Dump

select count(*) from zerorez.March_2018_Quickbook_Dump
where [Type] IS NULL

select count(1),NameType
from zerorez.March_2018_Quickbook_Dump
group by NameType

select count(1) from zerorez.March_2018_Quickbook_Dump
where NameType IS NOT NULL

/*
NameType column consist of two type of record
1. Name only (e.g: Smith, Courtney)
2. Total with Name(e.g: Total Smith, Courtney)
When value of nametype column is name only then all the corresponding column will be always NULL
When value of nametype column is Total with Name then Qty and Amount column will consisit the toltal value of its Qty and Amount.
*/

select count(1),Type from zerorez.March_2018_Quickbook_Dump
--where Type is null --203023
group by Type

select top 10 * from zerorez.March_2018_Quickbook_Dump
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

select count(1),MONTH(CAST([Date] as DATE)),YEAR(CAST([Date] as DATE)) from zerorez.March_2018_Quickbook_Dump
group by MONTH(CAST([Date] as DATE)),YEAR(CAST([Date] as DATE))
order by YEAR(CAST([Date] as DATE)),MONTH(CAST([Date] as DATE))

SELECT COUNT(1) As RecordCount,YEAR(CAST([Date] AS DATE)) As DateYear FROM zerorez.March_2018_Quickbook_Dump
GROUP BY YEAR(CAST([Date] AS DATE))
ORDER BY YEAR(CAST([Date] AS DATE))


select count(distinct date) from zerorez.March_2018_Quickbook_Dump
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

select count(1),Num,FileName from zerorez.March_2018_Quickbook_Dump
where Num is NOT NULL
group by Num,FileName

select count(1) As RecordCount,Num,FileName from zerorez.March_2018_Quickbook_Dump
where Num is NOT NULL
--and Num not like '%[0-9]%'
and Num like '%[^a-z,A-Z,0-9]%'
group by Num,FileName

/*
203036 NULL records avaialble in Num column

Most of the available data is of Integer type.
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