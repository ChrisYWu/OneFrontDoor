
import { Component, OnInit, Input, Output,EventEmitter } from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import {TAB_DIRECTIVES, MODAL_DIRECTIVES, BS_VIEW_PROVIDERS} from 'ng2-bootstrap/ng2-bootstrap';
import {FilterPipe} from '../../pipes/filter.pipe';

import {Merchandiser, Dispatches, ReassignMerchInput, DispatchOutput} from '../../services/dispatch';
import {DispserviceService } from '../../services/dispservice.service';
import {MerchConstant} from '../../../app/MerchAppConstant';

@Component({
  moduleId: module.id,
  selector: 'app-merchreassign',
  templateUrl: 'merchreassign.component.html',
  styleUrls: ['merchreassign.component.css'],
  directives: [CORE_DIRECTIVES, TAB_DIRECTIVES, MODAL_DIRECTIVES],
  pipes: [FilterPipe],
  viewProviders: [BS_VIEW_PROVIDERS],
  providers: [DispserviceService]
  
})
export class MerchreassignComponent implements OnInit {

  
     private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    @Input() unassignedOtherMerchInput: Array<Merchandiser>;
    
    @Input() unassignedMerchInput: Array<Merchandiser>;
    
    @Input() routeData: Dispatches;
    @Input() lastModifiedByInput: string;



    

    constructor(public dispService: DispserviceService) {
    
  }


  reassignMerch(gsn:string, lastname:string, firstname:string) {
      let reassignMerchInput: ReassignMerchInput = new ReassignMerchInput(this.routeData.DispatchDate,this.lastModifiedByInput,this.routeData.MerchGroupID,gsn, this.routeData.RouteID);
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
