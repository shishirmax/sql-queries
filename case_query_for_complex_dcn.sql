--match for space
select ATTORNEY_DOCKET_NBR from tbl_uspto
where ATTORNEY_DOCKET_NBR  like ''
--match for 11-2028 (1547.191US1)
select ATTORNEY_DOCKET_NBR from tbl_uspto
where ATTORNEY_DOCKET_NBR  like '%-% (%)'
--match for 1547.486WO1 (14-5903PCT)
select ATTORNEY_DOCKET_NBR from tbl_uspto
where ATTORNEY_DOCKET_NBR  like '% (%-%)'
-- 12475.0002-00000 case
DECLARE @attorney_docket_nbr NVARCHAR(100)
SELECT top 1 
	@attorney_docket_nbr_CLEAN=
	CASE 
		WHEN ATTORNEY_DOCKET_NBR  like '' 
			THEN NULL 
		WHEN ATTORNEY_DOCKET_NBR  like '%-% (%)' 
			THEN REPLACE(SUBSTRING(ATTORNEY_DOCKET_NBR,CHARINDEX('(',ATTORNEY_DOCKET_NBR)+1,LEN(ATTORNEY_DOCKET_NBR)),')','')
		WHEN ATTORNEY_DOCKET_NBR  like '% (%-%)'
			THEN substring(ATTORNEY_DOCKET_NBR,1,charindex('(',ATTORNEY_DOCKET_NBR)-1)
		WHEN ATTORNEY_DOCKET_NBR like '%-%' and ATTORNEY_DOCKET_NBR not like '%.%'
			THEN REPLACE(ATTORNEY_DOCKET_NBR,'-','.')
		ELSE ATTORNEY_DOCKET_NBR
		END 
FROM 
	tbl_uspto
select @attorney_docket_nbr






--***************************JUST POC***********************************
select * from tbl_uspto
--match for space
select ATTORNEY_DOCKET_NBR from tbl_uspto
where ATTORNEY_DOCKET_NBR  like ''
--match for 11-2028 (1547.191US1)
select ATTORNEY_DOCKET_NBR from tbl_uspto
where ATTORNEY_DOCKET_NBR  like '%-% (%)'
--match for 1547.486WO1 (14-5903PCT)
select ATTORNEY_DOCKET_NBR from tbl_uspto
where ATTORNEY_DOCKET_NBR  like '% (%-%)'
-- 12475.0002-00000 case

DECLARE @attorney_docket_nbr_CLEAN NVARCHAR(100)
DECLARE @attorney_docket_nbr NVARCHAR(100)
set @attorney_docket_nbr = '13348 Cranford Cir (Cranford Road) Rosemount, MN, 55068'

--select substring(@attorney_docket_nbr,1,charindex('(',@attorney_docket_nbr)-1)+''+substring(@attorney_docket_nbr,charindex(')',@attorney_docket_nbr)+1,len(@attorney_docket_nbr))
SELECT top 1 
	@attorney_docket_nbr_CLEAN=
	CASE 
		--WHEN @attorney_docket_nbr  like '' 
		--	THEN NULL 
		--WHEN @attorney_docket_nbr  like '%-% (%)' 
		--	THEN REPLACE(SUBSTRING(@attorney_docket_nbr,CHARINDEX('(',@attorney_docket_nbr)+1,LEN(@attorney_docket_nbr)),')','')
		WHEN @attorney_docket_nbr  like '%(%)%'
			--THEN substring(@attorney_docket_nbr,1,charindex('(',@attorney_docket_nbr)-1)
			THEN substring(@attorney_docket_nbr,1,charindex('(',@attorney_docket_nbr)-1)+''+substring(@attorney_docket_nbr,charindex(')',@attorney_docket_nbr)+1,len(@attorney_docket_nbr))
		--WHEN @attorney_docket_nbr like '%-%' and @attorney_docket_nbr not like '%.%'
		--	THEN REPLACE(@attorney_docket_nbr,'-','.')
		ELSE @attorney_docket_nbr
		END 
--FROM 
--	tbl_uspto
select @attorney_docket_nbr as original
select @attorney_docket_nbr_CLEAN as clean

DECLARE @address NVARCHAR(100)
set @address = '13348 Cranford Cir (Cranford Road) Rosemount, MN, 55068'
select substring(@address,1,charindex('(',@address)-1)+''+substring(@address,charindex(')',@address)+1,len(@address))