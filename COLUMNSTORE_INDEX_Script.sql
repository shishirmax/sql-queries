/****** Object:  Index [cci_idx]    Script Date: 6/7/2018 7:37:45 PM ******/
CREATE CLUSTERED COLUMNSTORE INDEX [cci_idx] ON [rba].[tblPopulationSummary_MA] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
GO


