---- Create the variables for the random number generation
DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT
DECLARE @Counter INT

SET @Lower = 1000 
SET @Upper = 9999
SET @Counter = 0 

WHILE @Counter <= 10
BEGIN
	SET @Random = 
		(
			ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
		)
	PRINT @Random
	SET @Counter += 1
END

--Generate Random Number using RAND() SQL function
DECLARE @count INT
SET @count = 0
WHILE @count<=100
BEGIN
	PRINT ROUND(RAND(),2)
	SET @count+=1
END