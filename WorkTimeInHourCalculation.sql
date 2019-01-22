--https://stackoverflow.com/questions/54301333/how-to-accummulate-two-datetime-in-two-tables-as-view-in-sql-server-2014#54301333
SELECT DATEDIFF(hour, '2018-11-10 08:00:00','2018-11-10 12:00:00')

CREATE TABLE CheckIN
(
	InID VARCHAR(100)
	,UserID INT
	,CheckInTime DATETIME
)

INSERT INTO CheckIN
VALUES
('IN-001',1,'2018-11-10 08:00:00')
,('IN-002',2,'2018-11-15 07:00:00')

CREATE TABLE CheckOut
(
	OutID VARCHAR(100)
	,UserID INT
	,CheckOutTime DATETIME
)

INSERT INTO CheckOut
VALUES
('OUT-001',1,'2018-11-10 12:00:00')
,('OUT-002',2,'2018-11-15 14:00:00')


SELECT * FROM CheckIN
SELECT * FROM CheckOut

SELECT A.UserID,A.InID,B.OutID,DATEDIFF(HOUR,A.CheckInTime,B.CheckOutTime) AS WorkTimeInHour
FROM CheckIN A
JOIN CheckOut B
ON A.UserID = B.UserID