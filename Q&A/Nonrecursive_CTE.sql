--Nonrecursive Common Table Expression

WITH 
  cteTotalSales (SalesPersonID, NetSales)
  AS
  (
    SELECT SalesPersonID, ROUND(SUM(SubTotal), 2)
    FROM Sales.SalesOrderHeader 
    WHERE SalesPersonID IS NOT NULL
    GROUP BY SalesPersonID
  )
SELECT 
  sp.FirstName + ' ' + sp.LastName AS FullName,
  sp.City + ', ' + StateProvinceName AS Location,
  ts.NetSales
FROM Sales.vSalesPerson AS sp
  INNER JOIN cteTotalSales AS ts
    ON sp.BusinessEntityID = ts.SalesPersonID
ORDER BY ts.NetSales DESC