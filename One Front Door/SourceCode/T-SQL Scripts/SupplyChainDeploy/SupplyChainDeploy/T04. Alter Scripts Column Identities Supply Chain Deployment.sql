use Portal_Data
Go

ALTER TABLE [SupplyChain].[MeasursType]  WITH CHECK ADD FOREIGN KEY([DeptID])
REFERENCES [SupplyChain].[Departments] ([DeptID])
GO

ALTER TABLE [SAP].[TradeMark]  
ADD  CONSTRAINT [FK_TradeMark_ProductLine] FOREIGN KEY([ProductLineID])
REFERENCES [SAP].[ProductLine] ([ProductLineID])
GO

