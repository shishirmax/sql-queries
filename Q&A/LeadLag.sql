--LEAD(): used to access data from nth next row in the same result set without the use of a self-join
--LAG(): used to access data from nth previous row in the same result set without the use of a self-join

SELECT 
	S.SalesOrderID
	,S.SalesOrderDetailID
	,S.OrderQty
	,LEAD(SalesOrderDetailID) OVER(ORDER BY SalesOrderDetailID) LeadValue
	,LAG(SalesOrderDetailID) OVER(ORDER BY SalesOrderDetailID) LagValue
FROM Sales.SalesOrderDetail S
ORDER BY S.SalesOrderID

--After Adding Prtition BY

SELECT 
	S.SalesOrderID
	,S.SalesOrderDetailID
	,S.OrderQty
	,LEAD(SalesOrderDetailID) OVER(PARTITION BY SalesOrderID ORDER BY SalesOrderDetailID) LeadValue
	,LAG(SalesOrderDetailID) OVER(PARTITION BY SalesOrderID ORDER BY SalesOrderDetailID) LagValue
FROM Sales.SalesOrderDetail S
ORDER BY S.SalesOrderID