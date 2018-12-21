select round(-1493,0)
select round(-1493,1)
select round(-1493,2)
select round(-1493,3)
select round(-1493,-1)
select round(-1493,-2)
select round(-1493,-3)
select round(-1493,-4)
select round(-1493,-5)


SELECT CAST('95.9565' AS DECIMAL(18,2))

SELECT FLOOR(7.6)
SELECT CEILING(7.6)


SELECT DATEPART(wk,DATEADD(wk,t2.number,'2011')) as Weeknumb
FROM master..spt_values t2
WHERE t2.type = 'P'
AND t2.number <= 255
AND YEAR(DATEADD(wk,t2.number,'2011'))=2011

SELECT * FROM master..spt_values



SET DATEFIRST 1

declare @mydate date = '2014-01-01'
DECLARE @myYear INT = DATEPART(YEAR, @myDate)
DECLARE @myMonth INT = DATEPART(MONTH, @myDate)

CREATE TABLE #tmpdates (SNo INT IDENTITY, WeekStart DATE, WeekEnd DATE)

IF datepart(dw,@mydate) <> 7 BEGIN 
	SET @mydate = dateadd(d,-datepart(dw,@mydate),@mydate)
END
INSERT INTO #TMPDATES VALUES (@MYDATE, DATEADD(D,6,@MYDATE))
SET @MYDATE = DATEADD(D,7,@MYDATE)

WHILE YEAR(@MYDATE) = @myYear AND MONTH(@myDate) = @myMonth BEGIN
	INSERT INTO #TMPDATES VALUES (@MYDATE, DATEADD(D,6,@MYDATE))
	SET @MYDATE = DATEADD(D,7,@MYDATE)
END

select * FROM #TMPDATES

DROP TABLE #TMPDATES


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

CREATE TABLE joins_A
(
	ID_A INT
)

CREATE TABLE joins_B
(
	ID_B INT
)

INSERT INTO joins_B
VALUES
(1)

SELECT * FROM joins_A
SELECT * FROM joins_B

SELECT A.ID_A,B.ID_B
FROM joins_A A
INNER JOIN 
joins_B B
ON A.ID_A = B.ID_B

CREATE TABLE ctr
(
	column1 INT
)

INSERT INTO ctr
VALUES
(1),(2),(3),(4)

SELECT * FROM ctr