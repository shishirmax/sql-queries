ALTER TABLE mtsnew
ALTER COLUMN dateposted varchar(50)

select convert(varchar(10), cast(DatePosted as date), 111) from mtsnew

SELECT LTRIM(STR(MONTH(DatePosted))) + '/' +
       LTRIM(STR(DAY(DatePosted))) + '/' +
       STR(YEAR(DatePosted), 4) from mtsnew

select MONTH(DatePosted) from mtsnew

select convert(varchar(20),DatePosted,101) as Cdate from mtsnew


select *,convert(varchar(20),DatePosted,101) as Cdate,REPLACE(TotalPayment,',','') as cTotalPayment
from mtsnew order by CSVReferenceNumber

-- ****Select Details from MTSNew Table****
Select replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/') as Cdate,
TransactionRef, AttorneyDocket, Status, TransactionID, Type, REPLACE(TotalPayment,',','') as cTotalPayment,
CustomerName, CSVReferenceNumber
from mtsnew order by CSVReferenceNumber

--[SALE INFORMATION] Select detail when there is no refund column in the sheet
--CSV Reference Number | Type | Transaction Status | Accounting Date | Name/Number | Attorney Docket Number

select
CSVReferenceNumber,
'Sale' as Type,
'Active' as TransactionStatus,
replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/') as AccountingDate,
TransactionRef as NameNumber,
AttorneyDocket,
Status,
Type
from MTSNew order by CSVReferenceNumber

--declare @Ttype varchar(100)
--set @Ttype = (Select
--Case
--	When Type = 'Refund' Then  @Ttype = 'Refund'
--	Else  @Ttype = 'Sale'
--End
--From MTSNew)



--Delete from MTSNew and MTD Table
delete from MtsNew
delete from MTD

--Select detail of Refund Record in MTSNew Table [REFUNDS DETAIL COLUMN]
--CSV Reference Number | Refund ID	| Accounting Date | Refund Amount	| Name/Number | Payment Method | Payee Name

--select *,replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/')  as TDate,
--REPLACE(replace(replace(REPLACE(TotalPayment,',',''),'(',''),')',''),'-','') as tpayment 
--from mtsnew
--where type = 'Refund' order by CSVReferenceNumber

select CSVReferenceNumber,TransactionID,replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/')  as AccountingDate,
REPLACE(replace(replace(REPLACE(TotalPayment,',',''),'(',''),')',''),'-','') as RefundAmount,
TransactionRef,'Credit Card' as PaymentMethod,'WOLF GREENFIELD' as PayeeName
from MTSNew
where Type = 'Refund'
order by CSVReferenceNumber



--Select Detail from MTSNew Table having NO REFUND Record
select replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/') as TDate,
TransactionRef, AttorneyDocket, Status, TransactionID, Type, REPLACE(TotalPayment,',','') as cTotalPayment,
CustomerName, CSVReferenceNumber,
'Credit Card' as PaymentType
from mtsnew
where type <> 'Refund'
order by CSVReferenceNumber

--[PAYMENT DETAIL]
--CSVReferenceNumber | PaymentType | TotalPaymentAmount | PaymentDate | PaymentAmount(this sale)
select 
CSVReferenceNumber,
'Credit Card' as PaymentType,
REPLACE(TotalPayment,',','') as TotalPaymentAmount,
replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/') as PaymentDate,
REPLACE(TotalPayment,',','') as PaymentAmount
from MTSNew
where type <> 'Refund'
order by CSVReferenceNumber


select CONVERT(VARCHAR(10), DatePosted, 101) as TDate,* from mtsnew
order by CSVReferenceNumber


--Select detail from MTD table
Select replace(CONVERT(VARCHAR(10), DatePosted, 101),'-','/') as Cdate,
reference,attorneydocket,Status,transactionid,saleid,feecode,
REPLACE(FeeCodeDescription,'"',' ') as FeeDescription,
REPLACE(itemprice,',','') as ItemPrice,
quantity,
REPLACE(itemtotal,',','') as ItemTotal,
customername,
transaction_status
from MTD

select * from MTD
where AttorneyDocket = '1'

delete from MTD
where AttorneyDocket = '1'


select * from MTD
where Quantity IS NULL

select * from MTD
where FeeCodeDescription = 'SEARCH FEE - REGARDLESS OF WHETHER THERE IS A CORRESPONDING APPLICATION (SEE 35 U.S.C. 361(D) AND PCT RULE 16)'

update MTD
set Quantity = 1
where Quantity IS NULL


select * from mtd
where ItemPrice is NULL

select distinct  B.CSVReferenceNumber,B.DatePosted,A.reference,B.TransactionRef
--,A.AttorneyDocket as Aadn,B.AttorneyDocket as Badn,
--A.TransactionID as ATID,B.TransactionID as BTID,A.Quantity,A.ItemPrice,A.ItemTotal,A.FeeCode,REPLACE(A.FeeCodeDescription,'"',' ') as FeeCodeDescription
from MTD A
join MtsNew B
on
A.TransactionID = B.TransactionID
order by B.CSVReferenceNumber asc

--Query for Sale Detail section
select distinct  B.CSVReferenceNumber,A.Transaction_Status,A.reference,B.TransactionRef
,A.AttorneyDocket as Aadn,B.AttorneyDocket as Badn,
A.TransactionID as ATID,B.TransactionID as BTID,A.Quantity,REPLACE(A.ItemPrice,',','') as ItemPrice,REPLACE(A.ItemTotal,',','')as ItemTotal,A.FeeCode,REPLACE(A.FeeCodeDescription,'"',' ') as FeeCodeDescription
from MTD A
join MtsNew B
on
A.TransactionID = B.TransactionID
order by B.CSVReferenceNumber asc

--Sale Detail Section Formated Table [SALE DETAIL]
--CSV Reference Number | Name/Number | Attorney Docket Number | Transaction Status | Quantity | Item Total | Payment Amount | Fee Code | Description

select distinct  
B.CSVReferenceNumber,
A.reference as Name_Number,
A.AttorneyDocket as AttorneyDocketNumber,
--A.Transaction_Status,
'A' as TransactionStatus,
A.Quantity,
REPLACE(A.ItemPrice,',','') as ItemPrice,
REPLACE(REPLACE(REPLACE(A.ItemTotal,',',''),'(','-'),')','') as ItemTotal,
A.FeeCode,REPLACE(A.FeeCodeDescription,'"',' ') as FeeCodeDescription
--,B.TransactionRef,
--B.AttorneyDocket as Badn,
--A.TransactionID as ATID,
--B.TransactionID as BTID
from MTD A
join MtsNew B
on
A.TransactionID = B.TransactionID
order by B.CSVReferenceNumber asc
