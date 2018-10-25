import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { PlMerchInfoSelectComponent } from '../pl-merch-info-select';

@Component({
  selector: 'pl-route-popup',
  templateUrl: 'pl-route-popup.component.html',
  styleUrls: ['pl-route-popup.component.css'],
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
