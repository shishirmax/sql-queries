--Remove Trailing Spaces and Update in Columns in SQL Server

select * from tblEmployee
where Name like '% '

update tblEmployee set Name = LTRIM(RTRIM(Name))

insert into tblEmployee
values
(11,' John ',' Male ',45800,1)