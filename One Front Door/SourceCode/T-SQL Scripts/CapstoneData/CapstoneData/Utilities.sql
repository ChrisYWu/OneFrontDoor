use Portal_DataSRE
Go

--- Get Siva's schema line
--Create Schema BC
--Go

--Select * 
--From OpenQuery(COP, 'SELECT BEV_GRP_ID, TRADEMARK_ID, DEL_FLG, ROW_MOD_DT FROM CAP_DM.DM_BEV_GRP 
--WHERE ROW_MOD_DT >= TO_DATE(''2013-11-19 17:00:28'', ''YYYY-MM-DD HH24:MI:SS'')')
--Go

Alter Function BC.fnConvertToPLSqlTimeFilter
(
	@InputTime DateTime,
	@ObjectAlias Varchar(20) = null
)
Returns Varchar(200)
As
	Begin
		Declare @retval varchar(200)
		Set @retval = 'WHERE '
		If (IsNUll(@ObjectAlias, '') <> '')
			Set @retval += @ObjectAlias + '.'
		Set @retval += 'ROW_MOD_DT > TO_DATE('''''
		Set @retval += convert(varchar, @InputTime, 120)
		Set @retval += ''''', ''''YYYY-MM-DD HH24:MI:SS'''')'

		Return @retval
	End
Go
Select BC.fnConvertToPLSqlTimeFilter(GetDate(), 'D')
Go
Select BC.fnConvertToPLSqlTimeFilter(GetDate(), Default)
Go

Alter Function BC.fnSetOpenQuery
(
	@Query Varchar(1024),
	@LinkedServerName Varchar(20) = 'COP',
	@InputTime DateTime,
	@ObjectAlias Varchar(20) = null
)
Returns Varchar(1024)
As
	Begin
		Declare @retval varchar(1024)
		Set @retval = 'Select * From OpenQuery(' 
		Set @retval += @LinkedServerName +  ', ''';
		Set @retval += @Query;
		Set @retval += ' ' + BC.fnConvertToPLSqlTimeFilter(@InputTime, Default)
		Set @retval += ''')'

		Return @retval
	End
Go
Select BC.fnSetOpenQuery('SELECT BEV_GRP_ID, TRADEMARK_ID, DEL_FLG, ROW_MOD_DT FROM CAP_DM.DM_BEV_GRP', 'COP', '2013-11-19 17:00:28', Default)
Go
