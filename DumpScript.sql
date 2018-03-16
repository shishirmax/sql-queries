CREATE TABLE ZeroRez.ZeroRezQuickbookDump_FF
(
	ID					INT IDENTITY(1,1)			
	,[Type]				NVARCHAR(MAX)
	,[Date]				NVARCHAR(MAX)
	,Num				NVARCHAR(MAX)
	,Memo				NVARCHAR(MAX)
	,[Name]				NVARCHAR(MAX)
	,Item				NVARCHAR(MAX)
	,ItemDescription	NVARCHAR(MAX)
	,Qty				NVARCHAR(MAX)
	,SalesPrice			NVARCHAR(MAX)
	,Amount				NVARCHAR(MAX)
	,Balance			NVARCHAR(MAX)
	,[FileName]			NVARCHAR(MAX)
	,GoodToImport		NVARCHAR(MAX)
	,ErrorDescription	NVARCHAR(MAX)
	,ModifiedDate		DATETIME
	,LogTaskID			NVARCHAR(MAX)
)
GO

ALTER TABLE ZeroRez.ZeroRezQuickbookDump_FF ADD  DEFAULT ((1)) FOR [GoodToImport]
GO

ALTER TABLE ZeroRez.ZeroRezQuickbookDump_FF ADD  CONSTRAINT [df_ZeroRezQuickbookDump_FF_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

SELECT TOP 10 * FROM ZeroRez.ZeroRezQuickbookDump_FF
ORDER BY ID

INSERT INTO ZeroRez.ZeroRezQuickbookDump_FF
(Type
,Date
,Num
,Memo
,Name
,Item
,ItemDescription
,Qty
,SalesPrice
,Amount
,Balance
,FileName
)
SELECT
[Type]
,[Date]
,Num
,Memo
,[Name]
,Item
,[Item Description]
,Qty
,[Sales Price]
,Amount
,Balance
,[FileName]
FROM ZeroRez.March_2018_Quickbook_Dump
WHERE NameType IS NULL