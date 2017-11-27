# SQL | GROUP BY

The GROUP BY Statement in SQL is used to arrange identical data into groups with the help of some functions. i.e if a particular column has same values in different rows then it will arrange these rows in a group.

**Important Points:**

- GROUP BY clause is used with the SELECT statement.
- In the query, GROUP BY clause is placed after the WHERE clause.
- In the query, GROUP BY clause is placed before ORDER BY clause if used any.

**Syntax:**

```SQL
SELECT column1, function_name(column2)
FROM table_name
WHERE condition
GROUP BY column1, column2
ORDER BY column1, column2;
```

**function_name:** Name of the function used for example, SUM() , AVG().

**table_name:** Name of the table.

**condition:** Condition used.

## HAVING Clause

We know that WHERE clause is used to place conditions on columns but what if we want to place conditions on groups?

This is where HAVING clause comes into use. We can use HAVING clause to place conditions to decide which group will be the part of final result-set. Also we can not use the aggregate functions like SUM(), COUNT() etc. with WHERE clause. So we have to use HAVING clause if we want to use any of these functions in the conditions.

**Syntax:**

```SQL
SELECT column1, function_name(column2)
FROM table_name
WHERE condition
GROUP BY column1, column2
HAVING condition
ORDER BY column1, column2;
```

**function_name:** Name of the function used for example, SUM() , AVG().

**table_name:** Name of the table.

**condition:** Condition used.

**Example:**

```SQL
SELECT NAME, SUM(SALARY) FROM Employee 
GROUP BY NAME
HAVING SUM(SALARY)>3000; 
```