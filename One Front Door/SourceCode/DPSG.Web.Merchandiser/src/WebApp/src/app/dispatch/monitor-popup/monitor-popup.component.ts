import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS} from 'ng2-bootstrap/ng2-bootstrap';
import {ImageListComponent} from '../image-list';

@Component({
  moduleId: module.id,
  selector: 'monitor-popup',
  templateUrl: 'monitor-popup.component.html',
  styleUrls: ['monitor-popup.component.css'],
  directives: [MODAL_DIRECTIVES, CORE_DIRECTIVES, ImageListComponent],
  viewProviders: [BS_VIEW_PROVIDERS],
})


export class MonitorPopupComponent implements OnInit {

//public isShowSign: boolean = false;


//SignClick()
//{
//  debugger
//  this.isShowSign = !this.isShowSign ;
//}

@Input() storeModal: any ;
@Input() stop: any ;
@Input() storeDetails: any; 
@Input() storePictures: any = [] ;
@Input() displayPictures: any = [] ;
@Input() storeSignature: {} ;



  constructor() {}

  ngOnInit() {
  }



}
