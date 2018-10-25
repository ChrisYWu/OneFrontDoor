
use portal_data

begin Tran

alter table playbook.retailpromotion alter column promotiondescription  varchar(250) null

