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
A.filename,B.filename2,
count(A.filename)as filecount_TableA,
count(B.filename2)as filecount_TableB,
totalCount = (
				select count(distinct filename) from filedata
				join filedata2
				on filedata.filename = filedata2.filename2
			 )
from filedata A
join filedata2 B
on A.filename = B.filename2
group by A.filename, B.filename2


select count(*) from
(
select count(distinct filename) from filedata
join filedata2
on filedata.filename = filedata2.filename2
) T

select count(distinct filename) from filedata
select count(distinct filename2) from filedata2

select count(filename)as filecount_TableA from filedata
select count(filename2)as filecount_TableB from filedata2

select count(distinct filename) as totalcount
from filedata


select 
A.filename,
count(A.filename)as filecount_TableA,
totalCount = (
				select count(distinct filename) from filedata
			 )
from filedata A
group by A.filename


SELECT filename, COUNT( * ) AS filecount_TableA
FROM filedata
GROUP BY filename

SELECT filename2, COUNT( * ) AS filecount_TableB
FROM filedata2
GROUP BY filename2

SELECT filename, filename2, filecount_TableA, filecount_TableB, ISNULL( filecount_TableA, 0 ) + ISNULL( filecount_TableB, 0 ) AS totalCount,
    COUNT(*) OVER() AS UniqueFileCount
FROM
        ( SELECT filename, COUNT( * ) AS filecount_TableA
        FROM filedata
        GROUP BY filename ) AS A
    --FULL OUTER JOIN
	inner join
            ( SELECT filename2, COUNT( * ) AS filecount_TableB
            FROM filedata2
            GROUP BY filename2 ) AS B
        ON A.filename = B.filename2
