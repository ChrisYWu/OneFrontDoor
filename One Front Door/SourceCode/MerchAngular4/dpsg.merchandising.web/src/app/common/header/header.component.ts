import { Component, Inject, OnInit, ElementRef, Output, EventEmitter } from '@angular/core';
import { Http, Headers, Response, RequestOptions } from '@angular/http';
import { LocalStorageService } from 'ng2-webstorage';
import { Idle, DEFAULT_INTERRUPTSOURCES } from '@ng-idle/core';
import { Keepalive } from '@ng-idle/keepalive';
import { MerchConstant } from '../../../app/MerchAppConstant';
import { MerchBranch, MerchGroup } from '../../services/planning';
import { DOCUMENT } from '@angular/platform-browser';
import { Subscription } from 'rxjs/Subscription';
import { HeadernavService } from '../../services/headernav.service';
//import { ActivatedRoute } from '@angular/router';

import { Router, NavigationEnd } from '@angular/router';
// import { TopMenuComponent }   from '../menu/top-menu';
// import { TopSubMenuComponent }   from '../menu/top-sub-menu';
// import { UserDropdownComponent }   from '../menu/user-dropdown';

@Component({
  //moduleId: module.id,
  selector: 'app-header',
  templateUrl: 'header.component.html',
  styleUrls: ['header.component.css'],
  providers: [HeadernavService]
})
export class HeaderComponent implements OnInit {

  // added for IP version 
  @Output() ipMenuToggle: EventEmitter<any> = new EventEmitter();
  public isIpMenuOpen: boolean = false;
  public isIpBranchShow: boolean = true;
  public isIpGroupShow: boolean = true;
  public isIpMenuMonitor: boolean = true;

  public cssMenuActive(isActive: boolean): string {
    //debugger;
    let css: string = "row ip-menu-items menu-gradient-gray";
    if (isActive) {
      css = "row ip-menu-items menu-gradient-gray-active";
    }
    return css;
  }

  public cssBranchActive(id: string) {
    let css: string = "row ip-menu-items-dd menu-gradient-gray";
    if (id == this.selectedBranch.SAPBranchID) {
      css = "row ip-menu-items-dd ip-menu-items-active-dd  menu-gradient-gray-active";
    }
    return css;
  }

  public cssGroupActive(id: number) {
    let css: string = "row ip-menu-items-dd  menu-gradient-gray";
    if (id == this.selectedGroup.MerchGroupID) {
      css = "row ip-menu-items-dd ip-menu-items-active-dd  menu-gradient-gray-active";
    }
    return css;
  }

  public onIpMenuToggle() {
    // debugger;
    this.isIpMenuOpen = !this.isIpMenuOpen;
    this.ipMenuToggle.emit({ 'isIpMenuOpen': this.isIpMenuOpen });
    this.document.body.scrollTop = 0;

  }




  //end ---- added for IP version
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  public userName: string;
  public gsn: string;
  public emailid: string;

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
  public currentChoice: string = "monitor";

  public disabled: boolean = false;
  public status: { isopen: boolean } = { isopen: false };
  public items: Array<string> = ['The first choice!',
    'And another choice for you.', 'but wait! A third!'];

  public IsAuthorization:boolean;

  public toggled(open: boolean): void {
    console.log('Dropdown is now: ', open);
  }

  public toggleDropdown($event: MouseEvent): void {
    $event.preventDefault();
    $event.stopPropagation();
    this.status.isopen = !this.status.isopen;
  }

  setActive(choice: string): void {
    this.currentChoice = choice;
  }

  getActive(choice: string): string {
    if (this.currentChoice == choice)
      return "active";
    else
      return "not";

  }

  constructor( @Inject(DOCUMENT) private document: Document, public http: Http, public localSt: LocalStorageService,
    public idle: Idle, private keepalive: Keepalive, private navService: HeadernavService, private router: Router) {
   
    idle.setIdle(1200);
    idle.setTimeout(5);
    idle.setInterrupts(DEFAULT_INTERRUPTSOURCES);


    idle.onTimeout.subscribe(() => {
      console.log('Timeout');
      window.location.href = "/assets/logout.html";
    });

    
    idle.watch();
  }

  ngOnInit() {

    this.selectedBranch = new MerchBranch();
    this.selectedGroup = new MerchGroup();
    this.checkUserAuth();


    this.subscription = this.navService.navMerchItem$.subscribe(newitem => { this.merchitem = newitem; this.addMerchItem(newitem); });
    this.router.events.subscribe((val) => {
      // see also 
      if (val instanceof NavigationEnd) {
        if (val.url == "/rptnewstoreservice") {
          this.hideGeo(1);
        }
        this.currentChoice = val.url.split('/')[1];
        if (this.currentChoice == "") {
          this.currentChoice = "monitor";
        }
        else if (this.currentChoice == "mobileschedule") {
          this.isIpMenuMonitor = false;
        }
        else if (this.currentChoice == "monitor") {
          this.isIpMenuMonitor = true;
        }

      }
    });

  }

  addMerchItem(merchitem) {
    this.merchitem = merchitem;
    if (this.merchitem.MerchGroupID != undefined) {

      var grp = this.merchTargetGroups.filter((d: any) => {
        if (d.MerchGroupID == this.merchitem.MerchGroupID) {
          d.GroupName = this.merchitem.GroupName;
          d.IsDefault = this.merchitem.IsDefault;
          return d;
        }

      });

      if (grp.length == 0)
        this.merchGroups.push(this.merchitem);

      for (let item of this.merchGroups) {
        if (item.MerchGroupID == this.merchitem.MerchGroupID) {
          item.GroupName = this.merchitem.GroupName;
          item.IsDefault = this.merchitem.IsDefault;
        }
      }


      this.filterMerchGroups(merchitem.SAPBranchID);
      this.selectedGroup.LoggedInUser = this.localSt.retrieve("UserGSN");
      this.merchTargetGroups.sort(function (a, b) {
        if (a.GroupName < b.GroupName) return -1;
        if (a.GroupName > b.GroupName) return 1;
        return 0;
      });
      this.navService.changeNav(this.selectedGroup);
    }


  }

  public hideGeo(flag: number) {
    if (flag == 1)
      this.isGeoVisible = false;
    else
      this.isGeoVisible = true;
  }

  onBranchSelect(branch) {
    this.selectedBranch = branch;
    this.isIpBranchShow = false;
    this.filterMerchGroups(branch.SAPBranchID);
    this.selectedGroup.LoggedInUser = this.localSt.retrieve("UserGSN");
    this.navService.changeNav(this.selectedGroup);
  }
  onGroupSelect(group) {
    this.selectedGroup = group;
    this.item = this.selectedGroup;
    // this.isIpGroupShow = false;
    this.item.LoggedInUser = this.localSt.retrieve("UserGSN");
    this.navService.changeNav(this.item);
  }

  filterMerchGroups(sapBranchID: string) {
    this.merchTargetGroups = this.merchGroups.filter((d: any) => {
      if (d.SAPBranchID == sapBranchID && d.MerchGroupID != null)
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

      if (grp.length > 1) {
        grp.sort(function (a, b) {
          if (a.GroupName < b.GroupName) return -1;
          if (a.GroupName > b.GroupName) return 1;
          return 0;
        });


      }



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
        this.localSt.store('IsAuthorized', d.UserInfo.IsAuthorized);
  
        this.IsAuthorization = d.UserInfo.IsAuthorized;
        this.userName = d.UserInfo.Name;
        this.gsn = d.UserInfo.GSN;
        this.emailid = d.UserInfo.Email;
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

        // console.log(this.localSt.retrieve('UserGSN'));
        // console.log(this.localSt.retrieve('UserName'));
        // console.log(this.localSt.retrieve('UserEmail'));
      }
      else {
        console.log("User GSN - " + d.UserInfo.GSN + " is not valid.");
        window.location.href = "/assets/InvalidUser.html?GSN=" + d.UserInfo.GSN;
      }

    },
      error => {
        if (error.status == 401 || error.status == 404) {
        }
      });
  }

  WebAPIPostCall() {
    //return this.http.get(this._webapi + 'api/Merc/CheckAuthenticationByUser/')
    return this.http.get(this._webapi + 'api/Merc/CheckAuthentication/')
      .map(response => <any>(<Response>response).json());
  }

}

