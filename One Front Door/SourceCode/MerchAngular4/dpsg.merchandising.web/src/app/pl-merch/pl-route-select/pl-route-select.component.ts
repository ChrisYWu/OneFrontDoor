import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'pl-route-select',
  templateUrl: 'pl-route-select.component.html',
  styleUrls: ['pl-route-select.component.css']
})
export class PlRouteSelectComponent implements OnInit {

@Input() idx: number;
@Input() Route: any; 

  constructor() {}

  ngOnInit() {
  }

}
