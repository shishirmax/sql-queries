--https://stackoverflow.com/questions/46902242/count-in-sql-statement

 create table companyData(
 comp varchar(100),
 id varchar(100),
 name varchar(100),
 type varchar(100))

 insert into companyData
 values
('AAA','D2222','Jon','BR11'),
('AAA','D2222','Jon','BR12'),
('AAA','D2865','Toe','BR11'),
('BBB','D4151','Sue','BR11'),
('BBB','D4151','Sue','BR12'),
('BBB','D4151','Sue','BR13'),
('CCC','D6080','Pete','BR14'),
('CCC','D6723','Tom','BR13')

select * from companyData


SELECT Comp, 
    SUM(CASE WHEN type = 'BR11' THEN 1 ELSE 0 END) BR11,
    SUM(CASE WHEN type = 'BR12' THEN 1 ELSE 0 END) BR12,
    SUM(CASE WHEN type = 'BR13' THEN 1 ELSE 0 END) BR13,
    SUM(CASE WHEN type = 'BR14' THEN 1 ELSE 0 END) BR14
FROM companyData
GROUP BY Comp

--select * from companyData
--pivot(
--count(type)
--for id
--in([BR11],[BR12],[BR13],[BR14]))
--As pivotdate