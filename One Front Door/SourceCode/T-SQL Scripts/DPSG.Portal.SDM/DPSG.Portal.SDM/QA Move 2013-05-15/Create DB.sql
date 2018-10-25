USE [master]
GO

/****** Object:  Database [Portal_Data]    Script Date: 5/15/2013 11:00:34 AM ******/
If Not Exists (Select *
		From sys.databases
		Where name = 'Portal_Data'
		)
Begin
CREATE DATABASE [Portal_Data]
End
GO

USE [Portal_Data]
GO

Create Schema CDE
Go

Create Schema SAP
Go

Create Schema EDGE
Go

Create Schema MSTR
Go

Create Schema Playbook
Go

Create Schema SalesPriority
Go

Create Schema Staging
Go

Create Schema Person
Go

Create Schema ETL
Go

Create Schema MView
Go
