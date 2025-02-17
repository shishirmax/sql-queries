
    
ALTER PROCEDURE [ZeroRez].[Usp_CleanBusinessRule]      
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
        OR (email lIKE '%.@%') /*Added new condition by Gulrez for the jira [ERA-120]*/ 
        OR (SUBSTRING(Email, CHARINDEX('@',Email)+1,lEN(Email)) like '%..%') /*Added new condition by Gulrez for the jira [ERA-122]*/ 
       )      
   UPDATE  [ZeroRez].[tblAddress_FF] SET GoodToImport=0,ErrorDescription=ISNULL(ErrorDescription, '|') + '|' + 'Invalid Postal Code'      
   WHERE Postal_code NOT LIKE '[0-9][0-9][0-9][0-9][0-9]'      
    
   UPDATE [ZeroRez].[tblZeroRez_FF] SET Lifetime_Total=REPLACE(Lifetime_Total,'"','')    
         
 UPDATE [ZeroRez].[tblAddress_FF]  SET Street1=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Street1,'+',''),'!',''),'*',''),'@',''),'$','')    
 ,Street2=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Street2,'+',''),'!',''),'*',''),'@',''),'$','')    
    
 UPDATE [ZeroRez].[tblZeroRez_FF] SET First_Name=RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(First_Name,'"',''),'0',''),'1',''),'2',''),'3',''),'4',''),'5',''),'6',''),'7',''),'8',''),'9',''),'@',''),'?',''),'*',''),'+',''),'  ',' '))),    
 Last_Name=RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Last_Name,'"',''),'0',''),'1',''),'2',''),'3',''),'4',''),'5',''),'6',''),'7',''),'8',''),'9',''),'@',''),'?',''),'*',''),'+',''),'  ',' ')))    /* New Replace Condition Added by Shishir jira[ERA-127]*/
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