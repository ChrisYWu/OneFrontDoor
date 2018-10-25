import { Component, OnInit, Input, Output, EventEmitter} from '@angular/core';
import { PlRouteInfoComponent } from '../pl-route-info';
import { PlRouteItemComponent } from '../pl-route-item';

@Component({
  selector: 'pl-route-row',
  templateUrl: 'pl-route-row.component.html',
  styleUrls: ['pl-route-row.component.css'],
})
export class PlRouteRowComponent implements OnInit {
   
   @Input() idx: any ;
   @Input() RouteToDayMerch: any;
   @Input() MerchToAssigne: any;
   @Input() MerchandiserList: any;

  @Output() deleteMerch: EventEmitter<any> = new EventEmitter();  
  @Output() addMerchandiser: EventEmitter<any> = new EventEmitter(); 

onAddMerchandiser(val: any)
{

   switch (val.dayOfWeek) {
          case 1:
           this.MerchToAssigne.Sunday = val.availableMerchandisers;
            break;  
          case 2:
            this.MerchToAssigne.Monday = val.availableMerchandisers;
            break;
          case 3:
           this.MerchToAssigne.Tuesday = val.availableMerchandisers;
            break;
          case 4:
           this.MerchToAssigne.Wednesday = val.availableMerchandisers;
            break;
          case 5:
           this.MerchToAssigne.Thursday = val.availableMerchandisers;
            break;
          case 6:
           this.MerchToAssigne.Friday = val.availableMerchandisers;
            break;
          case 7:
           this.MerchToAssigne.Saturday = val.availableMerchandisers;
            break;
        
        }

    this.addMerchandiser.emit({'merchandiser': val.merchandiser, 'dayOfWeek': val.dayOfWeek, 'routeToDayMerch': this.RouteToDayMerch});
     

}



onDeleteMerch(val:any)
  {
    //here go update 
     // val.routeID = this.RouteToDayMerch.RouteID;
       this.deleteMerch.emit({ 'merch': val.merch, 'dayOfWeek': val.dayOfWeek, 'routeID': this.RouteToDayMerch.RouteID});
  }

  //public items: any[] = [0,1,2,null,4,5,6];
  public days: string[] = ['Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  

  constructor() {}

  ngOnInit() {

     //debugger;
  }

}
