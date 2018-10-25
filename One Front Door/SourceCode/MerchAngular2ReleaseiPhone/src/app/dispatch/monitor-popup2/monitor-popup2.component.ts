import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'monitor-popup2',
  templateUrl: './monitor-popup2.component.html',
  styleUrls: ['./monitor-popup2.component.scss']
})
export class MonitorPopup2Component implements OnInit {

@Input() storeModal: any ;
@Input() stop: any ;
@Input() allPictures: any = [] ;
@Input() storeDetails: {} ;
@Input() displayPictures: any = [] ;
@Input() storeSignature: {} ;

public isImageView : boolean = false;
public imageURL : string ='';
public selectedImg: any ={ "ImageURL": "", "Name1": "", "Name2": "", "Name3": "", "istoolTip": false, "RefusalReason": null, "isSlaePicture": false };

 showDPImageView($event) {
       this.isImageView = true;
       this.imageURL = $event.ImageURL;
    }

 getDeliveryTime(deliveryTime:string)
 {
   let _return: string ="No delivery";
   if ( (deliveryTime != null) && (deliveryTime != undefined) && deliveryTime.trim() != 'CST' && deliveryTime.trim() != '')   {
     _return = deliveryTime;
   }
   return _return;
 }


  getDriverName(driverName:string)
 {
   let _return: string ="";
   if ((driverName != null) && (driverName != undefined) && driverName.trim().length > 0)
   {
     _return = "(" + driverName + ")" ;
   }
   return _return;
 }


  getTimeInstore(timeInStore:string)
 {
   let _return: string ="";
   if ((timeInStore != null) && (timeInStore != undefined) &&timeInStore.trim().length > 0)
   {
     _return = "(" + timeInStore + ")" ;
   }
   return _return;
 }

  getImageName(name)
  {
    return name.substring(0,21);
  }

 imgSelected(img:any)
 {    //debugger;
      this.selectedImg = img; 
      this.isImageView = true; 
 }


  constructor() { }

  ngOnInit() {
  }

}
