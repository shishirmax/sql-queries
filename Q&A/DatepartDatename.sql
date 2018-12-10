--Determine SQL Server Date and Time with DATEPART and DATENAME Functions
--https://www.mssqltips.com/sqlservertip/2507/determine-sql-server-date-and-time-with-datepart-and-datename-functions/
DECLARE @Date DATETIME
SET @Date = GETDATE()
SELECT @Date
SELECT DATEPART(DW,@Date) AS WeekDay --Weekday
SELECT DATEPART(WEEK,@Date) AS Week --Week
SELECT DATEPART(YYYY,@Date) As Year --Year
SELECT DATENAME(WEEKDAY,@Date) As WeekdayName
SELECT DATENAME(MM,@Date) AS MonthName --MonthName
SELECT DATEPART(MM,@Date) As Month --MonthNumeric
SELECT DATEPART(DAYOFYEAR,@Date) As DayOfYear --DayOfYear
SELECT DATEPART(DAY,@Date) As Day --Day