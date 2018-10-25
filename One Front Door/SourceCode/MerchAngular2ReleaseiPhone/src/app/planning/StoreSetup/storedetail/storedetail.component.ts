import { Component, OnInit, Input, Output, EventEmitter, ViewChild, ChangeDetectionStrategy } from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
import { StoreInfo, StoreSetupDetailContainer, StoreSetupDOW, RouteInfo, MerchGroup } from '../../../services/planning';
import { Ng2MapComponent } from 'ng2-map';
//import { DROPDOWN_DIRECTIVES} from 'ng2-bootstrap/ng2-bootstrap';
import { DispserviceService } from '../../../services/dispservice.service';
import { MerchConstant } from '../../../../app/MerchAppConstant';
import { ModalDirective } from 'ng2-bootstrap/ng2-bootstrap';
//import { TooltipModule } from 'ng2-bootstrap/components/tooltip';

@Component({
  // moduleId: module.id,
  selector: 'storedetail',
  templateUrl: 'storedetail.component.html',
  styleUrls: ['storedetail.component.css'],
  providers: [DispserviceService],
  // directives:[CORE_DIRECTIVES,NG2_MAP_DIRECTIVES,DROPDOWN_DIRECTIVES,MODAL_DIRECTIVES],
  //  viewProviders: [BS_VIEW_PROVIDERS]
})
export class StoredetailComponent implements OnInit {

  @Input() storeSelectedInfo: any;
  @Input() routeList: Array<any>;
  public disabled: boolean = false;
  public status: { isopen: boolean } = { isopen: false };
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;//'http://localhost:8888/';
  @Input() selectedRoute: RouteInfo;

  @Input() daysofWeek: Array<StoreSetupDOW>;
  @Input() ShowSaveMsg: boolean = false;
  @Output() refreshList = new EventEmitter();
  @Input() MerchGroupItem: MerchGroup;
  @Output() cancelDetail = new EventEmitter();
  @ViewChild('detailModal') detailModal: ModalDirective;

  constructor(private dispService: DispserviceService) {
    Ng2MapComponent['apiUrl'] = "https://maps.google.com/maps/api/js?key=AIzaSyCbMGRUwcqKjlYX4h4-P6t-xcDryRYLmCM";

  }
  public toggled(open: boolean): void {
    console.log('Dropdown is now: ', open);
  }

  public toggleDropdown($event: MouseEvent): void {
    $event.preventDefault();
    $event.stopPropagation();
    this.status.isopen = !this.status.isopen;
  }

  onSelectRoute(route: any) {
    this.selectedRoute = route;

    for (var n = 0; n < 7; n++) {
      this.daysofWeek[n].RouteNameBackup = this.selectedRoute.RouteName;
      if (this.daysofWeek[n].FirstPull) {
        this.daysofWeek[n].RouteName = this.selectedRoute.RouteName;
      }
    }
  }

  onChkChange(week: any) {
    if (week.FirstPull) {
      week.FirstPull = false;
      week.RouteNameBackup = week.RouteName;
      week.RouteName = "";
    }
    else {
      week.FirstPull = true;
      if (this.selectedRoute != null) {
        week.RouteNameBackup = this.selectedRoute.RouteName;
      }
      week.RouteName = week.RouteNameBackup;
    }
  }

  onSecondPullChkChange(p: any) {
    if (p.SecondPull)
      p.SecondPull = false;
    else
      p.SecondPull = true;
  }

  onCancel() {
    this.cancelDetail.emit({});
  }

  onDaysClick(days: number) {
    for (var n = 0; n <= 6; n++) {
      if (this.daysofWeek[n].FirstPull) {
        this.daysofWeek[n].FirstPull = false;
        this.daysofWeek[n].RouteName = "";
      }
    }

    for (var n = 0; n < days; n++) {
      if (this.daysofWeek[n].FirstPull) {
        this.daysofWeek[n].FirstPull = false;
        this.daysofWeek[n].RouteName = "";
      }
      else {
        this.daysofWeek[n].FirstPull = true;
        this.daysofWeek[n].RouteName = this.selectedRoute.RouteName;
      }
    }
  }

  onStoreMainSave() {
    if (this.selectedRoute.RouteID == null) {
      this.detailModal.show();
    }
    else {
      this.onSave();
    }

  }



  onSave() {
    var route = this.selectedRoute;
    var week1 = this.daysofWeek;
    var input: any = {
      SAPBranchID: this.MerchGroupItem.SAPBranchID,
      MerchGroupID: this.MerchGroupItem.MerchGroupID,
      SAPAccountNumber: this.storeSelectedInfo.SAPAccountNumber,
      DefaultRouteID: this.selectedRoute.RouteID,
      WeekDays: this.daysofWeek,
      GSN: this.MerchGroupItem.LoggedInUser

    }

    this.insertStoreSetUpData(input, this.storeSelectedInfo);


  }

  insertStoreSetUpData(input: any, store: StoreInfo) {
    this.dispService.set(this._webapi + 'api/Merc/InsertUpdateStoreSetupDetails/');
    this.dispService.post(JSON.stringify(input))
      .subscribe(res => {
        var data: any = res;
        if (data.ReturnStatus == 1) {

          var result: any = { ReturnStatus: data.ReturnStatus, Account: store };
          this.refreshList.emit(result);
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
