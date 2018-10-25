
import { Component, OnInit,  Input, Output, EventEmitter,ViewChild } from '@angular/core';
import { CORE_DIRECTIVES, FORM_DIRECTIVES } from '@angular/common';
import {Subscription} from 'rxjs/Subscription';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS,ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import {DatePicker} from 'ng2-datepicker/ng2-datepicker';
import * as moment from 'moment';
import { DispserviceService } from '../services/dispservice.service';
import { RouteComponent} from '../common/route/'
import {} from '../services/dispatch';
import {Dispatches, DispatchInput, AccountInput, Account, Accounts,RouteListInput, Route, 
    Store,Merchandiser,DispatchReady, DispatchFinalResult, DispatchFinalInput, DispatchHistory} from '../services/dispatch';
import {MerchConstant} from '../../app/MerchAppConstant';

import { HeadernavService } from '../services/headernav.service';
import { SpinnerComponent } from '../common/spinner';



@Component({
  moduleId: module.id,
  selector: 'app-merc-main',
  templateUrl: 'merc-main.component.html',
  styleUrls: ['merc-main.component.css'],

  directives: [MODAL_DIRECTIVES,CORE_DIRECTIVES, FORM_DIRECTIVES, RouteComponent,DatePicker,SpinnerComponent],
  providers: [DispserviceService, HeadernavService], 
  viewProviders: [BS_VIEW_PROVIDERS]
  
          
})

export class MercMainComponent implements OnInit {
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public isRequesting: boolean ;

    @ViewChild('lgDispatchHistoryModal') lgDispatchHistoryModal: ModalDirective;

    public dispHistory:Array<DispatchHistory>;
    public dispHistoryLength:number = 0;

    public dispatch: Array<Dispatches>;
    public dispatchLength:number=0;
    public dispInput: DispatchInput;
    public dispathchDate: string; 
    public DispathchDate: string = new Date().toISOString().split('T')[0];
    public lastModifiedBy: string;
    
    public merchGroupId: number;

    public accts: Accounts;
    public acctInput: AccountInput;
    public allAccts: Array<Account>;
    public unassignedAccts: Array<Account>;
    public unassignedAcctsLength:number = 0;
    public otherAccts: Array<Account>;
    public selectedacct: string;
    // public routesInput: Array<Route>;
    public unassignedMerch: Array<Merchandiser> = [];
    public unassignedOtherMerch: Array<Merchandiser> = [];
    public dispatchReadyInfo:Array<DispatchReady>;
    public dispatchFinalResult:Array<DispatchFinalResult>;
    public dispatchReadyInfoLength:number = 0;
    public dispatchNotes:string='';
    public unassignedToggle:boolean = false;
     public changeeventtimeout :boolean=true ;// this is a global variable.
   
     private subscription:Subscription;

     public msgText:string = "";

    
    @Input() itemsObservables;

    constructor(public dispService: DispserviceService, public navService: HeadernavService) {
     
    }

  

    private stopRefreshing() {
        this.isRequesting = false;
    }

    setDispatchDate(){
        this.dispathchDate = this.DispathchDate.toString();
    }

    ngOnInit() {
        //this.DispathchDate = new Date().toISOString().split('T')[0];
       // this.setDispatchDate();
       // this.loadData();
        this.setDispatchDate();
    
        this.subscription = this.navService.navItem$.subscribe(item =>{this.merchGroupId = item.MerchGroupID;this.lastModifiedBy = item.LoggedInUser ;this.loadData()} );
         
    }

    ngOnDestroy() {
    // prevent memory leak when component is destroyed
        this.subscription.unsubscribe();
    }
    
    onChange($event)
    {
        if(this.dispathchDate != this.DispathchDate)
        {
            this.loadData();
            this.setDispatchDate();
        }
    }

      setselectedAcct($event) {
         this.dispService.set(this._webapi + 'api/Merc/GetStores/');
         this.acctInput = new AccountInput(this.merchGroupId, new Date(this.DispathchDate.toString()));
         this.getUnassignedAccounts(this.acctInput);
     }

    dispatchHistory()
    {
         this.dispService.set(this._webapi + 'api/Merc/GetDispatchHistory/');
         let routelistinput: RouteListInput;
         routelistinput = new RouteListInput(new Date(this.DispathchDate.toString()), this.merchGroupId);
     
          this.dispService.post(JSON.stringify(routelistinput), true)
            .subscribe(res => {
                var data: any = res;
                this.dispHistory = data.DispatchHistory;
                this.dispHistoryLength = this.dispHistory.length;
                this.lgDispatchHistoryModal.show();
            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });
    }

    loadData():void {
        this.msgText = "";

         this.dispService.set(this._webapi + 'api/Merc/GetAllDispatch/');
        this.dispInput = new DispatchInput(this.lastModifiedBy, this.merchGroupId, new Date(this.DispathchDate.toString()));
        this.getAllDipatchInfo(this.dispInput);

        // this.dispService.set(this._webapi + 'api/Merc/GetDispatches/');
        // this.dispInput = new DispatchInput('System', 102, this.dispathchDate);
        // this.getDipatchInfoPost(this.dispInput);
        // //this.getDipatchInfo();
        // this.dispService.set(this._webapi + 'api/Merc/GetStores/');
        // this.acctInput = new AccountInput(102, this.dispathchDate);
        // this.getAccounts(this.acctInput);

        // this.dispService.set(this._webapi + 'api/Merc/GetRouteList/');
        // let routelistinput: RouteListInput;
        // routelistinput = new RouteListInput(this.dispathchDate, this.merchGroupId);
        // this.getRoutes(routelistinput);

        
        // this.dispService.set(this._webapi + 'api/Merc/GetMerchList/');
        // this.getMerchs(routelistinput);

    }
    
    toggleUnassigned(){
        if(this.unassignedAcctsLength > 0)
        {
            if(this.unassignedToggle)
                this.unassignedToggle = false;
            else 
                this.unassignedToggle = true;
        }
        else{
            this.unassignedToggle = false;
        }
    }

    setupdatedroute($event) {
        let targetRouteId = $event.value.routeid;
        let reassignStore: Store = $event.value.store;

        for (var i = 0; i < this.dispatch.length; i++) {

            if (targetRouteId == this.dispatch[i].RouteID) {
                reassignStore.Sequence = this.dispatch[i].Stores.length + 1;
                this.dispatch[i].Stores.push(reassignStore);
            }

        }
        this.pullInfoUpdate();

    }

    pullInfoUpdate() {
         for (var i = 0; i < this.dispatch.length; i++) {
            
             let tempStores:Array<Store> = this.dispatch[i].Stores.slice();

             for (var j = 0; j < tempStores.length; j++) {
                 let pullcount = 0;
                 for (var k = 0; k < this.dispatch[i].Stores.length; k++) {
                     if (tempStores[j].AccountID == this.dispatch[i].Stores[k].AccountID) {
                         pullcount++;
                         if (pullcount == 1) {
                             this.dispatch[i].Stores[k].PullNumber = "";
                         }
                         else if (pullcount == 2) {
                             this.dispatch[i].Stores[k].PullNumber = pullcount + "nd Pull";
                         }
                         else if (pullcount == 3) {
                             this.dispatch[i].Stores[k].PullNumber = pullcount + "rd Pull";
                         }
                         else {
                             this.dispatch[i].Stores[k].PullNumber = pullcount + "th Pull";
                         }
                        
                     }
                 }
             }
            

         }
    }
   

    getAllDipatchInfo(data: DispatchInput) {
        this.isRequesting = true;
      this.dispService.post(JSON.stringify(data))
            .subscribe(res => {
                var data: any = res;
                 if (data.Dispatches.Routes.length <=0)
                     {
                             this.msgText = "No data found for " + moment(this.dispathchDate).format('MMM D, YYYY');
                     }else{
                            this.msgText = "";
                     }
                //dispatch
                this.dispatch = data.Dispatches.Routes;
                this.dispatchLength = this.dispatch.length;

                //Stores
                 this.allAccts = data.Stores.AllStores;
                this.unassignedAccts = data.Stores.UnassignedStores;
                this.unassignedAcctsLength = this.unassignedAccts.length;
                this.otherAccts = data.Stores.OtherStores;

                //Routes
                //this.routesInput = data.Routes.Routes;

                //Merchandiser
                this.unassignedMerch = data.Merchandisers.UnassignedMerchandiser;
                this.unassignedOtherMerch = data.Merchandisers.OtherUnassignedMerchandiser;

                this.pullInfoUpdate();

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


    getDipatchInfo(): void {
        this.isRequesting = true;
        this.dispService.get()
            .subscribe(res => {
                var data: any = res.json();
                this.dispatch = data.Routes;
              
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


    getDipatchInfoPost(data: DispatchInput) {
           this.isRequesting = true;
        this.dispService.post(JSON.stringify(data))
            .subscribe(res => {
                var data: any = res;
                this.dispatch = data.Routes;
                this.pullInfoUpdate();
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


    getAccounts(data: AccountInput) {
           this.isRequesting = true;
        this.dispService.post(JSON.stringify(data), true)
            .subscribe(res => {
                var data: any = res;
                this.allAccts = data.AllStores;
                this.unassignedAccts = data.UnassignedStores;
                this.unassignedAcctsLength = this.unassignedAccts.length;
                this.otherAccts = data.OtherStores;
             
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


   getUnassignedAccounts(data: AccountInput) {
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(data), true)
            .subscribe(res => {
                var data: any = res;
                this.unassignedAccts = data.UnassignedStores;
                this.unassignedAcctsLength = this.unassignedAccts.length;
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
    // getRoutes(data: RouteListInput) {
       
    //     this.isRequesting = true;
    //     this.dispService.post(JSON.stringify(data))
    //         .subscribe(res => {
    //             var data: any = res;
    //             this.routesInput = data.Routes;

    //         },

    //         () => this.stopRefreshing(),
    //         () => this.stopRefreshing()
    //         // error => {

    //         //     if (error.status == 401 || error.status == 404) {
    //         //         //this.notificationService.printErrorMessage('Authentication required');
    //         //         //this.utilityService.navigateToSignIn();
    //         //     }
    //         // }
            
    //         );
    // }

     getMerchs(data: RouteListInput) {
       
        this.isRequesting = true; 
        this.dispService.post(JSON.stringify(data))
            .subscribe(res => {
                var data: any = res;
                this.unassignedMerch = data.UnassignedMerchandiser;
                this.unassignedOtherMerch = data.OtherUnassignedMerchandiser;

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
    onKey(event:any) {
     
         this.dispatchNotes = event.target.value ;
    }

    previewDispatch(){
        let dispatchReady:AccountInput = new AccountInput(this.merchGroupId, new Date(this.DispathchDate.toString()));
        
        this.dispService.set(this._webapi + 'api/Merc/DispatchReady/');
         this.isRequesting = true;
        this.dispService.post(JSON.stringify(dispatchReady))
        .subscribe(res => {
            var data: any = res;
            this.dispatchReadyInfo = data.DispatchReadyListItems;
            this.dispatchReadyInfoLength = this.dispatchReadyInfo.length;
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
    finalDispatch(){
         let dispatchFinal:DispatchFinalInput = new DispatchFinalInput(new Date(this.DispathchDate.toString()),this.lastModifiedBy,this.merchGroupId, this.dispatchNotes);
        
         this.dispService.set(this._webapi + 'api/Merc/DispatchFinal/');
         this.isRequesting = true;
         this.dispService.post(JSON.stringify(dispatchFinal))
         .subscribe(res => {
             var data: any = res;
             this.dispatchFinalResult = data.DispatchFinalResult;
             if(this.dispatchFinalResult[0].DispatchInfo != 'OK')
             {
                 alert('Dispatch was not successfull!');
             }
             else
             {
                alert('Dispatch successfull!');
             }
         },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
        //  error => {

        // //     if (error.status == 401 || error.status == 404) {
        // //         //this.notificationService.printErrorMessage('Authentication required');
        // //         //this.utilityService.navigateToSignIn();
        // //     }
        // }
        );
    }
}