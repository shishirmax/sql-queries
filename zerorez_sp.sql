USE [Edina]
GO
/****** Object:  StoredProcedure [ZeroRez].[Usp_CleanBusinessRule]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ZeroRez].[Usp_CleanBusinessRule]  
AS  
BEGIN  
 BEGIN TRY  
  BEGIN TRAN  
     
   UPDATE FF SET PhoneNumber= dbo.[FN_REMOVE_SPECIAL_CHARACTER] (FF.PhoneNumber)   
   FROM ZeroRez.tblPhone_FF FF   
   UPDATE ZeroRez.tblPhone_FF set GoodToImport=0,ErrorDescription=ISNULL(ErrorDescription, '|') + '|' + 'PhoneNumber Contains Alphabets or special character' WHERE TRY_CAST(PhoneNumber AS BIGINT) IS NULL  
     
   UPDATE zeroRez.tblPhone_FF SET GoodToImport=0 ,ErrorDescription=ISNULL(ErrorDescription, '|') + '|' + 'PhoneNumber Cannot be null or blank'Where PhoneNumber IS NULL or PhoneNumber=''  
  
   UPDATE FF1 SET   
   Phonenumber =  STUFF(Phonenumber, 1, 1, '')  
   FROM zeroRez.tblPhone_FF FF1  
   WHERE  LEFT(Phonenumber,1) = '1' AND LEN(Phonenumber) = 11  
  
   SELECT ZeroRezId,PhoneNumber INTO #Temp  
   FROM zeroRez.tblPhone_FF WHERE zeroRezId IN(  
   SELECT ZeroRezId FROM ZeroRez.tblPhone_FF FF WHERE  ZeroRezId IN   
   (SELECT DISTINCT ZeroRezId FROM zeroRez.tblPhone_FF  
    WHERE LEN(PhoneNumber) BETWEEN 1 AND 4)  
    GROUP BY ZeroRezId HAVING COUNT(1)>1)  
  
   UPDATE FF1 SET Phonenumber=NewPhoneNumber  
   FROM zeroRez.tblPhone_FF FF1  
   INNER JOIN   
    (SELECT SUBSTRING(FF.phonenumber,1, (10 - LEN(T.phonenumber)))+T.PhoneNumber AS NewPhoneNumber,FF.ZeroRezID,T.PhoneNumber   
    FROM zeroRez.tblPhone_FF ff JOIN #Temp t  
    ON T.ZeroRezID=FF.ZeroRezID   
    AND T.phonenumber<>FF.PhoneNumber   
    AND LEN(T.Phonenumber)<>10 AND LEN(FF.PhoneNumber)=10  
   ) X ON X.ZeroRezID=FF1.ZeroRezID and X.PhoneNumber=FF1.PhoneNumber  
   DROP TABLE #temp  
  
  
   UPDATE  ZeroRez.tblPhone_FF set GoodToImport=0, ErrorDescription=ISNULL(ErrorDescription, '|') + '|' +'Phone Number does not contains 10 digits' WHERE LEN(PhoneNumber)<>10  
  
   UPDATE ZeroRez.tblEmail_FF  
     SET GoodToImport  = 0  
      ,ErrorDescription = ISNULL(ErrorDescription, '|') + '|' + 'Invalid email provided'  
     WHERE ISNULL(email, '') <> ''   
       AND   
       (  
        CHARINDEX(' ', email)  <> 0 OR  
        CHARINDEX('/', email)  <> 0 OR  
        CHARINDEX(':', email)  <> 0 OR  
        CHARINDEX(';', email)  <> 0 OR  
        (LEN(email)-1 <= CHARINDEX('.', email)) OR  
        (email like '%@%@%')OR   
        (email Not Like '_%@_%.__%')  
       )  
   UPDATE  [ZeroRez].[tblAddress_FF] SET GoodToImport=0,ErrorDescription=ISNULL(ErrorDescription, '|') + '|' + 'Invalid Postal Code'  
   WHERE Postal_code NOT LIKE '[0-9][0-9][0-9][0-9][0-9]'  

   UPDATE [ZeroRez].[tblZeroRez_FF] SET Lifetime_Total=REPLACE(Lifetime_Total,'"','')
     
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
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadAddressDimension]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ZeroRez].[usp_LoadAddressDimension]        
AS        
BEGIN        
	BEGIN TRY        
		UPDATE [ZeroRez].[DimAddress] 
		SET ApartmentNumber=CONCAT(CASE
		WHEN ApartmentNumber LIKE '%(UNIT%' 
		THEN dbo.udf_GetNumeric(SUBSTRING(ApartmentNumber,CHARINDEX('(',ApartmentNumber),len(ApartmentNumber)+ 1))
		ELSE dbo.udf_GetNumeric(ApartmentNumber)
		END,
		CASE

		WHEN RIGHT(ApartmentNumber,1) LIKE '[0-9.&( )_-]%' AND ISNUMERIC(SUBSTRING(ApartmentNumber, LEN(ApartmentNumber)-1,1)) = 1 THEN '' 
		WHEN ApartmentNumber LIKE '%(UNIT%' AND ISNUMERIC(SUBSTRING(ApartmentNumber, LEN(ApartmentNumber)-1,1)) = 0 
		AND ISNUMERIC(dbo.udf_GetNumeric(ApartmentNumber)) = 0
		THEN SUBSTRING(ApartmentNumber, LEN(ApartmentNumber)-1,1)

		WHEN ApartmentNumber LIKE 'UNIT%(%' AND ISNUMERIC(SUBSTRING(ApartmentNumber,CHARINDEX('(',ApartmentNumber),LEN(ApartmentNumber))) = 0 
		AND ISNUMERIC(dbo.udf_GetNumeric(ApartmentNumber)) = 0
		THEN RIGHT(LTRIM(RTRIM(SUBSTRING(ApartmentNumber,1,CHARINDEX('(',ApartmentNumber) - 1 ))),1)
	
		WHEN ApartmentNumber LIKE 'UNIT%' AND ApartmentNumber NOT LIKE '[0-9.&( )_-]%' AND dbo.udf_GetNumeric(ApartmentNumber) = 0 THEN RIGHT(REPLACE(ApartmentNumber,'.',''),1)

		WHEN dbo.udf_GetNumeric(ApartmentNumber) = '' THEN SUBSTRING(ApartmentNumber,CHARINDEX('UNIT',ApartmentNumber),LEN(ApartmentNumber))

		WHEN ApartmentNumber NOT LIKE '[0-9.&( )_-]%' AND ISNUMERIC(dbo.udf_GetNumeric(ApartmentNumber)) = 1 
		AND SUBSTRING(ApartmentNumber, LEN(ApartmentNumber),1) NOT LIKE '[0-9.&( )_-]%'
		AND LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(ApartmentNumber,CHARINDEX(dbo.udf_GetNumeric(ApartmentNumber),ApartmentNumber),LEN(ApartmentNumber)),
				'1',''),'2',''),'3',''),'4',''),'5',''),'6',''),'7',''),'8',''),'9',''),'0','')) = 1
		THEN RIGHT(ApartmentNumber,1) 
 
		END)

	


	COMMIT TRAN        
 RETURN 1        
 END TRY        
 BEGIN CATCH        
  IF @@TRANCOUNT>0        
   ROLLBACK        
        
  INSERT INTO LogError (                  
     objectName                  
     ,ErrorCode                 
     ,ErrorDescription                  
     ,ErrorGenerationTime                     
    )                  
                  
  SELECT -- autogenerated                    
    OBJECT_NAME(@@PROCID)                    
   ,ERROR_NUMBER() AS ErrorCode                    
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))                    
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))                    
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))                    
+' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription                    
   ,GETDATE()                                      
  RETURN -1          
 END CATCH        
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadAddressDimension_old]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ZeroRez].[usp_LoadAddressDimension_old]        
AS        
BEGIN        
 BEGIN TRY        
   IF OBJECT_ID('tempdb.. #DedupCase1') IS NOT NULL    
	DROP TABLE #DedupCase1    
    
   IF OBJECT_ID('tempdb.. #TempDedupCase1') IS NOT NULL    
    DROP TABLE #TempDedupCase1          
        
	-- SELECT 
	--	 REPLACE(LTRIM(RTRIM(ISNULL(ES.first_name,''))),'  ',' ') first_name
	--	,REPLACE(LTRIM(RTRIM(ISNULL(ES.last_name,''))),'  ',' ') last_name
	--	,REPLACE(T.formatted_address,'"', '') formatted_address
	
	--	,job_count
	--	,last_service_date
	--	,lifetime_total
	--	,MAX(ES.IZeroRezId) DedupZeroRezId
	--INTO #DedupCase1
	--FROM ZeroRez.ZeroRez_bcp (NOLOCK) ES
	--INNER JOIN zerorez.[tblZerorezStandardAddressApi] T
	--ON  REPLACE(
	--  REPLACE(
	--   CONCAT(
	--	COALESCE(ES.Street1,''),
	--	 COALESCE(ES.Street2,''),
	--	  COALESCE(ES.City,''),
	--	   COALESCE(ES.State,''),
	--		COALESCE(ES.postal_code,'')
	--		 ),' ',''),',','') = REPLACE(
	--				REPLACE(T.[OriginalAddress],' ',''),',','')
	--	GROUP BY 	
	--	 REPLACE(LTRIM(RTRIM(ISNULL(first_name,''))),'  ',' ')
	--	,REPLACE(LTRIM(RTRIM(ISNULL(last_name,''))),'  ',' ')
	--	,REPLACE(T.formatted_address,'"', '')
	--	,job_count
	--	,last_service_date
	--	,lifetime_total

	--SELECT 
	--d.first_name
	--,d.last_name
	--,d.formatted_address
	--,d.job_count
	--,d.last_service_date
	--,d.lifetime_total
	--,b.IZeroRezId
	--,d.DedupZeroRezId
	--INTO #TempDedupCase1
	--FROM ZeroRez.ZeroRez_bcp (NOLOCK) B
	--INNER JOIN zerorez.[tblZerorezStandardAddressApi] T
	--ON  REPLACE(
 -- REPLACE(
 --  CONCAT(
 --   COALESCE(B.Street1,''),
 --    COALESCE(B.Street2,''),
 --     COALESCE(B.City,''),
 --      COALESCE(B.State,''),
 --       COALESCE(B.postal_code,'')
 --        ),' ',''),',','') = REPLACE(
 --               REPLACE(T.[OriginalAddress],' ',''),',','')
	--INNER JOIN #DedupCase1 d
	--ON		REPLACE(LTRIM(RTRIM(ISNULL(b.first_name,''))),'  ',' ')	 = d.first_name
	--	AND REPLACE(LTRIM(RTRIM(ISNULL(b.last_name,''))),'  ',' ')	 = d.last_name
	--	AND REPLACE(T.formatted_address,'"', '')					 = d.formatted_address
	--	AND b.job_count												 = d.job_count
	--	AND b.last_service_date										 = d.last_service_date
	--	AND b.lifetime_total										 = d.lifetime_total
            
   --INSERT INTO ZeroRez.DimDedupZeroRez (ZeroRezId,DedupZeroRezId,CreatedBy,CreatedDate)      
   --SELECT DISTINCT S.ZeroRezId,S.ZeroRezId,-1,GETDATE()      
   --FROM ZeroRez.tblZeroRez_DT S      
   --LEFT JOIN ZeroRez.DimDedupZeroRez T       
   --ON S.ZeroRezId=T.ZeroRezId      
   --WHERE T.IDedupZeroRezId IS NULL      
           
      	SELECT 
	 REPLACE(LTRIM(RTRIM(ISNULL(b.first_name,''))),'  ',' ') first_name
	,REPLACE(LTRIM(RTRIM(ISNULL(b.last_name,''))),'  ',' ') last_name
	,REPLACE(T.formatted_address,'"', '') formatted_address
	,b.job_count
	,b.last_service_date
	,b.lifetime_total
	,b.IZeroRezId
	INTO #Temp
	FROM ZeroRez.ZeroRez_bcp (NOLOCK) B
	INNER JOIN zerorez.[tblZerorezStandardAddressApi] T
	ON  REPLACE(
  REPLACE(
   CONCAT(
    ISNULL(B.Street1,''),
     ISNULL(B.Street2,''),
      ISNULL(B.City,''),
       ISNULL(B.State,''),
        ISNULL(B.postal_code,'')
         ),' ',''),',','') = REPLACE(
                REPLACE(T.[OriginalAddress],' ',''),',','')
				 
				  SELECT 
		 first_name
		, last_name
		, formatted_address
		,job_count
		,last_service_date
		,lifetime_total
		,MAX(IZeroRezId) DedupZeroRezId
	INTO #DedupCase1 from #temp
	GROUP BY 	
		 first_name
		,last_name
		,formatted_address
		,job_count
		,last_service_date
		,lifetime_total

	
		select Distinct IZeroRezId,DedupZeroRezId
		INTO #TempDedupCase1
		from #temp b
		inner join #DedupCase1  d
		ON b.first_name	 = d.first_name
		AND b.last_name	 = d.last_name
		AND b.formatted_address		 = d.formatted_address
		AND b.job_count												 = d.job_count
		AND b.last_service_date										 = d.last_service_date
		AND b.lifetime_total										 = d.lifetime_total

   UPDATE dd      
   SET DD.Description    = CASE WHEN DD.DedupZeroRezId <> T.DedupZeroRezId      
          THEN 'Fact, formatted address, firstName, lastName are equal'      
          ELSE DD.Description      
          END      
   ,DD.DedupZeroRezId = T.DedupZeroRezId      
   FROM ZeroRez.DimDedupZeroRez DD      
   INNER JOIN #TempDedupCase1 T      
   ON DD.ZeroRezId = T.IZeroRezId      

	


	COMMIT TRAN        
 RETURN 1        
  END TRY        
 BEGIN CATCH        
  IF @@TRANCOUNT>0        
   ROLLBACK        
        
  INSERT INTO LogError (                  
     objectName                  
     ,ErrorCode                 
     ,ErrorDescription                  
     ,ErrorGenerationTime                     
    )                  
                  
  SELECT -- autogenerated                    
    OBJECT_NAME(@@PROCID)                    
   ,ERROR_NUMBER() AS ErrorCode                    
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))                    
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))                    
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))                    
+' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription                    
   ,GETDATE()                                      
  RETURN -1          
 END CATCH        
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadBCPToFF]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--exec ZeroRez.usp_LoadBCPToFF 174  
CREATE PROCEDURE [ZeroRez].[usp_LoadBCPToFF]  
 (  
  @ZeroRezGroupId BIGINT  
 )  
AS  
BEGIN  
 BEGIN TRY  
  DECLARE  
   @LogTaskIdheader  BIGINT,  
   @TotalRowCount   INT   
  
  BEGIN TRAN     
   INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus)   
   VALUES (@ZeroRezGroupId, 'Address', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')    
  
   SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Address'  
  
   INSERT INTO ZeroRez.tblAddress_FF  
   (  
     Street1  
    ,Street2  
    ,City  
    ,State  
    ,Postal_code  
    ,ZeroRezID  
    ,LogtaskId  
    ,ModifiedDate  
   )  
   SELECT DISTINCT   
    Street1  
    ,Street2  
    ,City  
    ,State  
    ,postal_code  
    ,IZeroRezId  
    ,@LogTaskIdheader  
    ,GETDATE()  
   FROM ZeroRez.ZeroRez_bcp  
  
   SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblAddress_FF WHERE logTaskId = @LogTaskIdheader    
   
   UPDATE  LogTaskControlFlow   
   SET StagingTotalRows = @TotalRowCount   
   WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Address'   
  
   INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus)   
   VALUES (@ZeroRezGroupId, 'Email', GETDATE(), 'ZeroRez File', 'ZeroRez data load in progress')  
  
   SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Email'  
  
   INSERT INTO ZeroRez.tblEmail_FF  
   (  
    Email  
    ,ZeroRezID  
    ,LogtaskId  
    ,ModifiedDate  
   )  
   SELECT DISTINCT   
    e.Value  
    ,IZeroRezId    
    ,@LogTaskIdheader  
    ,GETDATE()  
   FROM ZeroRez.ZeroRez_bcp z  
   CROSS APPLY STRING_SPLIT(z.emails, '|') e  
  
     
   SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblEmail_FF WHERE logTaskId = @LogTaskIdheader    
   
   UPDATE  LogTaskControlFlow   
   SET StagingTotalRows = @TotalRowCount   
   WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Email'   
  
   INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus)   
   VALUES (@ZeroRezGroupId, 'Phone', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')  
  
   SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Phone'  
     
   INSERT INTO  ZeroRez.tblPhone_FF  
   (  
    PhoneNumber  
    ,ZeroRezID  
    ,LogtaskId  
    ,ModifiedDate  
   )  
   SELECT DISTINCT   
    p.value as phones  
    ,IZeroRezId  
    ,@LogTaskIdheader  
    ,GETDATE()  
   FROM ZeroRez.ZeroRez_bcp  
   CROSS APPLY STRING_SPLIT(phones, '|') p  
  
   SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblPhone_FF WHERE logTaskId = @LogTaskIdheader    
   
   UPDATE  LogTaskControlFlow   
   SET StagingTotalRows = @TotalRowCount   
   WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Phone'   
  
   INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus)   
   VALUES (@ZeroRezGroupId, 'ClientTags', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')  
  
   SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'ClientTags'  
  
   INSERT INTO ZeroRez.tblClientTags_FF  
   (  
    ClientTags  
    ,ZeroRezID  
    ,LogtaskId  
    ,ModifiedDate  
   )  
   SELECT DISTINCT   
   c.value AS client_tags  
   ,IZeroRezId  
   ,@LogTaskIdheader  
   ,GETDATE()  
   FROM ZeroRez.ZeroRez_bcp  
   CROSS APPLY STRING_SPLIT(client_tags, '|') c  
  
   SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblClientTags_FF WHERE logTaskId = @LogTaskIdheader    
   
   UPDATE  LogTaskControlFlow   
   SET StagingTotalRows = @TotalRowCount   
   WHERE logTaskId= @LogTaskIdheader AND Subheader = 'ClientTags'   
  
   
  COMMIT TRAN  
  Select 1  
  RETURN 1   
 END TRY  
  
 BEGIN CATCH  
  
  IF @@TRANCOUNT>0  
   ROLLBACK    
      
  INSERT INTO LogError (            
     objectName            
     ,ErrorCode            
     ,ErrorDescription            
     ,ErrorGenerationTime               
    )            
            
  SELECT -- autogenerated              
    OBJECT_NAME(@@PROCID)              
   ,ERROR_NUMBER() AS ErrorCode,                    
   +' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))              
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))              
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))              
   +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription              
   ,GETDATE()                                
  RETURN -1    
 END CATCH   
END 
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadBCPToFF2]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ZeroRez].[usp_LoadBCPToFF2]  
 (  
  @ZeroRezGroupId BIGINT  
 )  
AS  
BEGIN  
 BEGIN TRY  
  DECLARE  
   @LogTaskIdheader  BIGINT,  
   @TotalRowCount   INT   
  
  BEGIN TRAN     
INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus)   
   VALUES (@ZeroRezGroupId, 'NetPromoterLabels', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')  
  
   SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'NetPromoterLabels'  
  
   INSERT INTO ZeroRez.tblNetPromoterLabels_FF  
   (  
    NetPromoterLabels  
    ,ZeroRezID  
    ,LogtaskId  
    ,ModifiedDate  
   )  
   SELECT DISTINCT  
     n.value AS net_promoter_labels  
     ,IZeroRezId  
     ,@LogTaskIdheader  
     ,GETDATE()  
   FROM ZeroRez.ZeroRez_bcp  
   CROSS APPLY STRING_SPLIT(net_promoter_labels, '|') n  
  
   SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblNetPromoterLabels_FF WHERE logTaskId = @LogTaskIdheader    
   
   UPDATE  LogTaskControlFlow   
   SET StagingTotalRows = @TotalRowCount   
   WHERE logTaskId= @LogTaskIdheader AND Subheader = 'NetPromoterLabels'   
  
   INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus)   
   VALUES (@ZeroRezGroupId, 'Source', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')  
  
   SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Source'  
   INSERT INTO  ZeroRez.tblSource_FF  
   (  
    [Source]  
    ,ZeroRezID  
    ,LogtaskId  
    ,ModifiedDate  
   )  
   SELECT DISTINCT   
    s.value AS [Source]  
    ,IZeroRezId  
    ,@LogTaskIdheader  
    ,GETDATE()  
   FROM ZeroRez.ZeroRez_bcp  
   CROSS APPLY STRING_SPLIT(source, '|') s  
  
   SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblSource_FF WHERE logTaskId = @LogTaskIdheader    
   
   UPDATE  LogTaskControlFlow   
   SET StagingTotalRows = @TotalRowCount   
   WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Source'   
  
   INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus)   
   VALUES (@ZeroRezGroupId, 'Product', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')  
  
   SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Product'  
  
   INSERT INTO ZeroRez.tblProducts_FF  
   (  
    Products  
    ,ZeroRezID  
    ,LogtaskId  
    ,ModifiedDate)  
   SELECT DISTINCT   
    pr.Value AS Products  
    ,IZeroRezID  
    ,@LogTaskIdheader  
    ,GETDATE()  
   FROM ZeroRez.ZeroRez_bcp  
   CROSS APPLY STRING_SPLIT(products, '|') pr  
  
   SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblProducts_FF WHERE logTaskId = @LogTaskIdheader    
   
   UPDATE  LogTaskControlFlow   
   SET StagingTotalRows = @TotalRowCount   
   WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Product'   
  
   INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus)   
   VALUES (@ZeroRezGroupId, 'ZeroRezJob', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')  
  
   SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'ZeroRezJob'  
  
   INSERT INTO  ZeroRez.tblZeroRez_FF  
   (  
    ZeroRezID  
    ,First_Name  
    ,Last_Name  
    ,Zones  
    ,Job_Count  
    ,Last_Service_Date  
    ,LifeTime_Total  
    ,LogtaskId  
    ,ModifiedDate  
   )  
   SELECT DISTINCT   
    IZeroRezId  
    ,first_name  
    ,last_name  
    ,zones  
    ,job_count  
    ,last_service_date  
    ,Lifetime_total  
    ,@LogTaskIdheader  
    ,GETDATE()  
   FROM ZeroRez.ZeroRez_bcp  
  
   SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblZeroRez_FF WHERE logTaskId = @LogTaskIdheader    
   
   UPDATE  LogTaskControlFlow   
   SET StagingTotalRows = @TotalRowCount   
   WHERE logTaskId= @LogTaskIdheader AND Subheader = 'ZeroRezJob'  
 COMMIT TRAN  
  Select 1  
  RETURN 1   
 END TRY  
  
 BEGIN CATCH  
  
  IF @@TRANCOUNT>0  
   ROLLBACK    
      
  INSERT INTO LogError (            
     objectName            
     ,ErrorCode            
     ,ErrorDescription            
     ,ErrorGenerationTime               
    )            
            
  SELECT -- autogenerated              
    OBJECT_NAME(@@PROCID)              
   ,ERROR_NUMBER() AS ErrorCode,                    
   +' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))              
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))              
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))              
   +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription              
   ,GETDATE()                                
  RETURN -1    
 END CATCH   
END 
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadDedupDimensions]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ZeroRez].[usp_LoadDedupDimensions]        
AS        
BEGIN        
 BEGIN TRY        
   IF OBJECT_ID('tempdb.. #DedupCase1') IS NOT NULL    
	DROP TABLE #DedupCase1    
    
   IF OBJECT_ID('tempdb.. #TempDedupCase1') IS NOT NULL    
    DROP TABLE #TempDedupCase1
	
	IF OBJECT_ID('tempdb.. #Temp') IS NOT NULL    
    DROP TABLE #Temp    
      
               
     SELECT 
	 REPLACE(LTRIM(RTRIM(ISNULL(b.first_name,''))),'  ',' ') first_name
	,REPLACE(LTRIM(RTRIM(ISNULL(b.last_name,''))),'  ',' ') last_name
	,REPLACE(T.formatted_address,'"', '') formatted_address
	,b.job_count
	,b.last_service_date
	,b.lifetime_total
	,b.IZeroRezId
	INTO #Temp
	FROM ZeroRez.ZeroRez_bcp (NOLOCK) B
	INNER JOIN zerorez.[tblZerorezStandardAddressApi] T
	ON  REPLACE(
	REPLACE(
	CONCAT(
    ISNULL(B.Street1,''),
     ISNULL(B.Street2,''),
      ISNULL(B.City,''),
       ISNULL(B.State,''),
        ISNULL(B.postal_code,'')
         ),' ',''),',','') = REPLACE(
                REPLACE(T.[OriginalAddress],' ',''),',','')
				 
				  SELECT 
		 first_name
		, last_name
		, formatted_address
		,job_count
		,last_service_date
		,lifetime_total
		,MAX(IZeroRezId) DedupZeroRezId
	INTO #DedupCase1 from #temp
	GROUP BY 	
		 first_name
		,last_name
		,formatted_address
		,job_count
		,last_service_date
		,lifetime_total

	
		select Distinct IZeroRezId,DedupZeroRezId
		INTO #TempDedupCase1
		from #temp b
		inner join #DedupCase1  d
		ON b.first_name	 = d.first_name
		AND b.last_name	 = d.last_name
		AND b.formatted_address		 = d.formatted_address
		AND b.job_count												 = d.job_count
		AND b.last_service_date										 = d.last_service_date
		AND b.lifetime_total										 = d.lifetime_total

   UPDATE dd      
   SET DD.Description    = CASE WHEN DD.DedupZeroRezId <> T.DedupZeroRezId      
          THEN 'Fact, formatted address, firstName, lastName are equal'      
          ELSE DD.Description      
          END      
   ,DD.DedupZeroRezId = T.DedupZeroRezId      
   FROM ZeroRez.DimDedupZeroRez DD      
   INNER JOIN #TempDedupCase1 T      
   ON DD.ZeroRezId = T.IZeroRezId      

	


	COMMIT TRAN        
 RETURN 1        
  END TRY        
 BEGIN CATCH        
  IF @@TRANCOUNT>0        
   ROLLBACK        
        
  INSERT INTO LogError (                  
     objectName                  
     ,ErrorCode                 
     ,ErrorDescription                  
     ,ErrorGenerationTime                     
    )                  
                  
  SELECT -- autogenerated                    
    OBJECT_NAME(@@PROCID)                    
   ,ERROR_NUMBER() AS ErrorCode                    
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))                    
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))                    
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))                    
+' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription                    
   ,GETDATE()                                      
  RETURN -1          
 END CATCH        
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadDimensions]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 -- rollback
 
CREATE PROCEDURE [ZeroRez].[usp_LoadDimensions]  
AS  
BEGIN  
 BEGIN TRY  
  DECLARE @Counter TABLE(LogTaskID BIGINT)  
  DECLARE @LogTaskId BIGINT  
  
  INSERT INTO @Counter   
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblAddress_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblClientTags_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblNetPromoterLabels_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblPhone_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblProducts_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblSource_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblZeroRez_DT] WHERE LogTaskId IS NOT NULL 
  UNION
   SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblEmail_DT] WHERE LogTaskId IS NOT NULL  
  
  BEGIN TRAN  
  WHILE EXISTS(SELECT 1 FROM @Counter)  
  BEGIN  
    SET @LogTaskId=(SELECT TOP 1 LogtaskID from @Counter)  
          
  
    SELECT   
     REPLACE(LTRIM(RTRIM(ISNULL(ES.first_name,''))),'  ',' ') first_name  
    ,REPLACE(LTRIM(RTRIM(ISNULL(ES.last_name,''))),'  ',' ') last_name  
    ,REPLACE(T.formatted_address,'"', '') formatted_address  
    ,job_count  
    ,last_service_date  
    ,lifetime_total  
    ,MAX(ES.ZeroRezId) DedupZeroRezId  
    INTO #DedupCase1  
    FROM ZeroRez.tblZeroRez_DT (NOLOCK) ES  
    INNER JOIN zerorez.[tblZerorezStandardAddressApi] T  
    ON ES.ZeroRezId = T.IZeroRezId  
    WHERE ES.LogTaskID=@LogTaskID   
    GROUP BY    
     REPLACE(LTRIM(RTRIM(ISNULL(first_name,''))),'  ',' ')  
    ,REPLACE(LTRIM(RTRIM(ISNULL(last_name,''))),'  ',' ')  
    ,REPLACE(T.formatted_address,'"', '')  
    ,job_count  
    ,last_service_date  
    ,lifetime_total  
      

  
    SELECT   
    d.first_name  
    ,d.last_name  
    ,d.formatted_address  
    ,d.job_count  
    ,d.last_service_date  
    ,d.lifetime_total  
    ,b.ZeroRezId  
    ,d.DedupZeroRezId  
    INTO #TempDedupCase1  
    FROM ZeroRez.tblZeroRez_DT (NOLOCK) B  
    INNER JOIN zerorez.[tblZerorezStandardAddressApi] T  
     ON B.ZeroRezId = T.IZeroRezId  
    INNER JOIN #DedupCase1 d  
    ON  REPLACE(LTRIM(RTRIM(ISNULL(b.first_name,''))),'  ',' ')  = d.first_name  
     AND REPLACE(LTRIM(RTRIM(ISNULL(b.last_name,''))),'  ',' ')  = d.last_name  
     AND REPLACE(T.formatted_address,'"', '')      = d.formatted_address  
     AND b.job_count             = d.job_count  
     AND b.last_service_date           = d.last_service_date  
     AND b.lifetime_total           = d.lifetime_total  
    WHERE B.LogTaskID=@LogTaskID   
      
   
	INSERT INTO ZeroRez.DimDedupZeroRez
	(
		ZeroRezId
		,DedupZeroRezId
		,CreatedDate
		,CreatedBy
	)
	SELECT DISTINCT
		ZeroRezID,
		ZeroRezID,
		GETDATE(),
		-1
	FROM [ZeroRez].tblZeroRez_DT 

	UPDATE dd
	SET DD.Description	   = CASE	WHEN DD.DedupZeroRezId <> T.DedupZeroRezId
								THEN 'Fact, formatted address, firstName, lastName are equal'
								ELSE DD.Description
								END
	,DD.DedupZeroRezId = T.DedupZeroRezId
	FROM ZeroRez.DimDedupZeroRez DD
	INNER JOIN #TempDedupCase1 T
	ON DD.ZeroRezId = T.ZeroRezId
  
    MERGE INTO ZeroRez.DimClient AS T  
    USING  
    (  
     SELECT DISTINCT   
     REPLACE(LTRIM(RTRIM(First_Name)),'  ',' ') AS FirstName  
     ,REPLACE(LTRIM(RTRIM(Last_Name)),'  ',' ') AS LastName  
     ,ZeroRezId  
     FROM ZeroRez.tblZeroRez_DT  
     WHERE LogTaskID=@LogTaskID  
    )  
    AS S  
    ON REPLACE(LTRIM(RTRIM(ISNULL(S.FirstName,''))),'  ',' ')=ISNULL(T.FirstName,'')  
    AND REPLACE(LTRIM(RTRIM(ISNULL(S.LastName,''))),'  ',' ')=ISNULL(T.FirstName,'')  
    WHEN NOT MATCHED THEN  
    INSERT(FirstName,LastName,ZeroRezId,DedupZeroRezId,CreatedDate,CreatedBy)  
    VALUES(S.FirstName,S.LastName,S.ZeroRezId,NULL,GETDATE(),@LogTaskID);  
  
    UPDATE T SET T.DedupZeroRezId = DD.DedupZeroRezId  
    FROM [ZeroRez].DimClient T  
    INNER JOIN ZeroRez.DimDedupZeroRez DD  
    ON DD.ZeroRezId = T.ZeroRezId  
  
    MERGE INTO [ZeroRez].[DimEmail] AS T  
    USING  
    (  
     SELECT DISTINCT Email  
     FROM [ZeroRez].[tblEmail_DT]  
     --WHERE LogTaskId=@logTaskId  
    )AS S  
    ON ISNULL(S.Email,'')=ISNULL(T.Email,'')  
    WHEN NOT MATCHED THEN  
    INSERT(Email,CreatedBy,CreatedDate)  
    VALUES(S.Email,-1,GETDATE());  
  
    MERGE INTO [ZeroRez].[DimPhone] AS T  
    USING  
    (  
     SELECT DISTINCT PhoneNumber AS Phone  
     FROM [ZeroRez].[tblPhone_DT]   
     WHERE LogTaskId=@logTaskId  
    )AS S  
    ON ISNULL(S.Phone,'')=ISNULL(T.Phone,'')  
    WHEN NOT MATCHED THEN  
    INSERT(Phone,CreatedBy,CreatedDate)  
    VALUES(S.Phone,@LogTaskId,GETDATE());  
  
    MERGE INTO ZeroRez.DimAddress AS T  
    USING  
    (  
     SELECT DISTINCT   
        REPLACE(LTRIM(RTRIM(Street1)),'  ',' ')  AS Street1  
       ,REPLACE(LTRIM(RTRIM(Street2)),'  ',' ')  AS Street2  
       ,REPLACE(LTRIM(RTRIM(City)),'  ',' ')  AS City  
       ,REPLACE(LTRIM(RTRIM(State)),'  ',' ') AS State  
       ,REPLACE(LTRIM(RTRIM(Postal_code)),'  ',' ') AS Zip  
     FROM [ZeroRez].[tblAddress_DT](NOLOCK)  
    )  
    AS S  
    ON REPLACE(LTRIM(RTRIM(ISNULL(S.Street1,''))),'  ',' ')=ISNULL(T.Street1,'')  
    AND REPLACE(LTRIM(RTRIM(ISNULL(S.Street2,''))),'  ',' ')=ISNULL(T.Street2,'')  
    AND REPLACE(LTRIM(RTRIM(ISNULL(S.City,''))),'  ',' ')=ISNULL(T.City,'')  
    AND REPLACE(LTRIM(RTRIM(ISNULL(S.State,''))),'  ',' ')=ISNULL(T.State,'')  
    AND REPLACE(LTRIM(RTRIM(ISNULL(S.Zip,''))),'  ',' ')=ISNULL(T.Zip,'')  
    WHEN NOT MATCHED THEN  
    INSERT(Street1,Street2,City,State,Zip,ApartmentNumber,StandardAddress,CreatedDate,CreatedBy)  
    VALUES(S.Street1,S.Street2,S.City,S.State,S.Zip,NULL,NULL,GETDATE(),@LogTaskID);  
  
  
    MERGE INTO ZeroRez.DimProduct AS T  
    USING  
    (  
     SELECT DISTINCT Products  
     FROM ZeroRez.tblProducts_DT  
     WHERE LogTaskID=@LogTaskID  
    )  
    AS S  
    ON ISNULL(S.Products,'')=ISNULL(T.Product  ,'')
    WHEN NOT MATCHED THEN  
    INSERT(Product,CreatedDate,CreatedBy)  
    VALUES(S.Products,GETDATE(),@LogTaskID);  
  
    MERGE INTO ZeroRez.DimSource AS T  
    USING   
    (  
     SELECT DISTINCT Source  
     ,LogTaskId  
     FROM ZeroRez.tblSource_DT  
     WHERE LogTaskID=@LogTaskID  
    )  
    AS S  
    ON ISNULL(S.Source,'')=ISNULL(T.Source  ,'')
    WHEN NOT MATCHED THEN  
    INSERT (Source,CreatedDate,CreatedBy)  
    VALUES(S.Source,GETDATE(),@LogTaskID);  
  
    MERGE INTO ZeroRez.DimClientTags AS T  
    USING  
    (  
     SELECT DISTINCT ClientTags  
     ,LogtaskId  
     FROM ZeroRez.tblClientTags_DT  
     WHERE LogTaskID=@LogTaskID  
    )  
    AS S  
    ON ISNULL(S.ClientTags,'')=ISNULL(T.ClientTag  ,'')
    WHEN NOT MATCHED THEN  
    INSERT (ClientTag,CreatedDate,CreatedBy)  
    VALUES(S.ClientTags,GETDATE(),@LogTaskID);  
  
  
  
    MERGE INTO [ZeroRez].[DimNetPromoterLabels] AS T  
    USING  
    (  
     Select DISTINCT NetPromoterLabels,  
     LogTaskId   
     FROM ZeroRez.tblNetPromoterLabels_DT  
     WHERE LogTaskID=@LogTaskID  
    )  
    AS S  
    ON ISNULL(S.NetPromoterLabels,'')=ISNULL(T.NetPromoterLabels  ,'')
   
    WHEN NOT MATCHED THEN   
    INSERT(NetPromoterLabels,CreatedDate,CreatedBy)  
    VALUES(S.NetPromoterLabels,GETDATE(),@LogTaskID);  
  
  
    MERGE INTO [ZeroRez].[DimZones] AS T  
    USING  
    (  
     Select DISTINCT Zones,  
     LogTaskId   
     FROM ZeroRez.tblZeroRez_DT  
     WHERE LogTaskID=@LogTaskID  
    )  
    AS S  
    ON ISNULL(S.Zones,'')=ISNULL(T.Zones  ,'')
    WHEN NOT MATCHED THEN   
    INSERT(Zones,CreatedDate,CreatedBy)  
    VALUES(S.Zones,GETDATE(),@LogTaskID);  
   
    DROP TABLE #DedupCase1
	DROP TABLE #TempDedupCase1
    DELETE FROM @counter where LogTaskId=@LogTaskId  
  END  
  COMMIT TRAN  
  RETURN 1  
 END TRY  
 BEGIN CATCH  
  IF @@TRANCOUNT>0  
   ROLLBACK  
  
  INSERT INTO LogError (            
     objectName            
     ,ErrorCode            
     ,ErrorDescription            
     ,ErrorGenerationTime               
    )            
            
  SELECT -- autogenerated              
    OBJECT_NAME(@@PROCID)              
   ,ERROR_NUMBER() AS ErrorCode              
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))              
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))              
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))              
   +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription              
   ,GETDATE()                                
  RETURN -1    
 END CATCH  
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadDimensions2]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ZeroRez].[usp_LoadDimensions2]        
AS        
BEGIN        
 BEGIN TRY        
    DECLARE @Counter TABLE(LogTaskID BIGINT)        
    DECLARE @LogTaskId BIGINT        
        
    --INSERT INTO @Counter         
    --SELECT DISTINCT LogTaskID        
    --FROM [ZeroRez].[tblAddress_DT] WHERE LogTaskId IS NOT NULL        
    --UNION        
    --SELECT DISTINCT LogTaskID        
    --FROM [ZeroRez].[tblClientTags_DT] WHERE LogTaskId IS NOT NULL        
    --UNION        
    --SELECT DISTINCT LogTaskID        
    --FROM [ZeroRez].[tblNetPromoterLabels_DT] WHERE LogTaskId IS NOT NULL        
    --UNION        
    --SELECT DISTINCT LogTaskID        
    --FROM [ZeroRez].[tblPhone_DT] WHERE LogTaskId IS NOT NULL        
    --UNION        
    --SELECT DISTINCT LogTaskID        
    --FROM [ZeroRez].[tblProducts_DT] WHERE LogTaskId IS NOT NULL        
    --UNION        
    --SELECT DISTINCT LogTaskID        
    --FROM [ZeroRez].[tblSource_DT] WHERE LogTaskId IS NOT NULL        
    --UNION        
    --SELECT DISTINCT LogTaskID        
    --FROM [ZeroRez].[tblZeroRez_DT] WHERE LogTaskId IS NOT NULL       
    --UNION      
    -- SELECT DISTINCT LogTaskID        
    --FROM [ZeroRez].[tblEmail_DT] WHERE LogTaskId IS NOT NULL        
        
    BEGIN TRAN        
   -- WHILE EXISTS(SELECT 1 FROM @Counter)        
   -- BEGIN        
   --SET @LogTaskId=(SELECT TOP 1 LogtaskID from @Counter)        
 
     
	INSERT INTO ZeroRez.DimDedupZeroRez (ZeroRezId,DedupZeroRezId,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.ZeroRezId,S.ZeroRezId,-1,GETDATE()      
   FROM ZeroRez.tblZeroRez_DT S      
   LEFT JOIN ZeroRez.DimDedupZeroRez T       
   ON S.ZeroRezId=T.ZeroRezId      
   WHERE T.IDedupZeroRezId IS NULL    
       
   INSERT INTO ZeroRez.DimClient (FirstName,LastName,ZeroRezId,DedupZeroRezId,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.First_Name,S.Last_Name,S.ZeroRezId,S.ZeroRezId,-1,GETDATE()      
   FROM ZeroRez.tblZeroRez_DT S      
   LEFT JOIN ZeroRez.DimClient T       
   ON REPLACE(LTRIM(RTRIM(ISNULL(S.First_Name,''))),'  ',' ')=ISNULL(T.FirstName,'')        
   AND REPLACE(LTRIM(RTRIM(ISNULL(S.Last_Name,''))),'  ',' ')=ISNULL(T.LastName,'')        
   WHERE T.IClientId IS NULL      
      
        
   UPDATE T SET T.DedupZeroRezId = DD.DedupZeroRezId        
   FROM [ZeroRez].DimClient T        
   INNER JOIN ZeroRez.DimDedupZeroRez DD        
   ON DD.ZeroRezId = T.ZeroRezId   
   
   INSERT INTO [ZeroRez].[DimAddress] (Street1,Street2,City,State,Zip,CreatedDate,CreatedBy)      
   SELECT DISTINCT         
    REPLACE(LTRIM(RTRIM(S.Street1)),'  ',' ')  AS Street1        
      ,REPLACE(LTRIM(RTRIM(S.Street2)),'  ',' ')  AS Street2        
      ,REPLACE(LTRIM(RTRIM(S.City)),'  ',' ')  AS City        
      ,REPLACE(LTRIM(RTRIM(S.State)),'  ',' ') AS State        
      ,REPLACE(LTRIM(RTRIM(S.Postal_code)),'  ',' ') AS Zip        
      ,GETDATE()      
      ,-1      
    FROM [ZeroRez].[tblAddress_DT] S      
    LEFT JOIN [ZeroRez].[DimAddress] T      
    ON REPLACE(LTRIM(RTRIM(ISNULL(S.Street1,'NA'))),'  ',' ')=ISNULL(T.Street1,'NA')        
   AND REPLACE(LTRIM(RTRIM(ISNULL(S.Street2,'NA'))),'  ',' ')=ISNULL(T.Street2,'NA')        
   AND REPLACE(LTRIM(RTRIM(ISNULL(S.City,'NA'))),'  ',' ')=ISNULL(T.City,'NA')        
   AND REPLACE(LTRIM(RTRIM(ISNULL(S.State,'NA'))),'  ',' ')=ISNULL(T.State,'NA')        
   AND REPLACE(LTRIM(RTRIM(ISNULL(S.Postal_code,'NA'))),'  ',' ')=ISNULL(T.Zip,'NA')      
   WHERE T.IAddressId IS NULL      
       
	UPDATE da set standardAddress=sa.formatted_address
   FROM zerorez.dimAddress da
   INNER JOIN zerorez.tblzerorezstandardaddressapi sa  
  ON REPLACE(
  REPLACE(
   CONCAT(
    COALESCE(da.Street1,''),
     COALESCE(da.Street2,''),
      COALESCE(da.City,''),
       COALESCE(da.State,''),
        COALESCE(da.zip,'')
         ),' ',''),',','') = REPLACE(
                REPLACE(SA.[OriginalAddress],' ',''),',','')     
         
   INSERT INTO [ZeroRez].[DimEmail] (Email,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.Email,-1,GETDATE()      
   FROM [ZeroRez].[tblEmail_DT] S      
   LEFT JOIN [ZeroRez].[DimEmail] T       
   ON ISNULL(S.Email,'NA')=ISNULL(T.Email,'NA')      
   WHERE T.IEmailID IS NULL      
      
       
   INSERT INTO [ZeroRez].[DimPhone] (Phone,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.PhoneNumber,-1,GETDATE()      
   FROM [ZeroRez].[tblPhone_DT] S      
   LEFT JOIN [ZeroRez].[DimPhone] T       
   ON ISNULL(S.PhoneNumber,'NA')=ISNULL(T.Phone,'NA')      
   WHERE T.IPhoneID IS NULL       
        
   INSERT INTO ZeroRez.DimProduct (Product,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.Products,-1,GETDATE()      
   FROM [ZeroRez].[tblProducts_DT ] S      
   LEFT JOIN [ZeroRez].DimProduct T       
   ON ISNULL(S.Products,'NA')=ISNULL(T.Product,'NA')      
   WHERE T.IProductId IS NULL      
          
   INSERT INTO ZeroRez.DimSource (Source,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.Source,-1,GETDATE()      
   FROM ZeroRez.tblSource_DT  S      
   LEFT JOIN ZeroRez.DimSource T       
   ON ISNULL(S.Source,'NA')=ISNULL(T.Source,'NA')      
   WHERE T.ISourceId IS NULL      
          
   INSERT INTO ZeroRez.DimClientTags (ClientTag,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.ClientTags,-1,GETDATE()      
   FROM ZeroRez.tblClientTags_DT  S      
   LEFT JOIN ZeroRez.DimClientTags T       
   ON ISNULL(S.ClientTags,'NA')=ISNULL(T.ClientTag,'NA')      
   WHERE T.IClientTagId IS NULL      
        
   INSERT INTO ZeroRez.[DimNetPromoterLabels] (NetPromoterLabels,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.NetPromoterLabels,-1,GETDATE()      
   FROM ZeroRez.tblNetPromoterLabels_DT   S      
   LEFT JOIN ZeroRez.[DimNetPromoterLabels] T       
   ON ISNULL(S.NetPromoterLabels,'NA')=ISNULL(T.NetPromoterLabels,'NA')      
   WHERE T.INetPromoterLabelsId IS NULL      
      
   INSERT INTO ZeroRez.[DimZones] (Zones,CreatedBy,CreatedDate)      
   SELECT DISTINCT S.Zones,-1,GETDATE()      
   FROM ZeroRez.tblZeroRez_DT   S      
   LEFT JOIN ZeroRez.[DimZones] T       
 ON ISNULL(S.Zones,'NA')=ISNULL(T.Zones,'NA')      
   WHERE T.IZonesId IS NULL      
             
   --DELETE FROM @counter where LogTaskId=@LogTaskId        
   -- END        
 COMMIT TRAN        
 RETURN 1        
  END TRY        
 BEGIN CATCH        
  IF @@TRANCOUNT>0        
   ROLLBACK        
        
  INSERT INTO LogError (                  
     objectName                  
     ,ErrorCode                 
     ,ErrorDescription                  
     ,ErrorGenerationTime                     
    )                  
                  
  SELECT -- autogenerated                    
    OBJECT_NAME(@@PROCID)                    
   ,ERROR_NUMBER() AS ErrorCode                    
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))                    
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))                    
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))                    
+' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription                    
   ,GETDATE()                                      
  RETURN -1          
 END CATCH        
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadFacts]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ZeroRez].[usp_LoadFacts]  
AS  
BEGIN  
 BEGIN TRY  
  DECLARE @Counter TABLE(LogTaskID BIGINT)  
  DECLARE @LogTaskId BIGINT  
  
  INSERT INTO @Counter   
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblZeroRez_DT] WHERE LogTaskId IS NOT NULL  
    
  BEGIN TRAN  
   WHILE EXISTS(SELECT 1 FROM @Counter)  
   BEGIN  
	SELECT TOP 1 @LogTaskId= LogTaskId FROM @Counter
    MERGE INTO [ZeroRez].[FactZeroRezDedupData] AS T  
    USING  
    (  
      SELECT DISTINCT  
      DC.DedupZeroRezId AS ClientDedupID  
      ,CAZ.DedupClientAddressZoneGroupId AS ClientAddZoneGrpID  
      ,DEG.DedupEmailGroupId AS EmailGroupId  
      ,DPG.DedupPhoneGroupId AS PhoneGroupId  
      ,DedupClientTagGroupId AS ClientTagGroupId  
      ,DedupNetPromoterLabelsGroupID AS NetPromoterLabelsGroupID  
      ,DedupProductGroupId AS ProductGroupId  
      ,DedupSourceGroupId AS SourceGroupId  
      ,Job_Count AS JobCount  
      ,Last_Service_Date AS LastServiceDate  
      ,CONVERT(DECIMAL(18,8),LifeTime_Total) AS [LifeTimeTotal]  
     FROM [ZeroRez].tblZeroRez_DT DT  
     INNER JOIN [ZeroRez].DimClient DC   
     ON DT.ZeroRezID = DC.DedupZeroRezId  
     LEFT JOIN [ZeroRez].tblAddress_DT ATT  
     ON DT.ZeroRezID = ATT.ZeroRezID  
     LEFT JOIN [ZeroRez].DimAddress DAA  
     ON  ISNULL(DAA.Street1, '') = REPLACE(LTRIM(RTRIM(ISNULL(ATT.Street1, ''))),'  ',' ')  
      AND ISNULL(DAA.Street2, '') = REPLACE(LTRIM(RTRIM(ISNULL(ATT.Street2, ''))),'  ',' ')  
      AND ISNULL(DAA.City, '') = REPLACE(LTRIM(RTRIM(ISNULL(ATT.City, ''))),'  ',' ')  
      AND ISNULL(DAA.State, '') = REPLACE(LTRIM(RTRIM(ISNULL(ATT.State, ''))),'  ',' ')  
      AND ISNULL(DAA.Zip, '')  = REPLACE(LTRIM(RTRIM(ISNULL(ATT.Postal_code, ''))),'  ',' ')  
     LEFT JOIN [ZeroRez].DimZones DZ  
     ON ISNULL(DT.Zones, '') = ISNULL(DZ.Zones, '')  
     LEFT JOIN [ZeroRez].[DimClientAddressZoneGroup] CAZ  
     ON DC.DedupZeroRezId = CAZ.ClientId  
      AND DAA.IAddressId = CAZ.AddressId  
      AND DZ.IZonesId = CAZ.ZoneId  
      AND CAZ.DedupClientAddressZoneGroupId = DT.ZeroRezID  
    LEFT JOIN [ZeroRez].tblEmail_DT EDT  
     ON DT.ZeroRezID = EDT.ZeroRezID  
    LEFT JOIN [ZeroRez].DimEmail DE  
     ON ISNULL(DE.Email, '') = ISNULL(EDT.Email, '')  
    LEFT JOIN [ZeroRez].[DimEmailGroup] DEG  
     ON DE.IEmailId=DEG.EmailId  
     AND DEG.DedupEmailGroupId = EDT.ZeroRezID  
    LEFT JOIN [ZeroRez].tblPhone_DT PT  
     ON DT.ZeroRezID = PT.ZeroRezID  
    LEFT JOIN [ZeroRez].DimPhone DPH  
     ON ISNULL(DPH.Phone, '') = ISNULL(PT.PhoneNumber, '')  
    LEFT JOIN [ZeroRez].[DimPhoneGroup] DPG  
     ON DPH.IPhoneId=DPG.PhoneId  
     AND DPG.DedupPhoneGroupId = PT.ZeroRezID  
     LEFT JOIN [ZeroRez].[tblNetPromoterLabels_DT] LDT   
     ON LDT.ZeroRezID=DT.ZeroRezID    
     LEFT JOIN [ZeroRez].[DimNetPromoterLabels] L   
     ON  ISNULL(L.NetPromoterLabels,'')=ISNULL(LDT.NetPromoterLabels,'')   
     LEFT  JOIN [ZeroRez].[DimNetPromoterLabelsGroup] LG   
     ON L.INetPromoterLabelsId=LG.NetPromoterLabelsId  
      AND LG.DedupNetPromoterLabelsGroupID = LDT.ZeroRezID  
     LEFT JOIN [ZeroRez].tblProducts_DT PDT   
     ON PDT.ZeroRezID=DT.ZeroRezID  
     LEFT JOIN [ZeroRez].[DimProduct] P   
     ON  ISNULL(P.Product,'')=ISNULL(PDT.Products,'')  
     LEFT JOIN [ZeroRez].[DimProductGroup] PG   
     ON P.IProductId=PG.ProductId  
     AND PG.DedupProductGroupId = PDT.ZeroRezID  
     LEFT JOIN [ZeroRez].tblSource_DT SDT   
     ON SDT.ZeroRezID=DT.ZeroRezID  
     LEFT JOIN [ZeroRez].[DimSource] S   
     ON  ISNULL(S.Source,'')=ISNULL(SDT.Source,'')  
     LEFT JOIN [ZeroRez].[DimSourceGroup] SG   
     ON S.ISourceId=SG.SourceID  
     AND SG.DedupSourceGroupId = SDT.ZeroRezID  
     LEFT JOIN [ZeroRez].tblClientTags_DT CDT   
     ON CDT.ZeroRezID=DT.ZeroRezID  
     LEFT JOIN [ZeroRez].[DimClientTags] C   
     ON  ISNULL(C.ClientTag,'')=ISNULL(CDT.ClientTags,'')  
     LEFT JOIN [ZeroRez].[DimClientTagGroup] CG   
     ON C.IClientTagId=CG.ClientTagId  
     AND CG.DedupClientTagGroupId = CDT.ZeroRezID  
    WHERE DT.LogTaskId=@LogTaskId  
    ) AS S  
    ON S.ClientDedupID=T.ClientDedupID  
    WHEN MATCHED THEN  
     UPDATE SET T.ClientAddZoneGrpID   =S.ClientAddZoneGrpID  
      ,T.EmailGroupId     =S.EmailGroupId      
      ,T.PhoneGroupId     =S.PhoneGroupId  
      ,T.ClientTagGroupId    =S.ClientTagGroupId      
      ,T.NetPromoterLabelsGroupID  =S.NetPromoterLabelsGroupID    
      ,T.ProductGroupId    =S.ProductGroupId      
      ,T.SourceGroupId    =S.SourceGroupId       
      ,T.JobCount      =S.JobCount        
      ,T.LastServiceDate    =S.LastServiceDate      
      ,T.LifeTimeTotal    =S.LifeTimeTotal   
    WHEN NOT MATCHED THEN  
     INSERT  (  
        ClientDedupID  
        ,ClientAddZoneGrpID  
        ,EmailGroupId  
        ,PhoneGroupId  
        ,ClientTagGroupId  
        ,NetPromoterLabelsGroupID  
        ,ProductGroupId  
        ,SourceGroupId  
        ,JobCount  
        ,LastServiceDate  
        ,LifeTimeTotal  
        ,CreatedDate  
        ,CreatedBy  
       )  
     VALUES  (  
         S.ClientDedupID  
        ,S.ClientAddZoneGrpID  
        ,S.EmailGroupId  
        ,S.PhoneGroupId  
        ,S.ClientTagGroupId  
        ,S.NetPromoterLabelsGroupID  
        ,S.ProductGroupId  
        ,S.SourceGroupId  
        ,S.JobCount  
        ,S.LastServiceDate  
        ,S.LifeTimeTotal  
        ,GETDATE()  
        ,@LogTaskId  
       );      
    DELETE FROM @counter where LogTaskId=@LogTaskId  
   END  
  COMMIT TRAN  
 END TRY  
 BEGIN CATCH  
   IF @@TRANCOUNT>0  
   ROLLBACK  
  
  INSERT INTO LogError (            
     objectName            
     ,ErrorCode            
     ,ErrorDescription            
     ,ErrorGenerationTime               
    )            
            
  SELECT        
    OBJECT_NAME(@@PROCID)              
   ,ERROR_NUMBER() AS ErrorCode              
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))              
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))              
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))              
   +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription              
   ,GETDATE()                                
  RETURN -1    
 END CATCH  
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadFacts2]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ZeroRez].[usp_LoadFacts2]  
AS  
BEGIN  
 BEGIN TRY  
  DECLARE @Counter TABLE(LogTaskID BIGINT)  
  DECLARE @LogTaskId BIGINT  
  
  INSERT INTO @Counter   
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblZeroRez_DT] WHERE LogTaskId IS NOT NULL  
    
  BEGIN TRAN  
   WHILE EXISTS(SELECT 1 FROM @Counter)  
   BEGIN  
	SELECT TOP 1 @LogTaskId= LogTaskId FROM @Counter
    MERGE INTO [ZeroRez].[FactZeroRezDedupData] AS T  
    USING  
    (  
      SELECT DISTINCT  
       DC.DedupZeroRezId AS ClientDedupID  
      ,Job_Count AS JobCount  
      ,Last_Service_Date AS LastServiceDate  
      ,CONVERT(DECIMAL(18,8),LifeTime_Total) AS [LifeTimeTotal]  
     FROM [ZeroRez].tblZeroRez_DT DT  
     INNER JOIN [ZeroRez].DimClient DC   
     ON DT.ZeroRezID = DC.DedupZeroRezId  
     WHERE DT.LogTaskId=@LogTaskId  
    ) AS S  
    ON S.ClientDedupID=T.ClientDedupID  
     WHEN NOT MATCHED THEN  
     INSERT  
		(  
			 ClientDedupID  
			,JobCount  
			,LastServiceDate  
			,LifeTimeTotal  
			,CreatedDate  
			,CreatedBy  
       )  
     VALUES  
	  (  
			 S.ClientDedupID  
			,S.JobCount  
			,S.LastServiceDate  
			,S.LifeTimeTotal  
			,GETDATE()  
			,@LogTaskId  
      );      
    DELETE FROM @counter where LogTaskId=@LogTaskId

	UPDATE F  SET ClientAddZoneGrpID = CAZ.DedupClientAddressZoneGroupId
	FROM [ZeroRez].[FactZeroRezDedupData] F
	INNER JOIN [ZeroRez].tblZeroRez_DT DTZ ON DTZ.ZeroRezID=F.ClientDedupID
	LEFT JOIN [ZeroRez].[tblAddress_DT] DT ON DT.ZeroRezID=F.ClientDedupID
	LEFT JOIN [ZeroRez].DimAddress DAA
	ON	ISNULL(DAA.Street1, '') = REPLACE(LTRIM(RTRIM(ISNULL(DT.Street1, ''))),'  ',' ')
		AND ISNULL(DAA.Street2, '') = REPLACE(LTRIM(RTRIM(ISNULL(DT.Street2, ''))),'  ',' ')
		AND ISNULL(DAA.City, '')	= REPLACE(LTRIM(RTRIM(ISNULL(DT.City, ''))),'  ',' ')
		AND ISNULL(DAA.State, '')	= REPLACE(LTRIM(RTRIM(ISNULL(DT.State, ''))),'  ',' ')
		AND ISNULL(DAA.Zip, '')		= REPLACE(LTRIM(RTRIM(ISNULL(DT.Postal_code, ''))),'  ',' ')
	 LEFT JOIN [ZeroRez].DimZones DZ
	ON ISNULL(DTZ.Zones, '') = ISNULL(DZ.Zones, '')
	LEFT JOIN [ZeroRez].[DimClientAddressZoneGroup] CAZ
	ON F.ClientDedupID = CAZ.ClientId
		AND DAA.IAddressId = CAZ.AddressId
		AND DZ.IZonesId = CAZ.ZoneId
		AND CAZ.DedupClientAddressZoneGroupId = DT.ZeroRezID

	UPDATE F SET EmailGroupId=DEG.DedupEmailGroupId
	FROM [ZeroRez].[FactZeroRezDedupData] F
	LEFT JOIN [ZeroRez].tblEmail_DT EDT
	ON F.ClientDedupID = EDT.ZeroRezID
	LEFT JOIN [ZeroRez].DimEmail DE
	ON ISNULL(DE.Email, '') = ISNULL(EDT.Email, '')
	LEFT JOIN [ZeroRez].[DimEmailGroup] DEG
	ON DE.IEmailId=DEG.EmailId
	AND DEG.DedupEmailGroupId = EDT.ZeroRezID

	UPDATE F SET PhoneGroupId=DedupPhoneGroupId
	FROM [ZeroRez].[FactZeroRezDedupData] F
	LEFT JOIN [ZeroRez].tblPhone_DT PT
	ON F.ClientDedupID = PT.ZeroRezID
	LEFT JOIN [ZeroRez].DimPhone DPH
	ON ISNULL(DPH.Phone, '') = ISNULL(PT.PhoneNumber, '')
	LEFT JOIN [ZeroRez].[DimPhoneGroup] DPG
	ON DPH.IPhoneId=DPG.PhoneId
	AND DPG.DedupPhoneGroupId = PT.ZeroRezID

	UPDATE F SET NetPromoterLabelsGroupID=DedupNetPromoterLabelsGroupId
	FROM [ZeroRez].[FactZeroRezDedupData] F
	LEFT JOIN [ZeroRez].[tblNetPromoterLabels_DT] LDT 
	ON LDT.ZeroRezID=F.ClientDedupID 
	LEFT JOIN [ZeroRez].[DimNetPromoterLabels] L 
	ON  ISNULL(L.NetPromoterLabels,'')=ISNULL(LDT.NetPromoterLabels,'') 
	LEFT  JOIN [ZeroRez].[DimNetPromoterLabelsGroup] LG 
	ON L.INetPromoterLabelsId=LG.NetPromoterLabelsId
		AND LG.DedupNetPromoterLabelsGroupID = LDT.ZeroRezID

	UPDATE F SET ProductGroupId=DedupProductGroupId
	FROM [ZeroRez].[FactZeroRezDedupData] F
	LEFT JOIN [ZeroRez].tblProducts_DT PDT 
	ON PDT.ZeroRezID=F.ClientDedupID
	LEFT JOIN [ZeroRez].[DimProduct] P 
	ON  ISNULL(P.Product,'')=ISNULL(PDT.Products,'')
	LEFT JOIN [ZeroRez].[DimProductGroup] PG 
	ON P.IProductId=PG.ProductId
	AND PG.DedupProductGroupId = PDT.ZeroRezID

	UPDATE F SET SourceGroupId=DedupSourceGroupId
	FROM [ZeroRez].[FactZeroRezDedupData] F
	LEFT JOIN [ZeroRez].tblSource_DT SDT 
	ON SDT.ZeroRezID=F.ClientDedupID
	LEFT JOIN [ZeroRez].[DimSource] S 
	ON  ISNULL(S.Source,'')=ISNULL(SDT.Source,'')
	LEFT JOIN [ZeroRez].[DimSourceGroup] SG 
	ON S.ISourceId=SG.SourceID
	AND SG.DedupSourceGroupId = SDT.ZeroRezID

	UPDATE F SET ClientTagGroupId=DedupClientTagGroupId
	FROM [ZeroRez].[FactZeroRezDedupData] F
	LEFT JOIN [ZeroRez].tblClientTags_DT CDT 
	ON CDT.ZeroRezID=F.ClientDedupID
	LEFT JOIN [ZeroRez].[DimClientTags] C 
	ON  ISNULL(C.ClientTag,'')=ISNULL(CDT.ClientTags,'')
	LEFT JOIN [ZeroRez].[DimClientTagGroup] CG 
	ON	C.IClientTagId=CG.ClientTagId
	AND CG.DedupClientTagGroupId = CDT.ZeroRezID


   END  
  COMMIT TRAN  
 END TRY  
 BEGIN CATCH  
   IF @@TRANCOUNT>0  
   ROLLBACK  
  
  INSERT INTO LogError (            
     objectName            
     ,ErrorCode            
     ,ErrorDescription            
     ,ErrorGenerationTime               
    )            
            
  SELECT        
    OBJECT_NAME(@@PROCID)              
   ,ERROR_NUMBER() AS ErrorCode              
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))              
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))              
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))              
   +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription              
   ,GETDATE()                                
  RETURN -1    
 END CATCH  
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadFlatToBCP]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec ZeroRez.usp_LoadFlatToBCP'/zerorezsource/ZeroRez-Data.csv','ZeroRez-Data.csv',174
CREATE PROCEDURE [ZeroRez].[usp_LoadFlatToBCP]
	(
		@Container NVARCHAR(127),
		@FileName NVARCHAR(127),
		@ZeroRezGroupId BIGINT
	)
AS
BEGIN

	BEGIN TRY
		DECLARE
			@Sql					NVARCHAR(MAX),		       
			@filepath    			NVARCHAR(255),          		
			@TableName   			NVARCHAR(127),  			         
			@SourceContainerURL		NVARCHAR(MAX),          
			@ArchiveContainerURL	NVARCHAR(MAX),
			@LogTaskID				BIGINT,
			@LogTaskIdheader		BIGINT,
			@TotalRowCount			INT      			    			    						

		SET		@TableName = '[ZeroRez].[vw_ZeroRez]'
		SET  	@filepath    			= @container          
		SET  	@container    			= SUBSTRING(RIGHT(@Container, LEN(@Container) - 1) ,1,CHARINDEX('/',RIGHT(@Container, LEN(@Container) - 1))- 1 )          		         
		SET  	@SourceContainerURL  	= 'https://contata.blob.core.windows.net/' + @Container          
		SET  	@ArchiveContainerURL 	= 'https://contata.blob.core.windows.net/' + REPLACE(@Container,'source','archive')          

		IF EXISTS(SELECT 1 FROM sys.external_data_sources WHERE name = @container)          
			SET @sql ='DROP EXTERNAL DATA SOURCE '+ @container     
			print  @sql  
			EXEC SP_EXECUTESQL @sql  

		SET @sql = 'CREATE EXTERNAL DATA SOURCE '+@container+ '
			WITH ( TYPE = BLOB_STORAGE, LOCATION = '''+ @SourceContainerURL+''');'  
			print @sql
			EXEC SP_EXECUTESQL @sql

		INSERT INTO LogTaskControlFlow(GroupId, StartTime,FeedName, FeedStatus) 
		VALUES (@ZeroRezGroupId,GETDATE(),'ZeroRez Feed', 'ZeroRez file load in progress')      

		SELECT @LogTaskId=MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez feed'
		BEGIN TRAN
			
			SET @sql= 'BULK INSERT ' + @TableName + ' FROM '''+ @FileName + ''' WITH (DATA_SOURCE = '''+@container+''', FORMAT = ''CSV'', FIELDTERMINATOR  = '','', FIRSTROW = 2);'          
				print @sql
				EXEC SP_EXECUTESQL @sql 
			
		COMMIT TRAN
		SELECT 1
		RETURN 1 
	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT>0
			ROLLBACK

		IF EXISTS(SELECT 1 FROM sys.external_data_sources WHERE name = @container )         
		set @sql='DROP EXTERNAL DATA SOURCE '+ @container     
		EXEC SP_EXECUTESQL @sql  
    
		INSERT INTO LogError (          
					objectName          
					,ErrorCode          
					,ErrorDescription          
					,ErrorGenerationTime             
				)          
          
		SELECT -- autogenerated            
			 OBJECT_NAME(@@PROCID)            
			,ERROR_NUMBER() AS ErrorCode            
			,'For File ' + @Container + ' ' + @FileName          
			+' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))            
			+' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))            
			+' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))            
			+' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription            
			,GETDATE()                              
		RETURN -1 	
	END CATCH
END 
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadFlatToFF]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [usp_LoadFlatToFF]'/zerorezsource/ZeroRez-Data.csv','ZeroRez-Data.csv',174
CREATE PROCEDURE [ZeroRez].[usp_LoadFlatToFF]
	(
		@Container NVARCHAR(127),
		@FileName NVARCHAR(127),
		@ZeroRezGroupId BIGINT
	)
AS
BEGIN

	BEGIN TRY
		DECLARE
			@Sql					NVARCHAR(MAX),		       
			@filepath    			NVARCHAR(255),          		
			@TableName   			NVARCHAR(127),  			         
			@SourceContainerURL		NVARCHAR(MAX),          
			@ArchiveContainerURL	NVARCHAR(MAX),
			@LogTaskID				BIGINT,
			@LogTaskIdheader		BIGINT,
			@TotalRowCount			INT      			    			    						

		SET		@TableName = '[ZeroRez].[vw_ZeroRez]'
		SET  	@filepath    			= @container          
		SET  	@container    			= SUBSTRING(RIGHT(@Container, LEN(@Container) - 1) ,1,CHARINDEX('/',RIGHT(@Container, LEN(@Container) - 1))- 1 )          		         
		SET  	@SourceContainerURL  	= 'https://contata.blob.core.windows.net/' + @Container          
		SET  	@ArchiveContainerURL 	= 'https://contata.blob.core.windows.net/' + REPLACE(@Container,'source','archive')          

		IF EXISTS(SELECT 1 FROM sys.external_data_sources WHERE name = @container)          
			SET @sql ='DROP EXTERNAL DATA SOURCE '+ @container     
			print  @sql  
			EXEC SP_EXECUTESQL @sql  

		SET @sql = 'CREATE EXTERNAL DATA SOURCE '+@container+ '
			WITH ( TYPE = BLOB_STORAGE, LOCATION = '''+ @SourceContainerURL+''');'  
			print @sql
			EXEC SP_EXECUTESQL @sql

		INSERT INTO LogTaskControlFlow(GroupId, StartTime,FeedName, FeedStatus) 
		VALUES (@ZeroRezGroupId,GETDATE(),'ZeroRez Feed', 'ZeroRez file load in progress')      

		SELECT @LogTaskId=MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez feed'
		BEGIN TRAN
			
			SET @sql= 'BULK INSERT ' + @TableName + ' FROM '''+ @FileName + ''' WITH (DATA_SOURCE = '''+@container+''', FORMAT = ''CSV'', FIELDTERMINATOR  = '','', FIRSTROW = 2);'          
				print @sql
				EXEC SP_EXECUTESQL @sql 

			INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus) 
			VALUES (@ZeroRezGroupId, 'Address', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')  

			SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Address'

			INSERT INTO ZeroRez.tblAddress_FF
			(
				 Street1
				,Street2
				,City
				,State
				,Postal_code
				,ZeroRezID
				,LogtaskId
				,ModifiedDate
			)
			SELECT DISTINCT 
				Street1
				,Street2
				,City
				,State
				,postal_code
				,IZeroRezId
				,@LogTaskIdheader
				,GETDATE()
			FROM ZeroRez.ZeroRez_bcp

			SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblAddress_FF WHERE logTaskId = @LogTaskIdheader  
	
			UPDATE  LogTaskControlFlow 
			SET StagingTotalRows = @TotalRowCount 
			WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Address' 

			INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus) 
			VALUES (@ZeroRezGroupId, 'Email', GETDATE(), 'ZeroRez File', 'ZeroRez data load in progress')

			SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Email'

			INSERT INTO	ZeroRez.tblEmail_FF
			(
				Email
				,ZeroRezID
				,LogtaskId
				,ModifiedDate
			)
			SELECT DISTINCT 
				e.Value
				,IZeroRezId  
				,@LogTaskIdheader
				,GETDATE()
			FROM ZeroRez.ZeroRez_bcp z
			OUTER APPLY STRING_SPLIT(z.emails, '|') e

			
			SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblEmail_FF WHERE logTaskId = @LogTaskIdheader  
	
			UPDATE  LogTaskControlFlow 
			SET StagingTotalRows = @TotalRowCount 
			WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Email' 

			INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus) 
			VALUES (@ZeroRezGroupId, 'Phone', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')

			SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Phone'
			
			INSERT INTO  ZeroRez.tblPhone_FF
			(
				PhoneNumber
				,ZeroRezID
				,LogtaskId
				,ModifiedDate
			)
			SELECT DISTINCT 
				p.value as phones
				,IZeroRezId
				,@LogTaskIdheader
				,GETDATE()
			FROM ZeroRez.ZeroRez_bcp
			OUTER APPLY STRING_SPLIT(phones, '|') p

			SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblPhone_FF WHERE logTaskId = @LogTaskIdheader  
	
			UPDATE  LogTaskControlFlow 
			SET StagingTotalRows = @TotalRowCount 
			WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Phone' 

			INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus) 
			VALUES (@ZeroRezGroupId, 'ClientTags', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')

			SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'ClientTags'

			INSERT INTO ZeroRez.tblClientTags_FF
			(
				ClientTags
				,ZeroRezID
				,LogtaskId
				,ModifiedDate
			)
			SELECT DISTINCT 
			c.value AS client_tags
			,IZeroRezId
			,@LogTaskIdheader
			,GETDATE()
			FROM ZeroRez.ZeroRez_bcp
			OUTER APPLY STRING_SPLIT(client_tags, '|') c

			SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblClientTags_FF WHERE logTaskId = @LogTaskIdheader  
	
			UPDATE  LogTaskControlFlow 
			SET StagingTotalRows = @TotalRowCount 
			WHERE logTaskId= @LogTaskIdheader AND Subheader = 'ClientTags' 

			INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus) 
			VALUES (@ZeroRezGroupId, 'NetPromoterLabels', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')

			SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'NetPromoterLabels'

			INSERT INTO ZeroRez.tblNetPromoterLabels_FF
			(
				NetPromoterLabels
				,ZeroRezID
				,LogtaskId
				,ModifiedDate
			)
			SELECT DISTINCT
				 n.value AS net_promoter_labels
				 ,IZeroRezId
				 ,@LogTaskIdheader
				 ,GETDATE()
			FROM ZeroRez.ZeroRez_bcp
			OUTER APPLY STRING_SPLIT(net_promoter_labels, '|') n

			SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblClientTags_FF WHERE logTaskId = @LogTaskIdheader  
	
			UPDATE  LogTaskControlFlow 
			SET StagingTotalRows = @TotalRowCount 
			WHERE logTaskId= @LogTaskIdheader AND Subheader = 'NetPromoterLabels' 

			INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus) 
			VALUES (@ZeroRezGroupId, 'Source', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')

			SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Source'
			INSERT INTO  ZeroRez.tblSource_FF
			(
				[Source]
				,ZeroRezID
				,LogtaskId
				,ModifiedDate
			)
			SELECT DISTINCT 
				s.value AS [Source]
				,IZeroRezId
				,@LogTaskIdheader
				,GETDATE()
			FROM ZeroRez.ZeroRez_bcp
			OUTER APPLY STRING_SPLIT(source, '|') s

			SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblSource_FF WHERE logTaskId = @LogTaskIdheader  
	
			UPDATE  LogTaskControlFlow 
			SET StagingTotalRows = @TotalRowCount 
			WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Source' 

			INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus) 
			VALUES (@ZeroRezGroupId, 'Product', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')

			SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'Product'

			INSERT INTO ZeroRez.tblProducts_FF
			(
				Products
				,ZeroRezID
				,LogtaskId
				,ModifiedDate)
			SELECT DISTINCT 
				pr.Value AS Products
				,IZeroRezID
				,@LogTaskIdheader
				,GETDATE()
			FROM ZeroRez.ZeroRez_bcp
			OUTER APPLY STRING_SPLIT(products, '|') pr

			SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblSource_FF WHERE logTaskId = @LogTaskIdheader  
	
			UPDATE  LogTaskControlFlow 
			SET StagingTotalRows = @TotalRowCount 
			WHERE logTaskId= @LogTaskIdheader AND Subheader = 'Product' 

			INSERT INTO LogTaskControlFlow(GroupId, Subheader, StartTime,  FeedName, FeedStatus) 
			VALUES (@ZeroRezGroupId, 'ZeroRezJob', GETDATE(),  'ZeroRez File', 'ZeroRez data load in progress')

			SELECT @LogTaskIdheader = MAX(LogTaskId) FROM LogTaskControlFlow WHERE GroupId=@ZeroRezGroupId AND FeedName = 'ZeroRez File' AND Subheader = 'ZeroRezJob'

			INSERT INTO  ZeroRez.tblZeroRez_FF
			(
				ZeroRezID
				,First_Name
				,Last_Name
				,Zones
				,Job_Count
				,Last_Service_Date
				,LifeTime_Total
				,LogtaskId
				,ModifiedDate
			)
			SELECT DISTINCT 
				IZeroRezId
				,first_name
				,last_name
				,zones
				,job_count
				,last_service_date
				,Lifetime_total
				,@LogTaskIdheader
				,GETDATE()
			FROM ZeroRez.ZeroRez_bcp

			SELECT @TotalRowCount =COUNT(1) FROM ZeroRez.tblSource_FF WHERE logTaskId = @LogTaskIdheader  
	
			UPDATE  LogTaskControlFlow 
			SET StagingTotalRows = @TotalRowCount 
			WHERE logTaskId= @LogTaskIdheader AND Subheader = 'ZeroRezJob' 

		COMMIT TRAN

			
		--Update LogTaskControlFlow set EndTime=GETDATE() WHERE LogTaskID=@LogTaskId
		Select 1
		RETURN 1        
	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT>0
			ROLLBACK

		IF EXISTS(SELECT 1 FROM sys.external_data_sources WHERE name = @container )         
		set @sql='DROP EXTERNAL DATA SOURCE '+ @container     
		EXEC SP_EXECUTESQL @sql  
    
		INSERT INTO LogError (          
					objectName          
					,ErrorCode          
					,ErrorDescription          
					,ErrorGenerationTime             
				)          
          
		SELECT -- autogenerated            
			 OBJECT_NAME(@@PROCID)            
			,ERROR_NUMBER() AS ErrorCode            
			,'For File ' + @Container + ' ' + @FileName          
			+' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))            
			+' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))            
			+' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))            
			+' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription            
			,GETDATE()                              
		RETURN -1 	
	END CATCH 
END	
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadIntermmediateDimensions]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [ZeroRez].[usp_LoadIntermmediateDimensions]  
AS  
BEGIN  
 BEGIN TRY  
  DECLARE @Counter TABLE(LogTaskID BIGINT)  
  DECLARE @LogTaskId BIGINT  
  
  INSERT INTO @Counter   
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblAddress_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblClientTags_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblNetPromoterLabels_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblPhone_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblProducts_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblSource_DT] WHERE LogTaskId IS NOT NULL  
  UNION  
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblZeroRez_DT] WHERE LogTaskId IS NOT NULL
  UNION
  SELECT DISTINCT LogTaskID  
  FROM [ZeroRez].[tblEmail_DT] WHERE LogTaskId IS NOT NULL
  
  BEGIN TRAN  
  WHILE EXISTS(SELECT 1 FROM @Counter)  
  BEGIN  
    SET @LogTaskId=(SELECT TOP 1 LogtaskID from @Counter)  
      
	MERGE INTO [ZeroRez].[DimClientAddressZoneGroup] AS T
	USING
	(
		  SELECT DISTINCT 
			C.DedupZeroRezId AS ClientID,
			S.IAddressId AS AddressID,
			Z.IZonesId AS ZoneID,
			sa.IZerorezStandardAddressApiId AS StandardAddressId,
			T.ZeroRezID AS ClientAddZoneGrpID,
			T.ZeroRezID AS DedupClientAddressZoneGroupId
		FROM [ZeroRez].DimAddress S
		INNER JOIN [ZeroRez].tblAddress_DT T
		ON  ISNULL(S.Street1, '') = REPLACE(LTRIM(RTRIM(ISNULL(T.Street1, ''))),'  ',' ')
		AND ISNULL(S.Street2, '') = REPLACE(LTRIM(RTRIM(ISNULL(T.Street2, ''))),'  ',' ')
		AND ISNULL(S.City, '')	  = REPLACE(LTRIM(RTRIM(ISNULL(T.City, ''))),'  ',' ')
		AND ISNULL(S.State, '')   = REPLACE(LTRIM(RTRIM(ISNULL(T.State, ''))),'  ',' ')
		AND ISNULL(S.Zip, '')     = REPLACE(LTRIM(RTRIM(ISNULL(T.Postal_code, ''))),'  ',' ')
		INNER JOIN [ZeroRez].tblZeroRez_DT DT
		ON DT.ZeroRezID = T.ZeroRezID
		INNER JOIN [ZeroRez].DimClient C 
		ON	DT.ZeroRezID = C.DedupZeroRezId
		INNER JOIN [ZeroRez].DimZones Z
		ON ISNULL(DT.Zones, '') = ISNULL(Z.Zones, '')
		INNER JOIN zerorez.[tblZerorezStandardAddressApi] sa
		ON sa.iZeroRezId = T.ZeroRezId
	)AS S
	ON 	S.ClientID							=T.ClientID
		AND S.AddressID						=T.AddressID
		AND S.ZoneID						=T.ZoneID
		AND S.StandardAddressId				=T.StandardAddressId
		AND S.ClientAddZoneGrpID			=T.ClientAddZoneGrpID
		AND S.DedupClientAddressZoneGroupId	=T.DedupClientAddressZoneGroupId
	WHEN NOT MATCHED THEN
	INSERT (
				ClientID
				,AddressID
				,ZoneID
				,StandardAddressId
				,ClientAddZoneGrpID
				,DedupClientAddressZoneGroupId
				,CreatedDate
				,CreatedBy
			)
	VALUES (
				 S.ClientID
				,S.AddressID
				,S.ZoneID
				,S.StandardAddressId
				,S.ClientAddZoneGrpID
				,S.DedupClientAddressZoneGroupId
				,GETDATE()
				,@LogTaskID
			);
	
	UPDATE T SET DedupClientAddressZoneGroupId = DedupZeroRezId
	FROM [ZeroRez].DimClientAddressZoneGroup T
	INNER JOIN ZeroRez.DimDedupZeroRez DD
	ON DD.ZeroRezId = T.ClientAddZoneGrpID

    MERGE INTO [ZeroRez].[DimEmailGroup] AS T  
     USING  
     (  
      SELECT DISTINCT DS.IEmailID AS EmailID  
     , ZeroRezID AS EmailGroupID  
     FROM [ZeroRez].[tblEmail_DT] DT  
     INNER JOIN  [ZeroRez].[DimEmail] DS on ISNULL(DT.Email,'')=ISNULL(DS.Email,'')  
     WHERE DT.LogTaskID=@LogTaskID  
      ) AS S  
     ON S.EmailID=T.EmailID  
     AND S.EmailGroupID=T.EmailGroupID  
     WHEN NOT MATCHED THEN  
     INSERT(EmailID,EmailGroupID,DedupEmailGroupId,CreatedDate)  
     VALUES(S.EmailID,S.EmailGroupID,S.EmailGroupID,GETDATE());  
  
     UPDATE T SET DedupEmailGroupId = DedupZeroRezId  
     FROM [ZeroRez].[DimEmailGroup] T  
     INNER JOIN ZeroRez.DimDedupZeroRez DD  
     ON DD.ZeroRezId = T.EmailGroupId  
  
     MERGE INTO [ZeroRez].[DimPhoneGroup] AS T  
     USING  
     (  
      SELECT DISTINCT DS.IPhoneID AS PhoneID  
     , ZeroRezID AS PhoneGroupID  
     FROM [ZeroRez].[tblPhone_DT] DT  
     INNER JOIN  [ZeroRez].[DimPhone] DS on ISNULL(DT.PhoneNumber,'')=ISNULL(DS.Phone,'')  
     WHERE DT.LogTaskID=@LogTaskID  
      ) AS S  
     ON S.PhoneID=T.PhoneID  
     AND S.PhoneGroupID=T.PhoneGroupID  
     WHEN NOT MATCHED THEN  
     INSERT(PhoneID,PhoneGroupID,DedupPhoneGroupId,CreatedDate)  
     VALUES(S.PhoneID,S.PhoneGroupID,S.PhoneGroupID,GETDATE());  
  
     UPDATE T SET DedupPhoneGroupId = DedupZeroRezId  
     FROM [ZeroRez].[DimPhoneGroup] T  
     INNER JOIN ZeroRez.DimDedupZeroRez DD  
     ON DD.ZeroRezId = T.PhoneGroupId  
  
     MERGE INTO [ZeroRez].[DimSourceGroup] AS T  
     USING  
     (  
      SELECT DISTINCT DS.ISourceID AS SourceID  
     , ZeroRezID AS SourceGroupID  
     FROM [ZeroRez].[tblSource_DT] DT  
     INNER JOIN  [ZeroRez].[DimSource] DS on ISNULL(DT.Source,'')=ISNULL(DS.Source,'')  
     WHERE DT.LogTaskID=@LogTaskID  
      ) AS S  
     ON S.SourceID=T.SourceID  
     AND S.SourceGroupID=T.SourceGroupID  
     WHEN NOT MATCHED THEN  
     INSERT(SourceID,SourceGroupID,DedupSourceGroupId,CreatedDate)  
     VALUES(S.SourceID,S.SourceGroupID,S.SourceGroupID,GETDATE());  
  
     UPDATE T SET DedupSourceGroupId = DedupZeroRezId  
     FROM [ZeroRez].DimSourceGroup T  
     INNER JOIN ZeroRez.DimDedupZeroRez DD  
     ON DD.ZeroRezId = T.SourceGroupId  
     
    MERGE INTO [ZeroRez].[DimNetPromoterLabelsGroup]  AS T  
    USING  
    (  
     SELECT DISTINCT  DS.INetPromoterLabelsId AS NetPromoterLabelsId  
     ,ZeroRezID AS NetPromoterLabelsGroupId  
     FROM [ZeroRez].tblNetPromoterLabels_DT DT  
     INNER JOIN  [ZeroRez].[DimNetPromoterLabels] DS   
     ON ISNULL(DT.NetPromoterLabels,'')=ISNULL(DS.NetPromoterLabels,'')  
     WHERE DT.LogTaskID=@LogTaskID  
       
    )  
    AS S  
    ON S.NetPromoterLabelsId=T.NetPromoterLabelsId  
    AND S.NetPromoterLabelsGroupId=T.NetPromoterLabelsGroupId  
    WHEN NOT MATCHED THEN  
    INSERT(NetPromoterLabelsId,NetPromoterLabelsGroupId,DedupNetPromoterLabelsGroupId,CreatedDate)  
    VALUES(S.NetPromoterLabelsId,S.NetPromoterLabelsGroupId,S.NetPromoterLabelsGroupId,GETDATE());    
    UPDATE T SET DedupNetPromoterLabelsGroupId = DedupZeroRezId  
    FROM [ZeroRez].DimNetPromoterLabelsGroup T  
    INNER JOIN ZeroRez.DimDedupZeroRez DD  
    ON DD.ZeroRezId = T.NetPromoterLabelsGroupId   
    
    MERGE INTO [ZeroRez].[DimClientTagGroup]  AS T  
    USING  
    (  
     SELECT DISTINCT  DS.IClientTagId AS ClientTagId  
     ,ZeroRezID AS ClientTagGroupId  
     FROM [ZeroRez].tblClientTags_DT DT  
     INNER JOIN  [ZeroRez].[DimClientTags] DS on ISNULL(DT.ClientTags,'')=ISNULL(DS.ClientTag,'')  
     WHERE LogTaskID=@LogTaskID  
    )  
    AS S  
    ON S.ClientTagId=T.ClientTagId  
    AND S.ClientTagGroupId=T.ClientTagGroupId  
    WHEN NOT MATCHED THEN  
    INSERT(ClientTagId,ClientTagGroupId,DedupClientTagGroupId,CreatedDate)  
    VALUES(S.ClientTagId,S.ClientTagGroupId,S.ClientTagGroupId,GETDATE());  
  
    UPDATE T SET DedupClientTagGroupId = DedupZeroRezId  
    FROM [ZeroRez].DimClientTagGroup T  
    INNER JOIN ZeroRez.DimDedupZeroRez DD  
    ON DD.ZeroRezId = T.ClientTagGroupId  
  
    MERGE INTO [ZeroRez].[DimProductGroup]  AS T  
    USING  
    (  
     SELECT DISTINCT  DS.IProductId AS ProductId  
     ,ZeroRezID AS ProductGroupId  
     FROM [ZeroRez].tblProducts_DT DT  
     INNER JOIN  [ZeroRez].[DimProduct] DS on ISNULL(DT.Products,'')=ISNULL(DS.Product,'')  
     WHERE LogTaskID=@LogTaskID  
    )  
    AS S  
    ON S.ProductId=T.ProductId  
    AND S.ProductGroupId=T.ProductGroupId  
    WHEN NOT MATCHED THEN  
    INSERT(ProductId,ProductGroupId,DedupProductGroupId,CreatedDate)  
    VALUES(S.ProductId,S.ProductGroupId,S.ProductGroupId,GETDATE());  
  
    UPDATE T SET DedupProductGroupId = DedupZeroRezId  
    FROM [ZeroRez].DimProductGroup T  
    INNER JOIN ZeroRez.DimDedupZeroRez DD  
    ON DD.ZeroRezId = T.ProductGroupId  
      
    DELETE FROM @counter where LogTaskId=@LogTaskId  
  END  
  COMMIT TRAN  
  RETURN 1  
 END TRY  
 BEGIN CATCH  
  IF @@TRANCOUNT>0  
   ROLLBACK  
  
  INSERT INTO LogError (            
     objectName            
     ,ErrorCode            
     ,ErrorDescription            
     ,ErrorGenerationTime               
    )            
            
  SELECT -- autogenerated              
    OBJECT_NAME(@@PROCID)              
   ,ERROR_NUMBER() AS ErrorCode              
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))              
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))              
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))              
   +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription              
   ,GETDATE()                                
  RETURN -1    
 END CATCH  
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_LoadIntermmediateDimensions2]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
CREATE PROCEDURE [ZeroRez].[usp_LoadIntermmediateDimensions2]    
AS    
BEGIN
SET NOCOUNT ON  
 BEGIN TRY    
  DECLARE @Counter TABLE(LogTaskID BIGINT)    
  DECLARE @LogTaskId BIGINT    
    
  --INSERT INTO @Counter     
  --SELECT DISTINCT LogTaskID    
  --FROM [ZeroRez].[tblAddress_DT] WHERE LogTaskId IS NOT NULL    
  --UNION    
  --SELECT DISTINCT LogTaskID    
  --FROM [ZeroRez].[tblClientTags_DT] WHERE LogTaskId IS NOT NULL    
  --UNION    
  --SELECT DISTINCT LogTaskID    
  --FROM [ZeroRez].[tblNetPromoterLabels_DT] WHERE LogTaskId IS NOT NULL    
  --UNION    
  --SELECT DISTINCT LogTaskID    
  --FROM [ZeroRez].[tblPhone_DT] WHERE LogTaskId IS NOT NULL    
  --UNION    
  --SELECT DISTINCT LogTaskID    
  --FROM [ZeroRez].[tblProducts_DT] WHERE LogTaskId IS NOT NULL    
  --UNION    
  --SELECT DISTINCT LogTaskID    
  --FROM [ZeroRez].[tblSource_DT] WHERE LogTaskId IS NOT NULL    
  --UNION    
  --SELECT DISTINCT LogTaskID    
  --FROM [ZeroRez].[tblZeroRez_DT] WHERE LogTaskId IS NOT NULL  
  --UNION  
  --SELECT DISTINCT LogTaskID    
  --FROM [ZeroRez].[tblEmail_DT] WHERE LogTaskId IS NOT NULL  
    
  BEGIN TRAN    
  --WHILE EXISTS(SELECT 1 FROM @Counter)    
  --BEGIN    
  --  SET @LogTaskId=(SELECT TOP 1 LogtaskID from @Counter)    
        
 INSERT INTO [ZeroRez].[DimClientAddressZoneGroup]  
 (  
  ClientID  
  ,AddressID  
  ,ZoneID  
  ,StandardAddressId  
  ,ClientAddZoneGrpID  
  ,DedupClientAddressZoneGroupId  
  ,CreatedDate  
  ,CreatedBy  
 )  
 SELECT DISTINCT   
   C.DedupZeroRezId AS ClientID,  
   S.IAddressId AS AddressID,  
   Z.IZonesId AS ZoneID,  
   sa.IZerorezStandardAddressApiId AS StandardAddressId,  
   DTA.ZeroRezID AS ClientAddZoneGrpID,  
   DTA.ZeroRezID AS DedupClientAddressZoneGroupId,  
   GETDATE(),  
   -1  
  
 FROM [ZeroRez].DimAddress S  
 INNER JOIN [ZeroRez].tblAddress_DT DTA  
  ON  ISNULL(S.Street1, '') = REPLACE(LTRIM(RTRIM(ISNULL(DTA.Street1, ''))),'  ',' ')  
  AND ISNULL(S.Street2, '') = REPLACE(LTRIM(RTRIM(ISNULL(DTA.Street2, ''))),'  ',' ')  
  AND ISNULL(S.City, '')   = REPLACE(LTRIM(RTRIM(ISNULL(DTA.City, ''))),'  ',' ')  
  AND ISNULL(S.State, '')   = REPLACE(LTRIM(RTRIM(ISNULL(DTA.State, ''))),'  ',' ')  
  AND ISNULL(S.Zip, '')     = REPLACE(LTRIM(RTRIM(ISNULL(DTA.Postal_code, ''))),'  ',' ')  
  INNER JOIN [ZeroRez].tblZeroRez_DT DT  
  ON DT.ZeroRezID = DTA.ZeroRezID  
  INNER JOIN [ZeroRez].DimClient C   
  ON DT.ZeroRezID = C.DedupZeroRezId  
  INNER JOIN [ZeroRez].DimZones Z  
  ON ISNULL(DT.Zones, '') = ISNULL(Z.Zones, '')  
  INNER JOIN zerorez.[tblZerorezStandardAddressApi] sa  
  ON sa.iZeroRezId = DTA.ZeroRezId  
 LEFT JOIN [ZeroRez].[DimClientAddressZoneGroup] T  
  ON  C.DedupZeroRezId    =T.ClientID  
  AND S.IAddressId     =T.AddressID  
  AND Z.IZonesId      =T.ZoneID  
  AND sa.IZerorezStandardAddressApiId =T.StandardAddressId  
  AND DTA.ZeroRezID     =T.ClientAddZoneGrpID  
 WHERE T.IClientAddZoneID IS NULL  
   
 UPDATE T SET DedupClientAddressZoneGroupId = DedupZeroRezId  
 FROM [ZeroRez].DimClientAddressZoneGroup T  
 INNER JOIN ZeroRez.DimDedupZeroRez DD  
 ON DD.ZeroRezId = T.ClientAddZoneGrpID  
  
 INSERT INTO [ZeroRez].[DimEmailGroup](EmailID,EmailGroupID, DedupEmailGroupId,CreatedBy,CreatedDate)  
 SELECT DISTINCT DS.IEmailID, ZeroRezID,ZeroRezID,-1,GETDATE()  
    FROM [ZeroRez].[tblEmail_DT] DT    
    INNER JOIN [ZeroRez].[DimEmail] DS ON ISNULL(DT.Email,'')=ISNULL(DS.Email,'')  
 LEFT JOIN [ZeroRez].[DimEmailGroup] T  
 ON DS.IEmailID=T.EmailID    
    AND DT.ZeroRezID=T.EmailGroupID   
 WHERE T.EmailId IS  NULL   
    
    UPDATE T SET DedupEmailGroupId = DedupZeroRezId    
    FROM [ZeroRez].[DimEmailGroup] T    
    INNER JOIN ZeroRez.DimDedupZeroRez DD    
    ON DD.ZeroRezId = T.EmailGroupId    
   
 INSERT INTO [ZeroRez].[DimPhoneGroup](PhoneID,PhoneGroupID,DedupPhoneGroupId,CreatedBy,CreatedDate)  
 SELECT DISTINCT DS.IPhoneID, ZeroRezID,ZeroRezID,-1,GETDATE()  
    FROM [ZeroRez].[tblPhone_DT] DT    
    INNER JOIN [ZeroRez].[DimPhone] DS ON ISNULL(DT.PhoneNumber,'')=ISNULL(DS.Phone,'')  
 LEFT JOIN [ZeroRez].[DimPhoneGroup] T  
 ON DS.IPhoneID=T.PhoneID    
    AND DT.ZeroRezID=T.PhoneGroupID   
 WHERE T.PhoneId IS  NULL   
    
    
     UPDATE T SET DedupPhoneGroupId = DedupZeroRezId    
     FROM [ZeroRez].[DimPhoneGroup] T    
     INNER JOIN ZeroRez.DimDedupZeroRez DD    
     ON DD.ZeroRezId = T.PhoneGroupId    
    
 INSERT INTO [ZeroRez].[DimSourceGroup](SourceID,SourceGroupID,DedupSourceGroupId,CreatedBy,CreatedDate)  
 SELECT DISTINCT DS.ISourceID, ZeroRezID,ZeroRezID,-1,GETDATE()  
    FROM [ZeroRez].[tblSource_DT] DT    
    INNER JOIN [ZeroRez].[DimSource] DS ON ISNULL(DT.Source,'')=ISNULL(DS.Source,'')  
 LEFT JOIN [ZeroRez].[DimSourceGroup] T  
 ON DS.ISourceID=T.SourceID    
    AND DT.ZeroRezID=T.SourceGroupID   
 WHERE T.SourceId IS  NULL   
        
     UPDATE T SET DedupSourceGroupId = DedupZeroRezId    
     FROM [ZeroRez].DimSourceGroup T    
     INNER JOIN ZeroRez.DimDedupZeroRez DD    
     ON DD.ZeroRezId = T.SourceGroupId    
       
 INSERT INTO [ZeroRez].[DimNetPromoterLabelsGroup](NetPromoterLabelsID,NetPromoterLabelsGroupID,DedupNetPromoterLabelsGroupId,CreatedBy,CreatedDate)  
 SELECT DISTINCT DS.INetPromoterLabelsID, ZeroRezID,ZeroRezID,-1,GETDATE()  
    FROM [ZeroRez].[tblNetPromoterLabels_DT] DT    
    INNER JOIN [ZeroRez].[DimNetPromoterLabels] DS ON ISNULL(DT.NetPromoterLabels,'')=ISNULL(DS.NetPromoterLabels,'')  
 LEFT JOIN [ZeroRez].[DimNetPromoterLabelsGroup] T  
 ON DS.INetPromoterLabelsID=T.NetPromoterLabelsID    
    AND DT.ZeroRezID=T.NetPromoterLabelsGroupID   
 WHERE T.NetPromoterLabelsId IS  NULL   
          
    UPDATE T SET DedupNetPromoterLabelsGroupId = DedupZeroRezId    
    FROM [ZeroRez].DimNetPromoterLabelsGroup T    
    INNER JOIN ZeroRez.DimDedupZeroRez DD    
    ON DD.ZeroRezId = T.NetPromoterLabelsGroupId     
      
 INSERT INTO [ZeroRez].[DimClientTagGroup](ClientTagID,ClientTagGroupID,DedupClientTagGroupId,CreatedBy,CreatedDate)  
 SELECT DISTINCT DS.IClientTagID, ZeroRezID,ZeroRezID,-1,GETDATE()  
    FROM [ZeroRez].[tblClientTags_DT] DT    
    INNER JOIN [ZeroRez].[DimClientTags] DS ON ISNULL(DT.ClientTags,'')=ISNULL(DS.ClientTag,'')  
 LEFT JOIN [ZeroRez].[DimClientTagGroup] T  
 ON DS.IClientTagID=T.ClientTagID    
    AND DT.ZeroRezID=T.ClientTagGroupID   
 WHERE T.ClientTagId IS  NULL   
    
    
    UPDATE T SET DedupClientTagGroupId = DedupZeroRezId    
    FROM [ZeroRez].DimClientTagGroup T    
    INNER JOIN ZeroRez.DimDedupZeroRez DD    
    ON DD.ZeroRezId = T.ClientTagGroupId  
   
 INSERT INTO [ZeroRez].[DimProductGroup](ProductID,ProductGroupID,DedupProductGroupId,CreatedBy,CreatedDate)  
 SELECT DISTINCT DS.IProductID, ZeroRezID,ZeroRezID,-1,GETDATE()  
    FROM [ZeroRez].[tblProducts_DT] DT    
    INNER JOIN [ZeroRez].[DimProduct] DS ON ISNULL(DT.Products,'')=ISNULL(DS.Product,'')  
 LEFT JOIN [ZeroRez].[DimProductGroup] T  
 ON DS.IProductID=T.ProductID    
    AND DT.ZeroRezID=T.ProductGroupID   
 WHERE T.ProductId IS  NULL     
      
    
    UPDATE T SET DedupProductGroupId = DedupZeroRezId    
    FROM [ZeroRez].DimProductGroup T    
    INNER JOIN ZeroRez.DimDedupZeroRez DD    
    ON DD.ZeroRezId = T.ProductGroupId    
        
  --  DELETE FROM @counter where LogTaskId=@LogTaskId    
  --END    
  COMMIT TRAN    
  RETURN 1    
 END TRY    
 BEGIN CATCH    
  IF @@TRANCOUNT>0    
   ROLLBACK    
    
  INSERT INTO LogError (              
     objectName              
     ,ErrorCode              
     ,ErrorDescription              
     ,ErrorGenerationTime                 
    )              
              
  SELECT -- autogenerated                
    OBJECT_NAME(@@PROCID)                
   ,ERROR_NUMBER() AS ErrorCode                
   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))                
   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))                
   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))                
   +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription                
   ,GETDATE()                                  
  RETURN -1   
 END CATCH
SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [ZeroRez].[usp_OneTimeData]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ZeroRez].[usp_OneTimeData]
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			IF NOT EXISTS(SELECT 1 FROM ZeroRez.DimProduct)
			BEGIN
				SET IDENTITY_INSERT ZeroRez.DimProduct ON
				INSERT INTO ZeroRez.DimProduct
				(
					IProductId
					,Product
					,CreatedDate
					,CreatedBy
				)
				VALUES (-1,NULL,GETDATE(),-1)
				SET IDENTITY_INSERT ZeroRez.DimProduct OFF
			END

			IF NOT EXISTS(SELECT 1 FROM ZeroRez.DimSource)
			BEGIN
				SET IDENTITY_INSERT ZeroRez.DimSource ON
				INSERT INTO ZeroRez.DimSource
				(
					ISourceId
					,Source
					,CreatedDate
					,CreatedBy
				)
				VALUES (-1,NULL,GETDATE(),-1)
				SET IDENTITY_INSERT ZeroRez.DimSource OFF
			END

			IF NOT EXISTS(SELECT 1 FROM ZeroRez.DimClientTags)
			BEGIN
				SET IDENTITY_INSERT ZeroRez.DimClientTags ON
				INSERT INTO ZeroRez.DimClientTags
				(
					IClientTagId
					,ClientTag
					,CreatedDate
					,CreatedBy
				)
				VALUES (-1,NULL,GETDATE(),-1)
				SET IDENTITY_INSERT ZeroRez.DimClientTags OFF
			END

			IF NOT EXISTS(SELECT 1 FROM ZeroRez.DimNetPromoterLabels)
			BEGIN
				SET IDENTITY_INSERT ZeroRez.DimNetPromoterLabels ON
				INSERT INTO ZeroRez.DimNetPromoterLabels
				(
					INetPromoterLabelsId
					,NetPromoterLabels
					,CreatedDate
					,CreatedBy
				)
				VALUES (-1,NULL,GETDATE(),-1)
				SET IDENTITY_INSERT ZeroRez.DimNetPromoterLabels OFF
			END
		COMMIT TRAN	
		RETURN 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK
		INSERT INTO LogError (            
		 objectName            
		 ,ErrorCode            
		 ,ErrorDescription            
		 ,ErrorGenerationTime               
		)            
	  SELECT       
		OBJECT_NAME(@@PROCID)              
	   ,ERROR_NUMBER() AS ErrorCode              
	   ,' Error of Severity: ' + CAST (ERROR_SEVERITY() AS VARCHAR (4))              
	   +' and State: ' + CAST (ERROR_STATE() AS VARCHAR (8))              
	   +' occured in Line: ' + CAST (ERROR_LINE() AS VARCHAR (10))              
	   +' with following Message: ' + ERROR_MESSAGE() AS ErrorColumnDescription              
	   ,GETDATE()                                
	  RETURN -1    
	END CATCH
END


GO
/****** Object:  StoredProcedure [ZeroRez].[uspLoadFFToDT]    Script Date: 1/30/2018 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ZeroRez].[uspLoadFFToDT]
AS
BEGIN
    BEGIN TRY
		DECLARE @ModifiedDate DATETIME
		SET @ModifiedDate=GETDATE()
        INSERT INTO ZeroRez.tblAddress_DT(
			Street1
			,Street2
			,City
			,State
			,Postal_code
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
		)
        SELECT 
			Street1
            ,Street2
            ,City
            ,State
            ,Postal_code
            ,ZeroRezID
            ,LogtaskId
            ,GETDATE()
        FROM ZeroRez.tblAddress_FF
        WHERE GoodToImport=1

		  UPDATE L   SET StagingTotalRowsPassed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblAddress_DT GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId
		       
        INSERT INTO ZeroRez.tblAddress_AE(
			Street1
			,Street2
			,City
			,State
			,Postal_code
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
			,GoodToImport
			,ErrorDescription
		)
        SELECT 
			Street1
            ,Street2
            ,City
            ,State
            ,Postal_code
            ,ZeroRezID
            ,LogtaskId
            ,@ModifiedDate
            ,GoodToImport
            ,ErrorDescription
        FROM ZeroRez.tblAddress_FF
        WHERE GoodToImport=0

		UPDATE L   SET StagingTotalRowsFailed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblAddress_AE GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblClientTags_DT(
			ClientTags		
			,ZeroRezID		
			,LogtaskId		
			,ModifiedDate		
			
		)
        SELECT 
			ClientTags		
			,ZeroRezID		
			,LogtaskId		
			,@ModifiedDate		
			
        FROM ZeroRez.tblClientTags_FF
        WHERE GoodToImport=1
		
		UPDATE L   SET StagingTotalRowsPassed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblClientTags_DT GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

        INSERT INTO ZeroRez.tblClientTags_AE(
			ClientTags		
			,ZeroRezID		
			,LogtaskId		
			,ModifiedDate	
			,GoodToImport	
			,ErrorDescription
		)
        SELECT 
			ClientTags		
			,ZeroRezID		
			,LogtaskId		
			,@ModifiedDate
			,GoodToImport	
			,ErrorDescription
        FROM ZeroRez.tblClientTags_FF
        WHERE GoodToImport=0
			
		UPDATE L   SET StagingTotalRowsFailed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblClientTags_AE GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblEmail_DT(
			Email			
			,ZeroRezID		
			,LogtaskId		
			,ModifiedDate		
		)
        SELECT 
			Email			
			,ZeroRezID		
			,LogtaskId		
			,@ModifiedDate	
        FROM ZeroRez.tblEmail_FF
        WHERE GoodToImport=1

			
		UPDATE L   SET StagingTotalRowsPassed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblEmail_DT GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

        INSERT INTO ZeroRez.tblEmail_AE(
			Email			
			,ZeroRezID		
			,LogtaskId		
			,ModifiedDate
			,GoodToImport
			,ErrorDescription
		)
        SELECT 
			Email			
			,ZeroRezID		
			,LogtaskId		
			,@ModifiedDate	
			,GoodToImport
			,ErrorDescription
        FROM ZeroRez.tblEmail_FF
        WHERE GoodToImport=0

		 UPDATE L   SET StagingTotalRowsFailed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblEmail_AE GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblPhone_DT
		(
			PhoneNumber
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
		)
		SELECT PhoneNumber
			,ZeroRezID
			,LogtaskId
			,@ModifiedDate
		FROM ZeroRez.tblPhone_FF
		WHERE GoodToImport=1

		 UPDATE L   SET StagingTotalRowsPassed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblPhone_DT GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblPhone_AE
		(
			PhoneNumber
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
			,GoodToImport
			,ErrorDescription
		)
		SELECT PhoneNumber
			,ZeroRezID
			,LogtaskId
			,@ModifiedDate
			,GoodToImport
			,ErrorDescription
		FROM ZeroRez.tblPhone_FF
		WHERE GoodToImport=0

		 UPDATE L   SET StagingTotalRowsFailed=DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblPhone_AE GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblNetPromoterLabels_DT
		(
			NetPromoterLabels
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
		)
		SELECT 
			NetPromoterLabels
			,ZeroRezID
			,LogtaskId
			,@ModifiedDate
		FROM ZeroRez.tblNetPromoterLabels_FF
		WHERE GoodToImport=1

		 UPDATE L   SET StagingTotalRowsPassed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblNetPromoterLabels_DT GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblNetPromoterLabels_AE
		(
			NetPromoterLabels
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
			,GoodToImport
			,ErrorDescription
		)
		SELECT NetPromoterLabels
			,ZeroRezID
			,LogtaskId
			,@ModifiedDate
			,GoodToImport
			,ErrorDescription
		FROM ZeroRez.tblNetPromoterLabels_FF
		WHERE GoodToImport=0

		UPDATE L   SET StagingTotalRowsFailed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblNetPromoterLabels_AE GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblProducts_DT
		(
			 Products
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
			
		)
		SELECT  Products
			,ZeroRezID
			,LogtaskId
			,@ModifiedDate
			
		FROM ZeroRez.tblProducts_FF WHERE GoodToImport=1

		UPDATE L   SET StagingTotalRowsPassed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblProducts_DT GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblProducts_AE
		(
			 Products
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
			,GoodToImport
			,ErrorDescription
		)
		SELECT  Products
			,ZeroRezID
			,LogtaskId
			,@ModifiedDate
			,GoodToImport
			,ErrorDescription
			FROM ZeroRez.tblProducts_FF WHERE GoodToImport=0

		
		UPDATE L   SET StagingTotalRowsFailed=DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblProducts_AE GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERT INTO ZeroRez.tblSource_DT
		(
			Source
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
		)
		SELECT Source
			,ZeroRezID
			,LogtaskId
			,@ModifiedDate
		FROM ZeroRez.tblSource_FF WHERE GoodToImport=1

		
		UPDATE L   SET StagingTotalRowsPassed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblSource_DT GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId


		INSERT INTO ZeroRez.tblSource_AE
		(
			Source
			,ZeroRezID
			,LogtaskId
			,ModifiedDate
			,GoodToImport
			,ErrorDescription
		)
		SELECT Source
			,ZeroRezID
			,LogtaskId
			,@ModifiedDate
			,GoodToImport
			,ErrorDescription
		FROM ZeroRez.tblSource_FF WHERE GoodToImport=0

		
		 UPDATE L   SET StagingTotalRowsFailed= DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblSource_AE GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERt INTO ZeroRez.tblZeroRez_DT
		(
			First_Name
			,Last_Name
			,Zones
			,Job_Count
			,Last_Service_Date
			,LifeTime_Total
			,LogtaskId
			,ModifiedDate
			
		)
		SELECT First_Name
			,Last_Name
			,Zones
			,Job_Count
			,Last_Service_Date
			,LifeTime_Total
			,LogtaskId
			,@ModifiedDate
			
		FROM ZeroRez.tblZeroRez_FF WHERE GoodToImport=1

		
		UPDATE L   SET StagingTotalRowsPassed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblZeroRez_DT GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId

		INSERt INTO ZeroRez.tblZeroRez_AE
		(
			First_Name
			,Last_Name
			,Zones
			,Job_Count
			,Last_Service_Date
			,LifeTime_Total
			,LogtaskId
			,ModifiedDate
			,GoodToImport
			,ErrorDescription
		)
		SELECT First_Name
			,Last_Name
			,Zones
			,Job_Count
			,Last_Service_Date
			,LifeTime_Total
			,LogtaskId
			,@ModifiedDate
			,GoodToImport
			,ErrorDescription
		FROM ZeroRez.tblZeroRez_FF WHERE GoodToImport=0

		
		UPDATE L   SET StagingTotalRowsFailed=   DT.cnt ,EndTime=GetDate()              
		  FROM LogtaskControlFlow L join               
		 ( SELECT COUNT(1) AS cnt ,logtaskId FROM ZeroRez.tblZeroRez_AE GROUP BY logtaskId) DT ON  L.LogTaskID=DT.LogTaskId              
		  WHERE L. LogTaskID= DT.LogTaskId
		
		TRUNCATE TABLE [ZeroRez].[tblAddress_FF]
		TRUNCATE TABLE [ZeroRez].[tblClientTags_FF]
		TRUNCATE TABLE [ZeroRez].[tblEmail_FF]
		TRUNCATE TABLE [ZeroRez].[tblNetPromoterLabels_FF]
		TRUNCATE TABLE [ZeroRez].[tblPhone_FF]
		TRUNCATE TABLE [ZeroRez].[tblProducts_FF]
		TRUNCATE TABLE [ZeroRez].[tblSource_FF]
		TRUNCATE TABLE [ZeroRez].[tblZeroRez_FF]
		DELETE FROM [ZeroRez].[ZeroRez_bcp]
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
GO
