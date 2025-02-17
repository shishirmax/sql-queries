 
ALTER  PROCEDURE [Edina].[usp_CheckBusinessRule]   
AS    
BEGIN    
    
 BEGIN TRY    
    
  BEGIN TRAN    
       
   DECLARE @column as nvarchar(200),@sql as nvarchar(max)  
    
   UPDATE FF SET PhoneNumber= dbo.[FN_REMOVE_SPECIAL_CHARACTER] (FF.PhoneNumber)   
   FROM Edina.[tblEdinaWebsiteData_FF]  FF   

   UPDATE Edina.tblEdinaEmailResults_FF    
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
	 
	UPDATE tblEdinaEmailResults_FF SET Firstname=REPLACE(FirstName,'"',''),
	LastName=REPLACE(LastName,'"','')
   UPDATE Edina.tblEdinaWebsiteData_FF    
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
    
    
   UPDATE Edina.tblEdinaWebsiteData_FF    
   SET GoodToImport  = 0    
    ,ErrorDescription = ISNULL(ErrorDescription, '|') + '|' + 'Invalid daytimePhone provided'    
   WHERE SUBSTRING(PhoneNumber, 1, 1) NOT IN  ('1', '+', '0')-- skip foreign phone    
     AND     
     (    
      PhoneNumber NOT LIKE '[2-9][0-8][0-9][2-9][0-9][0-9][0-9][0-9][0-9][0-9][x][0-9][0-9][0-9]' -- with three extension with x    
      AND PhoneNumber NOT LIKE '[2-9][0-8][0-9][2-9][0-9][0-9][0-9][0-9][0-9][0-9][x][0-9][0-9]' -- with two extension with x    
      AND PhoneNumber NOT LIKE '[2-9][0-8][0-9][2-9][0-9][0-9][0-9][0-9][0-9][0-9][x][0-9]' -- with one extension with x    
      AND PhoneNumber NOT LIKE '[1][0-9][0-9][2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' -- with one extension    
      AND PhoneNumber NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'    
     )    
    
    UPDATE Edina.tblEdinaSales_FF    
    SET GoodToImport  = 0    
    ,ErrorDescription = ISNULL(ErrorDescription, '') + '|' + 'Invalid Zip provided'    
    WHERE    
    zip NOT LIKE '[0-9][0-9][0-9][0-9][0-9]'     
    AND zip NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'      
    AND zip NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
	
	/* Update script to check BuyerEmail from Edina.tblEdinaSales_FF */
	UPDATE Edina.tblEdinaSales_FF 
	SET GoodToImport = 0
	,ErrorDescription = ISNULL(ErrorDescription,'') + '|' + 'Invalid email provided'        
	WHERE ISNULL(BuyerEmail, '') <> ''     
     AND     
     (    
      CHARINDEX(' ', LTRIM(RTRIM(BuyerEmail)))  <> 0 OR    
      CHARINDEX('/', LTRIM(RTRIM(BuyerEmail)))  <> 0 OR    
      CHARINDEX(':', LTRIM(RTRIM(BuyerEmail)))  <> 0 OR    
      CHARINDEX(';', LTRIM(RTRIM(BuyerEmail)))  <> 0 OR    
      (LEN(LTRIM(RTRIM(BuyerEmail)))-1 <= CHARINDEX('.', LTRIM(RTRIM(BuyerEmail)))) OR    
      (LTRIM(RTRIM(BuyerEmail)) like '%@%@%')OR     
      (LTRIM(RTRIM(BuyerEmail)) Not Like '_%@_%.__%')OR
	  SUBSTRING (LTRIM(RTRIM(BuyerEmail)),CHARINDEX('@', LTRIM(RTRIM(BuyerEmail)))+1,Len(LTRIM(RTRIM(BuyerEmail)))) like '%..%'    
     )
    
	UPDATE Edina.tblEdinaSales_FF
	SET Address=LTRIM(RTRIM(Address))
		,City=LTRIM(RTRIM(City))
		,State=LTRIM(RTRIM(State))
		,Zip=LTRIM(RTRIM(Zip))
		,Foundation			=LTRIM(RTRIM(Foundation))
		,CONSTRUCTION_TYPE	=LTRIM(RTRIM(CONSTRUCTION_TYPE))
		,EXTERIOR_WALLS		=LTRIM(RTRIM(EXTERIOR_WALLS))
		,AIR_CONDITIONING	=LTRIM(RTRIM(AIR_CONDITIONING))
		,Heating			=LTRIM(RTRIM(Heating))
		,Roof_Type			=LTRIM(RTRIM(Roof_Type))
		,[Style]			=LTRIM(RTRIM([Style]))
		,Sewer				=LTRIM(RTRIM(Sewer))

	UPDATE Edina.tblEdinaSales_FF
	SET Foundation=REPlace(LTRIM(RTRIM(foundation)),', ',',') 

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
