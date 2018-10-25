USE [Portal_Data204]
GO

ALTER TABLE [BCMyday].[PriorityBrand] DROP CONSTRAINT [CK_PriorityBrand]
GO

ALTER TABLE [BCMyday].[PriorityBrand]  WITH CHECK ADD  CONSTRAINT [CK_PriorityBrand] CHECK  (((case when coalesce([TradeMarkID],(-1))>(0) then (1) else (0) end+case when coalesce([BrandID],(-1))>(0) then (1) else (0) end)=(1)))
GO

ALTER TABLE [BCMyday].[PriorityBrand] CHECK CONSTRAINT [CK_PriorityBrand]
GO

USE [Portal_Data204]
GO

ALTER TABLE [BCMyday].[PriorityBottler] DROP CONSTRAINT [CK_PriorityBottler]
GO

ALTER TABLE [BCMyday].[PriorityBottler]  WITH CHECK ADD  CONSTRAINT [CK_PriorityBottler] CHECK  ((((((case when coalesce([BottlerID],(-1))>(0) then (1) else (0) end+case when coalesce([RegionID],(-1))>(0) then (1) else (0) end)+case when coalesce([DivisionID],(-1))>(0) then (1) else (0) end)+case when coalesce([ZoneID],(-1))>(0) then (1) else (0) end)+case when coalesce([SystemID],(-1))>(0) then (1) else (0) end)=(1)))
GO

ALTER TABLE [BCMyday].[PriorityBottler] CHECK CONSTRAINT [CK_PriorityBottler]
GO

USE [Portal_Data204]
GO

ALTER TABLE [BCMyday].[PriorityChain] DROP CONSTRAINT [CK_PriorityChain]
GO

ALTER TABLE [BCMyday].[PriorityChain]  WITH CHECK ADD  CONSTRAINT [CK_PriorityChain] CHECK  ((((case when coalesce([NationalChainID],(-1))>(0) then (1) else (0) end+case when coalesce([RegionalChainID],(-1))>(0) then (1) else (0) end)+case when coalesce([LocalChainID],(-1))>(0) then (1) else (0) end)=(1)))
GO

ALTER TABLE [BCMyday].[PriorityChain] CHECK CONSTRAINT [CK_PriorityChain]
GO




