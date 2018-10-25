import {
  Component,
  OnInit,
  Input,
  Output,
  EventEmitter
} from '@angular/core';
import {
  CORE_DIRECTIVES
} from '@angular/common';
import {
  MODAL_DIRECTIVES,
  BS_VIEW_PROVIDERS
} from 'ng2-bootstrap/ng2-bootstrap';
import {
  PlRoutePopupComponent
} from '../pl-route-popup'


@Component({
  moduleId: module.id,
  selector: 'pl-route-item',
  templateUrl: 'pl-route-item.component.html',
  styleUrls: ['pl-route-item.component.css'],
  directives: [MODAL_DIRECTIVES, CORE_DIRECTIVES, PlRoutePopupComponent],
  viewProviders: [BS_VIEW_PROVIDERS],
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
     this.DayMerch.isOffDay = merchandiser.isOffDay ;
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
          Email:  this.DayMerch.Email,
          Phone: this.DayMerch.Phone,
          Mon: null,
          Tues: true,
          Wed: null,
          Thu: null,
          Fri: null,
          Sat: null,
          Sun: null
      }

   this.AvailableMerchandisers.splice(0, 0, merch);

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
