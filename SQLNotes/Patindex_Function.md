**Patindex Function**
In SQL Server (Transact-SQL), the PATINDEX functions returns the location of a pattern in a string. The search is not case-sensitive.

**Syntax**
```SQL
PATINDEX( '%pattern%', string)
```

- The first position in string is 1.
- If the pattern is not found in string, the PATINDEX function will return 0.

**Example**

```SQL
select patindex('%hi%','shishir')
Result: 2

select PATINDEX('%hir%','shishir')
Result: 5

select PATINDEX('%rock%','I am a rockstar.')
Result: 8

select PATINDEX('%l%','I am a rockstar.')
Result: 0
```