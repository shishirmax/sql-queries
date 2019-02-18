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

SELECT Customer_id,Order_id,Order_time,lag_Order_time,DATEDIFF(day,lag_Order_time,Order_time) as Order_Day_Difference
FROM(
	SELECT Customer_id,Order_id,Order_time,LAG(Order_time) OVER (PARTITION BY Customer_id ORDER BY Customer_id) AS lag_Order_time FROM tblOrders
	) T


SELECT Customer_id,Order_id,AVG(DATEDIFF(minute,lag_Order_time,Order_time)) as Avg_Day_Difference
FROM(
	SELECT Customer_id,Order_id,Order_time,LAG(Order_time) OVER (PARTITION BY Customer_id ORDER BY Customer_id) AS lag_Order_time FROM tblOrders
	) T
GROUP BY Customer_id,Order_id

SELECT DATEDIFF(day,'2016-01-01 12:00:00.000','2017-10-01 08:00:00.000')

SELECT CAST(CAST(GETDATE() AS INT) AS DATETIME)