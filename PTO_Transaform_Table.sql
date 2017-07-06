CREATE TABLE [dbo].[MTSNew](
	[DatePosted] [datetime] NULL,
	[TransactionRef] [varchar](50) NULL,
	[AttorneyDocket] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[TransactionID] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[TotalPayment] [varchar](50) NULL,
	[CustomerName] [varchar](50) NULL,
	[CSVReferenceNumber] [int] NULL
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[MTD](
	[PaymentDatePosted] [datetime] NULL,
	[SaleItemDatePosted] [datetime] NULL,
	[Reference] [varchar](50) NULL,
	[AttorneyDocket] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[TransactionID] [varchar](50) NULL,
	[SaleID] [varchar](50) NULL,
	[FeeCode] [varchar](50) NULL,
	[FeeCodeDescription] [varchar](500) NULL,
	[ItemPrice] [varchar](50) NULL,
	[Quantity] [varchar](50) NULL,
	[ItemTotal] [varchar](50) NULL,
	[CustomerName] [varchar](50) NULL
) ON [PRIMARY]

GO







