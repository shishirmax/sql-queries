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