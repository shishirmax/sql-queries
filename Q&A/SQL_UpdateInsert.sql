CREATE TABLE DataSource
(
	EmpID INT
	,EmpName VARCHAR(100)
	,EmpSalary INT
	,EmpJoiningDate DATETIME
	,EmpLocation VARCHAR(100)
	,EmpContactNumber BIGINT
	,EmpBatch INT
)

CREATE TABLE DataDestination
(
	EmpID INT
	,EmpName VARCHAR(100)
	,EmpSalary INT
	,EmpJoiningDate DATETIME
	,EmpLocation VARCHAR(100)
	,EmpContactNumber BIGINT
	,EmpBatch INT
	,ImportDate DATETIME
	,UpdateDate DATETIME
)

INSERT INTO DataSource
VALUES
(102,'Raju Rastogi',18800,'02-23-2016','Noida',8574968578,3)

SELECT * FROM DataSource
SELECT * FROM DataDestination

ALTER TABLE DataDestination
ADD UpdateColumn INT

UPDATE DataDestination
SET UpdateColumn = 1001

EXEC sp_UpdateInsert

CREATE PROCEDURE sp_UpdateInsert
AS
BEGIN
	UPDATE D
		SET 
			D.EmpID		= S.EmpID
			,D.EmpName	= S.EmpName
			,D.EmpSalary	= S.EmpSalary
			,D.EmpJoiningDate	= S.EmpJoiningDate
			,D.EmpLocation		= S.EmpLocation
			,D.EmpContactNumber	= S.EmpContactNumber
			,D.EmpBatch			= S.EmpBatch
			,D.UpdateDate		= GETDATE() 
	FROM DataDestination D
	JOIN DataSource S
	ON	D.EmpID				= S.EmpID
	AND	D.EmpName			= S.EmpName
	AND	D.EmpSalary			= S.EmpSalary
	AND	D.EmpJoiningDate	= S.EmpJoiningDate
	AND	D.EmpLocation		= S.EmpLocation
	AND	D.EmpContactNumber	= S.EmpContactNumber
	AND	D.EmpBatch			= S.EmpBatch 
	
	INSERT INTO DataDestination
	(
		EmpID
		,EmpName
		,EmpSalary
		,EmpJoiningDate
		,EmpLocation
		,EmpContactNumber
		,EmpBatch
		,ImportDate	
	)
	SELECT 
		 S.EmpID
		,S.EmpName
		,S.EmpSalary
		,S.EmpJoiningDate
		,S.EmpLocation
		,S.EmpContactNumber
		,S.EmpBatch
		,GETDATE()
	FROM DataSource S
	LEFT JOIN DataDestination D
	ON 
			S.EmpID				= D.EmpID
		AND S.EmpName			= D.EmpName
		AND S.EmpSalary			= D.EmpSalary
		AND S.EmpJoiningDate	= D.EmpJoiningDate
		AND S.EmpLocation		= D.EmpLocation
		AND S.EmpContactNumber	= D.EmpContactNumber
		AND S.EmpBatch			= D.EmpBatch 
	WHERE 
		D.EmpID IS NULL
		AND D.EmpName IS NULL
		AND D.EmpSalary IS NULL
		AND D.EmpJoiningDate IS NULL
		AND D.EmpLocation IS NULL
		AND D.EmpContactNumber IS NULL
		AND D.EmpBatch IS NULL
END



SELECT ((8888-888)/8)