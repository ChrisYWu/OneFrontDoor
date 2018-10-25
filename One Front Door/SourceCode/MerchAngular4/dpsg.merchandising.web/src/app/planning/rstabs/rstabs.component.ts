import { Component, OnInit, ChangeDetectionStrategy, Input, Output, EventEmitter } from '@angular/core';
import {RsstorelistComponent} from '../rsstorelist/';
import {Account, Store, Dispatches} from '../RouteStoreAssignment';

@Component({
    selector: 'app-rstabs',
    templateUrl: 'rstabs.component.html',
    styleUrls: ['rstabs.component.css']
})
export class RstabsComponent implements OnInit {

    public tabAccts: Array<Account>;

    @Input() unassignedInputAccts: Array<Account>;
    @Input() allInputAccts: Array<Account>;
    @Input() otherInputAccts: Array<Account>;
    @Input() routeDataInput: Dispatches;
    @Input() lastModifiedByInput: string;
    @Output() accountSelected = new EventEmitter();
    @Input() selectedWeekDayInput: number;
    public active:boolean;

    constructor() { }

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
