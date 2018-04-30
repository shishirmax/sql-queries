SELECT STRING_AGG (User, CHAR(150)) AS csv 
FROM homeSpotter.DimUser

SELECT STRING_AGG(ISNULL(EmpName,'NA'),',') AS CSV
FROM EmployeeMaster

SELECT STUFF(
             (SELECT ',' + EmpName 
              FROM EmployeeMaster
              FOR XML PATH (''))
             , 1, 1, '')

--STRING_AGG aggregation result exceeded the limit of 8000 bytes. Use LOB types to avoid result truncation.

select * from sys.tables