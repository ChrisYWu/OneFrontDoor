import { Component, OnInit , Input, Output, EventEmitter } from '@angular/core';


@Component({
  selector: 'ip-store-details2',
  templateUrl: 'ip-store-details2.component.html',
  styleUrls: ['ip-store-details2.component.scss']
})
export class IpStoreDetails2Component implements OnInit {

@Input() storeInfo: any;
@Output() closeStoreDetails: EventEmitter<any> = new EventEmitter();  

public isShowStrPics: boolean= true;
public isShowDspPics: boolean= true;

onCloseStoreDetails()
{
      this.closeStoreDetails.emit({'isCloseStoreDetails': true});
}

  constructor() {}

  ngOnInit() {
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





}
