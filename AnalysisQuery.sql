--********************************
--Query to Neeraj
--********************************

--Table where formatted address will be inserted comming as a response from google API
CREATE TABLE EdinaAddressGoogleApi
(
	RecordIDs			VARCHAR(500),
	FormattedAddress	VARCHAR(MAX),
	Latitude			VARCHAR(MAX),
	Longitude			VARCHAR(MAX)
)

ALTER TABLE EdinaAddressGoogleApi
ADD OriginalAddress VARCHAR(MAX)

SELECT COUNT(*) FROM EdinaAddressGoogleApi (NOLOCK)

SELECT * FROM EdinaAddressGoogleApi (NOLOCK)

--TRUNCATE TABLE EdinaAddressGoogleApi

--**************************************************
--Record available in tblEdinaSales_DT : 134336
--Record available in tblEdinaStandardAddress : 66911
--**************************************************

INSERT INTO EdinaAddressGoogleApi(
				 RecordIDs
				,FormattedAddress
				,Latitude
				,Longitude
				,OriginalAddress
				)
		VALUES
		()

SELECT * FROM tblEdinaSales_DT
where RecordIds = 800062
/*
RecordIDs
FormattedAddress
Latitude
Longitude
*/

select count(*) from Edina_Address_Validation

select top 100 
		 [formatted address]
		,[Lat Lon]
		,[Address]+','+[City]+','+[State]+','+[Zip]
		,[Latitude]
		,[Longitude]
from Edina_Address_Validation

select 
	COUNT([Record IDs]),
	COUNT(TRY_CAST([Record IDs]) AS BIGINT)
from [Edina_Address_Validation]


/*
DECLARE @PageNumber AS INT
        ,@RowspPage AS INT

SET @PageNumber = 1
SET @RowspPage  = 100

SELECT * FROM (
                    SELECT  ROW_NUMBER() OVER(ORDER BY RecordIDs) AS Number,
                    SF.RecordIDs,
                    SF.[Address] + ',' + SF.City + ',' + SF.[State] + ',' + SF.Zip As [Address]
                    FROM tblEdinaSales_DT SF
                    LEFT JOIN [Edina_Address_Validation] EAV
                        ON SF.RecordIDs = CAST(EAV.[Record IDs] AS BIGINT)
                    WHERE CAST(EAV.[Record IDs] AS BIGINT) IS NULL
               ) AS TBL
WHERE Number BETWEEN ((@PageNumber - 1) * @RowspPage + 1) AND (@PageNumber * @RowspPage)
ORDER BY RecordIDs
*/

--===============================
-- Address Standardization
--===============================
/*
==tblEdinaStandardAddress
AddressId
FromattedAddress
LatitudeLongitude
OrgAddress
OrgCity
OrgState
OrgZip
OrgLatitude
OrgLongitude
*/


/*
==Edina_Address_Validation
[Formatted address]
[Lat Lon]
[Address]
[City]
[State]
[Zip]
[Latitude]
[Longitude]
*/
--tblEdinaSales_DT = 134336

--132434
select	 DISTINCT
		 [Address]+','+[City]+','+[State]+','+[Zip] As [OriginalAddress]
		,[Latitude]
		,[Longitude]
FROM tblEdinaSales_DT

--128206
SELECT DISTINCT [Address]
FROM tblEdinaSales_DT

--1464
SELECT DISTINCT City
FROM tblEdinaSales_DT

/*
--7
	|State|
	|-----|
	|NULL |
	|IA	  |
	|m	  |
	|MN	  |
	|ND	  |
	|SD	  |
	|WI	  |
*/
SELECT DISTINCT [State]
FROM tblEdinaSales_DT

SELECT COUNT(*) FROM tblEdinaStandardAddress
WHERE LatitudeLongitude ='NA' --1399

SELECT COUNT(*) FROM Edina_Address_Validation
WHERE [Lat Lon] = 'NA'

--66911
SELECT COUNT(1) from tblEdinaStandardAddress 
--where TRY_CAST(AddressId AS BIGINT) IS NULL

--66908
SELECT COUNT(1) from Edina_Address_Validation

--SELECT 
--	 A.[Formatted address]
--	,A.[Lat Lon]
--	,A.[Record IDs]
--	,B.FromattedAddress
--	,B.LatitudeLongitude
--FROM Edina_Address_Validation A
--LEFT JOIN tblEdinaStandardAddress B
--ON
--A.[Formatted address] = B.FromattedAddress

--2018
select FromattedAddress,count(*) from tblEdinaStandardAddress
group by FromattedAddress
having count(*)>1

--2017
select [Formatted address],count(*) from Edina_Address_Validation
group by [Formatted address]
having count(*)>1

/*
--Different Record ID for same address
--Record Ids
1222452
1222453
1205475
*/
SELECT 
	 [Record IDs]
	,[Formatted address]
	,[Lat Lon]
	,[Address]
	,[City]
	,[State]
	,[Zip]
	,[Latitude]
	,[Longitude]
FROM Edina_Address_Validation
WHERE [Formatted address] = '#NAME?,Alexandria,MN,56308'

/*
-- All record id have different First,Last Name and BuyerEmail
|First			|Last		|BuyerEmail				|
|---------------|-----------|-----------------------|
|Joey			|Anderson	|ruler.scale@hotmail.com|
|Stuart			|Wood		|ruler.scale@hotmail.com|		
|Daniel & Juanita|Wood		|NULL					|
*/
SELECT *
FROM tblEdinaSales_DT
WHERE RecordIDs IN('1222452','1222453','1205475')


SELECT 
	 [Record IDs]
	,[Formatted address]
	,[Lat Lon]
	,[Address]
	,[City]
	,[State]
	,[Zip]
	,[Latitude]
	,[Longitude]
FROM Edina_Address_Validation
WHERE [Formatted address] = 'XXX Jackson Avenue N,Morristown,MN,55052'

SELECT *
FROM tblEdinaSales_DT
WHERE RecordIDs IN('1146264','1126770','1137764','1063079','1126501','1109097','1060695','1055195','1198575','1191941')