import {Component, ViewContainerRef} from '@angular/core';
import { MercMainComponent } from  './merc-main/';




@Component({
  moduleId: module.id,
  selector: 'my-app',
  templateUrl: 'my.component.html',
  styleUrls: ['my.component.css'],
  directives: [MercMainComponent]

})
export class MyAppComponent {
    title = 'Merchantiser welcome angular2  app';
    viewContainerRef: ViewContainerRef;
    public constructor(viewContainerRef: ViewContainerRef) {
        // You need this small hack in order to catch application root view container ref
        this.viewContainerRef = viewContainerRef;
    }
    
}
