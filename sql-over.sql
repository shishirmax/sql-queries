create table shipment(
ShipDate datetime,
InvtID varchar(50),
QtyShip int,
Profit money
)

insert into shipment
values
('7/19/2016','Item101',4,'$20'),
('7/21/2016','Item101',5,'$25'),
('7/1/2016','Product411',11,'$44'),
('7/1/2016','Product411',14,'$56')

select * from shipment

select 
	replace(CONVERT(VARCHAR(10), ShipDate, 101),'-','/') as ShipDate,	
	InvtID,
	QtyShip,
	Profit,
	SUM(qtyship) over(partition by invtid) as TotalQtyShip,
	SUM(profit) over (partition by invtid) as TotalProfit
from shipment
where ShipDate > '07/01/2016'

--TotalProfit = TotalQtyShip * Profit

--484+784
--80+125