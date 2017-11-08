select count(*) from trulia_property_info

sp_help trulia_property_info

where assignedSchoolId = '3249700-536748-536712'



select TOP 10 * from trulia_property_info order by id desc

SELECT TOP 50 * FROM trulia_property_info WHERE elementarySchoolId IS NULL



INSERT INTO  Trulia_Property_info (streetNumber, street, AppartmentNumber, latitude, longitidue, NeighbourHoodId, state, city, zip,PriceHistory_1_date, PriceHistory_1_price, PriceHistory_1_event, PriceHistory_2_date, PriceHistory_2_price,PriceHistory_2_event,estimatedPrice,elementarySchoolId,middleSchoolId,highSchoolSchoolId,assignedSchoolId)
VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)


select count(*) from Trulia_School_Info



drop table School_Info

CREATE TABLE Trulia_School_Info
(
	id					INT IDENTITY(1,1)	NOT NULL,
	[name]				VARCHAR(250)		NULL,
	greatSchoolsRating	INT					NULL,
	[url]				VARCHAR(250)		NULL,
	[type]				VARCHAR(250)		NULL,
	schoolType			VARCHAR(250)		NULL,
	schoolId			VARCHAR(250)		NULL
)


ALTER TABLE trulia_property_info
ADD assignedSchoolId VARCHAR(250)

sp_help School_Info
''$293,629 

45.0007


DECLARE @string CHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len'  
Go

DECLARE @string VARCHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len'  
GO

DECLARE @string NCHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len'  
Go

DECLARE @string NVARCHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len'  
Go


select [Address],Latitude,Longitude from tblSales
FOR JSON PATH 
