import { Component, OnInit, ChangeDetectionStrategy, Input, Output, EventEmitter } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import {Account, Store, Dispatches, AccountInput} from '../../services/dispatch';

@Component({
  selector: 'app-mobile-tabs',
  templateUrl: './mobile-tabs.component.html',
  styleUrls: ['./mobile-tabs.component.scss']
})
export class MobileTabsComponent implements OnInit {

  
    public tabAccts: Array<Account>;
    

     @Input() unassignedInputAccts: Array<Account>;
     @Input() allInputAccts: Array<Account>;
     @Input() otherInputAccts: Array<Account>;
    
    @Input() routeDataInput: Dispatches;
    @Input() lastModifiedByInput: string;
    @Output() accountSelected = new EventEmitter();




 constructor() {
     
    }

    setselectedAcct($event) {
        this.accountSelected.emit(
            { $event }
        )
    }

 

    public setActiveTab(index: number): void {
        this.tabAccts = this.allInputAccts;
    };

    
   

    ngOnInit() {
         this.tabAccts = this.allInputAccts;

        // this.dispService.set(this._webapi + 'api/Merc/GetStores/');
        // var acctInput = new AccountInput(this.routeDataInput.MerchGroupID, this.routeDataInput.DispatchDate);
        // this.getAccounts(acctInput);
       
    }
}
