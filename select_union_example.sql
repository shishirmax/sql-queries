SELECT * FROM information_Schema.Tables
WHERE TABLE_TYPE = 'BASE TABLE'


SELECT C.Table_CataLog
    ,C.Table_Schema
    ,C.Table_Name
    ,C.Column_Name
    ,'[' + C.Table_CataLog + ']' + '.[' + C.Table_Schema + '].' 
    + '[' + C.Table_Name + ']' AS FullQualifiedTableName
FROM information_schema.Columns C
INNER JOIN information_Schema.Tables T ON C.Table_Name = T.Table_Name
    AND T.Table_Type = 'BASE TABLE'
	AND T.TABLE_SCHEMA = 'dbo'
    AND C.IS_Nullable='YES'
	AND C.TABLE_NAME = 'AppointmentDetails'


select * into #t from 
(select 1 as id
union all
select 2
union all
select 3
union all 
select 4) t


select * into #tt from 
(select 1 as id
union all
select 2
union all
select 3
union all 
select 4
union all
select 5
union all 
select 8) t


select * from #t t
left join #tt tt
on 1=1
on  null = null

DROP TABLE #t
DROP TABLE #tt