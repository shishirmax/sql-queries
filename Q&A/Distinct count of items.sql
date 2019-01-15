--Distinct count of items
DECLARE @T TABLE (CustomerNo int, Item varchar(50));
INSERT INTO @T (CustomerNo, Item) VALUES
(1, 'A'),
(1, 'B'),
(2, 'B'),
(3, 'A'),
(4, 'A'),
(4, 'B'),
(5, 'B'),
(6, 'A')

SELECT * FROM @T

SELECT CustomerNo
FROM @T
WHERE Item = 'A'

INTERSECT

SELECT CustomerNo
FROM @T
WHERE Item = 'B'

SELECT
    Item
    ,COUNT(DISTINCT CustomerNo) AS CustomerCount
    ,0 AS SortOrder
FROM @T
GROUP BY Item

UNION ALL

SELECT
    'A & B' AS Item
    ,COUNT(*) AS CustomerCount
    ,1 AS SortOrder
FROM
(
    SELECT CustomerNo
    FROM @T
    WHERE Item = 'A'

    INTERSECT

    SELECT CustomerNo
    FROM @T
    WHERE Item = 'B'
) AS T

ORDER BY SortOrder, Item
