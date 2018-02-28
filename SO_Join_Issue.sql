CREATE TABLE Transactions
(
TransId INT,
AccountId INT,
PayeeId INT,
TransAmount DECIMAL(10,2),
CatId INT,
SubCatId INT,
TransDate DATETIME
)

INSERT INTO Transactions
VALUES
(3,2,2,'150.00',4,5,'03/02/2018')

CREATE TABLE Payee(
PayeeId INT,
PayeeName VARCHAR(255))

INSERT INTO Payee
VALUES
(2,'Woolworths')

CREATE TABLE Category(
CatId INT,
CatName VARCHAR(255))

INSERT INTO Category
VALUES
(4,'Groceries')

CREATE TABLE SubCategory(
SubCatId INT,
SubCategoryName VARCHAR(255),
CatId INT)

INSERT INTO SubCategory
VALUES
(5,'Food',4)

select * from Transactions
select * from Payee
select * from Category
select * from SubCategory

SELECT T.TransId, T.Transdate, P.PayeeName, T.TransAmount
FROM  Transactions AS T
LEFT JOIN Payee AS P ON T.PayeeId  = P.PayeeId 
LEFT JOIN Category as C on C.CatId = T.CatId
WHERE 
    T.AccountId  = 1
ORDER BY T.TransDate DESC