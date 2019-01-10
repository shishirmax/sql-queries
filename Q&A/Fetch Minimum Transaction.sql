CREATE TABLE TransSummary
(
	CutomerID INT,
	TransactionAmount INT,
	TransMonth VARCHAR(100),
	TransYear INT
)

INSERT INTO TransSummary
VALUES
(101,300,'January',2018),
(101,500,'February',2018),
(101,600,'March',2018),
(101,700,'April',2018),
(101,1022,'May',2018),
(101,1500,'June',2018),
(102,1300,'January',2018),
(102,1500,'February',2018),
(102,1600,'March',2018),
(102,1700,'April',2018),
(102,11022,'May',2018),
(102,11500,'June',2018),
(103,1500,'January',2018),
(103,650,'February',2018),
(103,250,'March',2018),
(103,1500,'April',2018),
(103,15022,'May',2018),
(103,15500,'June',2018)

SELECT * FROM TransSummary

SELECT T.* FROM TransSummary T
INNER JOIN
(
  SELECT CutomerID,MIN(TransactionAmount) MinTransactionAmount FROM TransSummary GROUP BY CutomerID
)T1
ON T1.CutomerID=T.CutomerID
WHERE T1.MinTransactionAmount=T.TransactionAmount