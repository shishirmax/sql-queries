### Write a Stored Procedure that takes column name as a parameter and returns the result sorted by the column that is passed

we need a stored procedure that returns employee data sorted by a column, that the user is going to pass into the stored procedure as a parameter. There are 2 ways of doing this.

**Option 1: Use Case Statement as shown below:**

```SQL
Create Proc spGetEmployeesSorted
@SortCoumn nvarchar(10)
as
Begin

Select [Id],[Name],[Gender],[Salary],[City] 
From   [Employee]
Order by Case When @SortCoumn = 'Id' Then Id End,
                Case When @SortCoumn = 'Name' Then Name End,
                Case When @SortCoumn = 'Gender' Then Gender End,
                Case When @SortCoumn = 'Salary' Then Salary End,
                Case When @SortCoumn = 'City' Then City End

End
```

**Option 2: Use Dynamic SQL as shown below:**

```SQL
Create Proc spGetEmployeesSortedUsingDynamicSQL
@SortCoumn nvarchar(10)
as
Begin

Declare @DynamicQuery nvarchar(100)
Set @DynamicQuery = 'select [Id],[Name],[Gender],[Salary],[City] from [Employee] order by ' + @SortCoumn
Execute(@DynamicQuery)


End
```