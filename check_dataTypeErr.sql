ALTER  PROCEDURE [dbo].[usp_getDataTypeErrors]  
(  
 @schemaName NVARCHAR(255)  
 ,@dtTable NVARCHAR(255)  
 ,@ffTable NVARCHAR(255)  
)  
AS  
BEGIN  
  
DECLARE @q nvarchar(max);   
DECLARE @ctr int;    
  
BEGIN TRY  
  
 BEGIN TRAN  
  
  DECLARE @schemaId INT  
  
  DECLARE @temp AS TABLE  
  (  
   colname   NVARCHAR(255)  
   ,datatype  NVARCHAR(255)  
   ,datatypeLength INT  
   ,rownum   INT  
  );   
  
  SET @schemaId = SCHEMA_ID ( @schemaName )    
  
  INSERT INTO @temp   
  SELECT    
   c.name AS colname,   
   CAST(u.name AS NVARCHAR(MAX))+       
   CASE        
    WHEN u.name like 'NVARCHAR'       THEN  CASE WHEN c.max_length = -1 THEN '('+CAST(c.max_length AS NVARCHAR(MAX))+')' 
											 ELSE '('+CAST(c.max_length/2 AS NVARCHAR(MAX))+')'
											 END       
    WHEN u.name like 'VARCHAR'       THEN '('+CAST(c.max_length AS NVARCHAR(MAX))+')'       
    WHEN u.name like 'DECIMAL' OR u.name LIKE 'NUMERIC' THEN '('+ CAST(c.[precision] AS NVARCHAR(MAX))+',' + CAST(c.scale AS NVARCHAR(MAX)) +')'        else ''      
   END AS datatype,  
   CASE  
    WHEN u.name LIKE 'NVARCHAR' THEN CASE WHEN c.max_length = -1 THEN c.max_length ELSE c.max_length/2  END
    WHEN u.name LIKE 'VARCHAR' THEN c.max_length  
    WHEN u.name LIKE 'DECIMAL' OR u.name LIKE 'NUMERIC' THEN (c.[precision] + 1)  
   END AS datatypeLength,   
   ROW_NUMBER() OVER (ORDER BY c.name ASC) rowNum   
  FROM sys.columns c   
  INNER JOIN sys.tables t   
   ON  c.OBJECT_ID=t.OBJECT_ID   
    AND t.name=@dtTable   
    AND c.name NOT IN ('GoodToImport', 'ErrorDescription')   
    AND t.schema_id = @schemaId  
  INNER JOIN sys.types u   
   ON c.user_type_id=u.user_type_id   
  ORDER BY c.name ASC;   
  
  DELETE FROM @temp WHERE datatype = 'nvarchar(-1)'

  --SELECT * FROM @temp  
  SELECT @ctr= MAX(rowNum) FROM @temp;    
  
  WHILE (@ctr>0)   
   BEGIN    
    SELECT @q=    
     'UPDATE ['+ @schemaName+ '].[' + @ffTable +'] '+   'SET GoodToImport = 0, '+   'ErrorDescription = CONCAT(ErrorDescription,''| Error Column Name is ['+colname +        '] '' + ''and value is : (''+ CAST(['+colname+'] as nvarchar(max))+'')'') '+  'WHERE [' + colName + '] IS NOT NULL AND TRY_CAST(['+colname+'] as '+dataType+') IS NULL; '  FROM @temp WHERE rownum=@ctr;   
  
   SELECT @q= @q+   
     'UPDATE ['+ @schemaName+ '].[' + @ffTable +'] '+   'SET GoodToImport = 0, '+   'ErrorDescription = CONCAT(ErrorDescription,''|Truncation Error Column Name is ['+colname +        '] '' + ''and value is : (''+ CAST(['+colname+'] as nvarchar(max))+'')'') '+  'WHERE CAST(LEN([' + colName + ']) AS NVARCHAR(MAX)) > ' + CAST( dataTypeLength AS NVARCHAR(MAX)) + ' ;' FROM @temp WHERE rownum=@ctr AND datatypeLength IS NOT NULL;   
	 PRINT @q;
    EXEC(@q);  
  
    SET @ctr=@ctr-1;  
   END   
  
 COMMIT TRAN  
  
 END TRY  
  
 BEGIN CATCH  
  
  IF @@TRANCOUNT > 0  
  ROLLBACK TRAN;  
      
  INSERT INTO [LogError]   
  (  
   objectName  
   ,ErrorCode  
   ,ErrorDescription  
   ,ErrorGenerationTime     
  )  
  SELECT   
    OBJECT_NAME(@@PROCID)  
   ,ERROR_NUMBER() AS ErrorCode  
   ,'Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))  
    +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))  
    +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))  
    +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription  
   ,GETDATE()  
  
 END CATCH  
END