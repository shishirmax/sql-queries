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