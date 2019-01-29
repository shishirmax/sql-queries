SELECT * FROM tblEmployee

SELECT AVG(Salary) FROM tblEmployee
SELECT CEILING(AVG(Salary)-AVG(CAST(REPLACE(Salary,'0','') AS INT))) FROM tblEmployee

CREATE TABLE hEmployees
(
	ID INT,
	Name VARCHAR(100),
	Salary INT
)

INSERT INTO hEmployees
VALUES
(1,'Kristeen',1420,NULL,NULL)
,(2,'Ashley',2006,NULL,NULL)
,(3,'Julia',2210,NULL,NULL)
,(4,'Maria',3000,NULL,NULL)

SELECT * FROM hEmployees

SELECT AVG(Salary) FROM hEmployees
SELECT AVG(CAST(REPLACE(Salary,'0','') AS INT)) FROM hEmployees

SELECT ROUND(AVG(Salary) - AVG(CAST(REPLACE(Salary,'0','') AS INT)),1) FROM hEmployees


SELECT * FROM hEmployees
EXEC InsertOrUpdateEmployee 'Kimberly',6500

SELECT * FROM hEmployees
WHERE UpdateDate IS NULL

SELECT * FROM hEmployees
WHERE UpdateDate IS NOT NULL

DELETE FROM hEmployees WHERE NAME = 'Alexa'

TRUNCATE TABLE hEmployees

ALTER TABLE hEmployees
ADD  UpdateDate DATETIME

SELECT GETDATE()

UPDATE hEmployees
SET InsertDate = GETDATE()


ALTER PROCEDURE dbo.InsertOrUpdateEmployee
	@Name VARCHAR(50),
	@Salary INT
AS BEGIN
    --IF NOT EXISTS (SELECT * FROM dbo.hEmployees WHERE [Name] = @Name AND Salary = @Salary)
    --   INSERT INTO dbo.hEmployees([Name],Salary,InsertDate)
    --   VALUES(@Name,@Salary,GETDATE())
    --ELSE
    --   UPDATE dbo.hEmployees
    --   SET Name = @Name,
    --       salary = @Salary,
		  -- UpdateDate = GETDATE()
    
	CREATE TABLE #tmpData
	(
		Name VARCHAR(50),
		Salary INT
	)   

	INSERT INTO #tmpData(Name,Salary)

	VALUES(
		@Name,
		@Salary	
	)


	UPDATE A
	SET A.Name = B.Name,
		A.Salary = B.Salary,
		A.updatedate = GETDATE()
	FROM hEmployees A
	JOIN #tmpData B
	ON A.Name = B.Name
	AND A.Salary = B.Salary

	INSERT INTO hEmployees
	(
		Name,
		Salary,
		InsertDate
	)
	SELECT 
		S.Name,
		S.Salary,
		GETDATE()
	FROM #tmpData S
	LEFT JOIN hEmployees D
	ON S.Name = D.Name
	AND S.Salary = D.Salary
	WHERE D.Name IS NULL
	AND D.Salary IS NULL

	DROP TABLE #tmpData

END

Alter Table hEmployees
Add Id_new Int Identity(1, 1)
Go

Alter Table hEmployees Drop Column ID
Go

Exec sp_rename 'hEmployees.Id_new', 'ID', 'Column'