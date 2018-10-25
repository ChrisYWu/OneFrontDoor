import { Component, OnInit, ChangeDetectionStrategy, Input, Output, EventEmitter } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {TAB_DIRECTIVES} from 'ng2-bootstrap/ng2-bootstrap';
import {StorelistComponent} from '../storelist/';
//import { DispserviceService } from '../../services/dispservice.service';
//import {Accounts} from '../../services/dispatch';
import {Account, Store, Dispatches} from '../../services/dispatch';

//import {AccountInput} from '../../services/dispatch';

@Component({
    moduleId: module.id,
    selector: 'app-tabs',
    directives: [CORE_DIRECTIVES, TAB_DIRECTIVES, StorelistComponent],
    templateUrl: 'tabs.component.html',
    styleUrls: ['tabs.component.css']
})
export class TabsComponent implements OnInit {

    public tabAccts: Array<Account>;


    @Input() unassignedInputAccts: Array<Account>;
    @Input() allInputAccts: Array<Account>;
    @Input() otherInputAccts: Array<Account>;
    @Input() routeDataInput: Dispatches;
    @Input() lastModifiedByInput: string;
    @Output() accountSelected = new EventEmitter();




    public constructor() { }

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
       
    }

}
