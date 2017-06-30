--The below statement should be written on top of the sql script while creating SP
--This will check the existing SP in the database and drop the existing SP
--Will create the new SP with same name, where you dont need to use the ALTER PROC command for the same SP

IF Exists (select * from sysobjects where type = 'P' and name = 'name_of_sp_you_are_creating')
  BEGIN
    PRINT 'Dropping Procedure.....'
    DROP Procedure name_of_sp_you_are_creating
  END
GO

PRINT 'Creating procedure name_of_sp_you_are_creating'
GO

--Rest of your create SP queries will go down here.
