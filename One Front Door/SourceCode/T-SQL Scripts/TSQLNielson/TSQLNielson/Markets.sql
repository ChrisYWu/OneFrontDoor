use Portal_Data
Go

SELECT [NielsenMarketID]
      ,[NielsenMarketDesc]
      ,[AccountOwnerGSN]
  FROM [MSTR].[DimNielsenMarket]


-- Carb Market --
Select MRKT_KEY, MRKT_DSC_SHORT, MRKT_DSC_LONG
From MOTTS01..CSAFSUPI.VDPSGSAUCE_MKTTAB
Where MRKT_DET_LVL = 'TRADING AREA'
-- Sauce Market --
Union
Select MRKT_KEY, MRKT_DSC_SHORT, MRKT_DSC_LONG
From MOTTS01..CSACAWPI.VDPSGCRBNTDBVRG_MKTTAB
Where MRKT_DET_LVL = 'TRADING AREA'
-- LRB(Liquid Refereshment Beverage: Ready Coffee, Energy Drink and Maybe Water)
Union
Select MRKT_KEY, MRKT_DSC_SHORT, MRKT_DSC_LONG
From MOTTS01..CSA12AXI.VDPSGLRB_MKTTAB
Where MRKT_DET_LVL = 'TRADING AREA'
-- Non-Carb
Union
Select MRKT_KEY, MRKT_DSC_SHORT, MRKT_DSC_LONG
From MOTTS01..CSAJCDPI.VDPSGJCDRKTEA_MKTTAB
Where MRKT_DET_LVL = 'TRADING AREA'

Go
