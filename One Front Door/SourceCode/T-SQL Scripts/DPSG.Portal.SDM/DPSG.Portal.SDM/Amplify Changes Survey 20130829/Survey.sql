USE [Portal_Data]
GO

/****** Copy the table into New Bakaup table ******/
Select * into MSTR.SurveyCustomers_Bak from MSTR.SurveyCustomers
Go

/****** Object:  Table [MSTR].[SurveyCustomers]    Script Date: 8/29/2013 1:42:19 PM ******/
DROP TABLE [MSTR].[SurveyCustomers]
GO

/****** Object:  Table [MSTR].[SurveyCustomers]    Script Date: 8/29/2013 1:42:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [MSTR].[SurveyCustomers](
	[SCustId] [int] IDENTITY(1,1) NOT NULL,
	[StoreNo] [int] NULL,
	[StoreName] [varchar](250) NULL,
	[GroupName] [varchar](100) NULL,
	[OwnerName] [varchar](100) NULL,
	[StoreAddress] [varchar](100) NULL,
	[StoreCity] [varchar](100) NULL,
	[StoreState] [varchar](2) NULL,
	[StoreZipCode] [int] NULL,
	[StoreAreaCode] [int] NULL,
	[StorePhone] [int] NULL,
	[Latitude] [numeric](12, 9) NULL,
	[Longitude] [numeric](12, 9) NULL,
	[AnnualVolume] [varchar](30) NULL,
	[AnnualSales] [numeric](18, 0) NULL,
 CONSTRAINT [PK_SurveyCustomers] PRIMARY KEY CLUSTERED 
(
	[SCustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/******  Copy Data from Dev server********/

Set Identity_Insert MSTR.SurveyCustomers ON
Go
Insert Into MSTR.SurveyCustomers([SCustId]
      ,[StoreNo]
      ,[StoreName]
      ,[GroupName]
      ,[OwnerName]
      ,[StoreAddress]
      ,[StoreCity]
      ,[StoreState]
      ,[StoreZipCode]
      ,[StoreAreaCode]
      ,[StorePhone]
      ,[Latitude]
      ,[Longitude]
      ,[AnnualVolume]
      ,[AnnualSales])
Select [SCustId]
      ,[StoreNo]
      ,[StoreName]
      ,[GroupName]
      ,[OwnerName]
      ,[StoreAddress]
      ,[StoreCity]
      ,[StoreState]
      ,[StoreZipCode]
      ,[StoreAreaCode]
      ,[StorePhone]
      ,[Latitude]
      ,[Longitude]
      ,[AnnualVolume]
      ,[AnnualSales] from BSCCAP108.Portal_Data.MSTR.SurveyCustomers
Go
Set Identity_Insert MSTR.SurveyCustomers OFF
Go

/****** Object:  Table [MSTR].[WDDetailSurveyResults_new]    Script Date: 8/29/2013 1:53:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [MSTR].[WDDetailSurveyResults_new](
	[Userid] [varchar](10) NULL,
	[customerid] [varchar](100) NOT NULL,
	[HPGal_SKU] [int] NULL,
	[RealLemonLime_SKU] [int] NULL,
	[Motts64_SKU] [int] NULL,
	[Motts86128oz_SKU] [int] NULL,
	[CLAMATO64_SKU] [int] NULL,
	[CLAMATO32_SKU] [int] NULL,
	[HP10_SKU] [int] NULL,
	[Motts8_SKU] [int] NULL,
	[MottsMFTTetra_SKU] [int] NULL,
	[YooHoo65oz_SKU] [int] NULL,
	[VITACOCOKIDS_SKU] [int] NULL,
	[CLAMATOCANS_SKU] [int] NULL,
	[MottsSS636pk_SKU] [int] NULL,
	[MottsPouch4pk_SKU] [int] NULL,
	[MottsMS20s_SKU] [int] NULL,
	[MottsMS40s_SKU] [int] NULL,
	[IBCCrush12oz_SKU] [int] NULL,
	[YooHooCans_SKU] [int] NULL,
	[MrMrsT1L_SKU] [int] NULL,
	[MrMrsT175L_SKU] [int] NULL,
	[RosesRCI_SKU] [int] NULL,
	[Margaritaville_SKU] [int] NULL,
	[HPGal_BLOCKED] [int] NULL,
	[RealLemonLime_BLOCKED] [int] NULL,
	[Motts64_BLOCKED] [int] NULL,
	[Motts86128oz_BLOCKED] [int] NULL,
	[CLAMATO64_BLOCKED] [int] NULL,
	[CLAMATO32_BLOCKED] [int] NULL,
	[HP10_BLOCKED] [int] NULL,
	[Motts8_BLOCKED] [int] NULL,
	[MottsMFTTetra_BLOCKED] [int] NULL,
	[YooHoo65oz_BLOCKED] [int] NULL,
	[VITACOCOKIDS_BLOCKED] [int] NULL,
	[CLAMATOCANS_BLOCKED] [int] NULL,
	[MottsSS636pk_BLOCKED] [int] NULL,
	[MottsPouch4pk_BLOCKED] [int] NULL,
	[MottsMS20s_BLOCKED] [int] NULL,
	[MottsMS40s_BLOCKED] [int] NULL,
	[IBCCrush12oz_BLOCKED] [int] NULL,
	[YooHooCans_BLOCKED] [int] NULL,
	[MrMrsT1L_BLOCKED] [int] NULL,
	[MrMrsT175L_BLOCKED] [int] NULL,
	[RosesRCI_BLOCKED] [int] NULL,
	[Margaritaville_BLOCKED] [int] NULL,
	[HPGal_EDPRICE] [numeric](7, 2) NULL,
	[RealLemonLime_EDPRICE] [numeric](7, 2) NULL,
	[Motts64_EDPRICE] [numeric](7, 2) NULL,
	[Motts86128oz_EDPRICE] [numeric](7, 2) NULL,
	[CLAMATO64_EDPRICE] [numeric](7, 2) NULL,
	[CLAMATO32_EDPRICE] [numeric](7, 2) NULL,
	[HP10_EDPRICE] [numeric](7, 2) NULL,
	[Motts8_EDPRICE] [numeric](7, 2) NULL,
	[MottsMFTTetra_EDPRICE] [numeric](7, 2) NULL,
	[YooHoo65oz_EDPRICE] [numeric](7, 2) NULL,
	[VITACOCOKIDS_EDPRICE] [numeric](7, 2) NULL,
	[CLAMATOCANS_EDPRICE] [numeric](7, 2) NULL,
	[MottsSS636pk_EDPRICE] [numeric](7, 2) NULL,
	[MottsPouch4pk_EDPRICE] [numeric](7, 2) NULL,
	[MottsMS20s_EDPRICE] [numeric](7, 2) NULL,
	[MottsMS40s_EDPRICE] [numeric](7, 2) NULL,
	[IBCCrush12oz_EDPRICE] [numeric](7, 2) NULL,
	[YooHooCans_EDPRICE] [numeric](7, 2) NULL,
	[MrMrsT1L_EDPRICE] [numeric](7, 2) NULL,
	[MrMrsT175L_EDPRICE] [numeric](7, 2) NULL,
	[RosesRCI_EDPRICE] [numeric](7, 2) NULL,
	[Margaritaville_EDPRICE] [numeric](7, 2) NULL,
	[MargaritavilleRCI_EDPRICE] [numeric](7, 2) NULL,
	[HPGal_EDCOMPPRICE] [int] NULL,
	[RealLemonLime_EDCOMPPRICE] [int] NULL,
	[Motts64_EDCOMPPRICE] [int] NULL,
	[Motts86128oz_EDCOMPPRICE] [int] NULL,
	[CLAMATO64_EDCOMPPRICE] [int] NULL,
	[CLAMATO32_EDCOMPPRICE] [int] NULL,
	[HP10_EDCOMPPRICE] [int] NULL,
	[Motts8_EDCOMPPRICE] [int] NULL,
	[MottsMFTTetra_EDCOMPPRICE] [int] NULL,
	[YooHoo65oz_EDCOMPPRICE] [int] NULL,
	[VITACOCOKIDS_EDCOMPPRICE] [int] NULL,
	[CLAMATOCANS_EDCOMPPRICE] [int] NULL,
	[MottsSS636pk_EDCOMPPRICE] [int] NULL,
	[MottsPouch4pk_EDCOMPPRICE] [int] NULL,
	[MottsMS20s_EDCOMPPRICE] [int] NULL,
	[MottsMS40s_EDCOMPPRICE] [int] NULL,
	[IBCCrush12oz_EDCOMPPRICE] [int] NULL,
	[YooHooCans_EDCOMPPRICE] [int] NULL,
	[MrMrsT1L_EDCOMPPRICE] [int] NULL,
	[MrMrsT175L_EDCOMPPRICE] [int] NULL,
	[RosesRCI_EDCOMPPRICE] [int] NULL,
	[Margaritaville_EDCOMPPRICE] [int] NULL,
	[HPGal_PROMO] [int] NULL,
	[RealLemonLime_PROMO] [int] NULL,
	[Motts64_PROMO] [int] NULL,
	[Motts86128oz_PROMO] [int] NULL,
	[CLAMATO64_PROMO] [int] NULL,
	[CLAMATO32_PROMO] [int] NULL,
	[HP10_PROMO] [int] NULL,
	[Motts8_PROMO] [int] NULL,
	[MottsMFTTetra_PROMO] [int] NULL,
	[YooHoo65oz_PROMO] [int] NULL,
	[VITACOCOKIDS_PROMO] [int] NULL,
	[CLAMATOCANS_PROMO] [int] NULL,
	[MottsSS636pk_PROMO] [int] NULL,
	[MottsPouch4pk_PROMO] [int] NULL,
	[MottsMS20s_PROMO] [int] NULL,
	[MottsMS40s_PROMO] [int] NULL,
	[IBCCrush12oz_PROMO] [int] NULL,
	[YooHooCans_PROMO] [int] NULL,
	[MrMrsT1L_PROMO] [int] NULL,
	[MrMrsT175L_PROMO] [int] NULL,
	[RosesRCI_PROMO] [int] NULL,
	[Margaritaville_PROMO] [int] NULL,
	[HPGal_PROMOPRICE] [numeric](7, 2) NULL,
	[RealLemonLime_PROMOPRICE] [numeric](7, 2) NULL,
	[Motts64_PROMOPRICE] [numeric](7, 2) NULL,
	[Motts86128oz_PROMOPRICE] [numeric](7, 2) NULL,
	[CLAMATO64_PROMOPRICE] [numeric](7, 2) NULL,
	[CLAMATO32_PROMOPRICE] [numeric](7, 2) NULL,
	[HP10_PROMOPRICE] [numeric](7, 2) NULL,
	[Motts8_PROMOPRICE] [numeric](7, 2) NULL,
	[MottsMFTTetra_PROMOPRICE] [numeric](7, 2) NULL,
	[YooHoo65oz_PROMOPRICE] [numeric](7, 2) NULL,
	[VITACOCOKIDS_PROMOPRICE] [numeric](7, 2) NULL,
	[CLAMATOCANS_PROMOPRICE] [numeric](7, 2) NULL,
	[MottsSS636pk_PROMOPRICE] [numeric](7, 2) NULL,
	[MottsPouch4pk_PROMOPRICE] [numeric](7, 2) NULL,
	[MottsMS20s_PROMOPRICE] [numeric](7, 2) NULL,
	[IBCCrush12oz_PROMOPRICE] [numeric](7, 2) NULL,
	[YooHooCans_PROMOPRICE] [numeric](7, 2) NULL,
	[MrMrsT1L_PROMOPRICE] [numeric](7, 2) NULL,
	[MrMrsT175L_PROMOPRICE] [numeric](7, 2) NULL,
	[RosesRCI_PROMOPRICE] [numeric](7, 2) NULL,
	[Margaritaville_PROMOPRICE] [numeric](7, 2) NULL,
	[HPGal_INAD] [int] NULL,
	[RealLemonLime_INAD] [int] NULL,
	[Motts64_INAD] [int] NULL,
	[Motts86128oz_INAD] [int] NULL,
	[CLAMATO64_INAD] [int] NULL,
	[CLAMATO32_INAD] [int] NULL,
	[HP10_INAD] [int] NULL,
	[Motts8_INAD] [int] NULL,
	[MottsMFTTetra_INAD] [int] NULL,
	[YooHoo65oz_INAD] [int] NULL,
	[VITACOCOKIDS_INAD] [int] NULL,
	[CLAMATOCANS_INAD] [int] NULL,
	[MottsSS636pk_INAD] [int] NULL,
	[MottsPouch4pk_INAD] [int] NULL,
	[MottsMS20s_INAD] [int] NULL,
	[IBCCrush12oz_INAD] [int] NULL,
	[YooHooCans_INAD] [int] NULL,
	[MrMrsT1L_INAD] [int] NULL,
	[MrMrsT175L_INAD] [int] NULL,
	[RosesRCI_INAD] [int] NULL,
	[Margaritaville_INAD] [int] NULL,
	[HPGal_DISPLAY] [int] NULL,
	[RealLemonLime_DISPLAY] [int] NULL,
	[Motts64_DISPLAY] [int] NULL,
	[Motts86128oz_DISPLAY] [int] NULL,
	[CLAMATO64_DISPLAY] [int] NULL,
	[CLAMATO32_DISPLAY] [int] NULL,
	[HP10_DISPLAY] [int] NULL,
	[Motts8_DISPLAY] [int] NULL,
	[MottsMFTTetra_DISPLAY] [int] NULL,
	[YooHoo65oz_DISPLAY] [int] NULL,
	[VITACOCOKIDS_DISPLAY] [int] NULL,
	[CLAMATOCANS_DISPLAY] [int] NULL,
	[MottsSS636pk_DISPLAY] [int] NULL,
	[MottsPouch4pk_DISPLAY] [int] NULL,
	[MottsMS20s_DISPLAY] [int] NULL,
	[MottsMS40s_DISPLAY] [int] NULL,
	[IBCCrush12oz_DISPLAY] [int] NULL,
	[YooHooCans_DISPLAY] [int] NULL,
	[MrMrsT1L_DISPLAY] [int] NULL,
	[MrMrsT175L_DISPLAY] [int] NULL,
	[RosesRCI_DISPLAY] [int] NULL,
	[Margaritaville_DISPLAY] [int] NULL,
	[insertdate] [datetime] NULL,
	[DISPLAYQ1] [int] NULL,
	[DISPLAYQ2] [int] NULL,
	[DISPLAYQ3] [int] NULL,
	[ADQ1] [int] NULL,
	[ADQ2] [int] NULL,
	[ADQ3] [int] NULL,
	[OTHERQ1] [int] NULL,
	[OTHERQ2] [int] NULL,
	[ManagerName] [varchar](50) NULL,
	[ManagerApproved] [int] NULL,
	[DISPLAYQ4] [int] NULL,
	[ACTION_ITEMS] [varchar](max) NULL,
	[UNLISTED_STORE_NAME] [varchar](50) NULL,
	[UNLISTED_STORE_ADDRESS] [varchar](100) NULL,
	[UNLISTED_STORE_CITY] [varchar](50) NULL,
	[UNLISTED_STORE_STATE] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HPGal_SKU]  DEFAULT ((0)) FOR [HPGal_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RealLemonLime_SKU]  DEFAULT ((0)) FOR [RealLemonLime_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts64_SKU]  DEFAULT ((0)) FOR [Motts64_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts86128oz_SKU]  DEFAULT ((0)) FOR [Motts86128oz_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO64_SKU]  DEFAULT ((0)) FOR [CLAMATO64_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO32_SKU]  DEFAULT ((0)) FOR [CLAMATO32_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HP10_SKU]  DEFAULT ((0)) FOR [HP10_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts8_SKU]  DEFAULT ((0)) FOR [Motts8_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMFTTetra_SKU]  DEFAULT ((0)) FOR [MottsMFTTetra_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHoo65oz_SKU]  DEFAULT ((0)) FOR [YooHoo65oz_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_VITACOCOKIDS_SKU]  DEFAULT ((0)) FOR [VITACOCOKIDS_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATOCANS_SKU]  DEFAULT ((0)) FOR [CLAMATOCANS_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsSS636pk_SKU]  DEFAULT ((0)) FOR [MottsSS636pk_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsPouch4pk_SKU]  DEFAULT ((0)) FOR [MottsPouch4pk_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS20s_SKU]  DEFAULT ((0)) FOR [MottsMS20s_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS40s_SKU]  DEFAULT ((0)) FOR [MottsMS40s_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_IBCCrush12oz_SKU]  DEFAULT ((0)) FOR [IBCCrush12oz_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHooCans_SKU]  DEFAULT ((0)) FOR [YooHooCans_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT1L_SKU]  DEFAULT ((0)) FOR [MrMrsT1L_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT175L_SKU]  DEFAULT ((0)) FOR [MrMrsT175L_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RosesRCI_SKU]  DEFAULT ((0)) FOR [RosesRCI_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Margaritaville_SKU]  DEFAULT ((0)) FOR [Margaritaville_SKU]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HPGal_BLOCKED]  DEFAULT ((0)) FOR [HPGal_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RealLemonLime_BLOCKED]  DEFAULT ((0)) FOR [RealLemonLime_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts64_BLOCKED]  DEFAULT ((0)) FOR [Motts64_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts86128oz_BLOCKED]  DEFAULT ((0)) FOR [Motts86128oz_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO64_BLOCKED]  DEFAULT ((0)) FOR [CLAMATO64_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO32_BLOCKED]  DEFAULT ((0)) FOR [CLAMATO32_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HP10_BLOCKED]  DEFAULT ((0)) FOR [HP10_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts8_BLOCKED]  DEFAULT ((0)) FOR [Motts8_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMFTTetra_BLOCKED]  DEFAULT ((0)) FOR [MottsMFTTetra_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHoo65oz_BLOCKED]  DEFAULT ((0)) FOR [YooHoo65oz_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_VITACOCOKIDS_BLOCKED]  DEFAULT ((0)) FOR [VITACOCOKIDS_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATOCANS_BLOCKED]  DEFAULT ((0)) FOR [CLAMATOCANS_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsSS636pk_BLOCKED]  DEFAULT ((0)) FOR [MottsSS636pk_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsPouch4pk_BLOCKED]  DEFAULT ((0)) FOR [MottsPouch4pk_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS20s_BLOCKED]  DEFAULT ((0)) FOR [MottsMS20s_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS40s_BLOCKED]  DEFAULT ((0)) FOR [MottsMS40s_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_IBCCrush12oz_BLOCKED]  DEFAULT ((0)) FOR [IBCCrush12oz_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHooCans_BLOCKED]  DEFAULT ((0)) FOR [YooHooCans_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT1L_BLOCKED]  DEFAULT ((0)) FOR [MrMrsT1L_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT175L_BLOCKED]  DEFAULT ((0)) FOR [MrMrsT175L_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RosesRCI_BLOCKED]  DEFAULT ((0)) FOR [RosesRCI_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Margaritaville_BLOCKED]  DEFAULT ((0)) FOR [Margaritaville_BLOCKED]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HPGal_EDPRICE]  DEFAULT ((0)) FOR [HPGal_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RealLemonLime_EDPRICE]  DEFAULT ((0)) FOR [RealLemonLime_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts64_EDPRICE]  DEFAULT ((0)) FOR [Motts64_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts86128oz_EDPRICE]  DEFAULT ((0)) FOR [Motts86128oz_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO64_EDPRICE]  DEFAULT ((0)) FOR [CLAMATO64_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO32_EDPRICE]  DEFAULT ((0)) FOR [CLAMATO32_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HP10_EDPRICE]  DEFAULT ((0)) FOR [HP10_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts8_EDPRICE]  DEFAULT ((0)) FOR [Motts8_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMFTTetra_EDPRICE]  DEFAULT ((0)) FOR [MottsMFTTetra_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHoo65oz_EDPRICE]  DEFAULT ((0)) FOR [YooHoo65oz_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_VITACOCOKIDS_EDPRICE]  DEFAULT ((0)) FOR [VITACOCOKIDS_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATOCANS_EDPRICE]  DEFAULT ((0)) FOR [CLAMATOCANS_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsSS636pk_EDPRICE]  DEFAULT ((0)) FOR [MottsSS636pk_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsPouch4pk_EDPRICE]  DEFAULT ((0)) FOR [MottsPouch4pk_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS20s_EDPRICE]  DEFAULT ((0)) FOR [MottsMS20s_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS40s_EDPRICE]  DEFAULT ((0)) FOR [MottsMS40s_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_IBCCrush12oz_EDPRICE]  DEFAULT ((0)) FOR [IBCCrush12oz_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHooCans_EDPRICE]  DEFAULT ((0)) FOR [YooHooCans_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT1L_EDPRICE]  DEFAULT ((0)) FOR [MrMrsT1L_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT175L_EDPRICE]  DEFAULT ((0)) FOR [MrMrsT175L_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RosesRCI_EDPRICE]  DEFAULT ((0)) FOR [RosesRCI_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Margaritaville_EDPRICE]  DEFAULT ((0)) FOR [Margaritaville_EDPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HPGal_EDCOMPPRICE]  DEFAULT ((0)) FOR [HPGal_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RealLemonLime_EDCOMPPRICE]  DEFAULT ((0)) FOR [RealLemonLime_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts64_EDCOMPPRICE]  DEFAULT ((0)) FOR [Motts64_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts86128oz_EDCOMPPRICE]  DEFAULT ((0)) FOR [Motts86128oz_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO64_EDCOMPPRICE]  DEFAULT ((0)) FOR [CLAMATO64_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO32_EDCOMPPRICE]  DEFAULT ((0)) FOR [CLAMATO32_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HP10_EDCOMPPRICE]  DEFAULT ((0)) FOR [HP10_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts8_EDCOMPPRICE]  DEFAULT ((0)) FOR [Motts8_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMFTTetra_EDCOMPPRICE]  DEFAULT ((0)) FOR [MottsMFTTetra_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHoo65oz_EDCOMPPRICE]  DEFAULT ((0)) FOR [YooHoo65oz_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_VITACOCOKIDS_EDCOMPPRICE]  DEFAULT ((0)) FOR [VITACOCOKIDS_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATOCANS_EDCOMPPRICE]  DEFAULT ((0)) FOR [CLAMATOCANS_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsSS636pk_EDCOMPPRICE]  DEFAULT ((0)) FOR [MottsSS636pk_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsPouch4pk_EDCOMPPRICE]  DEFAULT ((0)) FOR [MottsPouch4pk_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS20s_EDCOMPPRICE]  DEFAULT ((0)) FOR [MottsMS20s_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS40s_EDCOMPPRICE]  DEFAULT ((0)) FOR [MottsMS40s_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_IBCCrush12oz_EDCOMPPRICE]  DEFAULT ((0)) FOR [IBCCrush12oz_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHooCans_EDCOMPPRICE]  DEFAULT ((0)) FOR [YooHooCans_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT1L_EDCOMPPRICE]  DEFAULT ((0)) FOR [MrMrsT1L_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT175L_EDCOMPPRICE]  DEFAULT ((0)) FOR [MrMrsT175L_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RosesRCI_EDCOMPPRICE]  DEFAULT ((0)) FOR [RosesRCI_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Margaritaville_EDCOMPPRICE]  DEFAULT ((0)) FOR [Margaritaville_EDCOMPPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HPGal_PROMO]  DEFAULT ((0)) FOR [HPGal_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RealLemonLime_PROMO]  DEFAULT ((0)) FOR [RealLemonLime_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts64_PROMO]  DEFAULT ((0)) FOR [Motts64_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts86128oz_PROMO]  DEFAULT ((0)) FOR [Motts86128oz_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO64_PROMO]  DEFAULT ((0)) FOR [CLAMATO64_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO32_PROMO]  DEFAULT ((0)) FOR [CLAMATO32_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HP10_PROMO]  DEFAULT ((0)) FOR [HP10_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts8_PROMO]  DEFAULT ((0)) FOR [Motts8_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMFTTetra_PROMO]  DEFAULT ((0)) FOR [MottsMFTTetra_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHoo65oz_PROMO]  DEFAULT ((0)) FOR [YooHoo65oz_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_VITACOCOKIDS_PROMO]  DEFAULT ((0)) FOR [VITACOCOKIDS_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATOCANS_PROMO]  DEFAULT ((0)) FOR [CLAMATOCANS_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsSS636pk_PROMO]  DEFAULT ((0)) FOR [MottsSS636pk_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsPouch4pk_PROMO]  DEFAULT ((0)) FOR [MottsPouch4pk_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS20s_PROMO]  DEFAULT ((0)) FOR [MottsMS20s_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS40s_PROMO]  DEFAULT ((0)) FOR [MottsMS40s_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_IBCCrush12oz_PROMO]  DEFAULT ((0)) FOR [IBCCrush12oz_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHooCans_PROMO]  DEFAULT ((0)) FOR [YooHooCans_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT1L_PROMO]  DEFAULT ((0)) FOR [MrMrsT1L_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT175L_PROMO]  DEFAULT ((0)) FOR [MrMrsT175L_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RosesRCI_PROMO]  DEFAULT ((0)) FOR [RosesRCI_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Margaritaville_PROMO]  DEFAULT ((0)) FOR [Margaritaville_PROMO]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HPGal_PROMOPRICE]  DEFAULT ((0)) FOR [HPGal_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RealLemonLime_PROMOPRICE]  DEFAULT ((0)) FOR [RealLemonLime_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts64_PROMOPRICE]  DEFAULT ((0)) FOR [Motts64_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts86128oz_PROMOPRICE]  DEFAULT ((0)) FOR [Motts86128oz_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO64_PROMOPRICE]  DEFAULT ((0)) FOR [CLAMATO64_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO32_PROMOPRICE]  DEFAULT ((0)) FOR [CLAMATO32_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HP10_PROMOPRICE]  DEFAULT ((0)) FOR [HP10_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts8_PROMOPRICE]  DEFAULT ((0)) FOR [Motts8_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMFTTetra_PROMOPRICE]  DEFAULT ((0)) FOR [MottsMFTTetra_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHoo65oz_PROMOPRICE]  DEFAULT ((0)) FOR [YooHoo65oz_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_VITACOCOKIDS_PROMOPRICE]  DEFAULT ((0)) FOR [VITACOCOKIDS_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATOKIDS_PROMOPRICE]  DEFAULT ((0)) FOR [CLAMATOCANS_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsSS636pk_PROMOPRICE]  DEFAULT ((0)) FOR [MottsSS636pk_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsPouch4pk_PROMOPRICE]  DEFAULT ((0)) FOR [MottsPouch4pk_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS20s_PROMOPRICE]  DEFAULT ((0)) FOR [MottsMS20s_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_IBCCrush12oz_PROMOPRICE]  DEFAULT ((0)) FOR [IBCCrush12oz_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHooCans_PROMOPRICE]  DEFAULT ((0)) FOR [YooHooCans_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT1L_PROMOPRICE]  DEFAULT ((0)) FOR [MrMrsT1L_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT175L_PROMOPRICE]  DEFAULT ((0)) FOR [MrMrsT175L_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RosesRCI_PROMOPRICE]  DEFAULT ((0)) FOR [RosesRCI_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Margaritaville_PROMOPRICE]  DEFAULT ((0)) FOR [Margaritaville_PROMOPRICE]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HPGal_INAD]  DEFAULT ((0)) FOR [HPGal_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RealLemonLime_INAD]  DEFAULT ((0)) FOR [RealLemonLime_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts64_INAD]  DEFAULT ((0)) FOR [Motts64_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts86128oz_INAD]  DEFAULT ((0)) FOR [Motts86128oz_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO64_INAD]  DEFAULT ((0)) FOR [CLAMATO64_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO32_INAD]  DEFAULT ((0)) FOR [CLAMATO32_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HP10_INAD]  DEFAULT ((0)) FOR [HP10_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts8_INAD]  DEFAULT ((0)) FOR [Motts8_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMFTTetra_INAD]  DEFAULT ((0)) FOR [MottsMFTTetra_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHoo65oz_INAD]  DEFAULT ((0)) FOR [YooHoo65oz_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_VITACOCOKIDS_INAD]  DEFAULT ((0)) FOR [VITACOCOKIDS_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATOCANS_INAD]  DEFAULT ((0)) FOR [CLAMATOCANS_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsSS636pk_INAD]  DEFAULT ((0)) FOR [MottsSS636pk_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsPouch4pk_INAD]  DEFAULT ((0)) FOR [MottsPouch4pk_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS20s_INAD]  DEFAULT ((0)) FOR [MottsMS20s_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_IBCCrush12oz_INAD]  DEFAULT ((0)) FOR [IBCCrush12oz_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHooCans_INAD]  DEFAULT ((0)) FOR [YooHooCans_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT1L_INAD]  DEFAULT ((0)) FOR [MrMrsT1L_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT175L_INAD]  DEFAULT ((0)) FOR [MrMrsT175L_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RosesRCI_INAD]  DEFAULT ((0)) FOR [RosesRCI_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Margaritaville_INAD]  DEFAULT ((0)) FOR [Margaritaville_INAD]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HPGal_DISPLAY]  DEFAULT ((0)) FOR [HPGal_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RealLemonLime_DISPLAY]  DEFAULT ((0)) FOR [RealLemonLime_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts64_DISPLAY]  DEFAULT ((0)) FOR [Motts64_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts86128oz_DISPLAY]  DEFAULT ((0)) FOR [Motts86128oz_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO64_DISPLAY]  DEFAULT ((0)) FOR [CLAMATO64_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATO32_DISPLAY]  DEFAULT ((0)) FOR [CLAMATO32_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_HP10_DISPLAY]  DEFAULT ((0)) FOR [HP10_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Motts8_DISPLAY]  DEFAULT ((0)) FOR [Motts8_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMFTTetra_DISPLAY]  DEFAULT ((0)) FOR [MottsMFTTetra_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHoo65oz_DISPLAY]  DEFAULT ((0)) FOR [YooHoo65oz_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_VITACOCOKIDS_DISPLAY]  DEFAULT ((0)) FOR [VITACOCOKIDS_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_CLAMATOCANS_DISPLAY]  DEFAULT ((0)) FOR [CLAMATOCANS_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsSS636pk_DISPLAY]  DEFAULT ((0)) FOR [MottsSS636pk_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsPouch4pk_DISPLAY]  DEFAULT ((0)) FOR [MottsPouch4pk_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS20s_DISPLAY]  DEFAULT ((0)) FOR [MottsMS20s_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MottsMS40s_DISPLAY]  DEFAULT ((0)) FOR [MottsMS40s_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_IBCCrush12oz_DISPLAY]  DEFAULT ((0)) FOR [IBCCrush12oz_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_YooHooCans_DISPLAY]  DEFAULT ((0)) FOR [YooHooCans_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT1L_DISPLAY]  DEFAULT ((0)) FOR [MrMrsT1L_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_MrMrsT175L_DISPLAY]  DEFAULT ((0)) FOR [MrMrsT175L_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_RosesRCI_DISPLAY]  DEFAULT ((0)) FOR [RosesRCI_DISPLAY]
GO

ALTER TABLE [MSTR].[WDDetailSurveyResults_new] ADD  CONSTRAINT [DF_WDDetailSurveyResults_new_Margaritaville_DISPLAY]  DEFAULT ((0)) FOR [Margaritaville_DISPLAY]
GO


