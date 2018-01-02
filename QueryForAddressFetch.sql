DECLARE @PageNumber INT, @RowspPage INT
SET @PageNumber = 1
SET @RowspPage  = 100
SELECT * FROM (
                             SELECT 
								ROW_NUMBER() OVER(ORDER BY crvNumberId, ID, recordType) AS Number,
								crvNumberId AS crvNumberId,
								ID   AS ID,
								recordType AS recordType,
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
                             FROM tblEcrvAddress (NOLOCK)
                             WHERE crvNumberId >= 485483 AND recordType != 'eCRV_property_add'
                            ) AS TBL
                        WHERE Number BETWEEN ((@PageNumber - 1) * @RowspPage + 1) AND (@PageNumber * @RowspPage)
                        ORDER BY TBL.Number

select count(1) from tblEcrvAddress (NOLOCK)
WHERE crvNumberId >= 485483 AND recordType != 'eCRV_property_add'