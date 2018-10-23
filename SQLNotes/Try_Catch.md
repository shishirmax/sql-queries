# TRY CATCH – Exception Handling in SQL Server

Similar to C++, Java and other languages SQL Server also has a mechanism to handle exceptions by using TRY-CATCH construct. The TRY block contains the SQL statements that may raise an error and CATCH block contains the handling mechanism to process the error. When any error is raised in the TRY block the control is immediately transferred to the CATCH block, where the Error is handled.

**Following rules should be taken care off while using TRY-CATCH constructs:**

- A TRY block must be followed immediately by the CATCH block.
- Both TRY & CATCH blocks must be inside a Batch, Stored Procedure or a Trigger.
- Only Errors with severity between 10 & 20 that do not close the database connection are caught & handled by TRY-CATCH constructs.
- As per MS BOL, Errors that have a severity of 20 or higher that cause the Database Engine to close the connection will not be handled by the TRY…CATCH block. And Errors that have a severity of 10 or lower are considered warnings or informational messages, and are not handled by TRY…CATCH blocks.

**let’s check how to use TRY-CATCH block:**

```SQL
USE [tempdb]
GO

--// Create a test Stored Procedure
CREATE PROC testPrc (@val VARCHAR(10))
AS
BEGIN
 SELECT 1/@val AS operation
END
GO

--// Test for Divide by 0 (Divide by zero error encountered.)
BEGIN TRY
 EXEC testPrc '0'
END TRY
BEGIN CATCH
 SELECT
 ERROR_NUMBER() AS ERROR_ID,
 ERROR_MESSAGE() AS ERROR_MSG,
 ERROR_SEVERITY() AS ERROR_SEVERITY,
 ERROR_STATE() AS ERROR_STATE,
 ERROR_PROCEDURE() AS ERROR_PROCEDURE,
 ERROR_LINE() AS ERROR_LINE
END CATCH
GO

--// Test for Datatype conversion (Conversion failed when converting the varchar value 'a' to data type int.)
BEGIN TRY
 EXEC testPrc 'a'
END TRY
BEGIN CATCH
 SELECT
 ERROR_NUMBER() AS ERROR_ID,
 ERROR_MESSAGE() AS ERROR_MSG,
 ERROR_SEVERITY() AS ERROR_SEVERITY,
 ERROR_STATE() AS ERROR_STATE,
 ERROR_PROCEDURE() AS ERROR_PROCEDURE,
 ERROR_LINE() AS ERROR_LINE
END CATCH
GO

--// Test nested TRY-CATCH for &quot;Divide by 0&quot; &amp; &quot;Datatype conversion&quot; errors both.
BEGIN TRY
 EXEC testPrc 'a'
END TRY
BEGIN CATCH
 SELECT 'outer block',
 ERROR_NUMBER() AS ERROR_ID,
 ERROR_MESSAGE() AS ERROR_MSG,
 ERROR_SEVERITY() AS ERROR_SEVERITY,
 ERROR_STATE() AS ERROR_STATE,
 ERROR_PROCEDURE() AS ERROR_PROCEDURE,
 ERROR_LINE() AS ERROR_LINE

 BEGIN TRY
 SELECT 1/0 AS operation
 END TRY
 BEGIN CATCH
 SELECT 'inner block',
 ERROR_NUMBER() AS ERROR_ID,
 ERROR_MESSAGE() AS ERROR_MSG,
 ERROR_SEVERITY() AS ERROR_SEVERITY,
 ERROR_STATE() AS ERROR_STATE,
 ERROR_PROCEDURE() AS ERROR_PROCEDURE,
 ERROR_LINE() AS ERROR_LINE
 END CATCH

END CATCH
GO

--// Test for violation of PK Constraint (Violation of PRIMARY KEY constraint 'PK__testTable__2C3393D0'. Cannot insert duplicate key in object 'dbo.testTable'.)
BEGIN TRY
 CREATE TABLE testTable (a INT PRIMARY KEY)

 INSERT INTO testTable VALUES(1)
 INSERT INTO testTable VALUES(1)
END TRY
BEGIN CATCH
 SELECT
 ERROR_NUMBER() AS ERROR_ID,
 ERROR_MESSAGE() AS ERROR_MSG,
 ERROR_SEVERITY() AS ERROR_SEVERITY,
 ERROR_STATE() AS ERROR_STATE,
 ERROR_PROCEDURE() AS ERROR_PROCEDURE,
 ERROR_LINE() AS ERROR_LINE
END CATCH
GO

SELECT * FROM testTable -- Contains single record with value 1

--// Test for recreating a table that already exists (There is already an object named 'testTable' in the databASe.)
BEGIN TRY
 CREATE TABLE testTable (a INT PRIMARY KEY)
END TRY
BEGIN CATCH
 SELECT
 ERROR_NUMBER() AS ERROR_ID,
 ERROR_MESSAGE() AS ERROR_MSG,
 ERROR_SEVERITY() AS ERROR_SEVERITY,
 ERROR_STATE() AS ERROR_STATE,
 ERROR_PROCEDURE() AS ERROR_PROCEDURE,
 ERROR_LINE() AS ERROR_LINE
END CATCH
GO

--// Test for inserting NULL value on Primary Key column (Cannot insert the value NULL into column 'a', table 'tempdb.dbo.testTable'; column does not allow nulls. INSERT fails.)
BEGIN TRY
 INSERT INTO testTable VALUES(NULL)
END TRY
BEGIN CATCH
 SELECT
 ERROR_NUMBER() AS ERROR_ID,
 ERROR_MESSAGE() AS ERROR_MSG,
 ERROR_SEVERITY() AS ERROR_SEVERITY,
 ERROR_STATE() AS ERROR_STATE,
 ERROR_PROCEDURE() AS ERROR_PROCEDURE,
 ERROR_LINE() AS ERROR_LINE
END CATCH
GO

--// Final Cleanup
DROP TABLE     testTable
DROP PROC testPrc
GO
```