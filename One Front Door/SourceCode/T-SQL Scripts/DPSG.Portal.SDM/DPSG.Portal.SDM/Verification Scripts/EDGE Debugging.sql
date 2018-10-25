Use Portal_Data
Go

Select top 10 *
From EDGE.RPLITem 
Where ReceivedDate > '2013-09-17'
Order By ItemID desc
Go

Select *
From EDGE.WebServiceLog 
--Where ModifiedDate > '2013-09-17'
Order By LogID desc
Go

-------------- Log --------------
Select * From EDGE.WebServiceLog 
Where ExternalReferenceType = 'ContentID' and ExternalReference = 8888 Order By ModifiedDate desc
Go

---------------------------------
Declare @ItemID int
Select @ItemID = Max(ItemID)
From EDGE.RPLITem 
Where ContentID = 8888
Select @ItemID

Select * From EDGE.RPLItem 
Where ItemID = @ItemID

Select * From EDGE.RPLItemCategory 
Where ItemID = @ItemID

Select * From EDGE.RPLItemPackage 
Where ItemID = @ItemID

Select * From EDGE.RPLItemNAE 
Where ItemID = @ItemID

Select * From EDGE.RPLItemChannel 
Where ItemID = @ItemID

Select * From EDGE.RPLItemBrand 
Where ItemID = @ItemID

Select * From EDGE.RPLAttachment 
Where ItemID = @ItemID

Select * From EDGE.RPLItemAccount 
Where ItemID = @ItemID

--Delete EDGE.RPLItemCategory
--From EDGE.RPLItemCategory c
--	Join EDGE.RPLItem r on c.ItemID = r.ItemID
--Where r.ContentID = 8888

--Delete From EDGE.RPLItemPackage Where ContentID = 8888
--Delete From EDGE.RPLItemPackage Where ContentID = 8888
--Delete From EDGE.RPLItemNAE Where ContentID = 8888
--Delete From EDGE.RPLItemChannel Where ContentID = 8888
--Delete From EDGE.RPLItemBrand Where ContentID = 8888
--Delete From EDGE.RPLItemAccount Where ContentID = 8888
--Delete From EDGE.RPLAttachment Where ContentID = 8888
--Delete From EDGE.RPLItem Where ContentID = 8888
--Delete From EDGE.WebServiceLog Where ExternalReferenceType = 'ContentID' and ExternalReference = 8888
Go


Select *
From EDGE.WebServiceLog 
Where Detail <> 'OK'
Order By LogID DESC
Go

Select *
From EDGE.RPLItem ri
Order By ItemId desc
Go

Select *
From EDGE.RPLItem ri
Join
(
	Select Max(ItemID) ItemID, ContentID
	From EDGE.RPLItem 
	--Where Title like 'TEST%'
	Group By ContentID
) lastedContents on ri.ItemID = lastedContents.ItemID
Order By ri.ItemID desc
Go

Select ri.Title, ri.REceivedDate ItemReceivedDate, datalength(physicalfile) DataLength, AttachmentID, 
	FileName, a.ItemID, a.ContentID, AttachmentType, a.ReceivedDate, a.TestData
From EDGE.RPLAttachment a
right Join
(
	Select Max(ItemID) ItemID, ContentID
	From EDGE.RPLItem 
	--Where Title like 'TEST%'
	Group By ContentID
) lastedContents on a.ItemID = lastedContents.ItemID
left Join EDGE.RPLItem ri on a.ItemID = ri.ItemID
Order By a.ItemID desc
Go

Select FileName, ItemID, ReceivedDate, AttachmentType, DAtaLength(PhysicalFile) Length
From EDGE.RPLAttachment a
Order By ContentID desc

Select Max(DAtaLength(PhysicalFile)) Length
From EDGE.RPLAttachment a

Select *
From EDGE.WebServiceLog
Where ExternalReference = 18334

Select *
FRom EDGE.RPLItem
Where ContentID = 18297



Select ReceivedDate, *
From EDGE.RPLItem
Order By ReceivedDate Desc
Go




Select *
From EDGE.RPLItem
Where ContentID = 18298

Select *
From EDGE.WebSErviceLog
Where ExternalREference = 18298

Select datalength(PhysicalFile) FileLength, ReceivedDate, * 
From EDGE.RPLAttachment r
--Where FileName in ('PUBLIX #20900 NAE DP REDBOX test.doc', 'walmart #21.1 contacts.xls')
Order By r.ReceivedDate desc
Go

Select datalength(PhysicalFile) FileLength, ReceivedDate, * 
From EDGE.RPLAttachment r
Where ItemID > 56 
Order By FileName, r.ReceivedDate desc
Go

Select * From EDGE.RPLItemAccount order By ItemID desc
Go

Select ri.*, FileName, datalength(PhysicalFile), ri.ReceivedDate 
From EDGE.RPLAttachment a
Join EDGE.RPLItem ri On a.itemID = ri.ItemID
order By a.ItemID desc
Go

Select * From EDGE.RPLItemBrand order By ItemID desc
Go
Select * From EDGE.RPLItemChannel order By ItemID desc
Go
Select * From EDGE.RPLItemNAE order By ItemID desc
Go
Select * From EDGE.RPLItemPackage order By ItemID desc
Go
Select * From EDGE.WebServiceLog order By LogID desc
Go

Select *
From Playbook.RetailPromotion
Order by modifieddate desc
Go

select *
From Playbook.PromotionBrand
Where PromotionID in (1203, 1204, 1205, 1206)
Go

select *
from SAP.Trademark
Where TrademarkID = 187
Go
