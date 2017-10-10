# Right Join with an Example

Let us understand Right Outer join with an example.

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


If you want to select all the rows from the LEFT Table ( In our example Candidate Table) that have non null foreign key values plus all the rows from the RIGHT table ( In our example Company Table) including the rows that are not referenced in the LEFT Table, then we use RIGHT OUTER JOIN. A query involving a RIGHT OUTER JOIN for the Candidate and Company Table is shown below.

```SQL
SELECT Cand.CandidateId, Cand.FullName, Cand.CompanyId, Comp.CompanyId, Comp.CompanyName
FROM Candidate Cand
RIGHT OUTER JOIN Company Comp
ON Cand.CompanyId = Comp.CompanyId
```

If we run the above query the output will be as shown in below. If you look at the out put, we now got 6 rows. All the rows from the Candidate Table that has non null foreign key value plus all the rows from the Company Table including the row that is not referenced in the Candidate Table.

![Right Join](https://github.com/shishirmax/sql-queries/blob/master/SQLNotes/img/RightJoin.png)

**Right Outer Join Results**

Instead of using RIGHT OUTER JOIN keyword we can just use RIGHT JOIN keyword as shown below. RIGHT OUTER JOIN or RIGHT JOIN means the same.

```SQL
SELECT Cand.CandidateId, Cand.FullName, Cand.CompanyId, Comp.CompanyId, Comp.CompanyName
FROM Candidate Cand
RIGHT JOIN Company Comp
ON Cand.CompanyId = Comp.CompanyId
```