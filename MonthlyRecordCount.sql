SELECT COUNT(1) TotalRecords, 
CASE 
	WHEN MONTH(CAST(SessionnStart As DATE)) = 1
	THEN 'January' 
	WHEN MONTH(CAST(SessionnStart As DATE)) = 2
	THEN 'February'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 3
	THEN 'March'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 4
	THEN 'April'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 5
	THEN 'May'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 6
	THEN 'June'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 7
	THEN 'July'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 8
	THEN 'August'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 9
	THEN 'September'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 10
	THEN 'October'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 11
	THEN 'November'
	WHEN MONTH(CAST(SessionnStart As DATE)) = 12
	THEN 'December'
END
	AS Month,YEAR(CAST(SessionnStart As DATE)) AS Year
FROM homespotter.DimSession
WHERE YEAR(CAST(SessionnStart As DATE)) = 2018 or YEAR(CAST(SessionnStart As DATE)) = 2017
GROUP BY MONTH(CAST(SessionnStart As DATE)),YEAR(CAST(SessionnStart As DATE))
ORDER BY MONTH(CAST(SessionnStart As DATE))