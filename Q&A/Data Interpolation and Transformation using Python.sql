
CREATE TABLE [dbo].[tbl_loanPrediction] 
(
	Loan_ID				VARCHAR(50),
	gender				VARCHAR(50),
	Married				VARCHAR(50),
	Dependents			VARCHAR(50),
	Education			VARCHAR(50),
	SelfEmployed		VARCHAR(50),
	ApplicationIncome	VARCHAR(50),
	CoapplicantIncome	VARCHAR(50),
	LoanAmount			FLOAT ,
	Loan_Amount_Term	VARCHAR(50),
	Credit_History		VARCHAR(50),
	Property_Area		VARCHAR(50)
)

/*
Loan_ID,Gender,Married,Dependents,Education,Self_Employed,ApplicantIncome,CoapplicantIncome,LoanA
mount,Loan_Amount_Term,Credit_History,Property_Area
LP001015,Male,Yes,0,Graduate,No,5720,0,110,360,1,Urban
LP001022,Male,Yes,1,Graduate,No,3076,1500,126,360,1,Urban
LP001031,Male,Yes,2,Graduate,No,5000,1800,208,360,1,Urban
LP001035,Male,Yes,2,Graduate,No,2340,2546,100,360,,Urban
LP001051,Male,No,0,Not Graduate,No,3276,0,78,360,1,Urban
LP001054,Male,Yes,0,Not Graduate,Yes,2165,3422,152,360,1,Urban
LP001055,Female,No,1,Not Graduate,No,2226,0,59,360,1,Semiurban
LP001056,Male,Yes,2,Not Graduate,No,3881,0,147,360,0,Rural
LP001059,Male,Yes,2,Graduate,,13633,0,280,240,1,Urban
*/


BULK
INSERT [tbl_LoanPrediction]
FROM 'D:\GIT\sql-queries\Q&A\file\loanprediction.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO
--Check the content of the table.
SELECT *
FROM [tbl_LoanPrediction]
GO