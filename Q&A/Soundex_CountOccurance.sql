--Soundex
--https://docs.microsoft.com/en-us/sql/t-sql/functions/soundex-transact-sql?view=sql-server-2017
SELECT SOUNDEX('Color'),SOUNDEX('Coulour')

SELECT * FROM student

--Adding Age Column
ALTER TABLE Student
ADD Age INT

SELECT * FROM student

--Update Query
--UPDATE student
--SET Age = 11
--WHERE ID = 7

--Select Occurance Group By Age
SELECT Age,COUNT(Age) As NumberCount
FROM student
GROUP BY Age

--Select Other Column as well
SELECT 
	A.id
	--,A.name
	--,A.marks
	,A.Age
	,B.NumberCount
FROM Student A
INNER JOIN 
(
	SELECT Age,COUNT(Age) As NumberCount
	FROM student
	GROUP BY Age
)B
ON A.age = B.age