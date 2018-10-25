import { Component, OnInit, ElementRef } from '@angular/core';
import { Http, Headers, Response, RequestOptions } from '@angular/http';
import { ROUTER_DIRECTIVES } from '@angular/router';
import { DROPDOWN_DIRECTIVES } from 'ng2-bootstrap/ng2-bootstrap';
import {LocalStorageService} from 'ng2-webstorage';
import {Idle, DEFAULT_INTERRUPTSOURCES} from 'ng2-idle/core';
import {MerchConstant} from '../../../app/MerchAppConstant';
import {MerchBranch, MerchGroup} from '../../services/planning';
import {HeadernavService} from '../../services/headernav.service';
import {Subscription} from 'rxjs/Subscription';

// import { TopMenuComponent }   from '../menu/top-menu';
// import { TopSubMenuComponent }   from '../menu/top-sub-menu';
// import { UserDropdownComponent }   from '../menu/user-dropdown';

@Component({
  moduleId: module.id,
  selector: 'app-header',
  templateUrl: 'header.component.html',
  styleUrls: ['header.component.css'],
  directives: [ROUTER_DIRECTIVES, DROPDOWN_DIRECTIVES],
  providers: [HeadernavService]
})
export class HeaderComponent implements OnInit {

  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  public userName: string;
  public merchBranches: Array<MerchBranch>;
  public merchGroups: Array<MerchGroup> = [];
  public merchTargetGroups: Array<MerchGroup>;
  public nobranch: boolean = false;
  public nomerchgroup: boolean = false;
  public selectedBranchID: string;

  public menushowreport: boolean = false;
  public menushowplanning: boolean = false;
  public selectedBranch: MerchBranch;
  public selectedGroup: MerchGroup;
  public item: MerchGroup = new MerchGroup();
  public merchitem: MerchGroup = new MerchGroup();
  subscription: Subscription;
  public isGeoVisible: boolean = true;


  public disabled: boolean = false;
  public status: { isopen: boolean } = { isopen: false };
  public items: Array<string> = ['The first choice!',
    'And another choice for you.', 'but wait! A third!'];

  public toggled(open: boolean): void {
    console.log('Dropdown is now: ', open);
  }

  public toggleDropdown($event: MouseEvent): void {
    $event.preventDefault();
    $event.stopPropagation();
    this.status.isopen = !this.status.isopen;
  }


  constructor(public http: Http, public localSt: LocalStorageService, public idle: Idle, private navService: HeadernavService) {
    idle.setIdle(1200);
    idle.setTimeout(5);
    idle.setInterrupts(DEFAULT_INTERRUPTSOURCES);


    idle.onTimeout.subscribe(() => {
      console.log('Timeout');
      window.location.href = "/logout.html";
    });

    idle.watch();
  }

  ngOnInit() {

    this.selectedBranch = new MerchBranch();
    this.selectedGroup = new MerchGroup();
    this.checkUserAuth();


    this.subscription = this.navService.navMerchItem$.subscribe(newitem => { this.merchitem = newitem; this.addMerchItem(newitem); });
  }

  addMerchItem(merchitem) {
    this.merchitem = merchitem;
    if (this.merchitem.MerchGroupID != undefined) {
      this.merchGroups.push(this.merchitem);
      this.filterMerchGroups(merchitem.SAPBranchID);
    }


  }

  hideGeo(flag: number) {
    if (flag == 1)
      this.isGeoVisible = false;
    else
      this.isGeoVisible = true;
  }

  onBranchSelect(branch) {
    this.selectedBranch = branch;
    this.filterMerchGroups(branch.SAPBranchID);
    this.selectedGroup.LoggedInUser = this.localSt.retrieve("UserGSN");
    this.navService.changeNav(this.selectedGroup);
  }
  onGroupSelect(group) {
    this.selectedGroup = group;
    this.item = this.selectedGroup;
    this.item.LoggedInUser = this.localSt.retrieve("UserGSN");
    this.navService.changeNav(this.item);
  }

  filterMerchGroups(sapBranchID: string) {
    this.merchTargetGroups = this.merchGroups.filter((d: any) => {
      if (d.SAPBranchID == sapBranchID)
        return d;
    });
    var grp = this.merchTargetGroups.filter((d: any) => {
      if (d.IsDefault == true)
        return d;
    });

    if (this.merchTargetGroups.length == 0) {
      this.merchTargetGroups = [];
      this.selectedGroup.SAPBranchID = sapBranchID;
      this.selectedGroup.GroupName = '';
      this.selectedGroup.MerchGroupID = null;
    }
    else if (grp.length == 0) {
      this.selectedGroup = this.merchTargetGroups[0];
    }
    else {
      this.selectedGroup = grp[0];
    }

  }

  checkUserAuth(): void {
    this.WebAPIPostCall().subscribe(res => {
      var d: any = res;
      if (d.UserInfo.IsValid == 1) {
        this.localSt.store('UserGSN', d.UserInfo.GSN);
        this.localSt.store('UserName', d.UserInfo.Name);
        this.localSt.store('UserEmail', d.UserInfo.Email);
        this.userName = d.UserInfo.Name;
        if (d.Branches.length >= 0) {

          var brch = d.Branches.filter((d: any) => {
            if (d.IsDefault == true)
              return d;
          });

          if (brch.length == 0) {
            this.selectedBranch = d.Branches[0];
          }
          else {
            this.selectedBranch = brch[0];
          }
          this.merchBranches = d.Branches;
          this.nobranch = true;
        }

        if (d.Groups.length >= 0) {

          this.merchGroups = d.Groups;
          this.merchTargetGroups = Object.assign(this.merchGroups);

          this.filterMerchGroups(this.selectedBranch.SAPBranchID);

          this.nomerchgroup = true;
        }

        this.item = this.selectedGroup;
        this.item.LoggedInUser = this.localSt.retrieve("UserGSN");
        this.navService.changeNav(this.item);

        console.log(this.localSt.retrieve('UserGSN'));
        console.log(this.localSt.retrieve('UserName'));
        console.log(this.localSt.retrieve('UserEmail'));
      }
      else {
        console.log("User GSN - " + d.UserInfo.GSN + " is not valid.");
        window.location.href = "/InvalidUser.html?GSN=" + d.UserInfo.GSN;
      }

    },
      error => {
        if (error.status == 401 || error.status == 404) {
        }
      });
  }

  WebAPIPostCall() {
    return this.http.get(this._webapi + 'api/Merc/CheckAuthenticationByUser/')
    //return this.http.get(this._webapi + 'api/Merc/CheckAuthentication/')
      .map(response => <any>(<Response>response).json());
  }
  
}
