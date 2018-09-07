# SQL Backup and Restore Script

## SQL Script to take Backup of a database:

```SQL
USE [master]
GO
 
BACKUP DATABASE [AdventureWorks2014]
    TO  DISK = N'D:\SQL\AdventureWorks2014.bak' WITH NOFORMAT, 
    NOINIT,  
    NAME = N'AdventureWorks2014-Full Database Backup', 
    SKIP, 
    NOREWIND, 
    NOUNLOAD,  
    STATS = 10
GO
```

## SQL Script to Restore a Backup file:

```SQL
USE [master]
GO
 
RESTORE DATABASE [TestManDB2] FROM  DISK = N'D:\SQL\TestManDB.bak' WITH FILE = 1,  
    MOVE N'TestManDB' TO N'D:\MSSQL\DATA\TestManDB2.mdf',  
    MOVE N'TestManDB_log' TO N'D:\MSSQL\DATA\TestManDB2_log.ldf',  
    NOUNLOAD,  
    STATS = 5
GO
```