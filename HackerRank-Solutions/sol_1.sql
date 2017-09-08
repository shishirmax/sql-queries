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