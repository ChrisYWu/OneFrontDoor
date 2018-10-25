import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS, ModalDirective, DROPDOWN_DIRECTIVES} from 'ng2-bootstrap/ng2-bootstrap';
import {DispserviceService } from '../../services/dispservice.service';
import {Dispatches, Store, Route, ReassignStoreInput, DispatchOutput} from '../RouteStoreAssignment';
import {MerchConstant} from '../../../app/MerchAppConstant';


@Component({
    moduleId: module.id,
    selector: 'app-rsstorereassign',
    templateUrl: 'rsstorereassign.component.html',
    styleUrls: ['rsstorereassign.component.css'],
    directives: [MODAL_DIRECTIVES, DROPDOWN_DIRECTIVES, CORE_DIRECTIVES],
    viewProviders: [BS_VIEW_PROVIDERS],
    providers: [DispserviceService]
})
export class RsstorereassignComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public routeId: number;
    public routeName: string;
    public gsn: string;
    public reassignStore: ReassignStoreInput;
    public resultInsert: DispatchOutput;


    @Input() lastModifiedByInput: string;
    @Input() storeInput: Store;
    @Input() routeData: Dispatches;
    @Input() routesInput: Array<Route>;
    @Input() routeNameInput: string;
    @Input() selectedWeekDayInput: number;
    @Output() routeReassigned = new EventEmitter();
    @Output() merchReassigned = new EventEmitter();

    constructor(public dispService: DispserviceService) { }

    selectedRoute(routeid: number, routename: string, gsn: string) {
        this.routeId = routeid;
        this.routeName = routename;
        this.gsn = gsn;
    }

    adjustSequence() {
        for (let i = 0; i < this.routeData.Stores.length; i++) {
            this.routeData.Stores[i].Sequence = i + 1;
        }
    }

    setupdatedroute($event) {

        this.reassignStore = new ReassignStoreInput(this.selectedWeekDayInput,
            this.storeInput.Sequence,
            this.lastModifiedByInput,
            this.routeData.MerchGroupID,
            this.routeId,
            this.routeData.RouteID,
            this.storeInput.AccountID);

        this.dispService.set(this._webapi + 'api/Merc/ReassignStorebyWeekDay/');

        this.dispService.post(JSON.stringify(this.reassignStore))
            .subscribe(res => {
                var data: any = res;
                this.resultInsert = data;
                if (this.resultInsert.ReturnStatus == 1) {
                    this.routeData.Stores.splice(this.storeInput.Sequence - 1, 1);
                    this.adjustSequence();
                    this.storeInput.PullNumber = '';
                    this.routeReassigned.emit(
                        { routeid: this.routeId, store: this.storeInput }
                    )

                }

            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });
    }

    ngOnInit() {
    }

}
