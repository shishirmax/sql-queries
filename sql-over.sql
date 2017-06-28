create table shipment(
ShipDate datetime,
InvtID varchar(50),
QtyShip int,
Profit money
)

insert into shipment
values
('7/21/2016','Item101',5,'$25'),
('7/1/2016','Product411',11,'$44'),
('7/1/2016','Product411',14,'$56')

select * from shipment

declare @TotalQtyShip int
set @TotalQtyShip = SUM(qtyship) over(partition by invtid)
select 
	replace(CONVERT(VARCHAR(10), ShipDate, 101),'-','/') as ShipDate,	
	InvtID,
	QtyShip,
	Profit,
	SUM(qtyship) over(partition by invtid) as TotalQtyShip
from shipment

TotalProfit = TotalQtyShip * Profit