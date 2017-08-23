# Q1: A table containing the students enrolled in a yearly course has incorrect data in records with ids between 20 and 100 (inclusive).

```sh
TABLE enrollments
  id INTEGER NOT NULL PRIMARY KEY
  year INTEGER NOT NULL
  studentId INTEGER NOT NULL
```
Write a query that updates the field *'year'* of every faulty record to 2015.

### Solution:
	update enrollments
	        set year = 2015
	        where id between 20 and 100
---	
# Q2: Given the following data definition, write a query that returns the number of students whose first name is John.

```sh
TABLE students
   id INTEGER PRIMARY KEY,
   firstName VARCHAR(30) NOT NULL,
   lastName VARCHAR(30) NOT NULL
```

### Solution:
	select count(*) from students
	    where firstname = 'John'
---	
# Q3:Information about pets is kept in two separate tables:

```sh
TABLE dogs
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
```
```sh
TABLE cats
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
```

Write a query that select all distinct pet names.
#### Example case create statement:

```sh
	CREATE TABLE dogs (
	  id INTEGER NOT NULL PRIMARY KEY, 
	  name VARCHAR(50) NOT NULL
	);

	CREATE TABLE cats (
	  id INTEGER NOT NULL PRIMARY KEY, 
	  name VARCHAR(50) NOT NULL
	);

	INSERT INTO dogs(id, name) values(1, 'Lola');
	INSERT INTO dogs(id, name) values(2, 'Bella');
	INSERT INTO cats(id, name) values(1, 'Lola');
	INSERT INTO cats(id, name) values(2, 'Kitty');
```
#### Expected output (in any order):
| Name  |
| ----  |
| Bella |   
| Kitty |   
| Lola  |	

### Solution:
	select distinct name from dogs
	union  
	select distinct name from cats
---	
# Q4:Each item in a web shop belongs to a different seller. To ensure service quality, each seller has a rating.

The data are kept in the following two tables:

```sh
TABLE sellers
  id INTEGER PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  rating INTEGER NOT NULL
```
```sh
TABLE items
  id INTEGER PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  sellerId INTEGER REFERENCES sellers(id)
```
Write a query that selects the item name and the name of its seller for each item that belongs to a seller with a rating of more than 4.

#### Example case create statement:
```sh
	CREATE TABLE sellers (
	  id INTEGER NOT NULL PRIMARY KEY,
	  name VARCHAR(30) NOT NULL,
	  rating INTEGER NOT NULL
	);

	CREATE TABLE items (
	  id INTEGER NOT NULL PRIMARY KEY,
	  name VARCHAR(30) NOT NULL,
	  sellerId INTEGER REFERENCES sellers(id)
	);

	INSERT INTO sellers(id, name, rating) VALUES(1, 'Roger', 3);
	INSERT INTO sellers(id, name, rating) VALUES(2, 'Penny', 5);

	INSERT INTO items(id, name, sellerId) VALUES(1, 'Notebook', 2);
	INSERT INTO items(id, name, sellerId) VALUES(2, 'Stapler', 1);
	INSERT INTO items(id, name, sellerId) VALUES(3, 'Pencil', 2);
```
#### Expected output (in any order):
| Item |Seller|
| ---- |------|
| Notebook | Penny |
| Pencil | Penny |

### Solution:
```sh
	select 
	  items.name,
	  sellers.name
	from items
	join sellers
	on
	items.sellerId = sellers.id
	where
	sellers.rating > 4
```
---
# Q5:App usage data are kept in the following table:

```sh
TABLE sessions
  id INTEGER PRIMARY KEY,
  userId INTEGER NOT NULL,
  duration DECIMAL NOT NULL
```
Write a query that selects userId and average session duration for each user who has more than one session.

#### Example case create statement:
```sh
	CREATE TABLE sessions (
	  id INTEGER NOT NULL PRIMARY KEY,
	  userId INTEGER NOT NULL,
	  duration DECIMAL NOT NULL
	);

	INSERT INTO sessions(id, userId, duration) VALUES(1, 1, 10);
	INSERT INTO sessions(id, userId, duration) VALUES(2, 2, 18);
	INSERT INTO sessions(id, userId, duration) VALUES(3, 1, 14);
```
#### Expected output:
| UserId | AverageDuration|
| -------|---------------|
| 1      | 12	|

### Solution:
```sh
	select userId,AVG(duration) from sessions
	    group by userId
	    having count(userId)>1
```
---

# Q6:Given the following data definition, write a query that selects the names of employees that are not managers.

```sh
TABLE employees
  id INTEGER NOT NULL PRIMARY KEY
  managerId INTEGER REFERENCES employees(id)
  name VARCHAR(30) NOT NULL
```

#### Example case create statement:
```sh
	CREATE TABLE employees (
	  id INTEGER NOT NULL PRIMARY KEY,
	  managerId INTEGER REFERENCES employees(id), 
	  name VARCHAR(30) NOT NULL
	);

	INSERT INTO employees(id, managerId, name) VALUES(1, NULL, 'John');
	INSERT INTO employees(id, managerId, name) VALUES(2, 1, 'Mike');
	INSERT INTO employees(id, managerId, name) VALUES(3, NULL, 'Liz');
	INSERT INTO employees(id, managerId, name) VALUES(4, 3, 'Bob');
```

#### Expected output (in any order):
| name|
| ----|
| Mike|

#### Explanation:
> In this example.
John is Mike's manager. Mike does not manage anyone.
Mike is the only employee who does not manage anyone.  

### Solution:
```sh
select name from employees
where id IN (select id from employees where managerId is not null)
```
Note: -- *Solution is under development*
