USE [Portal_Data]
GO

SET IDENTITY_INSERT [BCMyday].[SystemBrand] ON 
GO

If not exists (Select *
From [BCMyday].[SystemBrand] 
Where SystemBrandID > 49)
Begin
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (50, N'Peach', 157, N'B', 50, 1, N'System', CAST(N'2015-02-18 12:04:36.343' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.343' AS DateTime), 1, 9, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (51, N'Grapefruit', 155, N'B', 60, 1, N'System', CAST(N'2015-02-18 12:04:36.347' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.347' AS DateTime), 1, 9, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (52, N'Pineapple', 158, N'B', 70, 1, N'System', CAST(N'2015-02-18 12:04:36.347' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.347' AS DateTime), 1, 9, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (53, N'Cherry', 153, N'B', 80, 1, N'System', CAST(N'2015-02-18 12:04:36.347' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.347' AS DateTime), 1, 9, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (54, N'Rasberry Ale', 433, N'B', 30, 1, N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), 1, 10, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (55, N'Seltzers', 435, N'B', 40, 1, N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), 1, 10, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (56, N'Orange', NULL, N'B', 20, 1, N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), 0, 3, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (57, N'Diet Orange', NULL, N'B', 30, 1, N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), 0, 3, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (58, N'Strawberry', NULL, N'B', 40, 1, N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), 0, 3, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (59, N'Grape', NULL, N'B', 50, 1, N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.350' AS DateTime), 0, 3, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (60, N'Mango', NULL, N'B', 60, 1, N'System', CAST(N'2015-02-18 12:04:36.353' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.353' AS DateTime), 0, 3, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (61, N'Grapefruit', NULL, N'B', 70, 1, N'System', CAST(N'2015-02-18 12:04:36.353' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.353' AS DateTime), 0, 3, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (62, N'Pineapple', NULL, N'B', 80, 1, N'System', CAST(N'2015-02-18 12:04:36.353' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.353' AS DateTime), 0, 3, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (63, N'Cherry', NULL, N'B', 90, 1, N'System', CAST(N'2015-02-18 12:04:36.353' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.353' AS DateTime), 0, 3, NULL)
	INSERT [BCMyday].[SystemBrand] ([SystemBrandID], [ExternalBrandName], [BrandID], [TieInType], [BrandLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [IsDPSBrand], [SystemTradeMarkID], [ImageId]) VALUES (64, N'Regular', NULL, N'B', 100, 1, N'System', CAST(N'2015-02-18 12:04:36.357' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.357' AS DateTime), 0, 17, NULL)
End

SET IDENTITY_INSERT [BCMyday].[SystemBrand] OFF
GO

SET IDENTITY_INSERT [BCMyday].[SystemTradeMark] ON 
GO

If Not Exists(Select * From [BCMyday].[SystemTradeMark] Where SystemTradeMarkID = 17)
Begin
	INSERT [BCMyday].[SystemTradeMark] ([SystemTradeMarkID], [ExternalTradeMarkName], [TradeMarkID], [ImageID], [TradeMarkLevelSort], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (17, N'Seagrams', NULL, NULL, 300, 1, N'System', CAST(N'2015-02-18 12:04:36.343' AS DateTime), N'System', CAST(N'2015-02-18 12:04:36.343' AS DateTime))
End

SET IDENTITY_INSERT [BCMyday].[SystemTradeMark] OFF
GO

Select *
From [BCMyday].[SystemBrand]

