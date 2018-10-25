-- Executed on 5/18/2013 Afternoon

Use Portal_Data
Go

Begin Tran blah

Alter Table EDGE.WebServiceLog 
Alter Column Detail Varchar(max)

Commit Tran blah