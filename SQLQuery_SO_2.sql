create table Vendors
(VendorID int,
VendorName nvarchar(100),
Address nvarchar(100),
City nvarchar(100),
State nvarchar(100),
ZipCode int,
Active nvarchar(100)
CONSTRAINT PK_Cendor PRIMARY KEY (VendorID))

insert into Vendors
values
(1002,'Appleburg', '1472 Witch Hollow Way', 'Salt Lake City', 'Utah', 84115, 'TRUE')

select * from Vendors

truncate table Vendors

CREATE PROC dbo.spInsertNewVendor
AS
BEGIN
        BEGIN TRY
            BEGIN TRAN
            INSERT INTO Vendors (VendorID, VendorName, Address, City, State, ZipCode, Active)
            VALUES (1002, 'Appleburg', '1472 Witch Hollow Way', 'Salt Lake City', 'Utah', 84115, 'TRUE')
            COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
        END CATCH
END

EXEC dbo.spInsertNewVendor

-----------------------------------------------------


declare @Query nvarchar(max)
set @Query = 'Select Id, PtName + ''('' +Investigation+ '')'' as PtName, Y, M, D, Sex, PtCode FROM DiagMain'
print @Query

-----------------------------------------------------
create table temperature(
id int identity(1,1),
tempDate datetime,
tempRecorded varchar(10))

select * from temperature
select getdate()

insert into temperature
values
('2017-08-07','32'),
('2017-08-07','30'),
('2017-08-07','31'),
('2017-08-08','34'),
('2017-08-08','35'),
('2017-08-08','31'),
('2017-08-09','29'),
('2017-08-09','28'),
('2017-08-10','21'),
('2017-08-10','25'),
('2017-08-10','30')

select max(tempRecorded),tempDate
from temperature
group by tempDate