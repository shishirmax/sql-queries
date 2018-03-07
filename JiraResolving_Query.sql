SELECT * FROM [ZeroRez].[DimClient] 
WHERE 
FirstName LIKE '%[^a-z,A-Z, ]%' 
OR
lastName LIKE '%[^a-z,A-Z, ]%'

/*
Characters Found 
1. (.)Dot e.g: Eric M., Emily.
2. (&) e.g: Eric & Allie, Ericka & Adam
3. (') e.g: O'Brien, O'Kane
4. () Name inside bracket e.g: James (Jim), James (Peter)
5. ("") e.g: James Jim""
6. (/) Name seperated using / e.g: Jana/ Linda/Norleen
7. (-) Name seperated using - e.g: Adamson-Waitley
*/

SELECT * FROM [ZeroRez].[DimClient] 
WHERE FirstName LIKE '%[0-9]%'
OR
LastName LIKE '%[0-9]%'

SELECT * FROM [ZeroRez].[DimClient] 
WHERE FirstName LIKE '%"%' or LastName LIKE '%"%'

DECLARE @str VARCHAR(400)
DECLARE @expres  VARCHAR(50) = '%[0-9]%'
SET @str = 'Hoang Van-63'
WHILE PATINDEX( @expres, @str ) > 0
SET @str = Replace(REPLACE( @str, SUBSTRING( @str, PATINDEX( @expres, @str ), 1 ),''),'-',' ')
SELECT @str

select REPLACE(REPLACE('Mary @ Dan','@',''),'  ',' ')

select top 10 * from ZeroRez.ZeroRez_bcp 

select replace('Hoang Van-63',substring('Hoang Van-63',PATINDEX('%[0-9]%','Hoang Van-63'),1),'')

SELECT REPLACE('Cindy A2')

select * from [dbo].[LogError]
select * from [dbo].[LogTaskControlFlow]
order by 2 desc

DECLARE @txt VARCHAR(100)
SET @txt = 'Ann M. & Jim'
SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@txt,'.',''),'"',''),'0',''),'1',''),'2',''),'3',''),'4',''),'5',''),'6',''),'7',''),'8',''),'9','')


--ERA-132
select * from [ZeroRez].[FactZeroRezDedupData] where EmailGroupId is NULL 
or EmailGroupId =''

--ERA-133
select * from [ZeroRez].[FactZeroRezDedupData] where PhoneGroupId is NULL 
or PhoneGroupId =''

select abs(checksum(NewId()) % 10)

select CAST(RAND(CHECKSUM(NEWID())) * 10  as INT)

select RAND(convert(varbinary, newid())) magic_number 

SELECT table_name, 1.0 + floor(14 * RAND(convert(varbinary, newid()))) magic_number 
FROM information_schema.tables

set nocount on;

if object_id('dbo.Tally') is not null drop table dbo.tally
go

select top 10 identity(int,1,1) as ID
into dbo.Tally from SysColumns

alter table dbo.Tally
add constraint PK_ID primary key clustered(ID)
go

select * from dbo.Tally