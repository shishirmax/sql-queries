# What are the different ways to replace NULL values in SQL Server

Apart from using COALESCE(), there are 2 other ways to replace NULL values in SQL Server. Let's understand this with an example.

I have a Table tblEmployee, as shown in the diagram below. Some of the Employees does not have gender. All those employees who does not have Gender, must have a replacement value of 'No Gender' in your query result. Let's explore all the 3 possible options we have.

!(ReplaceNulls)[]

**Option 1 :** Replace NULL values in SQL Server using ISNULL() function.

```SQL
Select Name, ISNULL(Gender,'No Gender') as Gender
From tblEmployee
```


**Option 2 :** Replace NULL values in SQL Server using CASE.

```SQL
Select Name, Case  When Gender IS NULL Then 'No Gender' Else Gender End as Gender
From tblEmployee
```


**Option 3 :** Replace NULL values in SQL Server using COALESCE() function.

```SQL
Select Name, Coalesce(Gender, 'No Gender') as Gender
From tblEmployee
```