--'<buqueid:K-0001>'

select Right('<buqueid:K-0001>',1)
select LEFT('<buqueid:K-0001>',1)

select CHARINDEX(':','<buqueid:K-0001>')
select CHARINDEX(':','<buqueid:M5-0001>')
select CHARINDEX(':','<buqueid:M-0002>')

select LEFT('<buqueid:K-0001>',CHARINDEX(':','<buqueid:K-0001>'))
select RIGHT('<buqueid:M5-0001>',CHARINDEX(':','<buqueid:M5-0001>'))
select RIGHT('<buqueid:M-0002>',CHARINDEX(':','<buqueid:M-0002>'))

select RIGHT('<buqueid:M5-0001>',1)

declare @comment varchar(max)
set @comment = '<buqueid:M5-0001>'
--select Replace(RIGHT(@comment,CHARINDEX(':',@comment)-1),'>','')
select REPLACE(SUBSTRING(@comment,CHARINDEX(':','<buqueid:K-0001>')+1,LEN(@comment)),'>','')