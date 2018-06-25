CREATE TABLE AddressCASS(
IAddressId  VARCHAR(255),
AddressLin  VARCHAR(255),
Field3    	VARCHAR(255),
City    	VARCHAR(255),
State    	VARCHAR(255),
Zip    		VARCHAR(255),
STD_URB    	VARCHAR(255),
STD_EXTADR  VARCHAR(255),
STD_SECADR  VARCHAR(255),
STD_PRIADR  VARCHAR(255),
STD_CITY    VARCHAR(255),
STD_STATE   VARCHAR(255),
STD_ZIP    	VARCHAR(255),
STD_ZIP4    VARCHAR(255),
STD_CRT    	VARCHAR(255),
STD_DPBC    VARCHAR(255),
STD_LOT    	VARCHAR(255),
STD_LOTORD  VARCHAR(255),
STD_ACHKDI  VARCHAR(255),
STD_ERRSTT  VARCHAR(255),
STD_RECTYP  VARCHAR(255),
STD_DPVFTN  VARCHAR(255),
STD_DPVSTT  VARCHAR(255),
STD_COUNTY  VARCHAR(255),
STD_CONGCD	VARCHAR(255)
)

SELECT * FROM AddressCASS


BULK INSERT dbo.AddressCASS
FROM 'D:\Edina\AddressList_DefaultCASS.csv'
WITH
	(
		FIELDTERMINATOR = ','
	)

BULK INSERT EdinaLocal.dbo.Sales
FROM 'D:\Edina\AddressList_DefaultCASS.csv'
WITH
(
FIELDTERMINATOR=',',
FIRSTROW=2,
ROWTERMINATOR='\n'
)

bcp dbo.AddressCASS in D:\Edina\AddressList_DefaultCASS.csv -S SHISHIRS -d shishir -U sa -P sysadmin  -b 10000 -q -c -t","

UPDATE AddressCASS
SET 
IAddressId = REPLACE(IAddressId,'"','')
,AddressLin = REPLACE(AddressLin,'"','')
,Field3 = REPLACE(Field3,'"','')
,City = REPLACE(City,'"','')
,State = REPLACE(State,'"','')
,Zip = REPLACE(Zip,'"','')
,STD_URB = REPLACE(STD_URB,'"','')
,STD_EXTADR = REPLACE(STD_EXTADR,'"','')
,STD_SECADR = REPLACE(STD_SECADR,'"','')
,STD_PRIADR = REPLACE(STD_PRIADR,'"','')
,STD_CITY = REPLACE(STD_CITY,'"','')
,STD_STATE = REPLACE(STD_STATE,'"','')
,STD_ZIP = REPLACE(STD_ZIP,'"','')
,STD_ZIP4 = REPLACE(STD_ZIP4,'"','')
,STD_CRT = REPLACE(STD_CRT,'"','')
,STD_DPBC = REPLACE(STD_DPBC,'"','')
,STD_LOT = REPLACE(STD_LOT,'"','')
,STD_LOTORD = REPLACE(STD_LOTORD,'"','')
,STD_ACHKDI = REPLACE(STD_ACHKDI,'"','')
,STD_ERRSTT = REPLACE(STD_ERRSTT,'"','')
,STD_RECTYP = REPLACE(STD_RECTYP,'"','')
,STD_DPVFTN = REPLACE(STD_DPVFTN,'"','')
,STD_DPVSTT = REPLACE(STD_DPVSTT,'"','')
,STD_COUNTY = REPLACE(STD_COUNTY,'"','')
,STD_CONGCD = REPLACE(STD_CONGCD,'"','')

UPDATE AddressCASS
SET STD_CONGCD = NULL
WHERE STD_CONGCD = ''



