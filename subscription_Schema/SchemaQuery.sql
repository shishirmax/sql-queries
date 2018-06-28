--Table with data type columns
CREATE TABLE subscriptionStatus(
	ssid BIGINT IDENTITY(1,1)
	,CustomerID BIGINT
	,TransactionID BIGINT
	,TransactionStatus VARCHAR(31)
	,TransactionReference VARCHAR(31)
	,TransacionTimeStamp DATETIME
)

--Table with varchar type columns
CREATE TABLE StagingSubscriptionStatus(
	CustomerID				VARCHAR(1000)
	,TransactionID			VARCHAR(1000)
	,TransactionStatus		VARCHAR(1000)
	,TransactionReference	VARCHAR(1000)
	,TransacionTimeStamp	VARCHAR(1000)
)

--Table for Logging(ErrorLog Table)

CREATE TABLE LogError
(
	ErrorID				BIGINT IDENTITY(1,1)
	,ObjectName			NVARCHAR(1000)
	,ErrorCode			BIGINT
	,ErrorDescription	NVARCHAR(1000)
	,ErrorGenerationTime	DATETIME
)

--Insert into LogError Table
INSERT INTO [LogError] (
	objectName          
    ,ErrorCode          
    ,ErrorDescription          
    ,ErrorGenerationTime)          
	SELECT          
	OBJECT_NAME(@@PROCID),          
	ERROR_NUMBER() AS ErrorCode,          
	'Error of Severity: ' + CAST(ERROR_SEVERITY() AS varchar(4))          
	+ ' and State: ' + CAST(ERROR_STATE() AS varchar(8))          
	+ ' occured in Line: ' + CAST(ERROR_LINE() AS varchar(10))          
	+ ' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription,          
	GETDATE() 

SELECT * FROM LogError
DROP TABLE LogError

--Creating a StoredProcedure for inserting data into subscriptionStatus
ALTER PROCEDURE sp_InsertIntoSubscriptionStatus
AS
BEGIN
	DECLARE 
		@modifiedDate DATETIME
		,@ErrorCount INT
	SET @modifiedDate = GETDATE()

	BEGIN TRY
		BEGIN TRAN
			INSERT INTO dbo.subscriptionStatus(
				CustomerID
				,TransactionID
				,TransactionStatus
				,TransactionReference
				,TransacionTimeStamp
				,ModifiedDate
				)
			SELECT
				CustomerID
				,TransactionID
				,TransactionStatus
				,TransactionReference
				,TransacionTimeStamp
				,@modifiedDate
			FROM dbo.StagingSubscriptionStatus

			SET @ErrorCount = @@ROWCOUNT
			
			TRUNCATE TABLE dbo.StagingSubscriptionStatus
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		IF @@TRANCOUNT>0
		ROLLBACK TRAN

		INSERT INTO [LogError] (
			objectName          
			,ErrorCode          
			,ErrorDescription          
			,ErrorGenerationTime)          
			SELECT          
			OBJECT_NAME(@@PROCID),          
			ERROR_NUMBER() AS ErrorCode,          
			'Error of Severity: ' + CAST(ERROR_SEVERITY() AS varchar(4))          
			+ ' and State: ' + CAST(ERROR_STATE() AS varchar(8))          
			+ ' occured in Line: ' + CAST(ERROR_LINE() AS varchar(10))          
			+ ' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription,          
			GETDATE()
	END CATCH
END
	
--Executing Stored Procedure to insert data into subscriptionStatus table
EXEC sp_InsertIntoSubscriptionStatus

SP_HELPTEXT 'sp_InsertIntoSubscriptionStatus'




SELECT * FROM StagingSubscriptionStatus
--TRUNCATE TABLE StagingSubscriptionStatus

SELECT * FROM subscriptionStatus
--TRUNCATE TABLE subscriptionStatus

--Alter table subscriptionStatus to add column ModifiedDate

ALTER TABLE subscriptionStatus
ADD ModifiedDate DATETIME
SELECT CAST('"02-June-2018"' AS DATETIME)

--Insert Data using BULK INSERT SCRIPT
BULK INSERT StagingSubscriptionStatus
FROM 'D:\GIT\sql-queries\subscription_Schema\Data\data.csv'
WITH
(
FIELDTERMINATOR='|',
FIRSTROW=2,
ROWTERMINATOR='\n'
)

--Insert Data using BCP Script
bcp dbo.StagingSubscriptionStatus in D:\GIT\sql-queries\subscription_Schema\Data\data.csv -S SHISHIRS -d shishir -U sa -P sysadmin  -b 1000 -q -c -t"|"

--Inserting data into subscriptionStatus Table (DataType columns)
INSERT INTO subscriptionStatus

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

select round(rand(checksum(newid()))*(10)+20,2)