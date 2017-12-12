CREATE FUNCTION dbo.udf_GetNumeric
(@strAlphaNumeric VARCHAR(256))
RETURNS VARCHAR(256)
AS
BEGIN
	DECLARE @intAlpha INT
	SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric)
		BEGIN
			WHILE @intAlpha > 0
				BEGIN
					SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
					SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric )
				END
		END
	RETURN ISNULL(@strAlphaNumeric,0)
END
;

declare @str varchar(100)
set @str = '100godha'
select PATINDEX('%[^0-9]%', @str)

select STUFF('100godha', 1, 1, '' )

create table testing(
    alphanumeric varchar(100)
    )

insert into testing
(alphanumeric)
values
('-чу+0!\aК1234')

select * from testing

SELECT alphanumeric,dbo.udf_GetNumeric(alphanumeric) 
from testing