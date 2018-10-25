
import { Component, OnInit, Input, Output, EventEmitter, ViewChild } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
//import {TAB_DIRECTIVES, MODAL_DIRECTIVES, BS_VIEW_PROVIDERS} from 'ng2-bootstrap/ng2-bootstrap';
//import {FilterPipe} from '../../pipes/filter.pipe';
import { ModalDirective } from 'ng2-bootstrap/ng2-bootstrap';
import { Merchandiser, Dispatches, ReassignMerchInput, DispatchOutput, RouteListInput } from '../../services/dispatch';

import { MerchConstant } from '../../../app/MerchAppConstant';
import { DispserviceService } from '../../services/dispservice.service';

@Component({
    //moduleId: module.id,
    selector: 'app-merchreassign',
    templateUrl: 'merchreassign.component.html',
    styleUrls: ['merchreassign.component.css'],
    //viewProviders: [BS_VIEW_PROVIDERS],
    providers: [DispserviceService]


})
export class MerchreassignComponent implements OnInit {

    public filterText: string = '';
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public isRequesting: boolean;
    //  @Input() unassignedOtherMerchInput: Array<Merchandiser>;

    //  @Input() unassignedMerchInput: Array<Merchandiser>;

    public unassignedOtherMerch: Array<Merchandiser>;

    public unassignedMerch: Array<Merchandiser>;

    @Input() routeData: Dispatches;
    @Input() lastModifiedByInput: string;

    @ViewChild('lgModal') lgModal: ModalDirective;
    @Output() resequence = new EventEmitter();

    constructor(public dispService: DispserviceService) { }


    private stopRefreshing() {
        this.isRequesting = false;
    }


    getMerchs() {
        let routelistinput: RouteListInput;
        routelistinput = new RouteListInput(this.routeData.DispatchDate, this.routeData.MerchGroupID);
        this.dispService.set(this._webapi + 'api/Merc/GetMerchList/');


        this.isRequesting = true;
        this.dispService.post(JSON.stringify(routelistinput))
            .subscribe(res => {
                var data: any = res;
                this.unassignedMerch = data.UnassignedMerchandiser;
                this.unassignedOtherMerch = data.OtherUnassignedMerchandiser;
                this.lgModal.show();
            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            // error => {

            //     if (error.status == 401 || error.status == 404) {
            //         //this.notificationService.printErrorMessage('Authentication required');
            //         //this.utilityService.navigateToSignIn();
            //     }
            // }
            );
    }

    reassignMerch(gsn: string, lastname: string, firstname: string, AbsoluteURL: string, merchGroupName: string) {

        if (!merchGroupName) {

            let reassignMerchInput: ReassignMerchInput = new ReassignMerchInput(this.routeData.DispatchDate, this.lastModifiedByInput, this.routeData.MerchGroupID, gsn, this.routeData.RouteID);
            let resultInsert: DispatchOutput;
            this.dispService.set(this._webapi + 'api/Merc/ReassignMerch/');

            this.dispService.post(JSON.stringify(reassignMerchInput))
                .subscribe(res => {
                    var data: any = res;
                    resultInsert = data;
                    if (resultInsert.ReturnStatus == 1) {
                        this.routeData.GSN = gsn;
                        this.routeData.FirstName = firstname;
                        this.routeData.LastName = lastname;
                        this.routeData.AbsoluteURL = AbsoluteURL;
                    }
                    this.resequence.emit({ });
                    this.lgModal.hide();
                },
                error => {

                    if (error.status == 401 || error.status == 404) {
                        //this.notificationService.printErrorMessage('Authentication required');
                        //this.utilityService.navigateToSignIn();
                    }
                });
        }
        else {
            alert("Merchandiser is already pre-scheduled for this date " + this.routeData.DispatchDate + ". Please select different Merchandiser.")
        }
    }

    ngOnInit() {
    }

}
