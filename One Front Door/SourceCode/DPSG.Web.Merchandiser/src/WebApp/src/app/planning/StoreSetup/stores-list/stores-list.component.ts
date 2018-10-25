import { Component, OnInit,Input,Output,EventEmitter,ViewChild } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {StoreInfo} from '../../../services/planning';
import {FilterPipe} from '../../../pipes/filter.pipe';
import {MerchConstant} from '../../../../app/MerchAppConstant';


@Component({
  moduleId: module.id,
  selector: 'stores-list',
  templateUrl: 'stores-list.component.html',
  styleUrls: ['stores-list.component.css'],  
  directives:[CORE_DIRECTIVES],  
  pipes: [FilterPipe]
})
export class StoresListComponent implements OnInit {
  

  @Input() storeListData: Array<any>=[];  
  @Output() storeListSelected = new EventEmitter();
  @Input() selectedIdx: number= 0;




  constructor() {}

  ngOnInit() {
   

  }

  onStoreSelect(store:any,idx:number)
  {
     
      this.selectedIdx = idx;
      var result : any = { Account:store,ListIndex:this.selectedIdx};
      this.storeListSelected.emit(result);
      
  }

 

}
