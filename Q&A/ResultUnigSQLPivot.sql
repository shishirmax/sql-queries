SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Product%'

CREATE TABLE ProductSale
(
	ID INT IDENTITY(1,1)
	,ProductName VARCHAR(255)
	,SaleYear VARCHAR(4)
	,SaleAmount DECIMAL(18,2)
)

INSERT INTO ProductSale
VALUES
('A',2016,'100.32')
,('A',2016,'435.12')
,('A',2017,'65.00')
,('B',2016,'200.32')
,('B',2017,'526.00')
,('B',2018,'352.00')
,('C',2016,'85.00')
,('C',2016,'856.00')
,('C',2017,'856.00')
,('C',2018,'1256.00')

SELECT * FROM ProductSale

SELECT SUM(SaleAmount),ProductName,SaleYear
FROM ProductSale
GROUP BY ProductName,SaleYear
ORDER BY ProductName

SELECT ProductName,[2016],[2017],[2018]
FROM
(
	SELECT ProductName,SaleYear,SaleAmount FROM ProductSale
) AS PivotData
PIVOT
(
	SUM(SaleAmount)
	FOR SaleYear IN ([2016],[2017],[2018])
) As PivotTable





