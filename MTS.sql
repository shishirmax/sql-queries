USE [Shishir]
GO

/****** Object:  Table [dbo].[MTD]    Script Date: 7/7/2017 6:47:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTD](
	[DatePosted] [datetime] NULL,
	[ItemDatePosted] [datetime] NULL,
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
	[CustomerName] [varchar](50) NULL,
	[Transaction_Status] [varchar](10) NULL DEFAULT ('A')
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


