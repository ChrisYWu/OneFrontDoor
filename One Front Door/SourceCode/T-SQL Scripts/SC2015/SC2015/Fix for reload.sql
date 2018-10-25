use Portal_Data
Go

Select ConfigValue
From Settings.Configuration
Where ConfigKey = 'ForceSCDataReload'

Insert Into Settings.Configuration
           (ConfigKey
           ,ConfigValue
           ,Notes
           ,CreateBy
           ,LastModifiedBy
           ,LastModified)
     VALUES
           ('ForceSCDataReload'
           ,'0'
           ,'Boolean control to force data merging sps to load'
           ,'System'
           ,'System'
           ,GetDate())
GO


