/*
Coalesce Function
The COALESCE function in SQL returns the first non-NULL expression among its arguments. The syntax for COALESCE is as follows:

COALESCE ("expression 1", "expressions 2", ...)

It is the same as the following CASE statement:

SELECT CASE ("column_name")
  WHEN "expression 1 is not NULL" THEN "expression 1"
  WHEN "expression 2 is not NULL" THEN "expression 2"
  ...
  [ELSE "NULL"]
  END
FROM "table_name";
*/

CREATE TABLE Contact_info(
	Name VARCHAR(255)
	,Business_Phone VARCHAR(15)
	,Cell_Phone VARCHAR(15)
	,Home_Phone VARCHAR(15)
	)

INSERT INTO Contact_info
VALUES
('Jeff','531-2531','622-7813','565-9901'),
('Laura',NULL,'772-5588','312-4088'),
('Peter',NULL,NULL,'594-7477')

SELECT * FROM Contact_info

/*
Want to find out the best way to contact each person according to the following rules:
1. If a person has a business phone, use the business phone number.
2. If a person does not have a business phone and has a cell phone, use the cell phone number.
3. If a person does not have a business phone, does not have a cell phone, and has a home phone, use the home phone number.
*/

--We can use the COALESCE function to achieve our goal:

SELECT 
	Name
	,COALESCE (Business_Phone, Cell_Phone, Home_Phone) Contact_Phone 
FROM Contact_Info