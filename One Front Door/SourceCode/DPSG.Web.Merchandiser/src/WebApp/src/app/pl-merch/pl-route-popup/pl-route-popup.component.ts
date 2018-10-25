import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS} from 'ng2-bootstrap/ng2-bootstrap';
import { PlMerchInfoSelectComponent } from '../pl-merch-info-select';

@Component({
  moduleId: module.id,
  selector: 'pl-route-popup',
  templateUrl: 'pl-route-popup.component.html',
  styleUrls: ['pl-route-popup.component.css'],
  directives: [MODAL_DIRECTIVES, CORE_DIRECTIVES, PlMerchInfoSelectComponent],
  viewProviders: [BS_VIEW_PROVIDERS],  
})


export class PlRoutePopupComponent implements OnInit {


@Input() plRouteModal: any ;
@Input() AvailableMerchandisers: any[];
@Output() addMerchandiser: EventEmitter<any> = new EventEmitter();  



selectMerchandiser(merchandiser: any)
{       
     
     this.plRouteModal.hide(); 
      
      this.addMerchandiser.emit(merchandiser);
}
  constructor() {}

  ngOnInit() {
//debugger;

  }

}
