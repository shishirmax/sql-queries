#### What is a View?
First up what is a View? To paraphrase from Books Online (BOL) a view is a virtual table, the contents of which are defined by a query. Unless the view is an indexed view the data does not exist in the view directly but remains in the underlying tables. The database stores only the views definition (unless its an indexed view) therefore if you drop a view you don’t lose any data, you just the definition of the view.

#### Can you delete from a view?
So can you delete data from a view. so by the very definition of the view above the answer is ‘No’. There is no data in the view to delete, the data remains in the underlying tables.  Let’s assume though that real the question people are asking  is:

#### Can you delete data from the underlying tables that make up a view?
The simple answer is yes you can but with some caveats. If the query that is defined in your view is comprised of more than one table,   then you won’t be able to delete from the underlying tables.For example, if we use the Adventureworks2008R2 database and the [HumanResources].[vEmployee]view, the TSQL used to create the view is:

```SQL
USE [AdventureWorks2008R2]
GO

/****** Object:  View [HumanResources].[vEmployee]    Script Date: 07/04/2011 22:23:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [HumanResources].[vEmployee] 
AS 
SELECT 
e.[BusinessEntityID]
,p.[Title]
,p.[FirstName]
,p.[MiddleName]
,p.[LastName]
,p.[Suffix]
,e.[JobTitle]  
,pp.[PhoneNumber]
,pnt.[Name] AS [PhoneNumberType]
,ea.[EmailAddress]
,p.[EmailPromotion]
,a.[AddressLine1]
,a.[AddressLine2]
,a.[City]
,sp.[Name] AS [StateProvinceName] 
,a.[PostalCode]
,cr.[Name] AS [CountryRegionName] 
,p.[AdditionalContactInfo]
FROM [HumanResources].[Employee] e
INNER JOIN [Person].[Person] p
ON p.[BusinessEntityID] = e.[BusinessEntityID]
INNER JOIN [Person].[BusinessEntityAddress] bea 
ON bea.[BusinessEntityID] = e.[BusinessEntityID] 
INNER JOIN [Person].[Address] a 
ON a.[AddressID] = bea.[AddressID]
INNER JOIN [Person].[StateProvince] sp 
ON sp.[StateProvinceID] = a.[StateProvinceID]
INNER JOIN [Person].[CountryRegion] cr 
ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
LEFT OUTER JOIN [Person].[PersonPhone] pp
ON pp.BusinessEntityID = p.[BusinessEntityID]
LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
ON pp.[PhoneNumberTypeID] = pnt.[PhoneNumberTypeID]
LEFT OUTER JOIN [Person].[EmailAddress] ea
ON p.[BusinessEntityID] = ea.[BusinessEntityID];

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Employee names and addresses.' , @level0type=N'SCHEMA',@level0name=N'HumanResources', @level1type=N'VIEW',@level1name=N'vEmployee'
GO

```

This view returns information on employees such as name address and contact information which is retrieved  from several tables.

Lets try and delete data from the underlying tables using the view:
```SQL
delete [HumanResources].[vEmployee]
where BusinessEntityID = 5
```

If we run this code we get the following error:

>Msg 4405, Level 16, State 1, Line 3
>View or function 'HumanResources.vEmployee' is not updatable because the modification affects multiple base tables.

Therefore as the [HumanResources].[vEmployees] view has multiple tables we cannot delete from the view.

So what about views whose definition is based only on one table. I’ll create a new table in the AdventureWork2008R2 for this little test:

```SQL
select * 
into dbo.emptabview
from HumanResources.Employee
```

I’ll create a simple view called delview based on my new emptabview table:

```SQL
create view delview
as
select * from dbo.emptabview 
```

We’ll run a query against the table to make sure the row we want to delete exists:
```SQL
select * from dbo.emptabview
where BusinessEntityID = 6
```

Now I will try and delete the same record from the underlying table using the view:
```SQL
delete  delview 
where BusinessEntityID = 6

(1 row(s) affected) 
```

I’ll run the same select query from the table  and as we can see the row has been deleted:

```SQL
select * from dbo.emptabview
where BusinessEntityID = 6

(0 row(s) affected)
```

There we have it one row deleted from the underlying table by running a delete against the view.

**To conclude, we can delete data from the underlying table of the view as long as the view is only based on one table. If your view is made up of multiple tables then you won’t be able to use the view in the delete statement.**
