-- Executed on 5/22/2013 1502
Use Portal_Data
Go

Alter Table SAP.ProfitCenter
Add SPProfitCenterName varchar(50)
Go

Update SAP.BusinessUnit Set SPBUName = 'Central' Where SAPBUID = 'CENTRAL'
Update SAP.BusinessUnit Set SPBUName = 'Northeast' Where SAPBUID = 'NORTHEAST'
Update SAP.BusinessUnit Set SPBUName = 'Pacific' Where SAPBUID = 'PACIFIC'
Update SAP.BusinessUnit Set SPBUName = 'Southwest' Where SAPBUID = 'SOUTHWEST'

Update SAP.Region Set SPRegionName = 'Mid-Central' Where SAPRegionID = 'MID-CENTRAL'
Update SAP.Region Set SPRegionName = 'Mid-South' Where SAPRegionID = 'MID-SOUTH'
Update SAP.Region Set SPRegionName = 'Plains' Where SAPRegionID = 'PLAINS'
Update SAP.Region Set SPRegionName = 'Southeast' Where SAPRegionID = 'SOUTHEAST'
Update SAP.Region Set SPRegionName = 'Metro NY/NJ' Where SAPRegionID = 'METRO NY/NJ'
Update SAP.Region Set SPRegionName = 'Michigan' Where SAPRegionID = 'MICHIGAN'
Update SAP.Region Set SPRegionName = 'Ohio Valley' Where SAPRegionID = 'OHIO VALLEY'
Update SAP.Region Set SPRegionName = 'Northwest' Where SAPRegionID = 'NORTHWEST'
Update SAP.Region Set SPRegionName = 'So. Cal / Nevada' Where SAPRegionID = 'SOCAL - NEVADA'
Update SAP.Region Set SPRegionName = 'South Texas/New Mexico' Where SAPRegionID = 'SOUTH TEXAS/NEW MEXICO'
Update SAP.Region Set SPRegionName = 'Southern Texas' Where SAPRegionID = 'SOUTHERN TEXAS'
Update SAP.Region Set SPRegionName = 'Texoma' Where SAPRegionID = 'TEXOMA'

Update SAP.ProfitCenter Set SPProfitCenterName = 'Cookeville' Where SAPProfitCenterID = '101400'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Tupelo' Where SAPProfitCenterID = '101450'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Colorado' Where SAPProfitCenterID = '102692'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Plymouth' Where SAPProfitCenterID = '180220'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Clear Lake' Where SAPProfitCenterID = '100830'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Fort Dodge' Where SAPProfitCenterID = '101140'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Decorah' Where SAPProfitCenterID = '101130'
Update SAP.ProfitCenter Set SPProfitCenterName = 'West Burlington' Where SAPProfitCenterID = '101120'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Champaign' Where SAPProfitCenterID = '100120'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Topeka' Where SAPProfitCenterID = '101000'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Manhattan' Where SAPProfitCenterID = '101010'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Warrensburg' Where SAPProfitCenterID = '101020'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Fort Scott' Where SAPProfitCenterID = '101040'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Joplin' Where SAPProfitCenterID = '101150'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Lexington' Where SAPProfitCenterID = '101310'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Mankato' Where SAPProfitCenterID = '100950'
Update SAP.ProfitCenter Set SPProfitCenterName = 'St. Cloud' Where SAPProfitCenterID = '100970'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Eau Claire' Where SAPProfitCenterID = '100980'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Jefferson City' Where SAPProfitCenterID = '101080'
Update SAP.ProfitCenter Set SPProfitCenterName = 'St Joseph' Where SAPProfitCenterID = '101030'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Chillicothe' Where SAPProfitCenterID = '101050'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Sioux City' Where SAPProfitCenterID = '100920'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Aberdeen' Where SAPProfitCenterID = '101160'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Chattanooga' Where SAPProfitCenterID = '101410'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Kingsport' Where SAPProfitCenterID = '101420'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Fayetteville' Where SAPProfitCenterID = '100680'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Springdale' Where SAPProfitCenterID = '102100'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Castroville' Where SAPProfitCenterID = '102780'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Santa Paula' Where SAPProfitCenterID = '102485'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Mobile' Where SAPProfitCenterID = '101210'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Ft Pierce' Where SAPProfitCenterID = '101700'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Boynton Beach' Where SAPProfitCenterID = '101730'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Ft Myers' Where SAPProfitCenterID = '101720'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Ocala' Where SAPProfitCenterID = '101620'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Ormond Beach/Daytona' Where SAPProfitCenterID = '101660'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Cocoa' Where SAPProfitCenterID = '101690'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Sarasota' Where SAPProfitCenterID = '101670'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Lakeland' Where SAPProfitCenterID = '101680'
Update SAP.ProfitCenter Set SPProfitCenterName = 'Athens' Where SAPProfitCenterID = '101750'

Update SAP.Branch Set SPBranchName ='Harvey' Where SAPBranchID = 1018
Update SAP.Branch Set SPBranchName ='Northlake' Where SAPBranchID = 1020
Update SAP.Branch Set SPBranchName ='Peoria' Where SAPBranchID = 1021
Update SAP.Branch Set SPBranchName ='Rockford' Where SAPBranchID = 1022
Update SAP.Branch Set SPBranchName ='Oshkosh' Where SAPBranchID = 1068
Update SAP.Branch Set SPBranchName ='Racine' Where SAPBranchID = 1069
Update SAP.Branch Set SPBranchName ='Tomah' Where SAPBranchID = 1070
Update SAP.Branch Set SPBranchName ='Windsor' Where SAPBranchID = 1071
Update SAP.Branch Set SPBranchName ='Springfield' Where SAPBranchID = 1023
Update SAP.Branch Set SPBranchName ='Fort Wayne' Where SAPBranchID = 1024
Update SAP.Branch Set SPBranchName ='Indianapolis' Where SAPBranchID = 1025
Update SAP.Branch Set SPBranchName ='Seymour' Where SAPBranchID = 1026
Update SAP.Branch Set SPBranchName ='South Bend' Where SAPBranchID = 1027
Update SAP.Branch Set SPBranchName ='New Castle' Where SAPBranchID = 1028
Update SAP.Branch Set SPBranchName ='Nashville' Where SAPBranchID = 1064
Update SAP.Branch Set SPBranchName ='Knoxville' Where SAPBranchID = 1065
Update SAP.Branch Set SPBranchName ='Memphis' Where SAPBranchID = 1066
Update SAP.Branch Set SPBranchName ='Louisville' Where SAPBranchID = 1034
Update SAP.Branch Set SPBranchName ='Hazelwood' Where SAPBranchID = 1039
Update SAP.Branch Set SPBranchName ='Cedar Rapids' Where SAPBranchID = 1010
Update SAP.Branch Set SPBranchName ='Davenport' Where SAPBranchID = 1011
Update SAP.Branch Set SPBranchName ='Des Moines' Where SAPBranchID = 1012
Update SAP.Branch Set SPBranchName ='Dubuque' Where SAPBranchID = 1014
Update SAP.Branch Set SPBranchName ='Ottumwa' Where SAPBranchID = 1015
Update SAP.Branch Set SPBranchName ='Fargo' Where SAPBranchID = 1062
Update SAP.Branch Set SPBranchName ='Bismarck' Where SAPBranchID = 1180
Update SAP.Branch Set SPBranchName ='Twin Cities' Where SAPBranchID = 1037
Update SAP.Branch Set SPBranchName ='Lincoln' Where SAPBranchID = 1058
Update SAP.Branch Set SPBranchName ='Norfolk' Where SAPBranchID = 1059
Update SAP.Branch Set SPBranchName ='Omaha' Where SAPBranchID = 1060
Update SAP.Branch Set SPBranchName ='Spencer' Where SAPBranchID = 1016
Update SAP.Branch Set SPBranchName ='Hays' Where SAPBranchID = 1029
Update SAP.Branch Set SPBranchName ='Lenexa' Where SAPBranchID = 1030
Update SAP.Branch Set SPBranchName ='Wichita' Where SAPBranchID = 1032
Update SAP.Branch Set SPBranchName ='Superior' Where SAPBranchID = 1036
Update SAP.Branch Set SPBranchName ='Birmingham' Where SAPBranchID = 1001
Update SAP.Branch Set SPBranchName ='Jacksonville' Where SAPBranchID = 1004
Update SAP.Branch Set SPBranchName ='Miami' Where SAPBranchID = 1005
Update SAP.Branch Set SPBranchName ='Orlando' Where SAPBranchID = 1006
Update SAP.Branch Set SPBranchName ='Tallahassee' Where SAPBranchID = 1007
Update SAP.Branch Set SPBranchName ='Tampa' Where SAPBranchID = 1008
Update SAP.Branch Set SPBranchName ='Atlanta' Where SAPBranchID = 1009
Update SAP.Branch Set SPBranchName ='Gonzales' Where SAPBranchID = 1035
Update SAP.Branch Set SPBranchName ='Hattiesburg' Where SAPBranchID = 1056
Update SAP.Branch Set SPBranchName ='Avenel' Where SAPBranchID = 1080
Update SAP.Branch Set SPBranchName ='Brooklyn' Where SAPBranchID = 1083
Update SAP.Branch Set SPBranchName ='Elmsford' Where SAPBranchID = 1084
Update SAP.Branch Set SPBranchName ='Syosset' Where SAPBranchID = 1086
Update SAP.Branch Set SPBranchName ='Cadillac' Where SAPBranchID = 1073
Update SAP.Branch Set SPBranchName ='Detroit' Where SAPBranchID = 1074
Update SAP.Branch Set SPBranchName ='Gaylord' Where SAPBranchID = 1075
Update SAP.Branch Set SPBranchName ='Lansing' Where SAPBranchID = 1076
Update SAP.Branch Set SPBranchName ='Flint' Where SAPBranchID = 1078
Update SAP.Branch Set SPBranchName ='Paw Paw' Where SAPBranchID = 1079
Update SAP.Branch Set SPBranchName ='Holland' Where SAPBranchID = 1173
Update SAP.Branch Set SPBranchName ='Columbus' Where SAPBranchID = 1077
Update SAP.Branch Set SPBranchName ='Cincinnati' Where SAPBranchID = 1088
Update SAP.Branch Set SPBranchName ='Dayton' Where SAPBranchID = 1090
Update SAP.Branch Set SPBranchName ='Lima' Where SAPBranchID = 1091
Update SAP.Branch Set SPBranchName ='Youngstown' Where SAPBranchID = 1098
Update SAP.Branch Set SPBranchName ='Pittsburgh' Where SAPBranchID = 1099
Update SAP.Branch Set SPBranchName ='Beckley' Where SAPBranchID = 1100
Update SAP.Branch Set SPBranchName ='Charleston' Where SAPBranchID = 1101
Update SAP.Branch Set SPBranchName ='Stonewood' Where SAPBranchID = 1102
Update SAP.Branch Set SPBranchName ='Marietta' Where SAPBranchID = 1092
Update SAP.Branch Set SPBranchName ='Mansfield' Where SAPBranchID = 1093
Update SAP.Branch Set SPBranchName ='Twinsburg' Where SAPBranchID = 1094
Update SAP.Branch Set SPBranchName ='Midvale' Where SAPBranchID = 1095
Update SAP.Branch Set SPBranchName ='South Point' Where SAPBranchID = 1096
Update SAP.Branch Set SPBranchName ='Toledo' Where SAPBranchID = 1097
Update SAP.Branch Set SPBranchName ='Fremont' Where SAPBranchID = 1123
Update SAP.Branch Set SPBranchName ='Eureka' Where SAPBranchID = 1126
Update SAP.Branch Set SPBranchName ='Redding' Where SAPBranchID = 1128
Update SAP.Branch Set SPBranchName ='San Leandro' Where SAPBranchID = 1133
Update SAP.Branch Set SPBranchName ='Petaluma' Where SAPBranchID = 1135
Update SAP.Branch Set SPBranchName ='Ukiah' Where SAPBranchID = 1136
Update SAP.Branch Set SPBranchName ='Spokane' Where SAPBranchID = 1139
Update SAP.Branch Set SPBranchName ='Sacramento' Where SAPBranchID = 1164
Update SAP.Branch Set SPBranchName ='Bakersfield' Where SAPBranchID = 1121
Update SAP.Branch Set SPBranchName ='Fresno' Where SAPBranchID = 1124
Update SAP.Branch Set SPBranchName ='Orange' Where SAPBranchID = 1127
Update SAP.Branch Set SPBranchName ='Riverside' Where SAPBranchID = 1129
Update SAP.Branch Set SPBranchName ='San Diego' Where SAPBranchID = 1131
Update SAP.Branch Set SPBranchName ='San Fernando' Where SAPBranchID = 1132
Update SAP.Branch Set SPBranchName ='Santa Maria' Where SAPBranchID = 1134
Update SAP.Branch Set SPBranchName ='Las Vegas' Where SAPBranchID = 1138
Update SAP.Branch Set SPBranchName ='Vernon' Where SAPBranchID = 1142
Update SAP.Branch Set SPBranchName ='Denver' Where SAPBranchID = 1103
Update SAP.Branch Set SPBranchName ='Albuquerque' Where SAPBranchID = 1104
Update SAP.Branch Set SPBranchName ='Lubbock' Where SAPBranchID = 1178
Update SAP.Branch Set SPBranchName ='Amarillo' Where SAPBranchID = 1179
Update SAP.Branch Set SPBranchName ='Austin' Where SAPBranchID = 1108
Update SAP.Branch Set SPBranchName ='Corpus Christi' Where SAPBranchID = 1110
Update SAP.Branch Set SPBranchName ='Harlingen' Where SAPBranchID = 1113
Update SAP.Branch Set SPBranchName ='San Antonio' Where SAPBranchID = 1116
Update SAP.Branch Set SPBranchName ='Victoria' Where SAPBranchID = 1119
Update SAP.Branch Set SPBranchName ='Beaumont' Where SAPBranchID = 1109
Update SAP.Branch Set SPBranchName ='Houston' Where SAPBranchID = 1114
Update SAP.Branch Set SPBranchName ='Spring' Where SAPBranchID = 1118
Update SAP.Branch Set SPBranchName ='McAlester' Where SAPBranchID = 1105
Update SAP.Branch Set SPBranchName ='Oklahoma City' Where SAPBranchID = 1106
Update SAP.Branch Set SPBranchName ='Tulsa' Where SAPBranchID = 1107
Update SAP.Branch Set SPBranchName ='Corsicana' Where SAPBranchID = 1111
Update SAP.Branch Set SPBranchName ='Ft. Worth' Where SAPBranchID = 1112
Update SAP.Branch Set SPBranchName ='Irving' Where SAPBranchID = 1115
Update SAP.Branch Set SPBranchName ='Sherman' Where SAPBranchID = 1117
Update SAP.Branch Set SPBranchName ='Waco' Where SAPBranchID = 1120
Update SAP.Branch Set SPBranchName ='Newburgh' Where SAPBranchID = 1085