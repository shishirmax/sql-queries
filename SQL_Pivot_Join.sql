create table EmployeeMaster(
EmpId int identity(100,1),
EmpName varchar(100))

insert into EmployeeMaster
values
('Emp1'),
('Emp2'),
('Emp3'),
('Emp4'),
('Emp5')

create table EmployeeSalaryDetails(
EmpId int,
Component varchar(100),
Amount int)

truncate table EmployeeSalaryDetails

insert into EmployeeSalaryDetails
values
(100,'Basic',120000),
(100,'HRA',10000),
(100,'TA',2750),
(101,'Basic',20000),
(101,'HRA',1000),
(102,'Basic',10000),
(102,'HRA',500),
(102,'TA',750),
(103,'Basic',45000),
(103,'HRA',8000),
(104,'Basic',70000),
(104,'HRA',5000),
(104,'TA',1000),
(105,'Basic',90000),
(105,'HRA',1500)

select * from EmployeeMaster
select * from EmployeeSalaryDetails

--PIVOT of EmployeeSalaryDetails

select * from EmployeeSalaryDetails
pivot(
	sum(Amount) 
	for component
	in([Basic],[HRA],[TA])
	)As DtlPivot

--Applying join with EmployeeMaster

select Emp.*,
	COALESCE(Dtl.[Basic],0) as [Basic],
	COALESCE(Dtl.[HRA],0) as [HRA],
	COALESCE(Dtl.[TA],0) as [TA]
	from EmployeeMaster as Emp
	left join
	(
		select * from EmployeeSalaryDetails
		pivot(
			sum(Amount) 
			for component
			in([Basic],[HRA],[TA])
			)As DtlPivot
	) AS Dtl
	on Emp.EmpId = Dtl.EmpId