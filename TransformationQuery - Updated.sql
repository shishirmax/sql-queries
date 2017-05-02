--Query For Transforming File
/*
1. Sale Information [CSVReferenceNumber | Type | TransactionStatus | AccountingDate | Name/Number | AttorneyDocketNumber]
2. Sale Detail [CSVReferenceNumber | Name/Number | AttorneyDocketNumber | TransactionStatus | Quantity | ItemTotal | PaymentAmount | FeeCode | Description]
3. Payment Detail [CSVReferenceNumber | PaymentType | TotalPaymentAmount | PaymentDate | PaymentAmount(this sale)]
4. Refund Detail [CSVReferenceNumber | RefundID	| AccountingDate | RefundAmount	| Name/Number | PaymentMethod | PayeeName]
*/


--Selecting all record from MTSNew Table
--Selecting all record from MTD Table

Select * from MTSNew

select * from MTD

--Payment Date Posted	Sale Item Date Posted	Sale Item Reference #	Attorney Docket #	Status	Transaction ID	Sale ID	Fee Code	Fee Code Description	Item Price	Quantity	Item Total	Customer Name
--Deleteing record from MTSNew and MTD Table

Delete from MTSNew
Delete from MTD

/* ---- Select record for Sale Information part when there is no refund column in the sheet ---- */

select
CSVReferenceNumber,
'Sale' as Type,
'Active' as TransactionStatus,
replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/') as AccountingDate,
TransactionRef as NameNumber,
AttorneyDocket
--,Status,
--Type
from MTSNew order by CSVReferenceNumber

/* --- select record for Sale Information when there is refund record is also available ---- */

select
CSVReferenceNumber, Type =
	case
		when Status = 'Processed' Then 'Sale'
		else 'Refund'
	end,
	TransactionStatus = 
	case
		when Status = 'Processed' Then 'Active'
		when Status = 'Refund' Then 'Active'
	end,
replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/') as AccountingDate,
TransactionRef as NameNumber,
AttorneyDocket
from MTSNew order by CSVReferenceNumber

/* ----Select record for Sale Detail part ---- */

select distinct  
B.CSVReferenceNumber,
A.reference as Name_Number,
A.AttorneyDocket as AttorneyDocketNumber,
'A' as TransactionStatus,
A.Quantity,
REPLACE(A.ItemPrice,',','') as ItemPrice,
REPLACE(REPLACE(REPLACE(A.ItemTotal,',',''),'(','-'),')','') as ItemTotal,
A.FeeCode,REPLACE(A.FeeCodeDescription,'"',' ') as FeeCodeDescription
from MTD A
join MtsNew B
on
A.TransactionID = B.TransactionID
order by B.CSVReferenceNumber asc

/* ---- Select record for Payment Detail part ---- */

select 
CSVReferenceNumber,
'Credit Card' as PaymentType,
REPLACE(TotalPayment,',','') as TotalPaymentAmount,
replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/') as PaymentDate,
REPLACE(TotalPayment,',','') as PaymentAmount
from MTSNew
where type <> 'Refund'
order by CSVReferenceNumber

--This query will work for both the case when there is record with refund and without refund data 

/* Select record for Refund Detail part */

select 
CSVReferenceNumber,
TransactionID,
replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/')  as AccountingDate,
REPLACE(replace(replace(REPLACE(TotalPayment,',',''),'(',''),')',''),'-','') as RefundAmount,
TransactionRef,
'Credit Card' as PaymentMethod,
'WOLF GREENFIELD' as PayeeName
from MTSNew
where Type = 'Refund'
order by CSVReferenceNumber


