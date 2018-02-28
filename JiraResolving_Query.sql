SELECT * FROM [ZeroRez].[DimClient] 
WHERE 
FirstName LIKE '%[^a-z,A-Z, ]%' 
OR
lastName LIKE '%[^a-z,A-Z, ]%'

/*
Characters Found 
1. (.)Dot e.g: Eric M., Emily.
2. (&) e.g: Eric & Allie, Ericka & Adam
3. (') e.g: O'Brien, O'Kane
4. () Name inside bracket e.g: James (Jim), James (Peter)
5. ("") e.g: James Jim""
6. (/) Name seperated using / e.g: Jana/ Linda/Norleen
7. (-) Name seperated using - e.g: Adamson-Waitley
*/

SELECT * FROM [ZeroRez].[DimClient] 
WHERE FirstName LIKE '%[0-9]%'
OR
LastName LIKE '%[0-9]%'

DECLARE @str VARCHAR(400)
DECLARE @expres  VARCHAR(50) = '%[0-9]%'
SET @str = 'Hoang Van-63'
WHILE PATINDEX( @expres, @str ) > 0
SET @str = Replace(REPLACE( @str, SUBSTRING( @str, PATINDEX( @expres, @str ), 1 ),''),'-',' ')
SELECT @str

select REPLACE(REPLACE('Mary @ Dan','@',''),'  ',' ')

select top 10 * from ZeroRez.ZeroRez_bcp  

