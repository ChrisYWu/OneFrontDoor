import { Component, OnInit, Input,  Output,
  EventEmitter } from '@angular/core';


@Component({
  selector: 'ip-main',
  templateUrl: 'ip-main.component.html',
  styleUrls: ['ip-main.component.css']
  
})
export class IpMainComponent implements OnInit {

public isShowItems: Boolean = false;


 @Output() ipStoreDetails: EventEmitter<any> = new EventEmitter(); 
 @Input() dispatch: any;

  constructor() {}

onToggleClick(val: any)
{
  //debugger;
  this.isShowItems=!this.isShowItems
}


onIpStoreDetails(objStoreDetails: any)
{  
    //debugger;
    this.ipStoreDetails.emit(
                               {
                                 'storeDetails': objStoreDetails.storeDetails, 
                             //    'storePictures': objStoreDetails.storePictures,
                              //   'displayPictures': objStoreDetails.displayPictures,
                                     'allPictures': objStoreDetails.allPictures,
                                 'storeSignature': objStoreDetails.storeSignature,
                                 'stop' : objStoreDetails.stop
                               });

}

  ngOnInit() {
  }

}
