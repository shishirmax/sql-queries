SELECT PARSENAME(REPLACE('1234-4569-7896','-','.'),1)

DECLARE @str NVARCHAR(250) = '702 Donald St, Marshall, MN 56258, USA'
SELECT value
FROM STRING_SPLIT(@str,',')


DECLARE @Str NVARCHAR(500)
SET @Str = '702 Donald St, Marshall, MN 56258, USA'
SELECT 
PARSENAME(REPLACE(@Str,',','.'),4) As Address1,
PARSENAME(REPLACE(@Str,',','.'),3) As City,
PARSENAME(REPLACE(PARSENAME(REPLACE(@Str,',','.'),2),' ','.'),2) As State,
PARSENAME(REPLACE(PARSENAME(REPLACE(@Str,',','.'),2),' ','.'),1) As Zip,
PARSENAME(REPLACE(@Str,',','.'),1) As Country

DECLARE @Education TABLE
(Qualification VARCHAR(100),
	BTech	VARCHAR(100) NULL,
	MTech	VARCHAR(100) NULL)

INSERT INTO @Education
VALUES
('B.Tech',NULL,NULL),('B.Tech',NULL,NULL),('B.Tech',NULL,NULL),('M.Tech',NULL,NULL)

SELECT * FROM @Education

CREATE TABLE EducationQualification
(
Qualification VARCHAR(100),
BTech	VARCHAR(100) NULL,
MTech	VARCHAR(100) NULL
)

INSERT INTO EducationQualification
(Qualification,BTech,MTech)
VALUES
('B.Tech',NULL,NULL),('B.Tech',NULL,NULL),('B.Tech',NULL,NULL),('M.Tech',NULL,NULL)

SELECT * FROM EducationQualification



UPDATE EducationQualification
SET BTech = CASE
				WHEN Qualification = 'B.Tech' THEN 1
				ELSE NULL
			END,
	MTech = CASE
				WHEN Qualification = 'M.Tech' THEN 1
				ELSE NULL
			END

