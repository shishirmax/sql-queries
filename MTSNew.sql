USE [Shishir]
GO

/****** Object:  Table [dbo].[MTSNew]    Script Date: 7/7/2017 6:46:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTSNew](
	[DatePosted] [datetime] NULL,
	[TransactionRef] [varchar](50) NULL,
	[AttorneyDocket] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[TransactionID] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[TotalPayment] [varchar](50) NULL,
	[CustomerName] [varchar](50) NULL,
	[CSVReferenceNumber] [int] NULL,
	[PaymentType] [varchar](50) NULL DEFAULT ('Credit Card')
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


