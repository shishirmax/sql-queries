/*
USING COALESCE
When we have multi-value attribute with single or more null values in a Table, the Coalesce() function is very useful.
*/
create table tbl_coalesce(
id int identity(100,1),
name varchar(100),
phone_no varchar(10),
AltPhn_no varchar(10),
Office_no varchar(10))

truncate table tbl_coalesce
insert into tbl_coalesce
values
('John','9595959598',NULL,NULL),
('Bruce','8989898989','8578457845','1245785896'),
('Khan',NULL,NULL,'1212121212'),
('Victor','4578124556',NULL,'1212121212')

select * from tbl_coalesce

select 
id,name,coalesce(phone_no,AltPhn_no,Office_no) as Contact_Number
from tbl_coalesce

/*
The above Employee table may have single value or three values. 
If it has single value, then it fills null values with remaining attributes.

When we retrieve the number from employee table, that number Should Not be Null value. 
To get not null value from employee table, we use Coalesce() function. 
It returns the first encountered Not Null Value from employee table.
*/