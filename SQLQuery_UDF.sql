alter function calculateAge(@dob date)
returns int
as
begin

declare @age int

set @age = DATEDIFF(year,@dob,GETDATE()) - 
			case 
				when (MONTH(@dob) > MONTH(getdate())) or
					 (MONTH(@dob) = MONTH(getdate()) and day(@dob) > DAY(getdate()))
				then 1
				else 0
			end
return @age
end

--invoking the function
select dbo.calculateAge('06/03/1991')