DECLARE @var INT
SELECT @var = 5
WHILE @var>0
	BEGIN
		PRINT REPLICATE('* ',@var)
		SET @var = @var - 1
	END

/*
REPLICATE Function
Syntax: REPLICATE ( string_expression ,integer_expression )  
Repeats a string value a specified number of times.

#string_expression
Is an expression of a character string or binary data type. string_expression can be either character or binary data.

#integer_expression
Is an expression of any integer type, including bigint. If integer_expression is negative, NULL is returned.


*/

DECLARE @str VARCHAR(100)
SET @str = 'BINGO'

SELECT @str As OriginalVariable,REPLICATE('0',2)+@str As VariableWithReplicate