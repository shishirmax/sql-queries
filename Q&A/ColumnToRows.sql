--https://stackoverflow.com/questions/54360648/convert-column-name-value-into-rows-name-row-value-in-sql-server-2008
WITH CTE(Tyear,Tmonth,[User],d1,d2,d3,d4,d5)
AS
(
SELECT 2019,'Jan','Sam',249,297,296,288,269 UNION ALL
SELECT 2019,'Jan','Rahul',300,237,452,142,475
)
SELECT * INTO #Temp FROM CTE

SELECT * FROM #Temp


SELECT [Tyear],Tmonth,Dayz,[Sam],[Rahul] 
FROM
(
SELECT o.Tyear,
       o.Tmonth ,
       Dayz,
       dayval,
       dt.[User]
FROM #Temp o
CROSS APPLY ( VALUES ('d1',d1,[User]),('d2',d2,[User]),('d3',d3,[User]),('d4',d4,[User]),('d5',d5,[User])) 
AS dt (Dayz,dayval,[User]) 
)AS SRc
PIVOT
(
MAX(dayval) FOR [User] IN ([Sam],[Rahul])
)AS Pvt