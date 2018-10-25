import { Component, OnInit, Input,   Output, EventEmitter} from '@angular/core';
import { PlMerchInfoComponent } from '../pl-merch-info';
import { PlMerchItemComponent } from '../pl-merch-item';

@Component({
  moduleId: module.id,
  selector: 'pl-merch-row',
  templateUrl: 'pl-merch-row.component.html',
  styleUrls: ['pl-merch-row.component.css'],
   directives: [PlMerchInfoComponent, PlMerchItemComponent]
})
export class PlMerchRowComponent implements OnInit {
   
   @Input() idx: any ;
   @Input() MerchToDayRoute: any ;
   @Input() RouteToAssigne: any; 
   @Input() RouteList: any;

  @Output() deleteRoute: EventEmitter<any> = new EventEmitter();  
  @Output() addRoute: EventEmitter<any> = new EventEmitter(); 

  onDeleteRoute(val:any)
  {
    //here go update 
   // val.GSN = this.MerchToDayRoute.GSN;
       this.deleteRoute.emit({ 'route': val.route, 'dayOfWeek': val.dayOfWeek, 'GSN': this.MerchToDayRoute.GSN });
  }

  onAddRoute(val: any)
  {
  
  debugger; 
 switch (val.dayOfWeek) {
          case 1:
           this.RouteToAssigne.Sunday = val.availableRoutes;
            break;
          case 2:
            this.RouteToAssigne.Monday = val.availableRoutes;
            break;
          case 3:
           this.RouteToAssigne.Tuesday = val.availableRoutes;
            break;
          case 4:
           this.RouteToAssigne.Wednesday = val.availableRoutes;
            break;
          case 5:
           this.RouteToAssigne.Thursday = val.availableRoutes;
            break;
          case 6:
           this.RouteToAssigne.Friday = val.availableRoutes;
            break;
          case 7:
           this.RouteToAssigne.Saturday = val.availableRoutes;
            break;

        }


  //  this.addRoute.emit(val)
   // debugger
      this.addRoute.emit({'route': val.route, 'dayOfWeek': val.dayOfWeek, 'merchToDayRoute': this.MerchToDayRoute});
  }

 // public items: any[] = [0,1,2,null,4,5,6];
  public days: string[] = ['Monday','Tuseday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  
  constructor() {}

  ngOnInit() {
    //debugger;
//Get data AssignedDays and convert in to to assign here 

  }

}
