IF EXISTS(SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID('myTable'))
BEGIN;
    DROP TABLE [myTable];
END;
GO

CREATE TABLE AgeGroup (
    [Age] VARCHAR(255) NULL
)
GO

INSERT INTO AgeGroup([Age]) VALUES('82'),('49'),('26'),('63'),('14'),('20'),('24'),('13'),('87'),('60');
INSERT INTO myTable([Age]) VALUES('2118'),('8483'),('9421'),('4541'),('9463'),('4404'),('5446'),('1986'),('2140'),('9759');
INSERT INTO myTable([Age]) VALUES('9943'),('5251'),('1331'),('6288'),('4842'),('4819'),('2290'),('2737'),('6767'),('3695');
INSERT INTO myTable([Age]) VALUES('4232'),('6767'),('4787'),('4367'),('3209'),('5930'),('8781'),('7459'),('8045'),('2644');
INSERT INTO myTable([Age]) VALUES('3243'),('6240'),('4943'),('1436'),('3265'),('1482'),('9967'),('5335'),('8362'),('9076');
INSERT INTO myTable([Age]) VALUES('3209'),('2933'),('3593'),('8345'),('1464'),('5332'),('4816'),('1907'),('4856'),('2503');
INSERT INTO myTable([Age]) VALUES('9678'),('5263'),('2391'),('7951'),('3626'),('7403'),('3174'),('7284'),('9207'),('4378');
INSERT INTO myTable([Age]) VALUES('7998'),('1893'),('4982'),('9088'),('7220'),('8232'),('5573'),('3487'),('4033'),('1166');
INSERT INTO myTable([Age]) VALUES('4768'),('9884'),('7061'),('3301'),('7744'),('5493'),('8489'),('9025'),('3852'),('8411');
INSERT INTO myTable([Age]) VALUES('1934'),('3063'),('5354'),('2019'),('6854'),('8473'),('9678'),('6852'),('1603'),('5009');


SELECT * FROM AgeGroup

WITH CTE AS
(
SELECT 
		Age
		,Age_Buckket = CASE	
							WHEN Age < '20'
							THEN 'Young'
							WHEN Age >'20' and Age <'50'
							THEN 'Between'
							ELSE 'OLD'
						END
FROM AgeGroup
)

SELECT COUNT(1) As RecordCount, Age_Buckket
FROM CTE
GROUP BY Age_Buckket

SELECT * FROM AgeGroup
