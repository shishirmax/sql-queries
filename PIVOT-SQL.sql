create table CustomerSale(
CustomerName varchar(100),
ProductName Varchar(100),
Amount money)

select * from CustomerSale



insert into CustomerSale 
(CustomerName,ProductName,Amount)
values('Shiv','Shoes',100.50),
('Shiv','Shirt',200.50),
('Raju','Shirt',786.50),
('Ganesh','Shoes',2500.50),
('Ganesh','Shirt',564.26),
('Jignesh','Shoes',800.68),
('Shishir','Shoes',850.90),
('Shiv','Shoes',1500.50),
('Shiv','Shoes',1500.50)

select * from CustomerSale
--Step1 Deine the column name
select [CustomerName],
		[Shoes] as Shoes,
		[Shirt] as Shirt
from
--Step2 get the actual data
(
select CustomerName,
		ProductName,
		Amount
		From[CustomerSale]
) as PivotData

--step3 pivot function
pivot
(
sum(amount) for ProductName in 
(Shoes,Shirt))as Pivoting
order by CustomerName 


select CustomerName,Shoes,Shirt
from CustomerSale
PIVOT
(
	SUM(Amount)
	for ProductName
	IN([Shoes],[Shirt])
)
As PivotTable

select CustomerName,
	ProductName,
	SUM(Amount) as TotalAmount
from CustomerSale
group by ProductName,CustomerName
order by ProductName,CustomerName