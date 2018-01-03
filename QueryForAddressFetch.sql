DECLARE @PageNumber INT, @RowspPage INT
SET @PageNumber = 1
SET @RowspPage  = 100
SELECT * FROM (
                             SELECT 
								ROW_NUMBER() OVER(ORDER BY EA.crvNumberId, EA.ID, EA.recordType) AS Number,
								EA.crvNumberId AS crvNumberId,
								EA.ID   AS ID,
								EA.recordType AS recordType,
								REPLACE(CASE WHEN AddressLine1 = 'NA'
                                  THEN ' '
                                 WHEN AddressLine1 LIKE 'c/o%'
                                  THEN CASE WHEN PATINDEX('%[0-9]%',AddressLine1) > 0
                                     THEN SUBSTRING (  AddressLine1,PATINDEX('%[0-9]%',AddressLine1) , LEN(AddressLine1) )
                                    ELSE ''
                                  END
                                 ELSE AddressLine1
                               END +' '+
                               CASE WHEN AddressLine2 = 'NA' THEN ' ' ELSE AddressLine2 END +' '+
                               CASE WHEN City   = 'NA' THEN ' ' ELSE City   END +', '+
                               CASE WHEN State   = 'NA' THEN ' ' ELSE State   END +', '+
                               CASE WHEN Zip   = 'NA' THEN ' ' ELSE Zip    END,'#','') [Address]
                             FROM tblEcrvAddress (NOLOCK) EA
							 LEFT JOIN tbleCRVStandardAddressApi ESA (NOLOCK)
							 ON EA.crvNumberId = ESA.crvNumberId
								AND EA.ID = ESA.ID
								AND EA.recordType = ESA.recordType
                             WHERE ESA.crvNumberId IS NULL
                            ) AS TBL
                        WHERE Number BETWEEN ((@PageNumber - 1) * @RowspPage + 1) AND (@PageNumber * @RowspPage)
                        ORDER BY TBL.Number
						--count:463003

select count(1) from tblEcrvAddress (NOLOCK)
WHERE crvNumberId >= 488580 AND recordType != 'eCRV_property_add'

select max(crvNumberId) from tbleCRVStandardAddressApi
where recordType != 'eCRV_property_add'

SELECT count(1) FROM (
select distinct crvNumberId, recordType,ID from tblEcrvAddress
)K --1948182

select count(1) from 
(select distinct crvNumberId, recordType,ID  from tbleCRVStandardAddressApi)S --1486456


select 1948182-1486456 = 461726
462984