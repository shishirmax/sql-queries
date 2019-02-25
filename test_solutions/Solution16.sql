/*
Write a query to calculate time difference (in days) between current and previous order of each customer for every row? 
What is the avg time difference between two orders for every customer?
*/
CREATE TABLE tblOrders
(
	Customer_id INT
	,Order_id VARCHAR(10)
	,Order_time DATETIME
)
INSERT INTO tblOrders
VALUES
(1,'A','2017/02/12 10:09:24')
,(1,'B','2017/06/01 14:07:30')
,(1,'C','2017/09/11 01:01:01')
,(2,'D','2016/01/01 12:00:00')
,(2,'E','2017/10/01 08:00:00')
,(3,'F','2017/03/01 05:00:01')
,(3,'G','2017/06/17 20:00:50')

SELECT * FROM tblOrders
--Solution:
SELECT Customer_id,Order_id,Order_time,lag_Order_time,DATEDIFF(day,lag_Order_time,Order_time) as Order_Day_Difference
--INTO #tmpOrderTable
FROM(
	SELECT Customer_id,Order_id,Order_time,ISNULL(LAG(Order_time) OVER (PARTITION BY Customer_id ORDER BY Customer_id),Order_time) AS lag_Order_time FROM tblOrders
	) T

--

SELECT Customer_id,SUM(DATEDIFF(DAY,lag_Order_time,Order_time))/(COUNT(1)-1) as Avg_Day_Difference
FROM(
	SELECT Customer_id,Order_id,Order_time,ISNULL(LAG(Order_time) OVER (PARTITION BY Customer_id ORDER BY Customer_id),Order_time) AS lag_Order_time FROM tblOrders
	) T
GROUP BY Customer_id

SELECT DATEDIFF(day,'2016-01-01 12:00:00.000','2017-10-01 08:00:00.000')

SELECT CAST(CAST(GETDATE() AS INT) AS DATETIME)


------------------------------------------------------------
---------------------Order Day Difference & Average -----------------------

CREATE TABLE #TEMP 
(
CId INT 
,ORDERId VARCHAR(100)
,Order_Time DATETIME 
)

INSERT INTO #TEMP (CId,ORDERId,Order_Time)
SELECT 1	,'A',	'2/12/2017 10:09:24'	UNION ALL
SELECT 1	,'B',	'6/1/2017 14:07:30'	UNION ALL
SELECT 1	,'C',	'9/11/2017 1:01:01'	UNION ALL
SELECT 2	,'D',	'1/1/2016 12:00:00'	UNION ALL
SELECT 2	,'E',	'10/1/2017 8:00:00'	UNION ALL
SELECT 3	,'F',	'3/1/2017 5:00:01'	UNION ALL
SELECT 3	,'G',	'6/17/2017 20:00:50'


SELECT *,RN =ROW_NUMBER() OVER(PARTITION BY CID ORDER BY ORDER_TIME DESC) INTO #TEMP2
FROM #TEMP 

SELECT * FROM #TEMP2 WHERE CID = 1

SELECT DISTINCT A.*,B.Order_Time,
ISNULL(CAST(DATEDIFF(DAY,A.Order_Time,B.Order_Time) AS varchar(100)) , 'Current Order') AS DaysCount
FROM #TEMP2 AS A 
LEFT JOIN #TEMP2 AS B 
ON A.CId	=	B.CId AND A.RN-1 = B.RN
ORDER BY CID ,RN

SELECT A.*,B.* FROM #TEMP2 AS A
JOIN (
SELECT 
AVG(DATEDIFF(DAY,A.Order_Time,B.Order_Time))AS AVERAGE ,A.CID
FROM #TEMP2 AS A 
LEFT JOIN #TEMP2 AS B 
ON A.CId	=	B.CId AND A.RN-1 = B.RN
GROUP BY A.CId
) AS B	
ON A.CID = B.CID