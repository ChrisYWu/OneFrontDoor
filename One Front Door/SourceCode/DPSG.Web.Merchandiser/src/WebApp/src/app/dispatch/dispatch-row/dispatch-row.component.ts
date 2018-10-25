import { Component, OnInit, Input } from '@angular/core';
import { RouteInfoComponent } from '../route-info';
import { RouteItemComponent } from '../route-item';

@Component({
  moduleId: module.id,
  selector: 'dispatch-row',
  templateUrl: 'dispatch-row.component.html',
  styleUrls: ['dispatch-row.component.css'],
  directives: [RouteItemComponent, RouteInfoComponent]
})
export class DispatchRowComponent implements OnInit {

 @Input() dispatch: any;

  constructor() {}

  ngOnInit() {
  }

}
