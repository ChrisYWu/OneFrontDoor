import { Component, OnInit, Input, ComponentResolver, Output, EventEmitter} from '@angular/core';
import {CORE_DIRECTIVES} from '@angular/common';
import { DROPDOWN_DIRECTIVES} from 'ng2-bootstrap/ng2-bootstrap';
import { DispserviceService } from '../../../services/dispservice.service';
import {MerchConstant} from '../../../../app/MerchAppConstant';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS} from 'ng2-bootstrap/ng2-bootstrap';
import { MerchInfo, RouteData, MerchGroup, MerchSetupDetailInput} from '../MerchSetupClass';

@Component({
  moduleId: module.id,
  selector: 'app-merchdetail',
  templateUrl: 'merchdetail.component.html',
  styleUrls: ['merchdetail.component.css'],
  providers: [DispserviceService],
  directives: [CORE_DIRECTIVES, DROPDOWN_DIRECTIVES, MODAL_DIRECTIVES],
  viewProviders: [BS_VIEW_PROVIDERS]
})
export class MerchdetailComponent implements OnInit {

  @Input() routeList: Array<any>;
  public disabled: boolean = false;
  public status: { isopen: boolean } = { isopen: false };
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  @Input() selectedRoute: RouteData;  
  @Input() ShowSaveMsg: boolean = false;
  @Output() refreshList = new EventEmitter();
  @Input() MerchGroupItem: MerchGroup;
  @Output() cancelDetail = new EventEmitter();

  @Input() merchSelectedInfo: MerchInfo;

  public merchInput: MerchSetupDetailInput;
  public merchPhone: string;

  constructor(private dispService: DispserviceService) { }

  public toggled(open: boolean): void {
    //console.log('Dropdown is now: ', open);
  }

  public toggleDropdown($event: MouseEvent): void {
    $event.preventDefault();
    $event.stopPropagation();
    this.status.isopen = !this.status.isopen;
  }

  onSelectRoute(route: any) {
    this.selectedRoute = route;
  }

  onCancel() {
    this.cancelDetail.emit({});
  }

  onSave() {
    this.merchInput = new MerchSetupDetailInput(this.merchSelectedInfo.GSN, this.merchSelectedInfo.MerchName,
                      this.merchSelectedInfo.FirstName, this.merchSelectedInfo.LastName, this.selectedRoute.RouteID,
                      this.MerchGroupItem.MerchGroupID, this.merchSelectedInfo.Phone, this.merchSelectedInfo.Mon,
                      this.merchSelectedInfo.Tues, this.merchSelectedInfo.Wed, this.merchSelectedInfo.Thu, this.merchSelectedInfo.Fri,
                      this.merchSelectedInfo.Sat, this.merchSelectedInfo.Sun, this.MerchGroupItem.LoggedInUser);

    this.insertMerchSetUpData(this.merchInput);

  }



  insertMerchSetUpData(merch: MerchSetupDetailInput) {
    this.dispService.set(this._webapi + 'api/Merc/InsertUpdateMerchSetupDetail/');
    this.dispService.post(JSON.stringify(merch))
      .subscribe(res => {
        var data: any = res;
        if (data.ReturnStatus == 1) {
          var result: any = { ReturnStatus: data.ReturnStatus, NewMerchInfo: merch };
          this.refreshList.emit(result);
        }

      },
      error => {
        if (error.status == 401 || error.status == 404) {
        }
      });
  }

  ngOnInit() {
  }

}
