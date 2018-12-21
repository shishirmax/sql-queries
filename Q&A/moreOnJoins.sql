SELECT * FROM sys.tables
WHERE name LIKE '%join%'

SELECT * FROM joins_A
SELECT * FROM joins_B

SELECT A.*,B.*
FROM joins_A A
FULL OUTER JOIN joins_B B
on A.ID_A = B.ID_B
WHERE A.ID_A IS NULL OR B.ID_B IS NULL

--TRUNCATE TABLE joins_B

INSERT INTO joins_A
VALUES
(10)
,(NULL)
,(20)
,(30)
,(30)

INSERT INTO joins_B
VALUES
(10)
,(NULL)
,(NULL)
,(30)
,(40)
,(50)
,(60)