use Portal_Data_INT
Go

--------------------------------------
--------------------------------------
--------------------------------------
INSERT [BCMyday].[PriorityExecutionStatus] ([PriorityExecutionStatusID], [Description], [Active]) VALUES (0, N'Not Executed', 1)
GO
INSERT [BCMyday].[PriorityExecutionStatus] ([PriorityExecutionStatusID], [Description], [Active]) VALUES (1, N'Executed', 1)
GO
INSERT [BCMyday].[PriorityExecutionStatus] ([PriorityExecutionStatusID], [Description], [Active]) VALUES (2, N'Not Executed', 1)
GO
SET IDENTITY_INSERT [BCMyday].[PriorityPublishingStatus] ON 

GO
INSERT [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID], [Description], [Active]) VALUES (1, N'Draft', 1)
GO
INSERT [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID], [Description], [Active]) VALUES (2, N'Sent to MyDay', 1)
GO
INSERT [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID], [Description], [Active]) VALUES (3, N'Recalled from MyDay', 1)
GO
INSERT [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID], [Description], [Active]) VALUES (5, N'Deleted', 1)
GO
SET IDENTITY_INSERT [BCMyday].[PriorityPublishingStatus] OFF
GO
SET IDENTITY_INSERT [BCMyday].[PromotionExecutionStatus] ON 

GO
INSERT [BCMyday].[PromotionExecutionStatus] ([PromotionExectuionStatusID], [Description], [Active], [LastModified]) VALUES (1, N'Executed', 1, CAST(N'2015-03-02 10:10:44.7000000' AS DateTime2))
GO
INSERT [BCMyday].[PromotionExecutionStatus] ([PromotionExectuionStatusID], [Description], [Active], [LastModified]) VALUES (2, N'Not Executed', 1, CAST(N'2015-03-02 10:10:44.7000000' AS DateTime2))
GO
SET IDENTITY_INSERT [BCMyday].[PromotionExecutionStatus] OFF
GO

--------------------------------------
--------------------------------------
--------------------------------------

/****** Object:  Table [dbo].[PRIORITY_BRANDS]    Script Date: 3/30/2015 9:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRIORITY_BRANDS](
	[PRIORITY_ID] [float] NULL,
	[BRAND_ID] [float] NULL,
	[TRADEMARK_ID] [float] NULL,
	[UPDATE_TIME] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRIORITY_CUST_HIER]    Script Date: 3/30/2015 9:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRIORITY_CUST_HIER](
	[PRIORITY_ID] [float] NULL,
	[NATIONAL_CHAIN_ID] [float] NULL,
	[REGIONAL_CHAIN_ID] [nvarchar](255) NULL,
	[LOCAL_CHAIN_ID] [nvarchar](255) NULL,
	[STORE_ID] [nvarchar](255) NULL,
	[UPDATE_TIME] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRIORITY_MASTER]    Script Date: 3/30/2015 9:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRIORITY_MASTER](
	[PRIORITY_ID] [float] NULL,
	[PRIORITY_DESC] [nvarchar](255) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[CREATED_DATE] [nvarchar](255) NULL,
	[MODIFIED_DATE] [nvarchar](255) NULL,
	[UPDATE_TIME] [nvarchar](255) NULL
) ON [PRIMARY]

GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (100, 206, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (100, 207, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (200, NULL, 184, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (300, NULL, -1, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (400, NULL, -1, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (401, NULL, -1, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (402, NULL, -1, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (1, NULL, 187, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (2, NULL, 187, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (3, NULL, 187, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (4, NULL, 187, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (5, NULL, 1, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (5, NULL, 195, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (5, NULL, 35, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (5, NULL, 3, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (5, NULL, 194, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (6, NULL, 1, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (6, NULL, 195, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (6, NULL, 35, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (6, NULL, 3, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (6, NULL, 170, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (6, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (10, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (11, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (12, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (13, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (14, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (15, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (16, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (17, NULL, 49, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (18, NULL, 184, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (19, NULL, 184, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (20, NULL, 184, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (30, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (31, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (32, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_BRANDS] ([PRIORITY_ID], [BRAND_ID], [TRADEMARK_ID], [UPDATE_TIME]) VALUES (33, NULL, 69, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (100, 60, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (200, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (300, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (400, 55, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (400, 62, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (401, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (402, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (1, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (2, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (3, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (4, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (5, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (6, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (10, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (11, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (12, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (13, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (14, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (15, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (16, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (17, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (18, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (19, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (20, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (30, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (31, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (32, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_CUST_HIER] ([PRIORITY_ID], [NATIONAL_CHAIN_ID], [REGIONAL_CHAIN_ID], [LOCAL_CHAIN_ID], [STORE_ID], [UPDATE_TIME]) VALUES (33, -1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (100, N'Test Q1:  all Walmart stores for DP', CAST(N'2015-02-10 00:00:00.000' AS DateTime), CAST(N'2015-03-08 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (200, N'Test Q2: all chains, for Schweppes', CAST(N'2015-02-18 00:00:00.000' AS DateTime), CAST(N'2015-03-08 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (300, N'Test Q3:  all chains, all trademarks', CAST(N'2015-02-14 00:00:00.000' AS DateTime), CAST(N'2015-03-08 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (400, N'Test Q4: RaceTrack and 7-11; all brands', CAST(N'2015-02-14 00:00:00.000' AS DateTime), CAST(N'2015-03-08 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (401, N'Is the store in a Hispanic market area?', CAST(N'2015-02-14 00:00:00.000' AS DateTime), CAST(N'2015-04-08 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (402, N'DPSG brands on Ad-Week?', CAST(N'2015-02-14 00:00:00.000' AS DateTime), CAST(N'2015-04-08 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (1, N'ISO: Is Snapple straight Up Tea on the shelf? ', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (2, N'ISO: Is there a secondary location for Straight up Tea?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (3, N'ISO: Is Snapple Straight up Tea positioned adjacent to either Gold Peak or Honest tea?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (4, N'ISO: Is there Snapple Straight up Tea POS in the store?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (5, N'ISO: Does DPSG have fair share of cooler space on Core 5?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (6, N'ISO: Is TEN merchandised in a stand-alone TEN section?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (10, N'PASO:  Are Dr Pepper ‘more packs’ including 16.9oz/6 pk, 8pk/7.5oz, and 8pk/12oz PET POG on shelf equal to Pepsi?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (11, N'PASO:  Are Diet Dr Pepper ‘more packs’ POG on shelf equal to Pepsi?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (12, N'PASO:  Is Dr Pepper ‘Made with Sugar’ POG and on shelf in equal packaging offering with Pepsi ‘Real Sugar’ packaging', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (13, N'PASO:  Is Cherry Dr Pepper 12pk POG on shelf?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (14, N'PASO:  Is Cherry Dr Pepper 2 Liter POG on shelf?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (15, N'PASO:  Is Diet Cherry 12pk POG on shelf?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (16, N'PASO:  Is diet cherry 2 Liter POG on shelf?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (17, N'PASO:  Do the number of Crush Flavors POG on shelf equal to Fanta''s Flavor offering?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (18, N'PASO:  Is Schweppes Ale 12pk POG on shelf in the CSD section?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (19, N'PASO:  Is Schweppes Ale 2 Liter POG on shelf in the CSD section?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (20, N'PASO: Is Schweppes Sparkling 12 packs POG and on shelf in the store?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (30, N'CASO: Is there DP 12oz glass in the store?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (31, N'CASO: Is DP 8oz glass available in the account?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (32, N'CASO: Are either DP .5L PET and/or DP  8-pack 12oz PET included on the display?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[PRIORITY_MASTER] ([PRIORITY_ID], [PRIORITY_DESC], [START_DATE], [END_DATE], [CREATED_DATE], [MODIFIED_DATE], [UPDATE_TIME]) VALUES (33, N'CASO: Does DP have an inventory of 25% or more for all displays in the store?', CAST(N'2015-03-14 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), NULL, NULL, NULL)
GO
------------------------------------
------------------------------------
------------------------------------
------------------------------------
------------------------------------

Delete BCMyday.ManagementPriority 
--Truncate Table BCMyday.ManagementPriority --Lazy way to rekey
Go

SET IDENTITY_INSERT BCMyday.ManagementPriority ON
GO

INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
Select PRIORITY_ID, PRIORITY_DESC, START_DATE, END_DATE
           ,1
           ,1
           ,1
           ,1,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null
From dbo.PRIORITY_MASTER

SET IDENTITY_INSERT BCMyday.ManagementPriority OFF
GO

-----------------------------------------------
Delete [BCMyday].PriorityBottler
Go

Update BCMyday.ManagementPriority
Set ForAllBottlers = 0
Where Description like 'PASO%'
Or Description like 'CASO%'
Or Description like 'ISO%'
Go

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select ManagementPriorityID, 5,null,null, null, null,'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From BCMyday.ManagementPriority
Where Description like 'PASO%'
Go

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select ManagementPriorityID, 6,null,null, null, null,'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From BCMyday.ManagementPriority
Where Description like 'CASO%'
Go

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select ManagementPriorityID, 7,null,null, null, null,'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From BCMyday.ManagementPriority
Where Description like 'ISO%'
Go

---------------------------------------------
---------------------------------------------
Update BCMyday.ManagementPriority
Set ForAllChains = -1
Where ManagementPriorityID in 
(
	Select PRIORITY_ID
	From dbo.PRIORITY_CUST_HIER
	Where NATIONAL_CHAIN_ID > 0
)
Go

Delete [BCMyday].PriorityChain
Go

INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select PRIORITY_ID, NATIONAL_CHAIN_ID, null, null, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From dbo.PRIORITY_CUST_HIER
Where NATIONAL_CHAIN_ID > 0
Go
---------------------------------------------

Update BCMyday.ManagementPriority
Set ForAllBrands = -1
Where ManagementPriorityID in 
(
	Select PRIORITY_ID
	From dbo.PRIORITY_BRANDS
	Where TRADEMARK_ID > 0
)
Go

Delete [BCMyday].PriorityBrand
Go

INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select PRIORITY_ID, TRADEMARK_ID, BRAND_ID, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From dbo.PRIORITY_BRANDS
Where TRADEMARK_ID > 0
Go

-------------------------------------
-------------------------------------
-------------------------------------
/****** Object:  Table [dbo].[PRIORITY_MASTER]    Script Date: 3/30/2015 9:39:55 AM ******/
DROP TABLE [dbo].[PRIORITY_MASTER]
GO
/****** Object:  Table [dbo].[PRIORITY_CUST_HIER]    Script Date: 3/30/2015 9:39:55 AM ******/
DROP TABLE [dbo].[PRIORITY_CUST_HIER]
GO
/****** Object:  Table [dbo].[PRIORITY_BRANDS]    Script Date: 3/30/2015 9:39:55 AM ******/
DROP TABLE [dbo].[PRIORITY_BRANDS]

GO

update bcmyday.systempackage set containertype='', modifieddate=getdate() where containertype is null
Go

------------------------------
------------------------------
------------------------------
Truncate table [BCMyday].[SystemCompetitionBrand] 
Go

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 56, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 57, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 58, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 59, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 60, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 61, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 62, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 63, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 64, 10, 184, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (5, 65, NULL, NULL, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (6, 66, NULL, NULL, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

-------------------
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 5, 13, null, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 56, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 58, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 59, 9, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 56, 11, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 58, 11, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 59, 11, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 67, 12, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 68, 10, 184, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 69, 10, NULL, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 68, 16, NULL, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 69, 16, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 70, 16, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 71, 7, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 17, 21, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 20, 13, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 73, 12, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 74, 16, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 75, 11, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 76, null, null, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 77, 15, NULL, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 78, 15, NULL, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 79, 15, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 80, 15, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

INSERT [BCMyday].[SystemCompetitionBrand] ([SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) 
VALUES (7, 81, 15, 49, 1, N'System', SYSDATETIME(), N'System', SYSDATETIME())

Update scb
set TradeMarkID = stm.TradeMarkID
From [BCMyday].[SystemCompetitionBrand] scb
Join BCMyday.SystemTradeMark stm on scb.SystemTradeMarkID = stm.SystemTradeMarkID
Go

---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
/*
Truncate Table BCMyDay.Config
Truncate Table BCMyDay.SystemCompetitionBrand
Truncate Table BCMyDay.SystemPackageBrand
Truncate Table BCMyDay.SystemPackage
Delete BCMyDay.SystemBrand
Delete BCMyDay.SystemTrademark
--Delete Playbook.DisplayLocation 
Truncate Table BCMyDay.LOSDisplayLocation
Delete BCMyDay.LOS
Go

---- To fix data by filling holes ----
---0. Config ---------------------------------------------------
INSERT INTO [BCMyday].[Config]
           ([Key]
           ,[Value]
           ,[Description]
           ,[ModifiedDate]
           ,[SendToMyday]
           ,[System])
Select [Key]
           ,[Value]
           ,[Description]
           ,[ModifiedDate]
           ,[SendToMyday]
           ,Null
From BSCCAP108.Portal_Data.BCMyDay.Config
GO

---- To fix data by filling holes ----
---1. Image ---------------------------------------------------
Set Identity_Insert Shared.Image On
Insert Into Shared.Image(imageid,imageurl,description)
Select ImageID,ImageURL,Description
From BSCCAP108.Portal_Data.Shared.Image Where ImageID not in (Select ImageID From Shared.Image)
Set Identity_Insert Shared.Image Off
Go

---2. SystemTradeMark ----
Set Identity_Insert BCMyDay.SystemTrademark on
Insert Into BCMyDay.SystemTradeMark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
Select SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, SysDateTime(), ModifiedBy, SysDateTime()
From BSCCAP108.Portal_Data.BCMyDay.SystemTradeMark Where SystemTrademarkID Not In (Select SystemTradeMarkID From BCMyDay.SystemTradeMark)
Set Identity_Insert BCMyDay.SystemTrademark off
Go

---3. SystemBrand ----
Set Identity_Insert BCMyDay.SystemBrand On
Insert Into BCMyDay.SystemBrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageID)
Select SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,SysDateTime(),ModifiedBy,SysDateTime(),IsDPSBrand,SystemTradeMarkID,ImageID
From BSCCAP108.Portal_Data.BCMyDay.SystemBrand Where SystemBrandID Not In (Select SystemBrandID From BCMyDay.SystemBrand)
Set Identity_Insert BCMyDay.SystemBrand Off
Go

---4. SystemPackage ----
Set Identity_Insert BCMyDay.SystemPackage On
Insert Into BCMyDay.SystemPackage(SystemPackageID, ContainerType, PackageConfigID, BCSystemID, PackageLevelSort, IsActive, PackageName, CreatedDate, ModifiedDate)
Select SystemPackageID, ContainerType, PackageConfigID, BCSystemID, PackageLevelSort, IsActive, PackageName, SysDateTime(), SysDateTime()
From BSCCAP108.Portal_Data.BCMyDay.SystemPackage Where SystemPackageID Not In (Select SystemPackageID From BCMyDay.SystemPackage)
Set Identity_Insert BCMyDay.SystemPackage Off
Go

---5. SystemPackageBrand ----
Set Identity_Insert BCMyDay.SystemPackageBrand On
Insert Into BCMyDay.SystemPackageBrand(SystemPackageBrandID, SystemPackageID, SystemBrandId, IsActive)
Select SystemPackageBrandID, SystemPackageID, SystemBrandId, IsActive
From BSCCAP108.Portal_Data.BCMyDay.SystemPackageBrand Where SystemPackageBrandID Not In (Select SystemPackageBrandID From BCMyDay.SystemPackageBrand)
Set Identity_Insert BCMyDay.SystemPackageBrand Off
Go

---6. SystemCompetitionBrand ----
Set Identity_Insert BCMyDay.SystemCompetitionBrand On
Insert Into BCMyDay.SystemCompetitionBrand(SystemCompetionBrandID, [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified])
Select SystemCompetionBrandID, [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], SysDateTime(), [LastModifiedBy], SysDateTime()
From BSCCAP108.Portal_Data.BCMyDay.SystemCompetitionBrand
Set Identity_Insert BCMyDay.SystemCompetitionBrand Off
Go

---9. Playbook.DisplayLocation ----
Set Identity_Insert Playbook.DisplayLocation On
Insert Into Playbook.DisplayLocation(DisplayLocationID, DisplayLocationName)
Select DisplayLocationID, DisplayLocationName
From BSCCAP108.Portal_Data.Playbook.DisplayLocation Where DisplayLocationID not in (Select DisplayLocationID From Playbook.DisplayLocation)
Set Identity_Insert Playbook.DisplayLocation Off
Go

---7. LOS ----
Set Identity_Insert BCMyDay.LOS On
Insert Into BCMyDay.LOS([LOSID]
      ,[ChannelID]
      ,[LOSImageID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[LocalChainID]
      ,[AccountID]
      ,[IsActive])
Select [LOSID]
      ,[ChannelID]
      ,[LOSImageID]
      ,[CreatedBy]
      ,SysDateTime()
      ,[ModifiedBy]
      ,SysDateTime()
      ,[LocalChainID]
      ,[AccountID]
      ,[IsActive]
From BSCCAP108.Portal_Data.BCMyDay.LOS
Set Identity_Insert BCMyDay.LOS Off
Go

---8. LOSDisplayLocation ----
Insert Into BCMyDay.LOSDisplayLocation([LOSID]
      ,[DisplayLocationID]
      ,[DisplaySequence]
      ,[GridX]
      ,[GridY]
      ,[IsActive]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate])
Select [LOSID]
      ,[DisplayLocationID]
      ,[DisplaySequence]
      ,[GridX]
      ,[GridY]
      ,[IsActive]
      ,[CreatedBy]
      ,SysDateTime()
      ,[ModifiedBy]
      ,SysDateTime()
From BSCCAP108.Portal_Data.BCMyDay.LOSDisplayLocation
Go

*/

/*
Select *
From BCMyDay.LOSDisplayLocation

Select SystemPackageID, SystemBrandID, Count(*)
From BCMyDay.SystemPackageBrand
Group By SystemPackageID, SystemBrandID
Having Count(*) > 1

Select Count(*)
From BSCCAP108.Portal_Data.BCMyDay.SystemPackageBrand

Select Distinct DisplayLocationID
From Playbook.PromotionDisplayLocation
Where DisplayLocationID not in (Select DisplayLocationID From BSCCAP108.Portal_Data.Playbook.DisplayLocation)
Order By DisplayLocationID

Select DisplayLocationID From BSCCAP108.Portal_Data.Playbook.DisplayLocation
*/

--209
--210
--211
--212
--213
--214
--215
--216
--217
--218
--219
--220
--221
--225
--226
--227

--Select DisplayLocationID From BSCCAP108.Portal_Data.Playbook.DisplayLocation

--Update Playbook.RetailExecutionDisplay
--Set DisplayLocationID = null
--Where DisplayLocationID
--In
--(
--Select 
--DElete From Playbook.DisplayLocation
--Where DisplayLocationID not in (Select DisplayLocationID From BSCCAP108.Portal_Data.Playbook.DisplayLocation)
--)


--Select Top 100 *
--From Playbook.DisplayLocation








