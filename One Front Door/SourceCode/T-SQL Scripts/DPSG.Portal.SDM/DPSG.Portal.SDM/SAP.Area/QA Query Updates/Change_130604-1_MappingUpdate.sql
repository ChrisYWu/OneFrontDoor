-- executed 20130604 10:48

Update [Portal_Data].[EDGE].[ChannelMapping]
Set SAPChannelId = null
Where SAPChannelId = ''

Update [Portal_Data].[EDGE].[ChannelMapping]
Set SAPChannel = null
Where SAPChannel = ''

Update [Portal_Data].[EDGE].[PitPackageSizeMapping]
Set SAPPackConfID = null
Where SAPPackConfID = ''

Update [Portal_Data].[EDGE].[PitPackageSizeMapping]
Set SAPPackTypeID = null
Where SAPPackTypeID = ''

Select *
From SAP.TradeMark
Where TrademarkName in (
'Neuro', 'Fiji', 'Vita Coco')

Update EDGE.Brandmapping
Set SAPTradeMarkID = 'F01,N11,V12'
Where Name = 'Allied Brands'
