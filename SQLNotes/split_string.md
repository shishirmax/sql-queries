# Problem : To Split comma seperated value into columns

**Sample Data:**

*Combined Address: '702 Donald St, Marshall, MN 56258, USA'*

This combined address is bundle of Address/Stree,City,State Zip, Country
We now want to split this into differnt column like structure:

e.g.

|Address        |City       |State  |Zip    |Country|
|---------------|-----------|-------|-------|-------|
|702 Donald St  |Marshall   |MN     |56258  |USA    |

### Using SQL STRING_SPLIT()

**Syntax:**

```SQL
STRING_SPLIT ( string , separator )
```

Using STRING_SPLIT() for splitting the combined address:

```SQL
DECLARE @str NVARCHAR(250) = '702 Donald St, Marshall, MN 56258, USA'
SELECT value
FROM STRING_SPLIT(@str,',')
```
**Output:**

|value          |
|---------------|
|702 Donald St  |
| Marshall      |
| MN 56258      |
| USA           |

### Using PARSENAME()

**Syntax:**

```SQL
PARSENAME ( 'object_name' , object_piece )
```

Using PARSENAME() for splitting the combined address:

```SQL
DECLARE @Str NVARCHAR(500)
SET @Str = '702 Donald St, Marshall, MN 56258, USA'
SELECT 
    PARSENAME(REPLACE(@Str,',','.'),4) As Address1,
    PARSENAME(REPLACE(@Str,',','.'),3) As City,
    PARSENAME(REPLACE(PARSENAME(REPLACE(@Str,',','.'),2),' ','.'),2) As State,
    PARSENAME(REPLACE(PARSENAME(REPLACE(@Str,',','.'),2),' ','.'),1) As Zip,
    PARSENAME(REPLACE(@Str,',','.'),1) As Country
```

**Output:**

|Address1	    |City	    |State	|Zip    |Country|
|---------------|-----------|-------|-------|-------|
|702 Donald St	|Marshall	|MN	    |56258  |USA    |
