use Portal_Data
Go

begin tran

--select * from shared.image order by imageid desc
set identity_insert shared.image on

insert into shared.image (imageid,imageurl,description)
values(201,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/crush-cherry.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(202,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/crush-grapefruit.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(203,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/crush-peach.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(204,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/crush-pineapple.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(205,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-cherry.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(206,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-diet-zero.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(207,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-grape.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(208,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-grapefrt.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(209,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-mango.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(210,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-orange.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(211,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-pineapple.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(212,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-strawberry.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(213,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/schweppes-orig-seltz-120.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(214,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/schweppes-raspberry.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(215,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/seagram-reg.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(216,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/seagrams.png','BCMyday Branch/Trademark')


set identity_insert shared.image off


update bcmyday.SystemTradeMark set imageid=215, ModifiedDate=getdate() where systemtrademarkid=17

update bcmyday.SystemBrand set imageid=203, ModifiedDate=getdate() where SystemBrandID=50
update bcmyday.SystemBrand set imageid=202, ModifiedDate=getdate() where SystemBrandID=51
update bcmyday.SystemBrand set imageid=204, ModifiedDate=getdate() where SystemBrandID=52
update bcmyday.SystemBrand set imageid=201, ModifiedDate=getdate() where SystemBrandID=53
update bcmyday.SystemBrand set imageid=214, ModifiedDate=getdate() where SystemBrandID=54
update bcmyday.SystemBrand set imageid=213, ModifiedDate=getdate() where SystemBrandID=55
update bcmyday.SystemBrand set imageid=210, ModifiedDate=getdate() where SystemBrandID=56
update bcmyday.SystemBrand set imageid=206, ModifiedDate=getdate() where SystemBrandID=57
update bcmyday.SystemBrand set imageid=212, ModifiedDate=getdate() where SystemBrandID=58
update bcmyday.SystemBrand set imageid=207, ModifiedDate=getdate() where SystemBrandID=59
update bcmyday.SystemBrand set imageid=209, ModifiedDate=getdate() where SystemBrandID=60
update bcmyday.SystemBrand set imageid=208, ModifiedDate=getdate() where SystemBrandID=61
update bcmyday.SystemBrand set imageid=211, ModifiedDate=getdate() where SystemBrandID=62
update bcmyday.SystemBrand set imageid=205, ModifiedDate=getdate() where SystemBrandID=63
update bcmyday.SystemBrand set imageid=216, ModifiedDate=getdate() where SystemBrandID=64

select a.systembrandid,b.imageurl from bcmyday.systembrand a
left join shared.image b on a.imageid = b.imageid
where a.SystemBrandID between 50 and 64 

select * from bcmyday.systemtrademark a
left join shared.image b on a.imageid = b.imageid

--select * from shared.image order by imageid desc
commit tran

select dev.imageID, dev.imageURL, qa.imageURL, dev.Description, qa.description
from bsccap121.portal_data.shared.image qa
join shared.image dev on qa.imageid = dev.imageid
where dev.imageurl <> qa.imageurl

select count(*)
from shared.image


