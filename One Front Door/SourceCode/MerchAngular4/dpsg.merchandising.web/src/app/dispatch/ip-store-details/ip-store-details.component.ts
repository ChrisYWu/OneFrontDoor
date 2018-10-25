import { Component, OnInit , Input, Output, EventEmitter } from '@angular/core';


@Component({
  selector: 'ip-store-details',
  templateUrl: 'ip-store-details.component.html',
  styleUrls: ['ip-store-details.component.css']
})
export class IpStoreDetailsComponent implements OnInit {

@Input() storeInfo: any;
//@Input()   storeDetails: any ;
//@Input()   storePictures: any ;
//@Input()   displayPictures: any ;
//@Input()   storeSignature: any ;
//@Input()   stop: any ;

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

public strPics: any[]
=[
    {
      'ImageURL' : '/assets/img/store1.PNG',
      'Name' : 'Beverage Shelf Picture try for longer text',

    },
       {
      'ImageURL' : '/assets/img/store2.PNG',
      'Name' : 'Backroom Picture',

    } ,
     {
      'ImageURL' : '/assets/img/store3.PNG',
      'Name' : '2016 Dr Pepper Event',

    },
    
]


public dspPics: any[]
=[
    {
      'ImageURL' : '/assets/img/store3.PNG',
      'Name' : '2016 Dr Pepper Event',

    },
       {
      'ImageURL' : '/assets/img/nostoreimage.PNG',
      'Name' : '2016 Dr. Pepper Celebration No Time',

    },
     {
      'ImageURL' : '/assets/img/nostoreimage.PNG',
       'Name' : '2016 Canada Dry Celebration No Time',

    },
    
]




}
