import { Component, OnInit, Input, Output, EventEmitter, ViewChild } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import { StoreInfo, MerchGroup, StoreRemovalDispatchWarning } from '../../../services/planning';
import { FilterPipe } from '../../../pipes/filter.pipe';
import { MerchConstant } from '../../../../app/MerchAppConstant';
import { DispserviceService } from '../../../services/dispservice.service';
import { StoreDeleteInput } from '../../../services/planning';
import { ModalDirective } from 'ng2-bootstrap/ng2-bootstrap';

@Component({
    // moduleId: module.id,
    selector: 'stores-list',
    templateUrl: 'stores-list.component.html',
    styleUrls: ['stores-list.component.css'],
    // directives:[CORE_DIRECTIVES],  
    //  pipes: [FilterPipe]
})
export class StoresListComponent implements OnInit {


    @Input() storeListData: Array<any> = [];
    @Output() storeListSelected = new EventEmitter();
    @Input() selectedIdx: number = 0;
    @Output() refreshDeleteList = new EventEmitter();
    @Input() MerchGroupItem: MerchGroup;
    @ViewChild('storeDeleteModal') storeDeleteModal: ModalDirective;

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public storeDelInput: StoreDeleteInput;
    public StoreRemovalWarnings: Array<StoreRemovalDispatchWarning>;
    public StoreName: string;
    public MerchGroupName: string;
    private sapAccountNumberTobeDeleted: number;

    constructor(public dispService: DispserviceService) { }

    ngOnInit() { }

    onStoreSelect(store: any, idx: number) {
        this.selectedIdx = idx;
        var result: any = { Account: store, ListIndex: this.selectedIdx };
        this.storeListSelected.emit(result);
    }

    tryDeleteStore(sapAccountNumber: number, accountName: string) {
        this.dispService.set(this._webapi + 'api/Merc/GetDeleteStoreWarning/');

        this.storeDelInput = new StoreDeleteInput(sapAccountNumber, this.MerchGroupItem.MerchGroupID, this.MerchGroupItem.LoggedInUser);
        this.dispService.post(JSON.stringify(this.storeDelInput), true)
            .subscribe(res => {
                var d: any = res;
                this.StoreRemovalWarnings = d.DispatchChanges;
                if (this.StoreRemovalWarnings.length > 0)
                {
                    this.MerchGroupName = this.MerchGroupItem.GroupName;
                    this.StoreName = accountName;
                    this.sapAccountNumberTobeDeleted = sapAccountNumber;
                    this.storeDeleteModal.show();
                }
                else {
                    this.deleteStore(sapAccountNumber);
                }
                //this.refreshDeleteList.emit();
            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });
    }
    
    onDelete()
    {
        this.deleteStore(this.sapAccountNumberTobeDeleted);        
    }

    deleteStore(sapAccountNumber: number) {
        var r = confirm("Are you sure to delete this store?");
        if (r == true) {
            this.dispService.set(this._webapi + 'api/Merc/DeleteStore/');

            this.storeDelInput = new StoreDeleteInput(sapAccountNumber, this.MerchGroupItem.MerchGroupID, this.MerchGroupItem.LoggedInUser);
            this.dispService.post(JSON.stringify(this.storeDelInput), true)
                .subscribe(res => {
                    var d: any = res;
                    this.refreshDeleteList.emit();
                },
                error => {
                    if (error.status == 401 || error.status == 404) {
                    }
                });
        }
        //alert(sapAccountNumber);
    }
}
