Alter  procedure sp_fetch_data
@school varchar(max) = NULL,
@batch varchar(max) = NULL,
@academicYear varchar(max) = NULL
AS
Begin

--set @school = (Select
--CASE
--	when @school = ''
--	then NULL
--	Else @school
--END)

--set @batch = (Select
--CASE 
--	when @batch = ''
--		then NULL
--	Else @batch
--END)

--set @academicYear = (Select
--CASE 
--	when @academicYear = ''
--		then NULL
--	Else @academicYear
--END)

select * from myTable
where gender = 'male'
and (@school = school or @school IS NULL)
and (@batch = batch or @batch IS NULL)
and (@academicYear = academicYear or @academicYear IS NULL)
End

sql = "sp_fetch_data'"&Request.QueryString("school")&"','"&Request.QueryString("batch")&"','"&Request.QueryString("AcademicYear")&"'"

create table myTable(
name varchar(max),
gender varchar(max),
school varchar(max),
batch varchar(max),
academicyear varchar(10))

insert into myTable values('joana','female','DPS','Second','2010')

select * from myTable

select * from myTable
where gender = 'male'
and school = NULL
and batch = NULL
and academicYear = NULL

sp_fetch_data 'DAV','second','2009'

--UPDATE myTable
--SET batch = 'second'
--where name = 'neha'

select * from myTable
select * from myTabletar ;

MERGE myTabletar tar
using myTable src
	on tar.name = src.name
WHEN MATCHED THEN
UPDATE 
SET tar.gender		= src.gender
	,tar.school		= src.school		
	,tar.batch		= src.batch	
	,tar.academicyear= src.academicyear
WHEN NOT MATCHED THEN
INSERT 
(
name
,gender
,school
,batch
,academicyear
)
VALUES
(
src.name
,src.gender
,src.school
,src.batch
,src.academicyear
);