Consider the stored procedure shown below.

```SQL
Create procedure spGetCustomers
as
Begin
 Select * from Customers1
End
```

Customers1 table does not exist. When you execute the above SQL code, the stored procedure spGetCustomers will be successfully created without errors. But when you try to call or execute the stored procedure using Execute spGetCustomers, you will get a run time error stating Invalid object name 'Customers1'.


So, at the time of creating stored procedures, only the syntax of the sql code is checked. The objects used in the stored procedure are not checked for their existence. Only when we try to run the procedure, the existence of the objects is checked. So, the process of postponing, the checking of physical existence of the objects until runtime, is called as deffered name resolution in SQL server.


Functions in sql server does not support deferred name resolution. If you try to create an inline table valued function as shown below, we get an error stating Invalid object name 'Customers1' at the time of creation of the function itself.

```SQL
Create function fnGetCustomers()
returns table
as
return Select * from Customers1
```

So, this proves that, stored procedures support deferred name resolution, where as functions does not. Infact, this is one of the major difference between functions and stored procedures in sql server.