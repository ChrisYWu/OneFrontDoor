import {
  Component,
  OnInit
} from '@angular/core';
import {
  PlMerchRowComponent
} from './pl-merch-row';
import {
  PlRouteRowComponent
} from './pl-route-row';
import {
  MonitorService
} from '../services/monitor.service'
import {Subscription} from 'rxjs/Subscription';
import {MerchGroup} from '../services/planning';
import { HeadernavService } from '../services/headernav.service';
import { SpinnerComponent } from '../common/spinner';


@Component({
  selector: 'pl-merch',
  templateUrl: 'pl-merch.component.html',
  styleUrls: ['pl-merch.component.css'],
  providers: [MonitorService, HeadernavService]
})
export class PlMerchComponent implements OnInit {

  public msgText_MerchToDayRouteList = "";
  public msgText_RouteToDayMerchList = "";
  public errText = "";
  public isRequesting: boolean;
  public isShowDropDown: boolean = false;
  public isMerchTab: boolean = true;
  public RouteMercData: any
  = {
    ReturnStatus: 1,
    Message: null,
    CorrelationID: "",
    StackTrace: null,
    AssignedDays: {},
    RouteToAssigne: {},
    MerchToAssigne: {},
    MerchToDayRouteList: [],
    RouteList: [],
    RouteToDayMerchList: [],
    MerchandiserList: [],
    RouteMerchandiserList: []
  };

  item: MerchGroup = new MerchGroup();
  subscription: Subscription;

  //----------------------------------------------Route Methods

  onDeleteRoute(val: any) {

    // debugger;

    let dayMerch = {
      GSN: "",
      MerchGroupID: -1,
      LastName: "",
      FirstName: "",
      Email: "",
      Phone: "",
      DayOfWeek: val.dayOfWeek,
      isOffDay: null,
      isMerchAssigned: false
    }

    let merchTA = {};

    for (let a = 0; a < this.RouteMercData.MerchandiserList.length; a++) {
      if (this.RouteMercData.MerchandiserList[a].GSN == val.GSN) {
        merchTA = this.RouteMercData.MerchandiserList[a];
        break;
      }
    }

    for (let i = 0; i < this.RouteMercData.RouteToDayMerchList.length; i++) {
      if (this.RouteMercData.RouteToDayMerchList[i].RouteID == val.route.RouteID) {


        switch (val.dayOfWeek) {
          case 1:
            this.RouteMercData.RouteToDayMerchList[i].Sunday = dayMerch;
            this.RouteMercData.MerchToAssigne.Sunday.splice(0, 0, merchTA);
            break;
          case 2:
            this.RouteMercData.RouteToDayMerchList[i].Monday = dayMerch;
            this.RouteMercData.MerchToAssigne.Monday.splice(0, 0, merchTA);
            break;
          case 3:
            this.RouteMercData.RouteToDayMerchList[i].Tuesday = dayMerch;
            this.RouteMercData.MerchToAssigne.Tuesday.splice(0, 0, merchTA);
            break;
          case 4:
            this.RouteMercData.RouteToDayMerchList[i].Wednesday = dayMerch;
            this.RouteMercData.MerchToAssigne.Wednesday.splice(0, 0, merchTA);
            break;
          case 5:
            this.RouteMercData.RouteToDayMerchList[i].Thursday = dayMerch;
            this.RouteMercData.MerchToAssigne.Thursday.splice(0, 0, merchTA);
            break;
          case 6:
            this.RouteMercData.RouteToDayMerchList[i].Friday = dayMerch;
            this.RouteMercData.MerchToAssigne.Friday.splice(0, 0, merchTA);
            break;
          case 7:
            this.RouteMercData.RouteToDayMerchList[i].Saturday = dayMerch;
            this.RouteMercData.MerchToAssigne.Saturday.splice(0, 0, merchTA);
            break;

        }
        break;
      }
    }

    //this is database delete call - maybe goiing to drop 
    this.deleteRouteMerchandiser(val.route.RouteID, val.dayOfWeek, val.GSN)

  }

  updateMerchToAssigne(merchToAssigne, merchToDayRoute) {

    let _updateMerchToAssigne = [];

    for (let i = 0; i < merchToAssigne.length; i++) {

      if (merchToAssigne[i].GSN != merchToDayRoute.GSN) {
        _updateMerchToAssigne.push(merchToAssigne[i]);
      }

    }
    return _updateMerchToAssigne;
  }

  updateRouteToDayMerchList(routeToDayMerch, merchToDayRoute) {
    let updateRouteToDayMerch: any = routeToDayMerch;

    updateRouteToDayMerch.LastName = merchToDayRoute.LastName;
    updateRouteToDayMerch.FirstName = merchToDayRoute.FirstName;
    updateRouteToDayMerch.Email = merchToDayRoute.Email;
    updateRouteToDayMerch.Phone = merchToDayRoute.Phone;
    updateRouteToDayMerch.AbsoluteURL = merchToDayRoute.AbsoluteURL;
    updateRouteToDayMerch.isOffDay = merchToDayRoute.isOffDay;
    updateRouteToDayMerch.isMerchAssigned = true;

    return updateRouteToDayMerch

  }

  onAddRoute(val: any) {
    //{'route': val.route, 'dayOfWeek': val.DayOfWeek, 'merchToDayRoute': this.MerchToDayRoute}
    // remove from availbeRoute
    // remove from availble available Merchaniser 
    // debugger;
    let _dayOfWeek = val.dayOfWeek;
    let _route = val.route;
    let _merchToDayRoute = val.merchToDayRoute;
    let availableMerch: any;

    debugger

    switch (val.dayOfWeek) {
      case 1:
        availableMerch = this.RouteMercData.MerchToAssigne.Sunday;
        this.RouteMercData.MerchToAssigne.Sunday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute)
        break;
      case 2:
        availableMerch = this.RouteMercData.MerchToAssigne.Monday;
        this.RouteMercData.MerchToAssigne.Monday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute)
        break;
      case 3:
        availableMerch = this.RouteMercData.MerchToAssigne.Tuesday;
        this.RouteMercData.MerchToAssigne.Tuesday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute)
        break;
      case 4:
        availableMerch = this.RouteMercData.MerchToAssigne.Wednesday;
        this.RouteMercData.MerchToAssigne.Wednesday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute)
        break;
      case 5:
        availableMerch = this.RouteMercData.MerchToAssigne.Thursday;
        this.RouteMercData.MerchToAssigne.Thursday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute)
        break;
      case 6:
        availableMerch = this.RouteMercData.MerchToAssigne.Friday;
        this.RouteMercData.MerchToAssigne.Friday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute)
        break;
      case 7:
        availableMerch = this.RouteMercData.MerchToAssigne.Saturday;
        this.RouteMercData.MerchToAssigne.Saturday = this.updateMerchToAssigne(availableMerch, _merchToDayRoute)
        break;

    }

    //----------------------------------------------RouteToDayMerchList update  ----
    // do do debug here - getting error here 
    for (let i = 0; i < this.RouteMercData.RouteToDayMerchList.length; i++) {
      if (this.RouteMercData.RouteToDayMerchList[i].RouteID == _route.RouteID) {
        let routeToDayMerch: any;

        switch (val.dayOfWeek) {
          case 1:
            routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Sunday;
            this.RouteMercData.RouteToDayMerchList[i].Sunday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
            break;
          case 2:
            routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Monday;
            this.RouteMercData.RouteToDayMerchList[i].Monday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
            break;
          case 3:
            routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Tuesday;
            this.RouteMercData.RouteToDayMerchList[i].Tuesday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
            break;
          case 4:
            routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Wednesday;
            this.RouteMercData.RouteToDayMerchList[i].Wednesday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
            break;
          case 5:
            routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Thursday;
            this.RouteMercData.RouteToDayMerchList[i].Thursday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
            break;
          case 6:
            routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Friday;
            this.RouteMercData.RouteToDayMerchList[i].Friday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
            break;
          case 7:
            routeToDayMerch = this.RouteMercData.RouteToDayMerchList[i].Saturday;
            this.RouteMercData.RouteToDayMerchList[i].Saturday = this.updateRouteToDayMerchList(routeToDayMerch, _merchToDayRoute);
            break;

        }


        break;
      }

    }


    this.addRouteMerchandiser(_route.RouteID, _dayOfWeek, _merchToDayRoute.GSN)

  }


  //---------------------------------------------Merch methods

  onDeleteMerch(val: any) {

    let dayRoute = {
      RouteID: -1,
      RouteName: "",
      DayOfWeek: val.dayOfWeek,
      isOffDay: null,
      isRouteAssigned: false
    }


    let routeTA = {};

    for (let a = 0; a < this.RouteMercData.RouteList.length; a++) {
      if (this.RouteMercData.RouteList[a].RouteID == val.routeID) {
        routeTA = this.RouteMercData.RouteList[a];
        break;
      }
    }


    for (let i = 0; i < this.RouteMercData.MerchToDayRouteList.length; i++) {
      if (this.RouteMercData.MerchToDayRouteList[i].GSN == val.merch.GSN) {
        switch (val.dayOfWeek) {
          case 1:
            this.RouteMercData.MerchToDayRouteList[i].Sunday = dayRoute;
            this.RouteMercData.RouteToAssigne.Sunday.splice(0, 0, routeTA);
            break;
          case 2:
            this.RouteMercData.MerchToDayRouteList[i].Monday = dayRoute;
            this.RouteMercData.RouteToAssigne.Monday.splice(0, 0, routeTA);
            break;
          case 3:
            this.RouteMercData.MerchToDayRouteList[i].Tuesday = dayRoute;
            this.RouteMercData.RouteToAssigne.Tuesday.splice(0, 0, routeTA);
            break;
          case 4:
            this.RouteMercData.MerchToDayRouteList[i].Wednesday = dayRoute;
            this.RouteMercData.RouteToAssigne.Wednesday.splice(0, 0, routeTA);
            break;
          case 5:
            this.RouteMercData.MerchToDayRouteList[i].Thursday = dayRoute;
            this.RouteMercData.RouteToAssigne.Thursday.splice(0, 0, routeTA);
            break;
          case 6:
            this.RouteMercData.MerchToDayRouteList[i].Friday = dayRoute;
            this.RouteMercData.RouteToAssigne.Friday.splice(0, 0, routeTA);
            break;
          case 7:
            this.RouteMercData.MerchToDayRouteList[i].Saturday = dayRoute;
            this.RouteMercData.RouteToAssigne.Saturday.splice(0, 0, routeTA);
            break;

        }
        break;
      }
    }


    //this is database delete call - maybe goiing to drop 
    this.deleteRouteMerchandiser(val.routeID, val.dayOfWeek, val.merch.GSN)

  }


  updateRouteToAssigne(routeToAssigne, routeToDayMerch) {

    let _updateRouteToAssigne = [];

    for (let i = 0; i < routeToAssigne.length; i++) {

      if (routeToAssigne[i].RouteID != routeToDayMerch.RouteID) {
        _updateRouteToAssigne.push(routeToAssigne[i]);
      }

    }
    return _updateRouteToAssigne;
  }


  updateMerchToDayRouteList(merchToDayRoute, routeToDayMerch) {
    //debugger;

    let updateMerchToDayRoute: any = merchToDayRoute;

    updateMerchToDayRoute.RouteID = routeToDayMerch.RouteID;
    updateMerchToDayRoute.RouteName = routeToDayMerch.RouteName;
    updateMerchToDayRoute.DayOfWeek = routeToDayMerch.DayOfWeek;
    updateMerchToDayRoute.isRouteAssigned = true;

    return updateMerchToDayRoute

  }

  onAddMerchandiser(val: any) {

    //debugger;
    let _dayOfWeek = val.dayOfWeek;
    let _merchandiser = val.merchandiser;
    let _routeToDayMerch = val.routeToDayMerch;
    let availableRoute: any;


    switch (val.dayOfWeek) {
      case 1:
        availableRoute = this.RouteMercData.RouteToAssigne.Sunday;
        this.RouteMercData.RouteToAssigne.Sunday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch)
        break;
      case 2:
        availableRoute = this.RouteMercData.RouteToAssigne.Monday;
        this.RouteMercData.RouteToAssigne.Monday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch)
        break;
      case 3:
        availableRoute = this.RouteMercData.RouteToAssigne.Tuesday;
        this.RouteMercData.RouteToAssigne.Tuesday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch)
        break;
      case 4:
        availableRoute = this.RouteMercData.RouteToAssigne.Wednesday;
        this.RouteMercData.RouteToAssigne.Wednesday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch)
        break;
      case 5:
        availableRoute = this.RouteMercData.RouteToAssigne.Thursday;
        this.RouteMercData.RouteToAssigne.Thursday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch)
        break;
      case 6:
        availableRoute = this.RouteMercData.RouteToAssigne.Friday;
        this.RouteMercData.RouteToAssigne.Friday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch)
        break;
      case 7:
        availableRoute = this.RouteMercData.RouteToAssigne.Saturday;
        this.RouteMercData.RouteToAssigne.Saturday = this.updateRouteToAssigne(availableRoute, _routeToDayMerch)
        break;

    }


    for (let i = 0; i < this.RouteMercData.MerchToDayRouteList.length; i++) {
      if (this.RouteMercData.MerchToDayRouteList[i].GSN == _merchandiser.GSN) {

        let merchToDayRoute: any;

        switch (val.dayOfWeek) {
          case 1:
            merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Sunday;
            this.RouteMercData.MerchToDayRouteList[i].Sunday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
            break;
          case 2:
            merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Monday;
            this.RouteMercData.MerchToDayRouteList[i].Monday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
            break;
          case 3:
            merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Tuesday;
            this.RouteMercData.MerchToDayRouteList[i].Tuesday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
            break;
          case 4:
            merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Wednesday;
            this.RouteMercData.MerchToDayRouteList[i].Wednesday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
            break;
          case 5:
            merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Thursday;
            this.RouteMercData.MerchToDayRouteList[i].Thursday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
            break;
          case 6:
            merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Friday;
            this.RouteMercData.MerchToDayRouteList[i].Friday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
            break;
          case 7:
            merchToDayRoute = this.RouteMercData.MerchToDayRouteList[i].Saturday;
            this.RouteMercData.MerchToDayRouteList[i].Saturday = this.updateMerchToDayRouteList(merchToDayRoute, _routeToDayMerch);
            break;

        }


        break;
      }

    }


    this.addRouteMerchandiser(_routeToDayMerch.RouteID, _dayOfWeek, _merchandiser.GSN)

  }



  constructor(private monitorService: MonitorService, public navService: HeadernavService) {
    // this.getRouteMercDataStatic();
    // this.getRouteMercData(101);
  }

  private stopRefreshing() {
    this.isRequesting = false;
  }

  ngOnInit() {
    this.subscription = this.navService.navItem$.subscribe(item => { this.item = item; this.loadRouteMercData(this.item); });
  }


  ngOnDestroy() {
    // prevent memory leak when component is destroyed
    this.subscription.unsubscribe();
  }

  loadRouteMercData(item: MerchGroup) {
    this.item = item;
    if (this.item != null || this.item != undefined) {
      this.getRouteMercData();
    }

  }



  //------------------------------------database/service 

  deleteRouteMerchandiser(routeID: number, dayOfWeek: number, GSN: string) {    // debugger
    this.editRouteMerchandiser(routeID, dayOfWeek, GSN, true);
  }

  addRouteMerchandiser(routeID: number, dayOfWeek: number, GSN: string) {    //  debugger
    this.editRouteMerchandiser(routeID, dayOfWeek, GSN, false);
  }


  editRouteMerchandiser(routeID: number, dayOfWeek: number, GSN: string, isForDelete: Boolean) {
    // isForDelete - if only to delete record than set as true, other wise it add a record, before add it delete exit record, record is as below  
    //  RouteID	DayOfWeek	GSN	LastModified	LastModifiedBy
    // 10120	1	ARMDZ001	2016-06-09 16:00:56.0083365	System
    // debugger
    let result = {};
    this.isRequesting = true;
    this.monitorService.editRouteMerchandiser(routeID, dayOfWeek, GSN, isForDelete)
      .subscribe(res => {
        var data: any[] = res.json();
        result = data;

      },
      () => this.stopRefreshing(),
      () => this.stopRefreshing()
      );
  }



  getRouteMercData() {


    this.msgText_MerchToDayRouteList = "";
    this.msgText_RouteToDayMerchList = "";
    this.errText = "";
    
    //  debugger
    if (this.item.MerchGroupID != undefined || this.item.MerchGroupID != null)
    {    
        this.isRequesting = true;
          this.monitorService.getRouteMerchandiserByMerchGroupID(this.item.MerchGroupID)
            .subscribe(res => {
              var data: any[] = res.json();
              this.RouteMercData = data;
              this.errText = "";
              if (this.RouteMercData.MerchToDayRouteList.length <= 0) {
                this.msgText_MerchToDayRouteList = "No data found";
              }

              if (this.RouteMercData.RouteToDayMerchList.length <= 0) {
                this.msgText_RouteToDayMerchList = "No data found";
              }

            },
            () => this.stopRefreshing(),
            () => this.stopRefreshing()
            );
    }
  }

  //below to remove latter on  
  getRouteMercDataStatic() {

    //  debugger

    this.RouteMercData = {};



  }
  //end of get method

}