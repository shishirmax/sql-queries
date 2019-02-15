/*
Assume a Sales table with columns for Sales_Amount, Customer_Name, and Region. 
There are other columns and indeed other tables, but that’s not important. 
## Give me the top 5 customers by total Sales_Amount, within each Region. 
The number of regions may vary over time, and your query needs to keep working as regions come and go (i.e., you don’t get to handle this with a CASE statement). 
You may assume there are more than 5 customers with sales for each Region. 
So if I have 3 unique values of region in the table, I should get 15 rows, 5 for each region. 
But if there are 5 regions, I should get 25 rows. 
Write a T-SQL script for this. 
No JOINs are needed, you’re only using one table. 
You can use as many queries, and as many CTEs or Temp Tables, as you need.
*/

--## Give me the top 5 customers by total Sales_Amount, within each Region. 
SELECT * FROM Sales
ORDER BY Region

SELECT Customer_Name,Region,SUM(Sales_Amount)
FROM Sales
GROUP BY Customer_Name,Region WITH ROLLUP

SELECT DISTINCT Region 
FROM Sales

WITH cte AS (
SELECT 
	Customer_Name
	,Region
	,Sales_Amount
    ,DENSE_RANK() OVER(PARTITION BY Region ORDER BY Sales_Amount DESC) AS RowNum
	,ROW_NUMBER() OVER(PARTITION BY Region ORDER BY Sales_Amount DESC) AS RowNum2
FROM Sales)

SELECT Region,Customer_Name,SUM(Sales_Amount) As Total_Sales_Amount
FROM cte
WHERE RowNum2 <=5
GROUP BY Region,Customer_Name WITH ROLLUP
--GROUP BY ROLLUP(Region,Customer_Name)
--ORDER BY Region --,3 DESC



CREATE TABLE sales 
(
	Customer_Name VARCHAR(40)
	,Region VARCHAR(40)
	,Sales_Amount INT
)

insert into sales values ('ahmed2', 'Asia', 40000);
insert into sales values ('ahmed3', 'Asia', 60000);
insert into sales values ('ahmed4', 'Europe', 210000);
insert into sales values ('ahmed5', 'Europe', 30000);
insert into sales values ('ahmed6', 'Europe', 210000);
insert into sales values ('ahmed8', 'Europe', 5000);
insert into sales values ('ahmed9', 'Africa', 8000);
insert into sales values ('ahmed10', 'Africa', 86000);
insert into sales values ('ahmed11', 'Africa', 99000);
insert into sales values ('ahmed12', 'Australia', 76000);
insert into sales values ('ahmed13', 'Australia', 21000);
insert into sales values ('ahmed14', 'East America', 64000);
insert into sales values ('ahmed20', 'Asia', 96000);
insert into sales values ('ahmed23', 'South America', 98000);
insert into sales values ('ahmed24', 'South America', 95000);
insert into sales values ('ahmed25', 'North America', 98000);
insert into sales values ('ahmed26', 'North America', 91000);
insert into sales values ('ahmed27', 'South America', 97000);
insert into sales values ('ahmed28', 'South America', 94000);
insert into sales values ('ahmed29', 'Asia', 160000);
insert into sales values ('ahmed30', 'Asia', 620000);
insert into sales values ('ahmed31', 'Asia', 610000);
insert into sales values ('ahmed32', 'Australia', 71000);
insert into sales values ('ahmed33', 'Australia', 21000);
insert into sales values ('ahmed34', 'Australia', 51000);
insert into sales values ('ahmed38', 'North America', 108000);
insert into sales values ('ahmed39', 'North America', 38000);
insert into sales values ('ahmed40', 'North America', 68000);

insert into sales values ('Max10', 'Europe', 109560);
insert into sales values ('Max11', 'Europe', 526252);
insert into sales values ('Max12', 'Europe', 859000);
insert into sales values ('Max15', 'South America', 100500);
insert into sales values ('Max16', 'South America', 785111);

SELECT * FROM Sales
ORDER BY Region

