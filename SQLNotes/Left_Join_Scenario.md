### Left Join Scenario
Let there are two table tblEmployee and tblDepartment.
the common column between two table is DepartmentId column from tblEmployee table and ID column from tblDepartment table.

#### Table Structure:
**tblEmployee:**

|ID |Name    |Gender    |Salary |DepartmentID|
|-- |----    |------    |------ |------------|
|1	|Tom	 |Male	    |4000	|1           |
|2	|Pam	 |Female	|3000	|3           |
|3	|John	 |Male	    |3500	|1           |
|4	|Sam	 |Male	    |4500	|2           |
|5	|Todd	 |Male	    |2800	|2           |
|6	|Ben	 |Male	    |7000	|1           |
|7	|Sara	 |Female	|4800	|3           |
|8	|Valarie |Female	|5500	|1           |
|9	|James	 |Male	    |6500	|NULL        |
|10 |Russell |Male	    |8800	|NULL        |

**tblDepartment:**

|ID |DepartmentName     |Location   |DepartmentHead|
|-- |------------------ |-----------|--------------|
|1	|IT	                |London	    |Rick          |
|2	|Payroll	        |Delhi	    |Ron           |
|3	|HR	                |New York	|Christie      |
|4	|Other Department	|Sydney	    |Cindrella     |

**SQL Query 1**

when condition used with on clause
```SQL
select * from tblEmployee
left join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.ID
and tblEmployee.DepartmentId = 1
```

**SQL Query 2**

when condition used using where clause
```SQL
select * from tblEmployee
left join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.ID
where tblEmployee.DepartmentId = 1
```