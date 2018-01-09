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


SELECT count(1) FROM ZeroRez.ZeroRez_bcp --92766
--17 Column in File
--Comma delimited file

--Some column also contains double quote character, which we have removed using the below query
--Replaced double quote in the lifetime_total column 
UPDATE ZeroRez.ZeroRez_bcp
SET lifetime_total = REPLACE(lifetime_total,'"','')

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

select max(len(last_name)) from ZeroRez.ZeroRez_bcp
select count(distinct last_name) from ZeroRez.ZeroRez_bcp --32627



