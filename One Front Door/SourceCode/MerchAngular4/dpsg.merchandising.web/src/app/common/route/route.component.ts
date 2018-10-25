import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';

import {Account, StorePreDispatch, DispatchOutput, Store, Dispatches, ResequenceInput, RemoveStoreinput, Route,Merchandiser} from '../../services/dispatch';
import {MerchConstant} from '../../../app/MerchAppConstant';
import { DispserviceService } from '../../services/dispservice.service';

@Component({
  //moduleId: module.id,
  selector: 'app-route',
  templateUrl: 'route.component.html',
  styleUrls: ['route.component.css'],
  providers:[DispserviceService]

})
    
export class RouteComponent implements OnInit {


    
   private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    //public selectedacct: number;

    @Input() selectedacct: Store;
    @Input() routeName: String;
    public resultInsert: DispatchOutput;
    public storePredispatchInsertData: StorePreDispatch;
    public isRequesting: boolean;

    // @Input() unassignedInputAccts: Array<Account>;
    // @Input() allInputAccts: Array<Account>;
    // @Input() otherInputAccts: Array<Account>;
    @Input() dispatchDateInput: Date;
    @Input() lastModifiedByInput: string;
    @Input() routeData: Dispatches;
    @Input() routeIdInput: number;
    @Input() routesInput: Array<Route>;
    // @Input() unassignedOtherMerchInput: Array<Merchandiser>;
    // @Input() unassignedMerchInput: Array<Merchandiser>;

    @Output() routeReassigned = new EventEmitter();
    @Output() accountSelected = new EventEmitter();
    @Output() resequence = new EventEmitter();  
 
    constructor(public dispService: DispserviceService) { }


    private stopRefreshing() {
        this.isRequesting = false;
    }

   setselectedAcct($event) {
       
         this.accountSelected.emit(
             {  $event }
         )
    }
    
    draggedSuccess(seq:number) {
      
    }

    setupdatedroute($event) {

        this.routeReassigned.emit({
            value:$event
        });
        
    }

    setResequence($event)
    {
        this.resequence.emit({ });
    }

    dropStore(moveFrom) {
        let moveTo: number;
        
        for (var i = 0; i < this.routeData.Stores.length; i++) {
            if (moveFrom == this.routeData.Stores[i].Sequence) {
                moveTo = i + 1;
            }
        }

        for (var i = 0; i < this.routeData.Stores.length; i++) {
            if (i+1 != this.routeData.Stores[i].Sequence) {
                this.routeData.Stores[i].Sequence = i + 1;
            }
        }

        this.dispService.set(this._webapi + 'api/Merc/UpdateSequence/');
        let resequenceInput: ResequenceInput;

        resequenceInput = new ResequenceInput(this.dispatchDateInput, this.routeData.RouteID,moveFrom, moveTo, this.lastModifiedByInput);
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
        this.dispService.set(this._webapi + 'api/Merc/RemoveStore/');
        let removeStoreInput: RemoveStoreinput;
        removeStoreInput = new RemoveStoreinput(this.dispatchDateInput, this.routeData.RouteID, sequence, this.lastModifiedByInput);
        this.dispService.post(JSON.stringify(removeStoreInput))
            .subscribe(res => {
                var data: any = res;
                this.resultInsert = data;
                if (this.resultInsert.Message == null) {
                    this.routeData.Stores.splice(sequence - 1, 1);
                    for (var i = sequence - 1; i < this.routeData.Stores.length; i++) {
                        this.routeData.Stores[i].Sequence = this.routeData.Stores[i].Sequence - 1;
                    }

                    this.pullInfoUpdate();
                    this.accountSelected.emit({  });
                }

            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });
    }

    updateSequence(resequenceInput: ResequenceInput) {
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(resequenceInput))
            .subscribe(res => {
                var data: any = res;
                this.resultInsert = data;
                if (this.resultInsert.Message == null) {
                    this.pullInfoUpdate();
                    this.resequence.emit({ });
                }

                //if (this.resultInsert.Result == "1") {
                //    this.accountSelected.emit(
                //        { value: "refresh" }
                //    )
                //}


            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            // error => {

            //     if (error.status == 401 || error.status == 404) {
            //         //this.notificationService.printErrorMessage('Authentication required');
            //         //this.utilityService.navigateToSignIn();
            //     }
            //}
            );
    }

  

    ngOnInit() {
        
    }

}
