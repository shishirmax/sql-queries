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
