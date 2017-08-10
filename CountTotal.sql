create table filedata(
id int identity(1,1),
filename varchar(100)
)

create table filedata2(
id int identity(1,1),
filename2 varchar(100)
)

insert into filedata
values
('file1'),
('file1'),
('file2'),
('file2'),
('file3'),
('file4')


insert into filedata2
values
('file1'),
('file1'),
('file1'),
('file2'),
('file2'),
('file3'),
('file3'),
('file4'),
('file4')

select * from filedata
select * from filedata2

select 
filename,
count(filename)as filecount,
totalCount = (
				select count(distinct filename) from filedata
				join filedata2
				on filedata.filename = filedata2.filename2
			 )
from filedata
group by filename


select count(*) from
(
select count(distinct filename) from filedata
join filedata2
on filedata.filename = filedata2.filename2
) T

select count(distinct filename) from filedata
select count(distinct filename2) from filedata2