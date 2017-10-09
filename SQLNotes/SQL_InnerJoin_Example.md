### Inner Join with an example

Inner Join and left join are the most commonly used joins in real time projects. We will talk about left join in a later article. Now, let us understand Inner join with an example.

Create 2 tables Company and Candidate. Use the script below to create these tables and populate them. CompanyId column in Candidate Table is a foreign key referencing CompanyId in Company Table.

```SQL
CREATE TABLE Company
(
    CompanyId TinyInt Identity Primary Key,
    CompanyName Nvarchar(50) NULL
)
GO

INSERT Company VALUES('DELL')
INSERT Company VALUES('HP')
INSERT Company VALUES('IBM')
INSERT Company VALUES('Microsoft')
GO

CREATE TABLE Candidate
(
    CandidateId tinyint identity primary key,
    FullName nvarchar(50) NULL,
    CompanyId tinyint REFERENCES Company(CompanyId)
)
GO

INSERT Candidate VALUES('Ron',1)
INSERT Candidate VALUES('Pete',2)
INSERT Candidate VALUES('Steve',3)
INSERT Candidate VALUES('Steve',NULL)
INSERT Candidate VALUES('Ravi',1)
INSERT Candidate VALUES('Raj',3)
INSERT Candidate VALUES('Kiran',NULL)
GO
```


If you want to select all the rows from the LEFT table(In our example Candidate Table) that have a non null foreign key value(CompanyId in Candidate Table is the foreign key) then we use INNER JOIN. A query involving an INNER JOIN for the Candidate and Company Table is shown below. 

```SQL
SELECT Cand.CandidateId, Cand.FullName, Cand.CompanyId, Comp.CompanyId, Comp.CompanyName
FROM Candidate Cand
INNER JOIN Company Comp
ON Cand.CompanyId = Comp.CompanyId
```


If we run the above query the output will be as shown in the image below. If you look at the out put, we only got 5 rows. We did not get the 2 rows which has NULL value in the CompanyId column. So an INNER JOIN would get all the rows from the LEFT Table that has non null foreign key value.

|CandidateId|FullName|CompanyId|CompanyId|CompanyName|
|-----------|--------|---------|---------|-----------|
|1          |Ron     |1        |1        |DELL       |
|2          |Pete    |2        |2        |HP         |
|3          |Steve   |3        |3        |IBM        |
|5          |Ravi    |1        |1        |DELL       |
|6          |Raj     |3        |3        |IBM        |

Instead of using INNER JOIN keyword we can just use JOIN keyword as shown below. JOIN or INNER JOIN means the same.

```SQL
SELECT Cand.CandidateId, Cand.FullName, Cand.CompanyId, Comp.CompanyId, Comp.CompanyName
FROM Candidate Cand
JOIN Company Comp
ON Cand.CompanyId = Comp.CompanyId
```


If you can think of any other sql server interview questions please post them as comments, so they will be useful to other users like you. This will be a great help from your side to improve this site.