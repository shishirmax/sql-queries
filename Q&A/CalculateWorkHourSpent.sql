/*
Calculate Work Hours

Given two column with StartDateTime and EndDateTime of a particular work.
Need to calculate the total hours spent over the work.
Note: 1 Day working hours to be taken as 9Hours only. i.e WorkTimeStart = 08:00 AM and WorkTimeEnd = 17:00 PM 
*/

CREATE TABLE WorkHour
(
	ID INT IDENTITY(1,1)
	,WorkStartDateTime DATETIME
	,WorkEndDateTime DATETIME
	,WorkHourSpent VARCHAR(100)
)

--SELECT CAST(DATEPART(HOUR, GETDATE())AS VARCHAR)
SELECT * FROM WorkHour

INSERT INTO WorkHour
VALUES
('2011-07-20 09:00:00.000','2011-07-22 12:30:00.000','')

SELECT DATEPART(HOUR,'2011-07-20 15:00:00.000')

SELECT WorkStartDateTime,WorkEndDateTime,DATEPART(HOUR,WorkEndDateTime) - DATEPART(HOUR,WorkStartDateTime) As HourSpent FROM WorkHour

SELECT DATEPART(MONTH,'2018-01-02 02:30:45')
SELECT DATEPART(DAY,'2018-01-02 02:30:45')



DECLARE @WorkStart TIME
SET @WorkStart = '08:00'
PRINT @WorkStart

DECLARE @WorkFinish TIME
SET @WorkFinish = '17:00'
PRINT @WorkFinish

DECLARE @DailyWorkTime BIGINT
SET @DailyWorkTime = DATEDIFF(HOUR, @WorkStart, @WorkFinish)
PRINT @DailyWorkTime

SELECT WorkStartDateTime,WorkEndDateTime,DATEPART(HOUR,DATEADD(HOUR,DATEDIFF(HOUR,CAST(WorkStartDateTime AS TIME),@WorkFinish),DATEDIFF(HOUR,CAST(WorkEndDateTime AS TIME),@WorkFinish))) AS HourSpent FROM WorkHour

SELECT WorkStartDateTime,WorkEndDateTime,DATEPART(HOUR,WorkEndDateTime) - DATEPART(HOUR,WorkStartDateTime) As HourSpent FROM WorkHour


--SOLUTION
select *,
DATEDIFF(d,WorkStartDateTime,WorkEndDateTime)*9.0+
(DATEDIFF(MI,WorkStartDateTime,WorkEndDateTime)%(24*60))/60.00,
DATEDIFF(d,0,WorkEndDateTime-WorkStartDateTime)*9.0+
(DATEDIFF(MINUTE,0,WorkEndDateTime-WorkStartDateTime)%(24*60))/60.00
 from WorkHour


 UPDATE WorkHour
 SET WorkHourSpent = DATEDIFF(d,0,WorkEndDateTime-WorkStartDateTime)*9.0+
(DATEDIFF(MINUTE,0,WorkEndDateTime-WorkStartDateTime)%(24*60))/60.00

