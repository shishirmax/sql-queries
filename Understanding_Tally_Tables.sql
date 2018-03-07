----=============================================================================
----      Setup
----=============================================================================
--    USE TempDB     --DB that everyone has where we can cause no harm
--    SET NOCOUNT ON --Supress the auto-display of rowcounts for appearance/speed

--DECLARE @StartTime DATETIME    --Timer to measure total duration
--    SET @StartTime = GETDATE() --Start the timer

----=============================================================================
----      Create and populate a Tally table
----=============================================================================
----===== Conditionally drop and create the table/Primary Key
--     IF OBJECT_ID('dbo.Tally') IS NOT NULL 
--        DROP TABLE dbo.Tally

-- CREATE TABLE dbo.Tally 
--        (N INT, 
--         CONSTRAINT PK_Tally_N PRIMARY KEY CLUSTERED (N))

----===== Create and preset a loop counter
--DECLARE @Counter INT
--    SET @Counter = 1

----===== Populate the table using the loop and couner
--  WHILE @Counter <= 11000
--  BEGIN
--         INSERT INTO dbo.Tally
--                (N)
--         VALUES (@Counter)

--            SET @Counter = @Counter + 1
--    END

----===== Display the total duration
-- SELECT STR(DATEDIFF(ms,@StartTime,GETDATE())) + ' Milliseconds duration'

 --###################################################################################################

-- --=============================================================================
----      Setup
----=============================================================================
--    USE TempDB     --DB that everyone has where we can cause no harm
--    SET NOCOUNT ON --Supress the auto-display of rowcounts for appearance/speed

--DECLARE @StartTime DATETIME    --Timer to measure total duration
--    SET @StartTime = GETDATE() --Start the timer

----=============================================================================
----      Create and populate a Tally table
----=============================================================================
----===== Conditionally drop 
--     IF OBJECT_ID('dbo.Tally') IS NOT NULL 
--        DROP TABLE dbo.Tally

----===== Create and populate the Tally table on the fly
-- SELECT TOP 11000 --equates to more than 30 years of dates
--        IDENTITY(INT,1,1) AS N
--   INTO dbo.Tally
--   FROM Master.dbo.SysColumns sc1,
--        Master.dbo.SysColumns sc2

----===== Add a Primary Key to maximize performance
--  ALTER TABLE dbo.Tally
--    ADD CONSTRAINT PK_Tally_N 
--        PRIMARY KEY CLUSTERED (N) WITH FILLFACTOR = 100

----===== Let the public use it
--  GRANT SELECT, REFERENCES ON dbo.Tally TO PUBLIC

----===== Display the total duration
-- SELECT STR(DATEDIFF(ms,@StartTime,GETDATE())) + ' Milliseconds duration'

 --###################################################################################################

 --===============================================
--      Display the count from 1 to 10
--      using a loop.
--===============================================
--===== Declare a counter
DECLARE @N INT
    SET @N = 1

--===== While the counter is less than 10...
  WHILE @N <= 10
  BEGIN
        --==== Display the count
        SELECT @N

        --==== Increment the counter
           SET @N = @N + 1
    END