CREATE TABLE tblPopulation (
Country VARCHAR(100),
[State] VARCHAR(100),
City VARCHAR(100),
[Population(inMillions)] INT
)
GO

INSERT INTO tblPopulation VALUES('India', 'Delhi','East Delhi',9 )
INSERT INTO tblPopulation VALUES('India', 'Delhi','South Delhi',8 )
INSERT INTO tblPopulation VALUES('India', 'Delhi','North Delhi',5.5)
INSERT INTO tblPopulation VALUES('India', 'Delhi','West Delhi',7.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Bangalore',9.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Belur',2.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Manipal',1.5)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Mumbai',30)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Pune',20)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Nagpur',11 )
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Nashik',6.5)
GO

SELECT * FROM tblPopulation

SELECT Country,[State],City,
SUM ([Population(inMillions)]) AS [Population (in Millions)]
FROM tblPopulation
GROUP BY Country,[State],City WITH ROLLUP