import { Component, OnInit, Input, Output, EventEmitter, ViewChild, ElementRef } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS, ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import {RstabsComponent} from '../rstabs/';
import { DispserviceService } from '../../services/dispservice.service';
import {Account, DispatchOutput, Store, Dispatches} from '../RouteStoreAssignment';
import {MerchConstant} from '../../../app/MerchAppConstant';

@Component({
    moduleId: module.id,
    selector: 'app-rsaddstore',
    templateUrl: 'rsaddstore.component.html',
    styleUrls: ['rsaddstore.component.css'],
    directives: [MODAL_DIRECTIVES, CORE_DIRECTIVES, RstabsComponent],
    viewProviders: [BS_VIEW_PROVIDERS],
    providers: [DispserviceService]
})
export class RsaddstoreComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;

    @ViewChild('lgModal') lgModal: ModalDirective;
    public resultInsert: DispatchOutput;
    @Input() unassignedInputAccts: Array<Account>;
    @Input() allInputAccts: Array<Account>;
    // @Input() otherInputAccts: Array<Account>;
    @Input() lastModifiedByInput: string;
    @Input() routeDataInput: Dispatches;
    @Input() selectedWeekDayInput: number;

    @Output() accountSelected = new EventEmitter();

    public emptyStore: Store = new Store(null, null, null, null);

    closedialog() {
        this.lgModal.hide();
    }

    constructor() { }

    setselectedAcct($event) {
        if ($event.$event.close == 'true') {
            this.closedialog();
        }

        this.accountSelected.emit(
            { $event }
        )
    }

    ngOnInit() {
    }
}
