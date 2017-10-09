### Basic SQl Server Joins

What are the different types of joins available in sql server?
There are 3 different types of joins available in sql server, and they are
1. Cross Join 
2. Inner Join or Join 
3. Outer Join

Outer Join is again divided into 3 types as shown below.
1. Left Outer Join or Left Join 
2. Right Outer Join or Right Join 
3. Full Outer Join or Full Join 

You might have heard about self join, but self join is not a different type of join. A self join means joining a table with itself. We can have an inner self join or outer self join. Read this sql server interview question, to understand self join in a greater detail.



What is cross join. Explain with an example?
Let us understand Cross Join with an example. Create 2 tables Company and Candidate. Use the script below to create these tables and populate them. CompanyId column in Candidate Table is a foreign key referencing CompanyId in Company Table.

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

A cross join produces the Cartesian product of the tables involved in the join. The size of a Cartesian product result set is the number of rows in the first table multiplied by the number of rows in the second table. A query involving a CROSS JOIN for the Candidate and Company Table is shown below.

```SQL
SELECT  Cand.CandidateId,Cand.FullName,Cand.CompanyId, Comp.CompanyId,Comp.CompanyName
FROM Candidate Cand
CROSS JOIN Company Comp
```

If we run the above query, we produce the result set shown in the image below.
![alt text](https://github.com/shishirmax/sql-queries/blob/master/SQLNotes/img/CrossJoin.png)