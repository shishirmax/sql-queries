select Country.Continent,AVG(CITY.Population)
from CITY
join Country
on CITY.CountryCode = Country.Code
group by country.continent

--The Report
select 
	CASE
		when grades.grade<8
			Then NULL
		ELSE 
			student.name
	END As Name,student.marks,grades.grade
from student
join grades
on student.marks between grades.min_mark and grades.max_mark
order by grades.grade desc,student.name

--Top Competitors
select h.hacker_id, h.name
from submissions s
inner join challenges c
on s.challenge_id = c.challenge_id
inner join difficulty d
on c.difficulty_level = d.difficulty_level 
inner join hackers h
on s.hacker_id = h.hacker_id
where s.score = d.score 
group by h.hacker_id, h.name
having count(h.hacker_id) > 1
order by count(h.hacker_id) desc, h.hacker_id asc;

--Higher Than 75 Marks
select name from students
where marks > 75
order by right(name,3),id

--Weather Observation Station 5
select top 1 max(CITY),LEN(max(CITY)) from STATION  group by CITY order by LEN(max(CITY)) desc,CITY;
select top 1 min(CITY),LEN(min(CITY)) from STATION group by CITY order by LEN(min(CITY)),CITY;

--Weather Observation Station 14
select cast(max(lat_n)as decimal(10,4))  from station
where lat_n < 137.2345

--Weather Observation Station 15
select cast(long_w as decimal(10,4)) from station
where lat_n=(select max(lat_n)from station where lat_n<137.2345)

--Weather Observation Station 16
select cast(min(lat_n) as decimal(10,4)) from station 
where lat_n>38.7780

--Weather Observation Station 17
select cast(long_w as decimal(10,4)) from station
where lat_n = (select min(lat_n) from station where lat_n>38.7780)

--Weather Observation Station 18
select CAST((ABS(min(lat_n)-max(lat_n))+ABS(min(long_w)-max(long_w))) as decimal(10,4)) 
from station

--Type of Triangle
/*
SELECT CASE WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
            WHEN A = B AND B = C THEN 'Equilateral'
            WHEN A = B OR A = C OR B = C THEN 'Isosceles'
            ELSE 'Scalene'
        END
FROM TRIANGLES
*/
--OR--
SELECT CASE WHEN A + B <= C THEN 'Not A Triangle'
            WHEN A = B AND B = C THEN 'Equilateral'
            WHEN A = B OR A = C OR B = C THEN 'Isosceles'
            ELSE 'Scalene'
        END
FROM TRIANGLES

--The PADS
select name+'('+upper(substring(occupation,1,1))+')' from occupations order by name;
select 'There are a total of '+occupation_count+' '+lower(occupation)+'s.' from (select occupation,CAST(count(occupation)as varchar) as occupation_count from occupations
group by occupation)S
order by occupation_count,occupation asc;

--Occupations
select Doctor,Professor, Singer, Actor from 
(select 
    name,
    occupation,
    rank() over(partition by occupation order by name) rnk from occupations) sorce 
    pivot
        (max(name) for occupation in (Doctor,Professor, Singer, Actor)) pivoting order by rnk;

--Binary Tree Nodes
SELECT N, 
    CASE 
        WHEN P IS NULL 
            THEN 'Root' 
        WHEN (SELECT COUNT(*) FROM BST WHERE P=B.N)>0 
            THEN 'Inner' 
        ELSE 'Leaf' 
    END 
FROM BST AS B ORDER BY N;