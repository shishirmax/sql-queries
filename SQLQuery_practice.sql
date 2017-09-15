/*
URL: http://a4academics.com/interview-questions/53-database-and-sql/397-top-100-database-sql-interview-questions-and-answers-examples-queries
*/

--fetch the tables present in the database selected
select * from sys.tables

create table tblEmployee(
Employee_id int identity(1,1),
First_Name varchar(100),
Last_Name varchar(100),
Salary bigint,
Joining_date datetime,
Department varchar(100))

insert into tblEmployee
values
('John','Abraham',10000,'01-JAN-13','Banking'),
('Michael','Clarke',80000,'01-JAN-13','Insurance'),
('Roy','Thomas',70000,'01-FEB-13','Banking'),
('Tom','Jose',60000,'01-FEB-13','Insurance'),
('Jerry','Pinto',65000,'01-FEB-13','Insurance'),
('Philip','Mathew',75000,'01-JAN-13','Services'),
('Bruce','Wayne',65000,'01-JAN-13','Services'),
('Demi','Lovato',60000,'01-FEB-13','Insurance')
truncate table tblEmployee

select MONTH(joining_date) from tblEmployee

create table tblIncentives(
Employee_ref_id int,
Incentive_date datetime,
Incentive_amount int)

insert into tblIncentives
values
(1,'01-FEB-13',5000),
(2,'01-FEB-13',3000),
(3,'01-FEB-13',4000),
(1,'01-JAN-13',4500),
(2,'01-JAN-13',3500)

select * from tblEmployee
--select * from tblIncentives

select top 5 First_Name
from tblEmployee
order by Joining_date asc

select * from tblEmployee
join tblIncentives
on
tblEmployee.Employee_id = tblIncentives.Employee_ref_id
order by tblIncentives.Incentive_date

--selecting employee details from employee table if data exist in incentive table
select * from tblEmployee where exists(select * from tblIncentives)

--Select 20 % of salary from John , 10% of Salary for Roy and for other 15 % of salary from employee table
SELECT FIRST_NAME, 
	CASE FIRST_NAME WHEN 'John' 
			THEN SALARY * .2 
		WHEN 'Roy' 
			THEN SALARY * .10 
		ELSE SALARY * .15 
	END "Deduced_Amount",
	Salary,
	Department 
FROM tblEmployee

--Select Banking as 'Bank Dept', Insurance as 'Insurance Dept' and Services as 'Services Dept' from employee table

SELECT *,
	case DEPARTMENT 
		when 'Banking' then 'Bank Dept' 
		when 'Insurance' then 'Insurance Dept' 
		when 'Services' then 'Services Dept' 
	end 
FROM tblEmployee
---------------------------------------------------------------
/*
URL:https://stackoverflow.com/questions/45859688/calculating-variance-between-two-days-in-a-column
*/

create table variance(
fruit varchar(100),
vdate datetime,
profit decimal(10,2),
rolling_avg decimal(10,2))

insert into variance
values
('Apple','2014-01-16',5.61,0.80),
('Apple','2014-01-17',3.12,1.25),
('Apple','2014-01-18',2.20,1.56),
('Apple','2014-01-19',3.28,2.03),
('Apple','2014-01-20',7.59,3.11),
('Apple','2014-01-21',3.72,3.65),
('Apple','2014-01-22',1.11,3.80),
('Apple','2014-01-23',5.07,3.73)

select * from variance

--SELECT
--   [current].rowInt,
--   [current].Value,
--   ISNULL([next].Value, 0) - [current].Value
--FROM
--   sourceTable       AS [current]
--LEFT JOIN
--   sourceTable       AS [next]
--      ON [next].rowInt = (SELECT MIN(rowInt) FROM sourceTable WHERE rowInt > [current].rowInt)


select fruit,vdate,profit,rolling_avg,
	LAG(profit,1,0) over(order by day(vdate)) as previousprofit,
	((profit-LAG(profit) over(order by day(vdate)))/LAG(profit) over(order by day(vdate))) as variance_percent
from variance

--------------------
--HackerRank Problem(SQL) The Report
create table student(
id int,
name varchar(100),
marks int)

insert into student
values
(1,'Julia',88),
(2,'Samantha',68),
(3,'Maria',99),
(4,'Scarlet',78),
(5,'Ashley',63),
(6,'Jane',81)

create table grades(
grade int,
min_mark int,
max_mark int)

insert into grades
values
(1,0,9),
(2,10,19),
(3,20,29),
(4,30,39),
(5,40,49),
(6,50,59),
(7,60,69),
(8,70,79),
(9,80,89),
(10,90,100)

select * from student
select * from grades

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
order by grades.grade desc,student.name,student.marks

--HackerRank Top Competitors
create table Hackers(
hacker_id int,
name varchar(100))

create table Difficulty(
difficulty_level int,
score int)

create table Challenges(
challenge_id int,
hacker_id int,
difficulty_level int)

create table Submissions(
submission_id int,
hacker_id int,
challenge_id int,
score int)

insert into Hackers
values
(5580,'Rose'),
(8439,'Angela'),
(27205,'Frank'),
(52243,'Patrick'),
(52348,'Lisa'),
(57645,'Kimberly'),
(77726,'Bonnie'),
(83082,'Michael'),
(86870,'Todd'),
(90411,'Joe')

--To Check the size of stored data use DATALENGTH
select *,DATALENGTH(name) from Hackers


insert into Difficulty
values
(1,20),
(2,30),
(3,40),
(4,60),
(5,80),
(6,100),
(7,100)

insert into Challenges
values
(4810,77726,4),
(21089,27205,1),
(36566,5580,7),
(66730,52243,6),
(71055,52243,2)

insert into Submissions
values
(68628,77726,36566,30),
(65300,77726,21089,10),
(40326,52243,36566,77),
(8941,27205,4810,4),
(83554,77726,66730,30),
(43353,52243,66730,0),
(55385,52348,71055,20),
(39784,27205,71055,23),
(94613,868780,71055,30)

SELECT h.hacker_id, h.name
    FROM submissions s
    JOIN challenges c
        ON s.challenge_id = c.challenge_id
    JOIN difficulty d
        ON c.difficulty_level = d.difficulty_level 
    JOIN hackers h
        ON s.hacker_id = h.hacker_id
    WHERE s.score = d.score 
        AND c.difficulty_level = d.difficulty_level
    GROUP BY h.hacker_id
        HAVING COUNT(s.hacker_id) > 1
    ORDER BY COUNT(s.hacker_id) DESC, s.hacker_id ASC

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

--Computed Columns
create table ComputedColumns(
column1 int,
column2 int,
column3 int,
AverageColumn as (column1+column2+column3)/3
)

insert into ComputedColumns
values
(2,4,5),
(12,45,76),
(33,66,11)

select * from ComputedColumns

select * from sys.tables
select 'shishir'+'('+upper(substring('shishir',1,1))+')'

select * from tblEmployee

SELECT IIF(1 > 10, 'TRUE', 'FALSE' )

BCP shishir.tblEmployee out c:\tblEmployeeData.txt -SSHISHIRS -T -c