select * from tbljoin_1
select * from tbljoin_2

insert into tbljoin_1
values
('4')


select * from tbljoin_1
union
select * from tbljoin_2

select * from tbljoin_1 A
left join tbljoin_2 B
on A.tblColumn = B.tblColumn

CREATE TABLE StudentClass
(ID INT,
StudentName VARCHAR(100),
ClassName VARCHAR(100),
Marks INT)
GO
INSERT INTO StudentClass
SELECT 1, 'Roger', 'Science', 50
UNION ALL
SELECT 2, 'Sara', 'Science', 40
UNION ALL
SELECT 3, 'Jimmy', 'Science', 30
UNION ALL
SELECT 4, 'Mike', 'Maths', 50
UNION ALL
SELECT 5, 'Mona', 'Maths', 30
UNION ALL
SELECT 6, 'Ronnie', 'Maths', 10
UNION ALL
SELECT 7, 'James', 'Art', 50
UNION ALL
SELECT 8, 'Mona', 'Art', 35
UNION ALL
SELECT 9, 'Roger', 'Art', 25
GO

SELECT *
FROM StudentClass
GO

select * from(
select *,
row_number() over(partition by classname order by marks desc) as strn
 from StudentClass) A
 where strn in (1,2)
 select @@rowcount TotalRecord



 SELECT *
FROM (
SELECT ROW_NUMBER()
OVER(PARTITION BY ClassName
ORDER BY Marks DESC) AS StRank, *
FROM StudentClass) n
WHERE StRank IN (1,2)
GO