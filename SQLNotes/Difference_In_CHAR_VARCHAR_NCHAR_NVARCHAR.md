# Difference Between Char, Nchar, Varchar and Nvarchar Data Types in SQL Server

This small article is intended for the audience stuck in their interview when asked for the differences among CHAR, VARCHAR, NCHAR and NVARCHAR data types. Actually it is simple but sometimes people get confused.

To store data as characters, numeric values and special characters in a database, there are 4 data types that can be used. So what is the difference among all 4 of these data types?

CHAR vs VARCHAR
NCHAR vs NVARCHAR
Considering an example, we will look into each one of them. 

```SQL
DECLARE @string CHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len' 
```

**Note:** The LEN() method provides the length of a character excluding trailing blanks stored in the string expression whereas the DATALENGTH() method provides the number of byte spaces occupied by the characters in a string expression.
 
As you know we represent the character values within single quotes, for example 'Robin'. But do you know we can represent these same characters within double quotes similar to programming languages representing a string, for example “Robin”? This can be done by setting the value:


```SQL
SET QUOTED_IDENTIFIER OFF  
```

By default, it is set to ON

### CHAR vs VARCHAR

Talking about the CHAR data type:

- It is a fixed length data type
- Used to store non-Unicode characters
- Occupiers 1 byte of space for each character

If the value provided to a variable of CHAR data type is shorter than the length of a column of declared the size of the variable, then the value would be right-padded with blanks to match the size of column length. 

```SQL
DECLARE @string CHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len'
```

As you can see above, the bytes occupied by the variable are 20 even though the length of the characters is 5. That means that irrespective of the character stored in the column, it will occupy all bytes to store the value.

About the **VARCHAR** data type:

- It is a variable length data type
- Used to store non-Unicode characters
- Occupies 1 byte of space for each character

```SQL
DECLARE @string VARCHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len'  
```

As you can see above, it is showing DATALENGTH as 5 which means it will use only the number of bytes equal to the number of characters. This will allow me to avoid wasting database space.

**Note:**  If SET ANSI_PADDING is OFF when CREATE TABLE or ALTER TABLE is executed, a CHAR column defined as NULL is considered as VARCHAR.

When to use what?
If you are sure about the fixed length of the data that would be captured for any specific column then go for CHAR data type and if the data may vary then go for VARCHAR. 
 
### NCHAR vs NVARCHAR

Similar to CHAR data type, the NCHAR data type:
Is a fixed length data type
Used to store Unicode characters (for example the languages Arabic, German and so on)
Occupies 2 bytes of space for each character

```SQL
DECLARE @string NCHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len'  
```

As you can see above, the data length column shows 40 bytes even though the size declared is 20. It's because NCHAR holds 2 bytes of space for each character.

About the **NVARCHAR** data type:

- It is a variable-length data type
- Used to store Unicode characters
- Occupies 2 bytes of space for each character

```SQL
DECLARE @string NVARCHAR(20)  
SET @string = 'Robin'  
SELECT @string AS 'String', DATALENGTH(@string) AS 'Datalength' , LEN(@string) AS 'Len' 
```

As in the output above, you will observe DATALENGTH column is showing only 10 as a value. That is because it occupies 2 bytes of space for each character and the data length is only 5 characters, therefore it will occupy 10 bytes of space in the database.

**When to use what?**

If your column will store a fixed-length Unicode characters like French, Arabic and so on characters then go for NCHAR. If the data stored in a column is Unicode and can vary in length, then go for NVARCHAR. 
Querying to NCHAR or NVARCHAR is a bit slower then CHAR or VARCHAR. So don't go for NCHAR or NVARCHAR to store non-Unicode characters even though this data type supports that. 