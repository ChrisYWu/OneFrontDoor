import { Component, OnInit, Input } from '@angular/core';

@Component({
  moduleId: module.id,
  selector: 'pl-route-info',
  templateUrl: 'pl-route-info.component.html',
  styleUrls: ['pl-route-info.component.css']
})
export class PlRouteInfoComponent implements OnInit {

    @Input() idx: number;
    @Input() RouteId: number;
    @Input() RouteName: string;
    
  constructor() {}

  ngOnInit() {

    //debugger
  }

}
