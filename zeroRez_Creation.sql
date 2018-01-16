IF NOT EXISTS (select * from information_schema.schemata WHERE SCHEMA_NAME = 'ZeroRez')
BEGIN
	CREATE SCHEMA ZeroRez authorization dbo
END

IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE TABLE_SCHEMA = 'ZeroRez' AND TABLE_NAME = 'ZeroRez_bcp')
BEGIN

	CREATE TABLE ZeroRez.ZeroRez_bcp
	(
		first_name			VARCHAR(MAX) NULL,
		last_name			VARCHAR(MAX) NULL,
		street1				VARCHAR(MAX) NULL,
		street2				VARCHAR(MAX) NULL,
		city				VARCHAR(MAX) NULL,
		state				VARCHAR(MAX) NULL,
		postal_code			VARCHAR(MAX) NULL,
		emails				VARCHAR(MAX) NULL,
		phones				VARCHAR(MAX) NULL,
		client_tags			VARCHAR(MAX) NULL,
		net_promoter_labels	VARCHAR(MAX) NULL,
		zones				VARCHAR(MAX) NULL,
		products			VARCHAR(MAX) NULL,
		source				VARCHAR(MAX) NULL,
		job_count			VARCHAR(MAX) NULL,
		last_service_date	VARCHAR(MAX) NULL,
		lifetime_total		VARCHAR(MAX) NULL
	)

END
truncate table ZeroRez.ZeroRez_bcp

--bcp ZeroRez.ZeroRez_bcp in D:\Edina\ZeroRez\ZeroRez-Data.csv -S tcp:contata.database.windows.net -d Edina_qa -U contata.admin@contata -P C@ntata123  -b 20000 -q -c -t","

--exec ZeroRez.usp_LoadFlat'/zerorezsource/ZeroRez-Data.csv','ZeroRez-Data.csv'
Columns: 'emails','phones','client_tags','net_promoter_labels','products','source'

select TOP 100 * from ZeroRez.ZeroRez_bcp
order by 1 desc

SELECT count(1) FROM ZeroRez.ZeroRez_bcp --92766
--17 Column in File
--Comma delimited file

--Some column also contains double quote character, which we have removed using the below query
--Replaced double quote in the lifetime_total column 
UPDATE ZeroRez.ZeroRez_bcp
SET <column_name> = REPLACE(<column_name>,'"','')

UPDATE ZeroRez.ZeroRez_bcp
SET first_name = REPLACE(first_name,'"','')

--first_name
--this column has NULL values(from 92765 records 4 records were having NULL value in first_name column)
--Some records also contain double quotes (Edward Ted"")
--distinct first_name : 16126
--maximum character: 25
--Value is of VARCHAR type
select first_name,count(1) from ZeroRez.ZeroRez_bcp
group by first_name

select * from ZeroRez.ZeroRez_bcp
where first_name like '%"%'

select * from ZeroRez.ZeroRez_bcp
where len(first_name) = 25
select max(len(first_name)) from ZeroRez.ZeroRez_bcp

select * from ZeroRez.ZeroRez_bcp
where first_name = ' Amy '

select count(distinct first_name) from ZeroRez.ZeroRez_bcp

--last_name
--this column may contain NULL values (from 92765 records 1 records were having NULL value in last_name column)
--for the same records, first_name column also contains double quote character
--maximum character: 26
--value is of VARCHAR type
--distinct last_name: 32627
select last_name,count(1) from ZeroRez.ZeroRez_bcp
group by last_name

select * from ZeroRez.ZeroRez_bcp
where last_name like '%"%'

select * from ZeroRez.ZeroRez_bcp
where len(last_name) = 16 IN ('26','16')


select max(len(last_name)) from ZeroRez.ZeroRez_bcp
select count(distinct last_name) from ZeroRez.ZeroRez_bcp --32627


--street1
--column contains NULL values(49)
--blank column found 8
--maximum character length: 45
--5 records found whose length is 45(896 Coon Rapids Boulevard Extension Northwest, 10643 Kell Avenue South Minneapolis, MN 55437)
--records were street1 is null the corresponding value for street2 is also null, with city, state and postalcode(except one record where city:Maple Plain, first_name:Kathleen and last_name:Halloran)
--80171 distinct street1 record found
--value is of VARCHAR type

select street1,count(1) from ZeroRez.ZeroRez_bcp
group by street1

select TOP 10 * from ZeroRez.ZeroRez_bcp
where street1 is null
select min(len(street1)) from ZeroRez.ZeroRez_bcp

select distinct TOP 10 street1 from ZeroRez.ZeroRez_bcp

select * from ZeroRez.ZeroRez_bcp
where street1 = ' 172nd Lane Northwest'

--street2
--83023 null value for street2 column
--10 blank value for street2 column
--maximum character length: 69
--only one record found for street2 column whose length is 69(187th and Iden cross streets Lakeville 55044 [this is not Farmington]) corresponding value of street1 for same is(9002 187th Street West)
--few records found with street2 column, which might create problem if we standardize the address using google api, on combining street2.
--e.g:
--5th Street to the left. Last one on the left.
--(Highland Parkway NOT West Highland Parkway)
--5th Street to the left. Last one on the left.
--610 Townhouse Number.  Can Park by Garage
--187th and Iden cross streets Lakeville 55044 [this is not Farmington]

select TOP 10 * from ZeroRez.ZeroRez_bcp where street2 is NOT null
select street2, count(1) from ZeroRez.ZeroRez_bcp
group by street2

select * from ZeroRez.ZeroRez_bcp where len(street2) > 15
select max(len(street2)) from ZeroRez.ZeroRez_bcp

SELECT  COUNT(*)as recCount,LEN(street2) as lenCount FROM ZeroRez.ZeroRez_bcp
GROUP BY LEN(street2)
order by lenCount desc

--city
--NULL records found: 78
--No Blank records
--324 DISTINCT city
--Maximum character length: 25
--2 records found where the length of character in city column is more than 21
--example:
--West Lakeland Township
--East Glacier Park Village

select max(len(city)) from ZeroRez.ZeroRez_bcp
select count(1) as recCount, len(city) as lenCount from ZeroRez.ZeroRez_bcp
group by city
order by lenCount desc
select TOP 10 * from ZeroRez.ZeroRez_bcp

--state
--8 distinct state
--under state column (MINNESOTA) is also available, only 1 records
--more number of records available for MN state(90947) 
--maximum character length: 9
select distinct state from ZeroRez.ZeroRez_bcp where state is not null
select max(len(state)) from ZeroRez.ZeroRez_bcp 
select state, count(*) as rc from ZeroRez.ZeroRez_bcp 
group by state
order by rc desc

--postal_code
--60 NULL records
--301 distinct postal code
--maximum character length = 5
--value is of integer type
select max(len(postal_code)) from ZeroRez.ZeroRez_bcp
select len(postal_code) as lcount,count(1) as rcount from ZeroRez.ZeroRez_bcp
group by len(postal_code)

select postal_code,count(1) from ZeroRez.ZeroRez_bcp 
group by postal_code

--email
--8657 NULL records
--71156 distinct emails
--maximum character length = 77
--multiple emails available inside emails column seperated by pipe(|) character
--[jeffyoung21@hotmail.com|jeffyoungrealtor@gmail.com|jeffyoungrealtor@gmail.com]
--[tracygoldberger@mac.com|tracygoldberger@mac.com|bridgette.johnson@lakesmn.com]
--1264 columns contains multiple email records in emails column
--There are few records where emails column does not contain email type data
--e.g
--|
--||
--0
--na
--nananananana.batman
--nicole_bye56782yahoo.com
--no
--no email
--cindyhorton3.gmail
--k@j
--There are records available with same first_name,last_name,emails and phones but have different address
select max(len(emails)) from ZeroRez.ZeroRez_bcp
select len(emails) as lc,count(1) as rc from ZeroRez.ZeroRez_bcp
group by len(emails)
order by len(emails) desc

select * from ZeroRez.ZeroRez_bcp
where len(emails)>75

select TOP 10 * from ZeroRez.ZeroRez_bcp
where emails NOT like '%|%'--1264

select emails,count(1)as cr from ZeroRez.ZeroRez_bcp
where emails not like '%.com'--'%@%'
group by emails
order by cr desc

select * from ZeroRez.ZeroRez_bcp
where emails = 'dkennedy7766@comcast.net'

--phones
--20 NULL records
--No blank records
--79399 distinct records
--maximum character length = 51
--multiple phone number is available under phones column seperated by pipe(|)
--phones column have not fixed type phone pattern, many garbage like value is also available.
--': 612-812-2619','(952) 292-0187','(612)-280-4227','7633600265|552','7632213055|','|9529131635','1234567','|','0','+1 (612) 594-2444','651-653-2235|651-332-1598|612-381-6983|612-381-6983'
select top 10 * from ZeroRez.ZeroRez_bcp where phones like '%-%'
select max(len(phones)) from ZeroRez.ZeroRez_bcp
where phones is not null

select len(phones) as lc,count(1) as rc from ZeroRez.ZeroRez_bcp
where phones not like '%_|_%'
group by len(phones)
order by len(phones) desc

select * from ZeroRez.ZeroRez_bcp
where phones = '|'

select * from ZeroRez.tblPhone_FF
where PersonID  = 86284

select * from ZeroRez.ZeroRez_bcp where len(phones) IN('51','1','7','9','17','13','14')
select TOP 100 phones,count(1) from ZeroRez.ZeroRez_bcp
group by phones

select TOP 100 phones from ZeroRez.ZeroRez_bcp
where phones = '203-733-0157|952-255-8332'

--client_tags
--28900 NULL records
--5311 distinct value
--maximum character length = 116
--multiple tags are available in the column seperated by pipe(|)
--example: jHill|areaRugs|areaRugFollowUp|airDuctLead|inspectAirDuctsAppt|request|doNotAssign|gWogen|airDuctFollowUp|seniortech
--from records it seems like many value sin client_tags are fixed available tags(e.g:'airDuctFollowUp|pets','pets|airDuctFollowUp') and few are custom(e.g:'donotemailpromotions')
--many records have single tags too(e.g: 'sOlson','refill','ducts')

select distinct client_tags from ZeroRez.ZeroRez_bcp
select * from ZeroRez.ZeroRez_bcp  where client_tags like '%ducts'
select max(len(client_tags)) from ZeroRez.ZeroRez_bcp 

select len(client_tags) as lc,count(1) as rc from ZeroRez.ZeroRez_bcp
where client_tags not like '%_|_%'
group by len(client_tags)
order by len(client_tags) desc

select * from ZeroRez.ZeroRez_bcp where len(client_tags) = 5
'referralCard|airQuality' 'donotemailpromotions'

--net_promoter_labels
--76322 NULL records
--6 distinct records
--e.g(detractor,passive|promoter,detractor|passive,detractor|promoter,promoter,passive)
--maximum character length : 18
--some records have mixed labels also (e.g:'passive|promoter','detractor|passive','detractor|promoter')
select max(len(net_promoter_labels)) from ZeroRez.ZeroRez_bcp 

select distinct net_promoter_labels from ZeroRez.ZeroRez_bcp 
select net_promoter_labels,count(1) from ZeroRez.ZeroRez_bcp
group by net_promoter_labels

select * from ZeroRez.ZeroRez_bcp 
where net_promoter_labels = 'detractor|passive'

--zones
--2355 NULL records
--84 distinct records
--maximum character lenth = 34
--this column also contain some special character like &,$,@
--15700 records available which do not have special characters
--e.g: (Aquamarine,Loudoun,Violet,Brown,Blue,Orange,Red,Coral,MediumAquaMarine,Teal,Peoria,MediumSlateBlue)
--for same zone all records have same city,state and postal_code e.g(look for zones = 'Orange','MediumAquaMarine'), for few values there are difference in data.e.g(zones='Dark Orange 1','2 @ $314 Blue')
select distinct zones from ZeroRez.ZeroRez_split
select max(len(zones)) from ZeroRez.ZeroRez_bcp where zones is null

SELECT COUNT(1)
FROM ZeroRez.ZeroRez_bcp
WHERE zones not like '%[^a-Z0-9]%'

select zones, count(1) from ZeroRez.ZeroRez_bcp
WHERE zones  like '%[^a-Z0-9]%'
group by zones

select * from ZeroRez.ZeroRez_bcp
where zones = '2 @ $314 Blue'

select distinct zones from ZeroRez.ZeroRez_bcp

--products
--3978 NULL records
--57670 distinct records
--maximum character length = 1208
--only one record available whose column size is 1208
--e.g(100--$169 Two Room Special With Stairs|101-- $139 Two Room Special With Stairs|102--Oversized Area|102--Traffic Area Clean|103--Hallway|106--Stair Clean|109--Family Room|118--FREE Speed Drying|119--FREE Plus One Service|120 - Waste Disposal|140--Discount|143--$15 Gonna Love It Gift Card|152--Area Rug Protector|153--Area Rug Padding|155--Rug Delivery|162--Wool Hand Knot (Shop)|163--Wool Hand Tuft (Shop)|165--Wool Machine Woven (Shop)|167--Area Rugs Biological Treatment|170--In-Home Area Rug Estimate|181--Free Home Service Inspection: Area rugs - customer declined inspection|182--Free Home Service Inspection: Area rugs assessed - cleaning not immediately needed|197--Zerorez Spotter Kit|200--Fiber Protection|202--Deodorizer|205--Water Claw Treatment|206--Topical Biological Treatment|350--Chair Clean|351--Couch Clean|399a Inspect Air Ducts|400--Duct and Return Cleaning - Standard|401a--Air Duct Promo Discount|401--Duct and Return Cleaning - Premium|407a--Furnace Cleaning|420--Duct Waste Disposal Fee|432--Free Home Service Inspection: Ducts +ÛGÈºG«£ customer declined inspection|433--Free Home Service Inspection: Ducts assessed +ÛGÈºG«£ cleaning not immediately needed|y101a--$99 Two Room Special)
--mixed values seperated by pipe(|) character
--e.g(100--$159 Three Room Special|102--Area Carpet Clean (please specify)|102--Traffic Area Clean|103--Hallway|106--Stair Clean|107--Landing|108--Bedroom|113a - $154 December Two Room Special with Stairs|118--FREE Speed Drying|119--FREE Plus One Service|120 - Waste Disposal|142--$20 Gonna Love It Gift Card|151--Area Rug Clean (Shop)|152--Area Rug Protector|155b--$20 Off Promo|155--Rug Delivery|167--Area Rugs Biological Treatment|182--Free Home Service Inspection: Area rugs assessed - cleaning not immediately needed|196--ZeroStink Spotter|197--Zerorez Spotter Kit|200--Fiber Protection|205--Water Claw Treatment|206--Topical Biological Treatment|400--Duct and Return Cleaning - Standard|401a--Air Duct Promo Discount|402--Dryer Vent Cleaning|405a--Breathe Clean Bulbs|405--Breathe Clean System|407a--Furnace Cleaning|420--Duct Waste Disposal Fee|432--Free Home Service Inspection: Ducts +ÛGÈºG«£ customer declined inspection|y101--$139 Three Room Special|y101--$154 Two Room Special With Stairs)
--column contains different special caharacters also e.g('+ÛÈº«£')
select max(len(products)) from ZeroRez.ZeroRez_split

select len(products) as lc,count(1) as rc from ZeroRez.ZeroRez_bcp
group by len(products)
order by len(products) desc

select * from ZeroRez.ZeroRez_bcp
where len(products) = 994

SELECT TOP 10 products
FROM ZeroRez.ZeroRez_split
WHERE products   like '%|%'


--source
--171 NULL records
--2153 Disctinct records
--maximum character length = 109
--multiple values availavke in on single column seperated with pipe(|) character
--e.g('Area Rug Division|Customer Drop-Off|Employee Referral|Non-Revenue|Repeat Customer','Area Rug Division|KDWB 101.3 Dave Ryan|Non-Revenue|Radio')
--records also available which is not seperated using pipe character.
--e.g('Angie's List','Air Duct','Yelp','Book Now')
select distinct source  from ZeroRez.ZeroRez_split where source like '%[|]%'

select * from zerorez.zerorez_bcp
where source like '%Money Mailer - Promo MM%'

select count(*) from ZeroRez.ZeroRez_bcp
where source not like '%[-!#%&+,./:;<=>@`{|}~"()*\\\_\^\?\[\]\'']%'

select source,count(1) from ZeroRez.ZeroRez_bcp
where source not like '%[|]%'
group by source

select source,client_tags,count(1) from ZeroRez.ZeroRez_bcp
where source not like '%[|]%' and client_tags is not null
group by source,client_tags
order by source

select TOP 10 * from ZeroRez.ZeroRez_bcp
where source = 'ZEROREZ Events'

select min(len(source)) from ZeroRez.ZeroRez_Split

select count(1)


--job_count
--0 NULL Records
--32 distinct records
--maximum character length = 2
--Integer type data
--minimum job count value available = 0
--maximum job count value available = 40
--the value for job count goes from 0-40

select max(len(job_count)) from ZeroRez.ZeroRez_bcp

select count(1),count(try_cast(job_count as int)) from ZeroRez.ZeroRez_bcp
select max(try_cast(job_count as int)) from ZeroRez.ZeroRez_bcp

select DISTINCT try_cast(job_count as int) As DistinctJobCount from ZeroRez.ZeroRez_bcp order by 1
select job_count,count(1) as rc from ZeroRez.ZeroRez_bcp
group by job_count
order by rc desc


--last_service_date
--date type column
--NO NULL records
--1000 distinct records
--distinct year(2015,2016,2017)
--column can be cast to datetime column
--sample data: '1/2/2015','1/10/2015'
select max(len(last_service_date)) from ZeroRez.ZeroRez_bcp
select distinct top 10 last_service_date from ZeroRez.ZeroRez_bcp
select TRY_CAST(last_service_date as DATETIME) from ZeroRez.ZeroRez_bcp

--lifetime_total
--Replaced double quote in the lifetime_total column (cleaning data)
--NO NULL records
--10587 distinct records
--maximum character length = 9
--max value for lifetime_total =  19985.810
--min value for lifetime_total =  0
--value is of amount type
--the column can be cast into decimal data type
select max(CAST(lifetime_total AS DECIMAL(10,3))) from ZeroRez.ZeroRez_bcp

select distinct CAST(lifetime_total AS DECIMAL(10,3)) AS DistinctLifetimeTotal from ZeroRez.ZeroRez_bcp
order by 1 desc

select * from ZeroRez.ZeroRez_bcp
where CAST(lifetime_total AS DECIMAL(10,3)) = 19985.810
--2 records available for the user with maximum lifetime_total value
--same user but with different products and source

select distinct lifetime_total from ZeroRez.ZeroRez_bcp

select lifetime_total,count(1) from ZeroRez.ZeroRez_bcp
group by lifetime_total

select try_cast(lifetime_total as decimal(18,3)) from ZeroRez.ZeroRez_bcp


--DATA TYPE CHECK FOR DT TABLES
select count(first_name),count(try_cast(first_name as varchar))						from ZeroRez.ZeroRez_split	VARCHAR
select count(last_name),count(try_cast(last_name as varchar))						from ZeroRez.ZeroRez_split	VARCHAR
select count(street1),count(try_cast(street1 as varchar))							from ZeroRez.ZeroRez_split	VARCHAR
select count(street2),count(try_cast(street2 as varchar))							from ZeroRez.ZeroRez_split	VARCHAR
select count(city),count(try_cast(city as varchar))									from ZeroRez.ZeroRez_split	VARCHAR
select count([state]),count(try_cast([state] as varchar))							from ZeroRez.ZeroRez_split	VARCHAR
select count(postal_code),count(try_cast(postal_code as BIGINT))					from ZeroRez.ZeroRez_split	BIGINT
select count(emails),count(try_cast(emails as varchar))								from ZeroRez.ZeroRez_split	VARCHAR
select count(phones),count(try_cast(phones as BIGINT))								from ZeroRez.ZeroRez_split	BIGINT
select count(client_tags),count(try_cast(client_tags as varchar))					from ZeroRez.ZeroRez_split	VARCHAR
select count(net_promoter_labels),count(try_cast(net_promoter_labels as varchar))	from ZeroRez.ZeroRez_split	VARCHAR
select count(zones),count(try_cast(zones as varchar))								from ZeroRez.ZeroRez_split	VARCHAR
select count(products),count(try_cast(products as varchar))							from ZeroRez.ZeroRez_split	VARCHAR
select count(source),count(try_cast(source as varchar))								from ZeroRez.ZeroRez_split	VARCHAR
select count(job_count),count(try_cast(job_count as int))							from ZeroRez.ZeroRez_split	INT
select count(last_service_date),count(try_cast(last_service_date as datetime))		from ZeroRez.ZeroRez_split	DATETIME
select count(lifetime_total),count(try_cast(lifetime_total as decimal))				from ZeroRez.ZeroRez_split	DECIMAL

--imp metrics are: % null, % empty, mean, median, 1st Standard deviation, 2nd SD, min, max

select Street1,street2,city,state,postal_code,ISNULL(street1,' ')+','+ISNULL(street2,' ')+','+ISNULL(city,' ')+','+ISNULL(state,' ')+','+ISNULL(postal_code,' ') As originalAddress, count(1) As rc
from ZeroRez.ZeroRez_bcp 
--where 
--street1 is not null 
--and street2 is not null
--and city is not null
--and state is not null
--and postal_code is not null
group by Street1,street2,city,state,postal_code
having count(1)>1
order by rc desc

select * from ZeroRez.ZeroRez_bcp
where
street1 = '17 1st Street South'
and street2 = 'Unit A1007'
and city = 'Minneapolis'
and state = 'MN'
and postal_code = '55401'

select * from ZeroRez.ZeroRez_bcp 
where first_name = 'Beth'
and last_name = 'Evenson'


select street1+','+ISNULL(street2,'')+','+city+','+state+','+postal_code from ZeroRez.ZeroRez_bcp 

select value from STRING_SPLIT('Area Rug Division|KDWB 101.3 Dave Ryan|Non-Revenue|Radio','|')

select item from dbo.SplitString('Area Rug Division|KDWB 101.3 Dave Ryan|Non-Revenue|Radio','|')

SELECT TOP 10 * FROM ZeroRez.ZeroRez_bcp
SELECT * FROM ZeroRez.ZeroRez_split
where IZeroRezId = 11795

select count(1),street1,IzeroRezId from ZeroRez.ZeroRez_split
where street1 is null
group by street1,IzeroRezId

--CALCULATING NULL 
select count(distinct IzeroRezId) from ZeroRez.ZeroRez_split
where lifetime_total is null

--CALCULATING BLANK
select count(distinct IzeroRezId) from ZeroRez.ZeroRez_split
where CAST(lifetime_total AS DECIMAL(18,5)) = 0.00

select distinct * from ZeroRez.ZeroRez_split
where CAST(lifetime_total AS DECIMAL(18,5)) = 0.00

select * from ZeroRez.ZeroRez_bcp
where IZeroRezId = 2087

select * from  ZeroRez.ZeroRez_split
where street1 is null

select B.* from 
ZeroRez.ZeroRez_bcp(NOLOCK) A
join 
ZeroRez.ZeroRez_split(NOLOCK) B
on A.IZeroRezId = B.IZeroRezId
where A.IZeroRezId = 4

/*
Split_FFTables:
SELECT * FROM	ZeroRez.tblAddress_FF
SELECT * FROM	ZeroRez.tblClientTags_FF
SELECT * FROM	ZeroRez.tblEmail_FF
SELECT * FROM	ZeroRez.tblNetPromoterLabels_FF
SELECT * FROM	ZeroRez.tblPhone_FF
SELECT * FROM	ZeroRez.tblProducts_FF
SELECT COUNT(*) FROM	ZeroRez.tblSource_FF
SELECT COUNT(*) FROM	ZeroRez.tblZeroRez_FF
*/

--ZeroRez.ZeroRez_bcp

SELECT top 10 * FROM ZeroRez.tblEmail_FF where email is not null and email <> ''
select top 10 * from ZeroRez.tblAddress_FF
SELECT top 10 * FROM ZeroRez.tblClientTags_FF
SELECT top 10 * FROM ZeroRez.tblZeroRez_FF
SELECT TOP 10 * FROM ZeroRez.tblProducts_FF
SELECT TOP 10 * FROM	ZeroRez.tblPhone_FF where PhoneNumber IS NOT NULL and PhoneNumber <> ''

select top 10 phones from ZeroRez.ZeroRez_Split
SELECT TOP 10 * FROM	ZeroRez.tblNetPromoterLabels_FF where NetPromoterLabels is not null and NetPromoterLabels <> ''

--ZeroRez.tblSource_FF
--215 DISTINCT Source Type value
--171 NULL records
--Count for 'Repeat Customer' value = 24435

select count(distinct source)from ZeroRez.tblSource_FF --214
select count(distinct source) from ZeroRez.ZeroRez_Split --214


select top 10 * from ZeroRez.tblSource_FF where source is not null

select top 10 * from ZeroRez.ZeroRez_Split

--Getting Frequency for Source
select source,count(distinct IZeroRezId) as frequency from ZeroRez.ZeroRez_Split
where source is not null
group by Source
order by frequency desc

--Getting Frequency for products
select products,count(distinct IZeroRezId) as frequency from ZeroRez.ZeroRez_Split
where products is not null
group by products
order by frequency desc


--Getting Frequency for job_count
select job_count,count(distinct IZeroRezId) as frequency from ZeroRez.ZeroRez_Split
where job_count is not null
group by rollup(job_count)
order by frequency desc

--Getting Frequency for lifetime_total
select CAST(lifetime_total as money) as lifetime_total,NTILE(10) OVER(ORDER BY CAST(lifetime_total as money) DESC) AS tile ,count(distinct IZeroRezId) as frequency from ZeroRez.ZeroRez_Split
where CAST(lifetime_total as money) is not null
group by CAST(lifetime_total as money)
order by CAST(lifetime_total as money)--frequency desc

--******MEAN******
select sum(CAST(lifetime_total as decimal(28,8))) from ZeroRez.ZeroRez_bcp --62384330.30
select avg(CAST(lifetime_total as decimal(28,8))) from ZeroRez.ZeroRez_bcp --672.49132548 MEAN
select count(1) from ZeroRez.ZeroRez_bcp --92766
select (62384330.30/92766)

select sum(cast(job_count as int)) from ZeroRez.ZeroRez_bcp --208405
select avg(cast(job_count as int)) from ZeroRez.ZeroRez_bcp --2 MEAN
select cast((208405/92766)
--*****MEDIAN*****
select 
((Select Top 1 lifetime_total
		From   (
				Select Top 50 Percent CAST(lifetime_total as money) as lifetime_total
				From	ZeroRez.ZeroRez_bcp
				Where	CAST(lifetime_total as money) Is NOT NULL
				Order By CAST(lifetime_total as money)
				) As A
		Order By CAST(lifetime_total as money) DESC)
		+
(Select Top 1 lifetime_total
		From   (
				Select Top 50 Percent CAST(lifetime_total as money) as lifetime_total
				From	ZeroRez.ZeroRez_bcp
				Where	CAST(lifetime_total as money) Is NOT NULL
				Order By CAST(lifetime_total as money) DESC
				) As A
		Order By CAST(lifetime_total as money) Asc))/2 --453.00 MEDIAN


select 
((Select Top 1 job_count
		From   (
				Select Top 50 Percent CAST(job_count as int) as job_count
				From	ZeroRez.ZeroRez_bcp
				Where	CAST(job_count as int) Is NOT NULL
				Order By CAST(job_count as int)
				) As A
		Order By CAST(job_count as int) DESC)
		+
(Select Top 1 job_count
		From   (
				Select Top 50 Percent CAST(job_count as int) as job_count
				From	ZeroRez.ZeroRez_bcp
				Where	CAST(job_count as int) Is NOT NULL
				Order By CAST(job_count as int) DESC
				) As A
		Order By CAST(job_count as int) Asc))/2 --2 MEDIAN

--******MODE*****
SELECT TOP 1 with ties CAST(lifetime_total as money)
FROM   ZeroRez.ZeroRez_bcp
WHERE  CAST(lifetime_total as money) IS Not NULL
GROUP  BY CAST(lifetime_total as money)
ORDER  BY COUNT(*) DESC --173.00 MODE

SELECT TOP 1 with ties cast(job_count as int)
FROM   ZeroRez.ZeroRez_bcp
WHERE  cast(job_count as int) IS Not NULL
GROUP  BY cast(job_count as int)
ORDER  BY COUNT(*) DESC --1 MODE


--******Standard Deviation******
SELECT STDEV(CAST(lifetime_total as money))  
FROM ZeroRez.ZeroRez_bcp 
GO 

SELECT STDEV(cast(job_count as int))  
FROM ZeroRez.ZeroRez_bcp 
GO 


select count(1) from ZeroRez.ZeroRez_bcp
where products like '%120 - Waste Disposal%' --80887


--DISTINCT COLUMN CHECK
SELECT COUNT(DISTINCT first_name) FROM ZeroRez.ZeroRez_split WHERE first_name =''
SELECT COUNT(DISTINCT last_name) FROM ZeroRez.ZeroRez_split WHERE last_name = ''
SELECT COUNT(DISTINCT street1) FROM ZeroRez.ZeroRez_split WHERE street1 = ''
SELECT COUNT(DISTINCT street2) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT city) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT state) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT postal_code) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT emails) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT phones) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT client_tags) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT net_promoter_labels) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT zones) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT products) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT source) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT job_count) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT CAST(last_service_date As DATETIME)) FROM ZeroRez.ZeroRez_split
SELECT COUNT(DISTINCT lifetime_total) FROM ZeroRez.ZeroRez_split

select COUNT(DISTINCT PersonID) from ZeroRez.tblSource_FF
where Source = 'Repeat Customer'

--BLANK CHECK
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where first_name = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where last_name = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where street1 = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where street2 = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where city = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where state = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where postal_code = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where emails = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where phones = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where client_tags = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where net_promoter_labels = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where zones = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where products = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where source = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where job_count = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where last_service_date = ''
select count(DISTINCT IZeroRezId) from ZeroRez.ZeroRez_Split where lifetime_total = ''

select TOP 10 * 
from ZeroRez.ZeroRez_Split A
where A.phones = ''
and IZeroRezId IN (Select DISTINCT IZeroRezId from ZeroRez.ZeroRez_Split )
 
select A.personid,B.* 
from ZeroRez.tblSource_FF A
left join ZeroRez.ZeroRez_bcp B
on A.PersonID = B.IZeroRezId
where A.source is null

select * from sys.objects
where schema_id = 13 and type = 'U'

select * from sys.columns
where object_id = 884198200
order by name desc


