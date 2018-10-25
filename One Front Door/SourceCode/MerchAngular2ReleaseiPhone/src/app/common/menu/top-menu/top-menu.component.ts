import { Component, OnInit } from '@angular/core';
import { ROUTER_DIRECTIVES } from '@angular/router';
@Component({
  //moduleId: module.id,
  selector: 'top-menu',
  templateUrl: 'top-menu.component.html',
  styleUrls: ['top-menu.component.css'],
  directives:[ROUTER_DIRECTIVES]
})
export class TopMenuComponent implements OnInit {

  constructor() {}

  ngOnInit() {
  }

}
