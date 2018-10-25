use Portal_Data
Go

Select *
From SAP.Account
Where isnull(ChannelID,0) = 0
And InCapstone = 1
And CRMActive = 1


exec SupplyChain.pGetDsdOverAllScoresForLanding @DateID=20150208,@RegionIDs=N'1,2,3,4,5,6,7,8,9,11,14,12',@BranchIDs=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@PackageIDs=N'1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186',@MeasureType=N'MinMax',@AggregationID=0

exec SupplyChain.pGetDsdInventoryRegionMeasuresForLanding @DateID=20150208,@RegionIDs=N'1,2,3,4,5,6,7,8,9,11,14,12',@BranchIDs=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@PackageTypeIDs=N'1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186',@MeasureType=N'MinMax',@AggregationID=0

exec SupplyChain.pGetDsdMostImpactedPackagesForLanding @DateID=20150208,@RegionIDs=N'1,2,3,4,5,6,7,8,9,11,14,12',@BranchIDs=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@packageIDs=N'2,4,6,12,15,17,18,19,22,27,32,35,36,38,45,46,50,53,64,68,69,73,75,76,79,87,88,90,98,100,101,105,106,107,108,109,112,113,115,121,122,126,127,128,131,132,133,134,137,139,142,144,146,147,152,153,154,157,162,163,186,187,189,196,220,221,247,250,254,255,257,259,262,264,265,266,267,268,270,272,274,284,294,299,304,306,307,308,311,313,324,325,326,327,329,330,334,337,338,341,344,347,349,352,353,365,366,368,370,371,373,375,376,378,390,392,394,395,396,405,410,417,419,423,425,429,432,433,435,451,452,453,454,455,457,460,461,463,464,465,466,469,472,473,474,481,483,486,490,492,494,496,497,508,512,517,518,533,543,545,550,551,552,567,570,571,579,581,584,587,590,596,600,602,604,605,606,615,619,622,623,624,628,632,635,637,640,644,646,650,654,655,656,658,662,664,665,666,673,674,675,676,679,684,685,686,694,699,703,704,705,706,708,709,710,711,712,713,715,717,730,734,736,739,740,753,755,757,780,792,793,798,800,802,803,806,808,815,817,818,828,830,832,833,835,836,839,842,845,846,852,853,854,861,862,863,867,868,870,871,876,878,880,882,883,885,888,895,900,901,902,903,905,906,909,911,913,917,919,925,937,941,955,968,970,973,975,977,979,982,983,985,988,991,992,994,996,997,1019,1022,1027,1028,1030,1033,1039,1044,1046,1050,1051,1055,1056,1057,1059,1060,1061,1064,1066,1070,1071,1072,1073,1074,1079,1081,1083,1084,1086,1097,1116,1118,1119,1142,1145,1146,1152,1153,1154,1159,1160,1166,1173,1179,1196,1197,1203,1204,1205,1208,1211,1212,1220,1225,1227,1229,1231,1236,1238,1239',@MeasureType=N'DOS',@AggregationID=0

exec SupplyChain.pGetDsdInventoryBranchMeasuresForLanding @DateID=20150208,@BranchIDs=N'9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@PackageTypeIDs=N'1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186',@MeasureType=N'MinMax',@AggregationID=0

exec SupplyChain.pGetDsdOverAllScoresForLanding @DateID=20150208,@RegionIDs=N'1,2,3,4,5,6,7,8,9,11,14,12',@BranchIDs=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@PackageIDs=N'1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186',@MeasureType=N'DOS',@AggregationID=0

-------------------------
use Portal_Data
Go

exec SupplyChain.pGetDsdOverAllScoresForLanding @DateID=20150208,@RegionIDs=N'1,2,3,4,5,6,7,8,9,11,14,12',@BranchIDs=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@PackageIDs=N'1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186',@MeasureType=N'MinMax',@AggregationID=0

exec SupplyChain.pGetDsdInventoryRegionMeasuresForLanding @DateID=20150208,@RegionIDs=N'1,2,3,4,5,6,7,8,9,11,14,12',@BranchIDs=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@PackageTypeIDs=N'1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186',@MeasureType=N'MinMax',@AggregationID=0

exec SupplyChain.pGetDsdMostImpactedPackagesForLanding @DateID=20150208,@RegionIDs=N'1,2,3,4,5,6,7,8,9,11,14,12',@BranchIDs=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@packageIDs=N'2,4,6,12,15,17,18,19,22,27,32,35,36,38,45,46,50,53,64,68,69,73,75,76,79,87,88,90,98,100,101,105,106,107,108,109,112,113,115,121,122,126,127,128,131,132,133,134,137,139,142,144,146,147,152,153,154,157,162,163,186,187,189,196,220,221,247,250,254,255,257,259,262,264,265,266,267,268,270,272,274,284,294,299,304,306,307,308,311,313,324,325,326,327,329,330,334,337,338,341,344,347,349,352,353,365,366,368,370,371,373,375,376,378,390,392,394,395,396,405,410,417,419,423,425,429,432,433,435,451,452,453,454,455,457,460,461,463,464,465,466,469,472,473,474,481,483,486,490,492,494,496,497,508,512,517,518,533,543,545,550,551,552,567,570,571,579,581,584,587,590,596,600,602,604,605,606,615,619,622,623,624,628,632,635,637,640,644,646,650,654,655,656,658,662,664,665,666,673,674,675,676,679,684,685,686,694,699,703,704,705,706,708,709,710,711,712,713,715,717,730,734,736,739,740,753,755,757,780,792,793,798,800,802,803,806,808,815,817,818,828,830,832,833,835,836,839,842,845,846,852,853,854,861,862,863,867,868,870,871,876,878,880,882,883,885,888,895,900,901,902,903,905,906,909,911,913,917,919,925,937,941,955,968,970,973,975,977,979,982,983,985,988,991,992,994,996,997,1019,1022,1027,1028,1030,1033,1039,1044,1046,1050,1051,1055,1056,1057,1059,1060,1061,1064,1066,1070,1071,1072,1073,1074,1079,1081,1083,1084,1086,1097,1116,1118,1119,1142,1145,1146,1152,1153,1154,1159,1160,1166,1173,1179,1196,1197,1203,1204,1205,1208,1211,1212,1220,1225,1227,1229,1231,1236,1238,1239',@MeasureType=N'DOS',@AggregationID=0

exec SupplyChain.pGetDsdInventoryBranchMeasuresForLanding @DateID=20150208,@BranchIDs=N'9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@PackageTypeIDs=N'1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186',@MeasureType=N'MinMax',@AggregationID=0

exec SupplyChain.pGetDsdOverAllScoresForLanding @DateID=20150208,@RegionIDs=N'1,2,3,4,5,6,7,8,9,11,14,12',@BranchIDs=N'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178',@TrademarkIDs=N'5,7,11,12,13,231,29,20,33,59,37,60,44,61,50,51,73,75,86,94,104,101,113,111,112,119,124,134,131,143,148,145,149,141,156,152,157,160,161,167,174,232,199,196,219,221,223,1,3,22,34,35,36,47,49,64,65,69,89,99,105,138,158,170,173,184,190,194,195,208,217,54,97,129,130,137,154,171,187,192,216,228',@PackageIDs=N'1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,127,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,169,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186',@MeasureType=N'DOS',@AggregationID=0


---- OOS ---
Declare @Time DateTime2(7)
Set @Time = sysdatetime()

Exec [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding] 20150208
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 14, 12'
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 167, 168, 169, 170, 172, 173, 174, 175, 176, 177'
,'4, 5, 6, 7, 9, 11, 12, 13, 18, 231, 29, 20, 23, 33, 24, 59, 37, 53, 38, 39, 41, 42, 52, 58, 60, 44, 61, 45, 46, 48, 50, 51, 67, 68, 71, 72, 73, 75, 76, 77, 79, 80, 86, 94, 95, 96, 98, 104, 101, 113, 110, 111, 112, 115, 119, 120, 121, 124, 134, 135, 131, 132, 143, 148, 140, 145, 147, 149, 141, 230, 150, 151, 156, 152, 157, 160, 161, 162, 167, 169, 179, 172, 174, 178, 181, 203, 185, 202, 188, 232, 193, 199, 196, 198, 209, 210, 213, 215, 219, 221, 223, 226, 2, 1, 3, 247, 256, 8, 16, 10, 17, 15, 14, 254, 19, 28, 21, 26, 32, 22, 31, 25, 27, 30, 56, 250, 34, 249, 35, 36, 40, 55, 57, 43, 245, 47, 62, 238, 49, 63, 64, 70, 234, 65, 66, 69, 74, 83, 82, 78, 84, 235, 255, 85, 81, 87, 93, 90, 88, 92, 89, 253, 103, 99, 100, 102, 105, 108, 106, 107, 109, 114, 116, 240, 117, 118, 122, 123, 126, 237, 252, 127, 128, 136, 138, 139, 146, 142, 144, 242, 155, 153, 158, 159, 165, 163, 164, 166, 251, 241, 168, 236, 170, 173, 176, 177, 180, 182, 183, 184, 200, 204, 186, 257, 205, 206, 233, 189, 190, 191, 201, 194, 195, 244, 207, 197, 243, 208, 211, 212, 246, 214, 239, 217, 220, 218, 222, 224, 225, 248, 227, 229, 54, 91, 97, 125, 129, 130, 133, 137, 154, 171, 175, 187, 192, 216, 228'
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180'
,'DOS'
Select DateDiff(ms, @Time, sysdatetime()) RegionBar
GO

 ----- Over all
Declare @Time DateTime2(7)
Set @Time = sysdatetime()
Exec [SupplyChain].[pGetDsdOverAllScoresForLanding] 20150208
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 14, 12'
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 167, 168, 169, 170, 172, 173, 174, 175, 176, 177'
,'4, 5, 6, 7, 9, 11, 12, 13, 18, 231, 29, 20, 23, 33, 24, 59, 37, 53, 38, 39, 41, 42, 52, 58, 60, 44, 61, 45, 46, 48, 50, 51, 67, 68, 71, 72, 73, 75, 76, 77, 79, 80, 86, 94, 95, 96, 98, 104, 101, 113, 110, 111, 112, 115, 119, 120, 121, 124, 134, 135, 131, 132, 143, 148, 140, 145, 147, 149, 141, 230, 150, 151, 156, 152, 157, 160, 161, 162, 167, 169, 179, 172, 174, 178, 181, 203, 185, 202, 188, 232, 193, 199, 196, 198, 209, 210, 213, 215, 219, 221, 223, 226, 2, 1, 3, 247, 256, 8, 16, 10, 17, 15, 14, 254, 19, 28, 21, 26, 32, 22, 31, 25, 27, 30, 56, 250, 34, 249, 35, 36, 40, 55, 57, 43, 245, 47, 62, 238, 49, 63, 64, 70, 234, 65, 66, 69, 74, 83, 82, 78, 84, 235, 255, 85, 81, 87, 93, 90, 88, 92, 89, 253, 103, 99, 100, 102, 105, 108, 106, 107, 109, 114, 116, 240, 117, 118, 122, 123, 126, 237, 252, 127, 128, 136, 138, 139, 146, 142, 144, 242, 155, 153, 158, 159, 165, 163, 164, 166, 251, 241, 168, 236, 170, 173, 176, 177, 180, 182, 183, 184, 200, 204, 186, 257, 205, 206, 233, 189, 190, 191, 201, 194, 195, 244, 207, 197, 243, 208, 211, 212, 246, 214, 239, 217, 220, 218, 222, 224, 225, 248, 227, 229, 54, 91, 97, 125, 129, 130, 133, 137, 154, 171, 175, 187, 192, 216, 228'
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180'
,'DOS'
Select DateDiff(ms, @Time, sysdatetime()) Overall
GO
 
Declare @Time DateTime2(7)
Set @Time = sysdatetime()

Exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20150208
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 167, 168, 169, 170, 172, 173, 174, 175, 176, 177'
,'4, 5, 6, 7, 9, 11, 12, 13, 18, 231, 29, 20, 23, 33, 24, 59, 37, 53, 38, 39, 41, 42, 52, 58, 60, 44, 61, 45, 46, 48, 50, 51, 67, 68, 71, 72, 73, 75, 76, 77, 79, 80, 86, 94, 95, 96, 98, 104, 101, 113, 110, 111, 112, 115, 119, 120, 121, 124, 134, 135, 131, 132, 143, 148, 140, 145, 147, 149, 141, 230, 150, 151, 156, 152, 157, 160, 161, 162, 167, 169, 179, 172, 174, 178, 181, 203, 185, 202, 188, 232, 193, 199, 196, 198, 209, 210, 213, 215, 219, 221, 223, 226, 2, 1, 3, 247, 256, 8, 16, 10, 17, 15, 14, 254, 19, 28, 21, 26, 32, 22, 31, 25, 27, 30, 56, 250, 34, 249, 35, 36, 40, 55, 57, 43, 245, 47, 62, 238, 49, 63, 64, 70, 234, 65, 66, 69, 74, 83, 82, 78, 84, 235, 255, 85, 81, 87, 93, 90, 88, 92, 89, 253, 103, 99, 100, 102, 105, 108, 106, 107, 109, 114, 116, 240, 117, 118, 122, 123, 126, 237, 252, 127, 128, 136, 138, 139, 146, 142, 144, 242, 155, 153, 158, 159, 165, 163, 164, 166, 251, 241, 168, 236, 170, 173, 176, 177, 180, 182, 183, 184, 200, 204, 186, 257, 205, 206, 233, 189, 190, 191, 201, 194, 195, 244, 207, 197, 243, 208, 211, 212, 246, 214, 239, 217, 220, 218, 222, 224, 225, 248, 227, 229, 54, 91, 97, 125, 129, 130, 133, 137, 154, 171, 175, 187, 192, 216, 228'
,'1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180'
,'DOS'

Select DateDiff(ms, @Time, sysdatetime()) ImpactedBranches
GO
  
Declare @Time DateTime2(7)
Set @Time = sysdatetime()

  Exec [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] 20150208
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 14, 12'
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 167, 168, 169, 170, 172, 173, 174, 175, 176, 177'
,'4, 5, 6, 7, 9, 11, 12, 13, 18, 231, 29, 20, 23, 33, 24, 59, 37, 53, 38, 39, 41, 42, 52, 58, 60, 44, 61, 45, 46, 48, 50, 51, 67, 68, 71, 72, 73, 75, 76, 77, 79, 80, 86, 94, 95, 96, 98, 104, 101, 113, 110, 111, 112, 115, 119, 120, 121, 124, 134, 135, 131, 132, 143, 148, 140, 145, 147, 149, 141, 230, 150, 151, 156, 152, 157, 160, 161, 162, 167, 169, 179, 172, 174, 178, 181, 203, 185, 202, 188, 232, 193, 199, 196, 198, 209, 210, 213, 215, 219, 221, 223, 226, 2, 1, 3, 247, 256, 8, 16, 10, 17, 15, 14, 254, 19, 28, 21, 26, 32, 22, 31, 25, 27, 30, 56, 250, 34, 249, 35, 36, 40, 55, 57, 43, 245, 47, 62, 238, 49, 63, 64, 70, 234, 65, 66, 69, 74, 83, 82, 78, 84, 235, 255, 85, 81, 87, 93, 90, 88, 92, 89, 253, 103, 99, 100, 102, 105, 108, 106, 107, 109, 114, 116, 240, 117, 118, 122, 123, 126, 237, 252, 127, 128, 136, 138, 139, 146, 142, 144, 242, 155, 153, 158, 159, 165, 163, 164, 166, 251, 241, 168, 236, 170, 173, 176, 177, 180, 182, 183, 184, 200, 204, 186, 257, 205, 206, 233, 189, 190, 191, 201, 194, 195, 244, 207, 197, 243, 208, 211, 212, 246, 214, 239, 217, 220, 218, 222, 224, 225, 248, 227, 229, 54, 91, 97, 125, 129, 130, 133, 137, 154, 171, 175, 187, 192, 216, 228'
,'1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180'
,'Minmax'

Select DateDiff(ms, @Time, sysdatetime()) ImpactedPackages
GO
