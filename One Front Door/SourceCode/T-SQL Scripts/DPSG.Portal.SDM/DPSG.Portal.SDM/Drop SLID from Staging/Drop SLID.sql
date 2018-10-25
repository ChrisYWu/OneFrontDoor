USE [Portal_Data]
GO

/****** Object:  Index [PK_SLNO]    Script Date: 9/25/2013 4:24:48 PM ******/
ALTER TABLE [Staging].[MaterialBrandPKG] DROP CONSTRAINT [PK_SLNO]
GO

ALTER TABLE [Staging].[MaterialBrandPKG] DROP Column [SLNO]
GO

