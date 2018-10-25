USE [Portal_Data]
GO
/****** Object:  StoredProcedure [Settings].[pGetBehaviorsWithCounts]    Script Date: 2/12/2014 10:22:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [Settings].[pGetBehaviorsWithCounts]
As
Begin
	Set NoCount On;

	Select 
	B.[BehaviorID]
      ,B.[BehavoirName]
      ,B.[DisplayName]
      ,B.[Description]
      ,B.[MaxAssignment]
      ,B.[AssignLevel]
      ,B.[CreatedBy]
      ,B.[LastModifiedBy]
      ,B.[LastModified]
	  ,(Select Count(*) from [Settings].[BehaviorMember] as BM where BM.[BehaviorID] = B.[BehaviorID]) as MemberCount
  FROM [Settings].[Behavior] as B


End
