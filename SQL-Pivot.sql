-- creating a table
Create Table Student(
StudentName varchar(50),
Subject varchar(50),
Marks INT)

--inserting record in the table
insert into Student (StudentName,Subject,Marks)
--values('John','Maths',85),
--values('Paul','Maths',96),
--values('Raven','Maths',78),
--values('Paul','Science',91),
values('John','Science',62)

--select all record from the table
select * from Student
--Result---------------------
--|StudentName|Subject|Marks|
--|John	      |Hindi  |85   |
--|Paul	      |Hindi  |96   |
--|Raven      |English|78   |
--|Paul	      |English|91   |
--|John	      |English|62   |
--|John	      |Maths  |85   |
--|Paul	      |Maths  |96   |
--|Raven	  |Maths  |78   |
--|Paul	      |Science|91   |
--|John	      |Science|62   |

--PIVOT table
Select StudentName as StudentName,[Hindi],[English],[Maths],[Science]
FROM
(
Select studentname,subject,marks from student) as sourcetable
PIVOT
(
SUM(marks)
FOR subject in (hindi,english,maths,science)
) As PivotTable

--Result
--|StudentName|Hindi|English|Maths|Science|
--|John	      |85	|62	    |85	  |62     |
--|Paul	      |96	|91	    |96	  |91     |
--|Raven	  |NULL	|78	    |78	  |NULL   |