# Left Join with an Example

Inner Join and left join are the most commonly used joins in real time projects. Click here to read about Inner Join in SQL Server. Now, let us understand Left join with an example.

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

If you want to select all the rows from the LEFT table ( In our example Candidate Table ) including the rows that have a null foreign key value ( CompanyId in Candidate Table is the foreign key ) then we use LEFT OUTER JOIN. A query involving a LEFT OUTER JOIN for the Candidate and Company Table is shown below.

```SQL
SELECT Cand.CandidateId, Cand.FullName, Cand.CompanyId, Comp.CompanyId, Comp.CompanyName
FROM Candidate Cand
LEFT OUTER JOIN Company Comp
ON Cand.CompanyId = Comp.CompanyId
```

If we run the above query the output will be as shown in below. If you look at the out put, we now got all 7 rows ( All the rows from the Candidate Table ) including the row that has a null value for the CompanyId column in the Candidate Table. So, LEFT OUTER JOIN would get all the rows from the LEFT Table including the rows that has null foreign key value.

![Left Join](https://github.com/shishirmax/sql-queries/blob/master/SQLNotes/img/LeftJoin.png)

**Left Join Result**

Instead of using LEFT OUTER JOIN keyword we can just use LEFT JOIN keyword as shown below. LEFT OUTER JOIN or LEFT JOIN means the same.

```SQL
SELECT Cand.CandidateId, Cand.FullName, Cand.CompanyId, Comp.CompanyId, Comp.CompanyName
FROM Candidate Cand
LEFT JOIN Company Comp
ON Cand.CompanyId = Comp.CompanyId
```