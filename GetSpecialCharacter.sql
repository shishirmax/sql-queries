
create table tbl ( col varchar(40) NULL)

insert into tbl VALUES ('lowercase')
insert into tbl VALUES ('UPPER')
insert into tbl VALUES ('0123')
insert into tbl VALUES ('special characters & ^')
insert into tbl VALUES ('special characters ! \/')
insert into tbl VALUES ('special characters _ + = ')
insert into tbl VALUES (NULL)

SELECT * FROM tbl WHERE PATINDEX('%[^a-zA-Z0-9]%',col) >1

drop table tbl