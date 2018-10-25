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
import{PlMerchPopupComponent} from '../pl-merch-popup';


@Component({
  moduleId: module.id,
  selector: 'pl-merch-item',
  templateUrl: 'pl-merch-item.component.html',
  styleUrls: ['pl-merch-item.component.css'],
  directives: [MODAL_DIRECTIVES, CORE_DIRECTIVES, PlMerchPopupComponent],
  viewProviders: [BS_VIEW_PROVIDERS],
})
export class PlMerchItemComponent implements OnInit {

  @Input() Day: string;
  @Input() DayRoute: any;
  @Input() AvailableRoutes: any;

@Output() deleteRoute: EventEmitter<any> = new EventEmitter();  
@Output() addRoute: EventEmitter<any> = new EventEmitter();  

//onHidden(MODAL_DIRECTIVES): void
//{
 // debugger;
//}
 
   onAddRoute(route: any)
  { 
    debugger;
    this.DayRoute.RouteID = route.RouteID;
    this.DayRoute.RouteName = route.RouteName;
    this.DayRoute.isRouteAssigned = true; 

       let _availableRoutes = []; 

   for (let i = 0; i < this.AvailableRoutes.length; i++)
     { 

       if(route.RouteID != this.AvailableRoutes[i].RouteID)
       {  
         _availableRoutes.push(this.AvailableRoutes[i])
       }
     }


    this.addRoute.emit({'route': route, 'dayOfWeek': this.DayRoute.DayOfWeek, 'availableRoutes': _availableRoutes});
   
       
  }


  removeRoute(){

    let route = 
     {
      RouteID: this.DayRoute.RouteID,
      MerchGroupID: 101,
      RouteName: this.DayRoute.RouteName
      }

   this.AvailableRoutes.splice(0, 0, route);

    this.DayRoute.RouteName = "";
    this.DayRoute.RouteID = -1;
    this.DayRoute.isRouteAssigned = false; 
   // debugger 
    let dayOfWeek = this.DayRoute.DayOfWeek;


  //  let val = 
   // { 'route': route, 'dayOfWeek': dayOfWeek, 'GSN': '' }
   
     this.deleteRoute.emit({ 'route': route, 'dayOfWeek': dayOfWeek});

   // here to to bubble AvailableRoutes
   // here to call service or at parent on buble?

  }

  constructor() {}

  ngOnInit() {
  }

}
