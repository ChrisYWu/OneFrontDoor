Use Portal_DataSRE
Go

-- Check available space for database files
SELECT name ,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
FROM sys.database_files;

-- Displaying log space information for all databases
DBCC SQLPERF(LOGSPACE);
GO

-- Shrink DB file
ALTER DATABASE Portal_DATASRE SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKFILE(Portal_Data_Log, 1)
--DBCC SHRINKFILE(Portal_Data, 1)
GO

sp_who2 'active'

-----------------
Use Portal_Data_SREINT
Go

SELECT name ,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
FROM sys.database_files;

-- Displaying log space information for all databases
DBCC SQLPERF(LOGSPACE);
GO

-- Shrink DB file
ALTER DATABASE Portal_DATASRE SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKFILE(Portal_Data_Log, 1)
--DBCC SHRINKFILE(Portal_Data, 1)
GO
