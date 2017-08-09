create table filedata(
id int identity(1,1),
filename varchar(100)
)

insert into filedata
values
('file1'),
('file1'),
('file2'),
('file2'),
('file3'),
('file4')

select * from filedata

select 
filename,
count(filename)as filecount,
totalCount = (select count(distinct filename) from filedata)
from filedata
group by filename


select count(*) from
(select count(distinct filename) from filedata) T