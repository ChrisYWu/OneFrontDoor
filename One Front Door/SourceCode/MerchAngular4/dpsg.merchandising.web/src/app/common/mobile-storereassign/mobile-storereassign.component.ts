import { Component, Inject, OnInit, Input, Output, EventEmitter,ViewChild } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import {ModalDirective, DropdownDirective} from 'ng2-bootstrap/ng2-bootstrap';
import { DOCUMENT } from '@angular/platform-browser';
import {Dispatches, Store, Route, ReassignStoreInput, DispatchOutput, RouteListExcludeCurrentInput} from '../../services/dispatch';
import {MerchConstant} from '../../../app/MerchAppConstant';
import { DispserviceService } from '../../services/dispservice.service';

@Component({
  selector: 'app-mobile-storereassign',
  templateUrl: './mobile-storereassign.component.html',
  styleUrls: ['./mobile-storereassign.component.scss'],
  providers:[DispserviceService]
})
export class MobileStorereassignComponent implements OnInit {

// IP version related 
@Output() storeAssignToggle: EventEmitter<any> = new EventEmitter();  

public isShowStorePopup:boolean = false;
   public toClosePopup()
   {
      //  debugger;
        
         this.isShowStorePopup = false ;

         this.storeAssignToggle.emit({});
   }
// IP version - ends 
    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    public routeId: number;
    public routeName: string;
    public gsn: string;
    public reassignStore: ReassignStoreInput;
    public resultInsert: DispatchOutput;
    public routesFiltered: Array<Route> = [];
    @ViewChild('lgModal') lgModal: ModalDirective;


    @Input() lastModifiedByInput: string;
    @Input() storeInput: Store;
    @Input() routeData: Dispatches;
    //@Input() routesInput: Array<Route> ;
    @Input() routeNameInput: string;
    @Output() routeReassigned = new EventEmitter();
    @Output() merchReassigned = new EventEmitter();


    //constructor(@Inject(DOCUMENT) private document: Document,public dispService: DispserviceService) { }
    constructor(public dispService: DispserviceService) { }


    adjustSequence()
    {
        for(let i=0; i< this.routeData.Stores.length ; i++)
        {
            this.routeData.Stores[i].Sequence = i+1;
        }
    }

  getRoutes(data: RouteListExcludeCurrentInput, isForIP: boolean) {
   //    debugger;      
        this.dispService.post(JSON.stringify(data))
            .subscribe(res => {
                var data: any = res;
                this.routesFiltered = data.Routes;
                if(isForIP == true)
                {
                     this.isShowStorePopup = true ;

                     //this.document.body.scrollTop = 0;
                     this.storeAssignToggle.emit({});
                }else{
                    this.lgModal.show();
                }
            },

          
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            }
            
            );
    }
    setupdatedroute(routeid: number, routename: string, gsn:string, isForIP: boolean) {

        this.routeId = routeid;
        this.routeName = routename;
        this.gsn = gsn;

        this.reassignStore = new ReassignStoreInput(this.routeData.DispatchDate,
            this.storeInput.Sequence,
            this.lastModifiedByInput,
            this.routeData.MerchGroupID,
            this.gsn,
            this.routeId,
            this.routeData.RouteID,
            this.storeInput.AccountID);
        
        this.dispService.set(this._webapi + 'api/Merc/ReassignStore/');
        
        this.dispService.post(JSON.stringify(this.reassignStore))
            .subscribe(res => {
                var data: any = res;
                this.resultInsert = data;
                if (this.resultInsert.Message == null) {
                    this.routeData.Stores.splice(this.storeInput.Sequence - 1, 1);
                    this.adjustSequence();

                    this.storeInput.PullNumber='';
                    this.routeReassigned.emit(
                        { routeid: this.routeId, store: this.storeInput}
                    )

                }
                
                if (isForIP)
                {
                    this.storeAssignToggle.emit({});
                }else{
                    this.lgModal.hide();
                }

            },
            error => {

                if (error.status == 401 || error.status == 404) {
                    //this.notificationService.printErrorMessage('Authentication required');
                    //this.utilityService.navigateToSignIn();
                }
            });
    }



    openModal(isForIP: boolean)
    {
        this.dispService.set(this._webapi + 'api/Merc/GetRouteList/');
        let routelistinput: RouteListExcludeCurrentInput;
        routelistinput = new RouteListExcludeCurrentInput(this.routeData.DispatchDate, this.routeData.MerchGroupID, this.routeData.RouteID);
        this.getRoutes(routelistinput, isForIP)
    }

    ngOnInit() {
        
    }
   


}
