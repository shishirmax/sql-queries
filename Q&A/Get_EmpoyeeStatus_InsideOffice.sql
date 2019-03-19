CREATE TABLE EmployeeEntry
(
	EmpId			INT
	,EntryTimeStamp DATETIME
	,EntryStatus	VARCHAR(10)
)

SELECT * FROM EmployeeEntry

SELECT GETDATE()

INSERT INTO EmployeeEntry
VALUES
(3,'2019-03-19 10:00:00.000','IN')

SELECT * FROM EmployeeEntry

WITH tCTE AS
(
SELECT EmpId,EntryStatus,EntryTimeStamp,RANK() OVER(PARTITION BY EmpId ORDER BY EntryTimeStamp DESC) AS RN
FROM EmployeeEntry
)

SELECT * FROM tCTE
WHERE RN = 1 AND EntryStatus = 'IN'