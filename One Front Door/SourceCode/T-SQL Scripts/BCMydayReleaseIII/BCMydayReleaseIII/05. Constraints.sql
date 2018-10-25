USE [Portal_Data204]
GO

-------- PriorityChain --------------------------------------------------------
--- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -------------------
If Exists (Select * From sys.check_constraints Where name = 'CK_PriorityChain') 
	Alter Table [BCMyday].[PriorityChain] Drop Constraint [CK_PriorityChain] 
Go

ALTER TABLE [BCMyday].[PriorityChain]  WITH CHECK ADD  CONSTRAINT [CK_PriorityChain] CHECK  
(
	(
		(case when Coalesce([NationalChainID], -1) >(0) then (1) else 0 end) +
		(case when Coalesce(RegionalChainID, -1) >(0) then (1) else 0 end) +
		(case when Coalesce(LocalChainID, -1) > (0) then (1) else 0 end)
	) = 1
)
GO

ALTER TABLE [BCMyday].[PriorityChain] CHECK CONSTRAINT [CK_PriorityChain]
GO


-------- PriorityChain --------------------------------------------------------
--- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -------------------
If Exists (Select * From sys.check_constraints Where name = 'CK_PriorityBottler') 
	Alter Table [BCMyday].PriorityBottler Drop Constraint [CK_PriorityBottler] 
Go

ALTER TABLE [BCMyday].[PriorityBottler]  WITH CHECK ADD  CONSTRAINT [CK_PriorityBottler] CHECK  
(
	(
		(case when Coalesce(BottlerID,-1) > (0) then (1) else 0 end) +
		(case when Coalesce(RegionID,-1) > (0) then (1)  else 0  end) +
		(case when Coalesce(DivisionID,-1) > (0) then (1) else 0 end)  +
		(case when Coalesce(ZoneID,-1) > (0) then (1) else 0 end) +
		(case when Coalesce(SystemID,-1) > (0) then (1) else 0 end)
	) = 1
)
GO

ALTER TABLE [BCMyday].[PriorityBottler] CHECK CONSTRAINT [CK_PriorityBottler]
GO

-------- PriorityChain --------------------------------------------------------
--- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -------------------
If Exists (Select * From sys.check_constraints Where name = 'CK_PriorityBrand') 
	Alter Table [BCMyday].PriorityBrand Drop Constraint [CK_PriorityBrand] 
Go

ALTER TABLE [BCMyday].[PriorityBrand]  WITH CHECK ADD  CONSTRAINT [CK_PriorityBrand] CHECK  
(
	(
		(case when Coalesce(TradeMarkID,-1) > 0 then 1 else 0 end) +
		(case when Coalesce(BrandID, -1) > 0 then 1 else 0 end)
	) = 1
)
GO

ALTER TABLE [BCMyday].[PriorityBrand] CHECK CONSTRAINT [CK_PriorityBrand]
GO

