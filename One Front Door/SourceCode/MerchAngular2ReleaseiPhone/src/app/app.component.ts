
import { Component, OnInit, ViewContainerRef } from '@angular/core';

// import { HeadernavService } from './services/headernav.service';


@Component({
//  moduleId: module.id,
  selector: 'app',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.css']
})
export class MerchAppComponent implements OnInit {

    title = 'Merchantiser welcome angular2  app';
    viewContainerRef: ViewContainerRef;
    public constructor(viewContainerRef: ViewContainerRef) {
        // You need this small hack in order to catch application root view container ref
        this.viewContainerRef = viewContainerRef;

    }

public isIpMenuOpen: boolean = false; 

public onIpMenuToggle(objOpen: any)
{
   // debugger;
   this.isIpMenuOpen= objOpen.isIpMenuOpen; 
}
  ngOnInit() {
  }

}
