Use Portal_DataSRE
Go

-- Seems to be 3K~4K active bottlers that have EB, BC or FS relationships

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
   D.BTTLR_ID, D.BTTLR_NM, 
   D.CHNL_CODE, D.GLOBAL_STTS, 
   D.DEL_FLG, D.ROW_MOD_DT, 
   D.PRODUCER_FLG
FROM CAP_DM.DM_BTTLR D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCBottler')

Exec (@OPENQUERY)
Go

Select * From Staging.BCBottler
Go

Select * From Staging.BCBottler
Select * From Staging.BCBPAddress
Select * From BC.GlobalStatus
Select * From SAP.Channel
Select * From BC.BottlerEB4
Select * From BC.Region
Go

-----  Maybe need to use the sale table, just trundate and reload every time ---
--If Exists (Select * From Sys.Tables Where Object_id = object_id('Staging.WorkingBottlerEBNodes'))
--Begin
--	Drop Table Staging.WorkingBottlerNodes
--End

--Select NODE_ID, Max(ROW_MOD_DT) ROW_MOD_DT
--Into Staging.WorkingBottlerEBNodes
--From Staging.BCBottlerHierachy h
--Where DEL_FLG <> 'Y'
--Group By NODE_ID	
--Go

--Select PARTNER
--From Staging.BCBottlerHierachy
--Go

--Select *
--From Staging.BCBottlerSalesHierachy
--Go

Select *
From BC.Bottler

Select *
From Staging.BCBottler

--Delete BC.Bottler

Merge BC.Bottler As BTTR
	Using ( 
		   Select B.BTTLR_ID, Replace(Replace(Replace(dbo.udf_TitleCase(BTTLR_NM), 'Pb - ', 'PB - '), 'Ccr ', 'CCR '), 'Usf ', 'USF ') BTTLR_NM, c.ChannelID, 
				Case When b.DEL_FLG = 'Y' 
					Then 99 
					Else b.GLOBAL_STTS
				End GLOBAL_STTS, 
			r.RegionID BCRegionID, r2.RegionID FSRegionID, eb4.EB4ID,
			dbo.udf_TitleCase(a.[ADDR_LINE_1]) ADDR_LINE_1,
			dbo.udf_TitleCase(a.[ADDR_CITY]) ADDR_CITY,
			a.ADDR_REGION_ABRV,
			a.[ADDR_PSTL_CODE],
			a.EMAIL,
			a.PHN_NBR,
			a.ADDR_CNTRY_CODE,
			b.ROW_MOD_DT,
			a.ROW_MOD_DT Address_ROW_MOD_DT,
			dbo.udf_TitleCase(a.ADDR_CNTY_NM) ADDR_CNTY_NM,
			tempMDT1.ROW_MOD_DT EB_ROW_MOD_DT,
			tempMDT2.ROW_MOD_DT BC_ROW_MOD_DT,
			tempMDT3.ROW_MOD_DT FS_ROW_MOD_DT
		From Staging.BCBottler b
			Left Join Staging.BCBPAddress a on b.BTTLR_ID = a.BP_ID
			Left Join SAP.Channel c on b.CHNL_CODE = c.SAPChannelID
			Left Join Staging.BCBottlerHierachyE e on e.BTTLR_ID = b.BTTLR_ID
			Left Join Staging.TempBottlerLEGLatestUpdatedDate tempMDT1 on tempMDT1.Partner = b.BTTLR_ID And tempMDT1.HIER_TYPE = 'EB'
			Left Join BC.BottlerEB4 eb4 on eb4.BCNodeID = e.NODE4_ID
			Left Join Staging.BCBottlerSalesHierachy sh on sh.BTTLR_ID = b.BTTLR_ID and sh.HIER_TYPE = 'BC'
			Left Join BC.Region r on r.BCNodeID = sh.REGION_ID
			Left Join Staging.TempBottlerLEGLatestUpdatedDate tempMDT2 on tempMDT2.Partner = b.BTTLR_ID And tempMDT2.HIER_TYPE = 'BC'
			Left Join Staging.BCBottlerSalesHierachy shfs on shfs.BTTLR_ID = b.BTTLR_ID and shfs.HIER_TYPE = 'FS'
			Left Join BC.Region r2 on r2.BCNodeID = shfs.REGION_ID
			Left Join Staging.TempBottlerLEGLatestUpdatedDate tempMDT3 on tempMDT3.Partner = b.BTTLR_ID And tempMDT3.HIER_TYPE = 'FS'
		) As input
	On BTTR.[BCBottlerID] = Convert(bigint, input.BTTLR_ID)
When Matched Then
	Update Set BottlerName = input.BTTLR_NM,
			ChannelID = input.ChannelID,
			GlobalStatusID = input.GLOBAL_STTS,
			EB4ID = input.EB4ID,
			BCRegionID = input.BCRegionID,
			FSRegionID = input.FSRegionID,
			Address = input.ADDR_LINE_1,
			City = input.ADDR_CITY,
			County = input.ADDR_CNTY_NM,
			State = input.ADDR_REGION_ABRV,
			PostalCode = input.ADDR_PSTL_CODE,
			Email = input.EMAIL,
			PhoneNumber = input.PHN_NBR,
			LastModified = input.ROW_MOD_DT,
			AddressLastModified = input.Address_ROW_MOD_DT,
			EB4LastModified = input.EB_ROW_MOD_DT,
			[BCRegionLastModified] = input.BC_ROW_MOD_DT,
			[FSRegionLastModified] = input.FS_ROW_MOD_DT
When Not Matched By Target Then
	Insert([BCBottlerID],[BottlerName],[ChannelID],[GlobalStatusID],[EB4ID],
	[BCRegionID],[FSRegionID],[Address],[City],[County],[State],[PostalCode],
	[Country],[Email],[PhoneNumber],[LastModified],AddressLastModified,
	EB4LastModified,[BCRegionLastModified],[FSRegionLastModified])
	Values(input.BTTLR_ID,input.BTTLR_NM,input.ChannelID,input.GLOBAL_STTS,input.EB4ID,
	input.BCRegionID,input.FSRegionID,input.ADDR_LINE_1,input.ADDR_CITY,
	input.ADDR_CNTY_NM,input.ADDR_REGION_ABRV,input.ADDR_PSTL_CODE,
	input.ADDR_CNTRY_CODE,input.EMAIL,input.PHN_NBR,input.ROW_MOD_DT,input.Address_ROW_MOD_DT,
	input.EB_ROW_MOD_DT,input.BC_ROW_MOD_DT,input.FS_ROW_MOD_DT)
When Not Matched By Source Then
	Update Set GlobalStatusID = 03;
Go

If 0 = 1
Begin
	Drop Table Staging.TempBottlerLEGLatestUpdatedDate
End
Go

Select PARTNER, HIER_TYPE, Count(*) LEG_COUNT, MAX(ROW_MOD_DT) ROW_MOD_DT
Into Staging.TempBottlerLEGLatestUpdatedDate
From Staging.BCBottlerHierachy
Where PARTNER is not null
And DEL_FLG <> 'Y'
Group By PARTNER, HIER_TYPE

Select *
From BC.Bottler
Where GlobalStatusID = 2
And FSRegionLastModified <> BCRegionLastModified

Select *
From Staging.TempBottlerLEGLatestUpdatedDate
Where PARTNER = 0012013188
Order By PARTNER, HIER_TYPE

Select *
From BC.Bottler
Where BCBottlerID = 0012013188


Select *
From BC.Bottler
Where GlobalStatusID = 2
And BCRegionID is not null

Select *
From BC.Bottler
Where GlobalStatusID = 2
And Email is not null

Select *
From BC.Bottler
Where GlobalStatusID = 2
And BCRegionID is not null

Select *
From BC.Bottler
Where GlobalStatusID = 2
And EB4ID is null
And BCRegionID is null
And FSRegionID is null






