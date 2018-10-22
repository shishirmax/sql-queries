declare @num_min int; 
    set @num_min = 35; 

select dateadd(minute, @num_min, getdate()) as time_added, 
       getdate() as curr_date  




declare @StartTime datetime = '2011-07-20 11:00:33',
    @EndTime datetime = '2011-07-20 15:37:34',
    @Interval int = 20 -- this can be changed.

;WITH cSequence AS
(
    SELECT
       @StartTime AS StartRange, 
       DATEADD(MINUTE, @Interval, @StartTime) AS EndRange
    UNION ALL
    SELECT
      EndRange, 
      DATEADD(MINUTE, @Interval, EndRange)
    FROM cSequence 
    WHERE DATEADD(MINUTE, @Interval, EndRange) < @EndTime
)
 /* insert into tmp_IRange */
SELECT * FROM cSequence OPTION (MAXRECURSION 0);

CREATE TABLE FuelUsage(
ID INT IDENTITY(1,1)
,Fuel_Ltrs INT
,DateTrack DATETIME
)

SELECT * FROM FuelUsage