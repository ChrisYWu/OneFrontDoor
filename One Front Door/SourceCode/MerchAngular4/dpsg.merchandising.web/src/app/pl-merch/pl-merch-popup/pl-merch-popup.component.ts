import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { PlRouteSelectComponent } from '../pl-route-select';

@Component({
  selector: 'pl-merch-popup',
  templateUrl: 'pl-merch-popup.component.html',
  styleUrls: ['pl-merch-popup.component.css'],
})
export class PlMerchPopupComponent implements OnInit {

public items: any[] = [0,1,2,3,4,5,6];

@Input() plMerchModal: any ;
@Input() AvailableRoutes: any = []; 
@Output() addRoute: EventEmitter<any> = new EventEmitter();  

selectRoute(route: any)
{       
    this.plMerchModal.hide();      
    this.addRoute.emit(route);
}

//Not using, thoise are snipptes may use 
/*
addRouteX(route: any)
{
     let idx: number = -1;
     for (let i = 0; i < this.AvailableRoutes.length; i++)
     { 
     //  debugger ;
       if(route.RouteID == this.AvailableRoutes[i].RouteID)
       {     idx= i;
             break; 
       }
     }

     this.AvailableRoutes.Splice(idx, 1); 

       this.AvailableRoutes.Splice(this.AvailableRoutes.indexOf(route), 1); 



let _availableRoutes = []; 

for (let i = 0; i < this.AvailableRoutes.length; i++)
     { 

       if(route.RouteID != this.AvailableRoutes[i].RouteID)
       {  
         _availableRoutes.push(this.AvailableRoutes[i])
       }
     }

      // debugger ; 
      this.AvailableRoutes = _availableRoutes;

      this.plMerchModal.hide(); 

       //Splice did not work? Why? to find 
       //this.AvailableRoutes.Splice(0, 1); 


}
*/


constructor() {}

  ngOnInit() {
  }

}
