DECLARE @json_data NVARCHAR(MAX)

SET @json_data = '{"MSSQL":[
    {
    "SQLServer":{  
   "Version":"2008",
   "CompatibilityLevel":100,
   "CodeName":"Katmai" },
    "YearofRelease":"2008"
    },
 {
    "SQLServer":{  
   "Version":"2012",
   "CompatibilityLevel":110,
   "CodeName":"Denali" },
    "YearofRelease":"2012"
    },
 {   
    "SQLServer":{  
   "Version":"2014",
   "CompatibilityLevel":120,
   "CodeName":"Hekaton" },
    "YearofRelease":"2014"
    },
 {
    "SQLServer":{  
   "Version":"2016",
   "CompatibilityLevel":130,
   "CodeName":"2016" },
    "YearofRelease":"2016"
    }
   ]
}'

--SELECT ISJSON(@json_data) valid_json

DROP TABLE IF EXISTS json_data_tbl
CREATE TABLE json_data_tbl
(
	ID INT IDENTITY(1,1)
	,json_col NVARCHAR(MAX)
)

INSERT json_data_tbl SELECT(@json_data)

SELECT * FROM json_data_tbl

SELECT T.id,C.[key],C.value
FROM json_data_tbl T
CROSS APPLY OPENJSON(json_col) C

SELECT T.id,C.[key],C.value
FROM json_data_tbl T
CROSS APPLY OPENJSON(json_col,'$') C

SELECT T.id,C.[key],C.value
FROM json_data_tbl T
CROSS APPLY OPENJSON(json_col,'$.MSSQL') C

SELECT C.*
FROM json_data_tbl T
CROSS APPLY OPENJSON(json_col,'$.MSSQL')
	WITH(
			Version VARCHAR(255) '$.SQLServer.Version',
			CompatibilityLevel VARCHAR(255) '$.SQLServer.CompatibilityLevel',
			CodeName VARCHAR(255) '$.SQLServer.CodeName',
			YearofRelease VARCHAR(255) '$.YearofRelease'
		) AS C

--By adding INSERT statement on top of SELECT with OPENJSON, We can insert JSON data converted into rows &Columns format.

--Ref:
--https://docs.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql?view=sql-server-2017