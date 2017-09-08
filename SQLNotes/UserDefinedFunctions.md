##### SQL Server has 3 types of User Defined Functions
1. Scalar Functions
2. Inline table-valued functions
3. Multi-statement table-valued functions

Scalar functions may or may not have parameters, but always return a single(scalar) value. 
The returned value can be of any data type,except text,ntext,image,cursor and timestamp.

**Syntax to create a function.**
```SQL
Create FUNCTION function_name(@parameter1 Datatype, @Parameter2 Datatype,....@ParameterN Datatype)
RETURNS Return_Datatype
As
Begin
	--Function Body
	Return Return_Datatype
End
```


A Store procedure also can accept parameter and return the result, but you cannot use store procedure
in a select or where clause. This is just one difference between a function and a store procedure.

To alter a function we can use ALTER FUNCTION FunctionName statement and to delete it, we can use DROP Function FunctionName.

**Function To Create SplitString**

```SQL
CREATE FUNCTION [dbo].[fnSplitString] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX)) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END
```
Use it like

```SQL
select * from dbo.fnSplitString('6,7,8',',')
```
