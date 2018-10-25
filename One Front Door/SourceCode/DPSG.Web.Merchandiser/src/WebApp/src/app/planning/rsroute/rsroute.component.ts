import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {DND_PROVIDERS, DND_DIRECTIVES } from 'ng2-dnd/ng2-dnd';
import { DispserviceService } from '../../services/dispservice.service';
import {Account, DispatchOutput, Store, Dispatches, ResequenceInput, RemoveStoreinput, Route} from '../RouteStoreAssignment';
import {RsaddstoreComponent} from '../rsaddstore/';
import {RsstorereassignComponent} from '../rsstorereassign/';
import {MerchConstant} from '../../../app/MerchAppConstant';

@Component({
    moduleId: module.id,
    selector: 'app-rsroute',
    templateUrl: 'rsroute.component.html',
    styleUrls: ['rsroute.component.css'],
    directives: [CORE_DIRECTIVES, RsaddstoreComponent, DND_DIRECTIVES, RsstorereassignComponent],
    providers: [DispserviceService, DND_PROVIDERS]
})
export class RsrouteComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;

    @Input() selectedacct: Store;
    @Input() routeName: String;
    public resultInsert: DispatchOutput;
    @Input() unassignedInputAccts: Array<Account>;
    @Input() allInputAccts: Array<Account>;
    @Input() otherInputAccts: Array<Account>;
    @Input() dispatchDateInput: Date;
    @Input() lastModifiedByInput: string;
    @Input() routeData: Dispatches;
    @Input() routeIdInput: number;
    @Input() routesInput: Array<Route>;
    @Input() selectedWeekDayInput: number;

    @Output() routeReassigned = new EventEmitter();
    @Output() accountSelected = new EventEmitter();

    constructor(public dispService: DispserviceService) { }

    setselectedAcct($event) {

        this.accountSelected.emit(
            { $event }
        )
    }

   setupdatedroute($event) {
        this.routeReassigned.emit(
            { value: $event }
        )
    }

    dropStore(moveFrom) {
        let moveTo: number;

        for (var i = 0; i < this.routeData.Stores.length; i++) {
            if (moveFrom == this.routeData.Stores[i].Sequence) {
                moveTo = i + 1;
            }
        }

        for (var i = 0; i < this.routeData.Stores.length; i++) {
            if (i + 1 != this.routeData.Stores[i].Sequence) {
                this.routeData.Stores[i].Sequence = i + 1;
            }
        }

        this.dispService.set(this._webapi + 'api/Merc/UpdateStoreSequence/');
        let resequenceInput: ResequenceInput;
        resequenceInput = new ResequenceInput(this.selectedWeekDayInput, this.routeData.RouteID, moveFrom, moveTo, this.lastModifiedByInput);
        this.updateSequence(resequenceInput);

    }

    pullInfoUpdate() {

        let tempStores: Array<Store> = this.routeData.Stores.slice();

        for (var j = 0; j < tempStores.length; j++) {
            let pullcount = 0;
            for (var k = 0; k < this.routeData.Stores.length; k++) {
                if (tempStores[j].AccountID == this.routeData.Stores[k].AccountID) {
                    pullcount++;
                    if (pullcount == 1) {
                        this.routeData.Stores[k].PullNumber = "";
                    }
                    else if (pullcount == 2) {
                        this.routeData.Stores[k].PullNumber = pullcount + "nd Pull";
                    }
                    else if (pullcount == 3) {
                        this.routeData.Stores[k].PullNumber = pullcount + "rd Pull";
                    }
                    else {
                        this.routeData.Stores[k].PullNumber = pullcount + "th Pull";
                    }

                }
            }
        }

    }

    removeStore(sequence) {
        this.dispService.set(this._webapi + 'api/Merc/RemoveStoreByWeekDay/');
        let removeStoreInput: RemoveStoreinput;
        removeStoreInput = new RemoveStoreinput(this.selectedWeekDayInput, this.routeData.RouteID, sequence, this.lastModifiedByInput);
        this.dispService.post(JSON.stringify(removeStoreInput))
            .subscribe(res => {
                var data: any = res;
                this.resultInsert = data;
                this.routeData.Stores.splice(sequence - 1, 1);
                for (var i = sequence - 1; i < this.routeData.Stores.length; i++) {
                    this.routeData.Stores[i].Sequence = this.routeData.Stores[i].Sequence - 1;
                }
                this.pullInfoUpdate();
                this.accountSelected.emit({});

            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });
    }

    updateSequence(resequenceInput: ResequenceInput) {
        this.dispService.post(JSON.stringify(resequenceInput))
            .subscribe(res => {
                var data: any = res;
                this.resultInsert = data;

                if (this.resultInsert.ReturnStatus == 1) {
                    this.pullInfoUpdate();
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
