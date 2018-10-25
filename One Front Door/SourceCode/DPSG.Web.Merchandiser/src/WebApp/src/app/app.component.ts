
import { Component, OnInit, ViewContainerRef } from '@angular/core';
import { ROUTER_DIRECTIVES }  from '@angular/router';
import {HeaderComponent} from './common/header';
import {FooterComponent} from './common/footer';
// import { HeadernavService } from './services/headernav.service';


@Component({
  moduleId: module.id,
  selector: 'app',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.css'],
  directives: [ROUTER_DIRECTIVES, HeaderComponent, FooterComponent]
})
export class MerchAppComponent implements OnInit {

    title = 'Merchantiser welcome angular2  app';
    viewContainerRef: ViewContainerRef;
    public constructor(viewContainerRef: ViewContainerRef) {
        // You need this small hack in order to catch application root view container ref
        this.viewContainerRef = viewContainerRef;

    }

  ngOnInit() {
  }

}
