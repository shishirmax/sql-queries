--Creating NonClustered Index

-- Find an existing index named IX_tblHomeSpotter_DT and delete it if found.   
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_tblHomeSpotter_DT')   
    DROP INDEX IX_tblHomeSpotter_DT ON homeSpotter.tblHomeSpotter_DT;   
GO  
-- Create a nonclustered index called IX_tblHomeSpotter_DT   
-- on the Purchasing.ProductVendor table using the BusinessEntityID column.   
CREATE NONCLUSTERED INDEX IX_tblHomeSpotter_DT   
    ON homeSpotter.tblHomeSpotter_DT (LogTaskID);   
GO