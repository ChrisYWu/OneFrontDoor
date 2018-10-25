use Portal_Data805
Go

Select ChainID, Count(*) Cnt, Min(ImageName) ImageName
From (
Select Distinct ChainID, Chain, ImageName
From [MSTR].[RevChainImages]) temp
Group by ChainID
Order By Count(*) Desc

Select *,'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/' + ImageName WebImageURL
	  ,'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/Mobile/' + ImageName MobileImageURL
From [MSTR].[RevChainImages]
Where ChainID in ('N00177', 'R00596')


SELECT Distinct 
	   [ChainID]
      ,[Chain]
      ,[ImageName]
	  ,'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/' + ImageName WebImageURL
	  ,'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/Mobile/' + ImageName MobileImageURL
  FROM [MSTR].[RevChainImages] Order By ImageName

