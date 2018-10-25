use Portal_Data
Go

update shared.image
set imageurl = 'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/lipton-W83xH83.png'
where imageid = 221

--update shared.image
--set imageurl = 'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/Trademark_H06.png'
--where imageid = 108

--go

begin tran

--select * from shared.image order by imageid desc
set identity_insert shared.image on

--Select *
--From Shared.Image Order By ImageID Desc


insert into shared.image (imageid,imageurl,description)
values(217,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/arizona-W105xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(218,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/barq-W50xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(220,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/goldpeak-W81xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(221,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/lipton-W83xH83.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(222,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/mrpibb-xtra-W105xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(223,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/Mug-W70xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(224,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/polar-W52xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(225,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/pure-leaf-W138xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(226,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/sun-drop-120x120.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(227,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/sun-drop-W65xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(228,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fresca-W138xH25.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(229,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/cott-W145xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(230,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/private-label-W82xH56.png','BCMyday Branch/Trademark')

set identity_insert shared.image off

update bcmyday.SystemTradeMark set imageid=218, ModifiedDate=getdate() where systemtrademarkid=18
update bcmyday.SystemTradeMark set imageid=222, ModifiedDate=getdate() where systemtrademarkid=20
update bcmyday.SystemTradeMark set imageid=227, ModifiedDate=getdate() where systemtrademarkid=21
update bcmyday.SystemTradeMark set imageid=223, ModifiedDate=getdate() where systemtrademarkid=22
update bcmyday.SystemTradeMark set imageid=224, ModifiedDate=getdate() where systemtrademarkid=23
update bcmyday.SystemTradeMark set imageid=221, ModifiedDate=getdate() where systemtrademarkid=26
update bcmyday.SystemTradeMark set imageid=220, ModifiedDate=getdate() where systemtrademarkid=27
update bcmyday.SystemTradeMark set imageid=225, ModifiedDate=getdate() where systemtrademarkid=28
update bcmyday.SystemTradeMark set imageid=217, ModifiedDate=getdate() where systemtrademarkid=29
update bcmyday.SystemTradeMark set imageid=228, ModifiedDate=getdate() where systemtrademarkid=19
update bcmyday.SystemTradeMark set imageid=229, ModifiedDate=getdate() where systemtrademarkid=24
update bcmyday.SystemTradeMark set imageid=230, ModifiedDate=getdate() where systemtrademarkid=25

update bcmyday.SystemBrand set imageid=226, ModifiedDate=getdate() where SystemBrandID=72

Select *
From bcmyday.SystemBrand

select a.systembrandid, a.ExternalBrandName, b.imageurl from bcmyday.systembrand a
left join shared.image b on a.imageid = b.imageid
order by a.SystemBrandID desc

select a.systemtrademarkid, a.externaltrademarkname, b.imageurl from bcmyday.systemtrademark a
left join shared.image b on a.imageid = b.imageid
order by SystemTradeMarkID desc

--select * from shared.image order by imageid desc
commit tran