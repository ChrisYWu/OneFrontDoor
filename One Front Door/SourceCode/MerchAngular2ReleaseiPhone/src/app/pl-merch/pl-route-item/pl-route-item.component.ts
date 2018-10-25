import {
  Component,
  OnInit,
  Input,
  Output,
  EventEmitter
} from '@angular/core';
import {
  PlRoutePopupComponent
} from '../pl-route-popup'


@Component({
  selector: 'pl-route-item',
  templateUrl: 'pl-route-item.component.html',
  styleUrls: ['pl-route-item.component.css'],
})
export class PlRouteItemComponent implements OnInit {
  @Input() Day: string;
  @Input() DayMerch: any;
  @Input() AvailableMerchandisers: any[];

  @Output() deleteMerch: EventEmitter<any> = new EventEmitter();  
  @Output() addMerchandiser: EventEmitter<any> = new EventEmitter();  

   onAddMerchandiser(merchandiser: any)
  { 

     let _availableMerchandisers = [];

     this.DayMerch.GSN = merchandiser.GSN ;
     this.DayMerch.LastName = merchandiser.LastName ;
     this.DayMerch.FirstName = merchandiser.FirstName ;
     this.DayMerch.Email = merchandiser.Email ;
     this.DayMerch.Phone = merchandiser.Phone ;
     this.DayMerch.AbsoluteURL = merchandiser.AbsoluteURL;

     //this.DayMerch.isOffDay = merchandiser.isOffDay ;
     this.DayMerch.isMerchAssigned  = true;
     

       for (let i = 0; i < this.AvailableMerchandisers.length; i++)
     { 

       if(merchandiser.GSN != this.AvailableMerchandisers[i].GSN)
       {  
         _availableMerchandisers.push(this.AvailableMerchandisers[i])
       }
     }

      this.addMerchandiser.emit({'merchandiser': merchandiser, 'dayOfWeek': this.DayMerch.DayOfWeek, 'availableMerchandisers': _availableMerchandisers});
 
       
  }

  removeMerch(){

    let merch = 
     {
          GSN: this.DayMerch.GSN,
          MerchGroupID: this.DayMerch.MerchGroupID,
          LastName: this.DayMerch.LastName ,
          FirstName: this.DayMerch.FirstName,
          AbsoluteURL: this.DayMerch.AbsoluteURL,
          Email:  this.DayMerch.Email,
          Phone: this.DayMerch.Phone,
          Mon: null,
          Tues: null,
          Wed: null,
          Thu: null,
          Fri: null,
          Sat: null,
          Sun: null
      }

var foundUserIndex = -1; 
 for(var i=0; i< this.AvailableMerchandisers.length; i++)
 {
    if(this.AvailableMerchandisers[i].GSN == merch.GSN)
      {
         foundUserIndex = i;
         break;
      }
 }

 if(foundUserIndex < 0)
 {
    this.AvailableMerchandisers.splice(0, 0, merch);
 }

    this.DayMerch.GSN = "";
    this.DayMerch.MerchGroupID = -1;
    this.DayMerch.LastName = "";
    this.DayMerch.FirstName = "";
    this.DayMerch.Email = "";
    this.DayMerch.Phone = "";
    this.DayMerch.isMerchAssigned = false; 
  //  debugger 
    let dayOfWeek = this.DayMerch.DayOfWeek;
    
   // let val = 
   ///   { 'merch': merch, 'dayOfWeek': dayOfWeek, 'routeID': 0 }
   
        this.deleteMerch.emit({ 'merch': merch, 'dayOfWeek': dayOfWeek});

   // here to to bubble AvailableRoutes
   // here to call service or at parent on buble?

  }


  constructor() {}

  ngOnInit() {

   // debugger;
  }

}
