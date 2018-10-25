import { Component, OnInit, Input } from '@angular/core';


@Component({
  //moduleId: module.id,
  selector: 'dispatch-row',
  templateUrl: 'dispatch-row.component.html',
  styleUrls: ['dispatch-row.component.css']
})
export class DispatchRowComponent implements OnInit {

 @Input() dispatch: any;

  constructor() {}

  ngOnInit() {
  }

}
