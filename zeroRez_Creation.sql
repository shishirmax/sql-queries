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
select * from ZeroRez.ZeroRez_bcp
where len(city)>21
