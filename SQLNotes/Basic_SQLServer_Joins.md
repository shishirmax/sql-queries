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

Key Points to remember about CROSS JOIN. 

1. A cross join produces the Cartesian product of the tables involved in the join.This mean every row in the Left Table is joined to every row in the Right Table. Candidate is LEFT Table and Company is RIGHT Table. In our example we have 28 total number of rows in the result set. 7 rows in the Candidate table multiplied by 4 rows in the Company Table. 
2. In real time scenarios we rarley use CROSS JOIN. Most often we use either INNER JOIN or LEFT OUTER JOIN. 
3. CROSS JOIN does not have an ON clause with a Join Condition. All the other JOINS use ON clause with a Join Condition. 
4. Using an ON clause on a CROSS JOIN would generate a syntax error. 

Note: Understanding the above key points will help you answer any follow up interview questions on cross join in sql server.