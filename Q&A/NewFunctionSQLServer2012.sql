--https://www.c-sharpcorner.com/UploadFile/rohatash/new-functions-in-sql-server-2012/
DECLARE @X INT;
SET @X=50;
DECLARE @Y INT;
SET @Y=60;
Select iif(@X>@Y, 50, 60) As IIFResult

DECLARE @clm1 INT
DECLARE @clm2 INT
SET @clm1 = 12345
SET @clm2 = 54321

SELECT @clm1,@clm2
SELECT ISNULL(@clm2,@clm1)