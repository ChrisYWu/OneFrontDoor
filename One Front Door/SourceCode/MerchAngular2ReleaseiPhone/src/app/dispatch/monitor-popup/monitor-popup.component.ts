import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
//import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS} from 'ng2-bootstrap/ng2-bootstrap';


@Component({
 // moduleId: module.id,
  selector: 'monitor-popup',
  templateUrl: 'monitor-popup.component.html',
  styleUrls: ['monitor-popup.component.css']

  //viewProviders: [BS_VIEW_PROVIDERS],
})


export class MonitorPopupComponent implements OnInit {

@Input() storeModal: any ;
@Input() stop: any ;
@Input() storeDetails: any; 
@Input() storePictures: any = [] ;
@Input() displayPictures: any = [] ;
@Input() storeSignature: {} ;

@Output() showDPImage = new EventEmitter();

public isImageView : boolean = false;
public imageURL : string ='';


 showDPImageView($event) {
       this.isImageView = true;
       this.imageURL = $event.ImageURL;
    }


  constructor() {}

  ngOnInit() {
  }



}
