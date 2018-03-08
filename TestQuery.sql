DROP EXTERNAL DATA SOURCE B2CDTAEXTRACT28

CREATE EXTERNAL DATA SOURCE B2CDTAEXTRACT28
   WITH ( TYPE = BLOB_STORAGE, LOCATION = 'https://contatapowershell.blob.core.windows.net/vdbs');

   BULK INSERT [lubetech].tblLubTechFullDataScored  
FROM 'Full_data_scored.csv' 
WITH (
   DATA_SOURCE = 'B2CDTAEXTRACT28', 
   FORMAT = 'CSV',
   FIELDTERMINATOR  = ',',
   FIRSTROW = 2
  );

select TOP 100 * from lubetech.tblLubTechFullDataScored(NOLOCK)
where ShipToCustomerClassDesc_x = 'ShipToCustomerClassDesc_x'

TRUNCATE TABLE lubetech.tblLubTechFullDataScored
DROP TABLE lubetech.tblLubTechFullDataScored

bcp lubetech.tblLubTechFullDataScored in D:\Edina\Lubtech\Full_data_scored.csv -S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123  -b 10000 -q -c -t","