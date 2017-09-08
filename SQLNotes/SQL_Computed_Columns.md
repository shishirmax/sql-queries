**Computed Columns**
A computed column is computed from an expression that can use other columns in the same table. The expression can be a noncomputed column name, constant, function, and any combination of these connected by one or more operators. The expression cannot be a subquery.

>For example, in the AdventureWorks2008R2 sample database, the TotalDue column of the Sales.SalesOrderHeader table has the definition: TotalDue AS Subtotal + TaxAmt + Freight.

**Limitations and Restrictions**

1. A computed column cannot be used as a DEFAULT or FOREIGN KEY constraint definition or with a NOT NULL constraint definition. However, if the computed column value is defined by a deterministic expression and the data type of the result is allowed in index columns, a computed column can be used as a key column in an index or as part of any PRIMARY KEY or UNIQUE constraint. For example, if the table has integer columns a and b, the computed column a + b may be indexed, but computed column a + DATEPART(dd, GETDATE()) cannot be indexed, because the value might change in subsequent invocations.
2. A computed column cannot be the target of an INSERT or UPDATE statement.

**Example**
```SQL
create table ComputedColumns(
column1 int,
column2 int,
column3 int,
AverageColumn as (column1+column2+column3)/3
)

insert into ComputedColumns
values
(2,4,5),
(12,45,76),
(33,66,11)

select * from ComputedColumns
```