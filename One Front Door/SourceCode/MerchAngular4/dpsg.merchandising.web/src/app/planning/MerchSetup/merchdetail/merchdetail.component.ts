import { Component, OnInit, Input, Output, EventEmitter,ViewChild} from '@angular/core';
//import {CORE_DIRECTIVES} from '@angular/common';
//import { DROPDOWN_DIRECTIVES} from 'ng2-bootstrap/ng2-bootstrap';
import {ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import { DispserviceService } from '../../../services/dispservice.service';
import {MerchConstant} from '../../../../app/MerchAppConstant';
//import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS} from 'ng2-bootstrap/ng2-bootstrap';
import { MerchInfo, RouteData, MerchGroup, MerchSetupDetailInput,RouteMerchandiser, RoutesByDayInput} from '../MerchSetupClass';


@Component({
 //moduleId: module.id,
  selector: 'app-merchdetail',
  templateUrl: 'merchdetail.component.html',
  styleUrls: ['merchdetail.component.css'],
  providers: [DispserviceService],
 // directives: [CORE_DIRECTIVES, DROPDOWN_DIRECTIVES, MODAL_DIRECTIVES],
  //viewProviders: [BS_VIEW_PROVIDERS]
})
export class MerchdetailComponent implements OnInit {

  public routeList: Array<any>;
  @Input() routeListAll: Array<any>;
  public routeListByDay: Array<RouteData> = new Array<RouteData>();
  public disabled: boolean = false;
  public status: { isopen: boolean } = { isopen: false };
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  @Input() selectedRoute: RouteData;  
  
  @Input() selectedRouteMon: RouteData; 
  @Input() selectedRouteTue: RouteData; 
  @Input() selectedRouteWed: RouteData; 
  @Input() selectedRouteThu: RouteData; 
  @Input() selectedRouteFri: RouteData; 
  @Input() selectedRouteSat: RouteData; 
  @Input() selectedRouteSun: RouteData; 

  @Input() ShowSaveMsg: boolean = false;
  @Output() refreshList = new EventEmitter();
  @Input() MerchGroupItem: MerchGroup;
  @Output() cancelDetail = new EventEmitter();

  @Input() merchSelectedInfo: MerchInfo;

  public merchInput: MerchSetupDetailInput;
  public merchPhone: string;
  public routeMerches: Array<RouteMerchandiser>;
 @ViewChild('detailModal') detailModal: ModalDirective;
  constructor(private dispService: DispserviceService) { }



public getChrOfMerchName(name:string)
{  
   let chr = "-";
 
   if ((name != null) && (name.trim().length  > 0))
   {
    chr = name.trim().charAt(0) ;
   }
   return chr ;
}

 onInputChange(event:KeyboardEvent){                
        var key:string = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        let sc_REGEXP = '^[0-9 ]*$';
        var reg = new RegExp(sc_REGEXP)   

              if (!reg.test(key)) {
                    event.preventDefault();
                    return false;
                }
          
    }

  public toggled($event: MouseEvent, dayofweek:number): void {
    if($event)
    this.getRouteByDay(dayofweek);
    // if($event && this.merchSelectedInfo.Thu)
    // {

    // }
    // else{
    //   return false;
    // }

  }

  public toggledDefaultRoute($event:MouseEvent):void{
     this.getAvailableDefaultRoutes();
  }

  public toggleDropdown($event: MouseEvent): void {
    $event.preventDefault();
    $event.stopPropagation();
    this.status.isopen = !this.status.isopen;
  }

  onChecked(day:string)
  {
    if(day=='Mon')
    {
       if(!this.merchSelectedInfo.Mon)
       {
         this.selectedRouteMon = new RouteData(-1,'No Default Route');
       }
       else
       {
         this.selectedRouteMon = this.selectedRoute;
       }
    } 
    
    if(day=='Tue')
    {
       if(!this.merchSelectedInfo.Tues)
       {
         this.selectedRouteTue = new RouteData(-1,'No Default Route');
       }
       else
       {
         this.selectedRouteTue = this.selectedRoute;
       }
    } 

    if(day=='Wed')
    {
       if(!this.merchSelectedInfo.Wed)
       {
         this.selectedRouteWed = new RouteData(-1,'No Default Route');
       }
       else
       {
         this.selectedRouteWed = this.selectedRoute;
       }
    } 
    
    if(day=='Thu')
    {
       if(!this.merchSelectedInfo.Thu)
       {
         this.selectedRouteThu = new RouteData(-1,'No Default Route');
       }
       else
       {
         this.selectedRouteThu = this.selectedRoute;
       }
    } 

    if(day=='Fri')
    {
       if(!this.merchSelectedInfo.Fri)
       {
         this.selectedRouteFri = new RouteData(-1,'No Default Route');
       }
       else
       {
         this.selectedRouteFri = this.selectedRoute;
       }
    } 

    if(day=='Sat')
    {
       if(!this.merchSelectedInfo.Sat)
       {
         this.selectedRouteSat = new RouteData(-1,'No Default Route');
       }
       else
       {
         this.selectedRouteSat = this.selectedRoute;
       }
    } 

    if(day=='Sun')
    {
       if(!this.merchSelectedInfo.Sun)
       {
         this.selectedRouteSun = new RouteData(-1,'No Default Route');
       }
       else
       {
         this.selectedRouteSun = this.selectedRoute;
       }
    } 
  }

  onSelectRoute(route: any) {

    this.selectedRoute = route;

    if(this.merchSelectedInfo.Mon)
    {
      this.selectedRouteMon = this.selectedRoute;
    }

    if(this.merchSelectedInfo.Tues)
    {
      this.selectedRouteTue = this.selectedRoute;
    }

    if(this.merchSelectedInfo.Wed)
    {
      this.selectedRouteWed = this.selectedRoute;
    }

    if(this.merchSelectedInfo.Thu)
    {
      this.selectedRouteThu = this.selectedRoute;
    }

    if(this.merchSelectedInfo.Fri)
    {
      this.selectedRouteFri = this.selectedRoute;
    }

    if(this.merchSelectedInfo.Sat)
    {
      this.selectedRouteSat = this.selectedRoute;
    }

    if(this.merchSelectedInfo.Sun)
    {
      this.selectedRouteSun = this.selectedRoute;
    }


  }
 

  onSelectRouteWeek(route: any, day:string) {    
    
    if(day=='')
    {
      this.selectedRoute = route;  
    }
    else if(day=='Mon')
    {
      this.selectedRouteMon = route;
    }
    else if(day=='Tue')
    {
      this.selectedRouteTue = route;
    }
    else if(day=='Wed')
    {
      this.selectedRouteWed = route;
    }
    else if(day=='Thu')
    {
      this.selectedRouteThu = route;
    }
    else if(day=='Fri')
    {
      this.selectedRouteFri = route;
    }
    else if(day=='Sat')
    {
      this.selectedRouteSat = route;
    }
    else if(day=='Sun')
    {
      this.selectedRouteSun = route;
    }

  }
 

  onCancel() {
    this.cancelDetail.emit({});
  }

  onMerchMainSave()
  {
    if(this.selectedRoute.RouteID==-1)
    {
         this.detailModal.show();
    }
    else
    {
       this.onSave(); 
    }
  }

  onSave() {
    this.merchInput = new MerchSetupDetailInput(this.merchSelectedInfo.GSN, this.merchSelectedInfo.MerchName,
                      this.merchSelectedInfo.FirstName, this.merchSelectedInfo.LastName, this.selectedRoute.RouteID,
                      this.selectedRouteMon.RouteID,this.selectedRouteTue.RouteID,this.selectedRouteWed.RouteID,this.selectedRouteThu.RouteID,
                      this.selectedRouteFri.RouteID,this.selectedRouteSat.RouteID,this.selectedRouteSun.RouteID,
                      this.MerchGroupItem.MerchGroupID, this.merchSelectedInfo.Phone, this.merchSelectedInfo.Mon,
                      this.merchSelectedInfo.Tues, this.merchSelectedInfo.Wed, this.merchSelectedInfo.Thu, this.merchSelectedInfo.Fri,
                      this.merchSelectedInfo.Sat, this.merchSelectedInfo.Sun, this.MerchGroupItem.LoggedInUser);

    this.insertMerchSetUpData(this.merchInput);

  }

  SetMonSunRouteMerch()
  {
     for(let item of this.routeMerches)
     {
       if(item.DayOfWeek == 1)
       {
          this.selectedRouteSun.RouteID = item.RouteID;
          this.selectedRouteSun.RouteName = item.RouteName;
       }
       else  if(item.DayOfWeek == 2)
       {
          this.selectedRouteMon.RouteID = item.RouteID;
          this.selectedRouteMon.RouteName = item.RouteName;
       }
       else  if(item.DayOfWeek == 3)
       {
          this.selectedRouteTue.RouteID = item.RouteID;
          this.selectedRouteTue.RouteName = item.RouteName;
       }
       else  if(item.DayOfWeek == 4)
       {
          this.selectedRouteWed.RouteID = item.RouteID;
          this.selectedRouteWed.RouteName = item.RouteName;
       }
       else  if(item.DayOfWeek == 5)
       {
          this.selectedRouteThu.RouteID = item.RouteID;
          this.selectedRouteThu.RouteName = item.RouteName;
       }
       else  if(item.DayOfWeek == 6)
       {
          this.selectedRouteFri.RouteID = item.RouteID;
          this.selectedRouteFri.RouteName = item.RouteName;
       }
       else  if(item.DayOfWeek == 7)
       {
          this.selectedRouteSat.RouteID = item.RouteID;
          this.selectedRouteSat.RouteName = item.RouteName;
       }
     }              
  }

     getRouteByDay(dayofWeek: number) {
        
        this.dispService.set(this._webapi + 'api/Merc/GetRoutesByDay/');
        var routeByDayInput: RoutesByDayInput = new RoutesByDayInput(this.MerchGroupItem.SAPBranchID,this.MerchGroupItem.MerchGroupID,dayofWeek);
        this.dispService.post(JSON.stringify(routeByDayInput), true)
            .subscribe(res => {
                var d: any = res;
                this.routeListByDay = d.Routes;
                
            },
            error => {
            if (error.status == 401 || error.status == 404) {
            }
          });
    }

      getAvailableDefaultRoutes() {
        
        this.dispService.set(this._webapi + 'api/Merc/GetAvailableDefaultRoutes/');
        var MerchListInput: any = { SAPBranchID: this.MerchGroupItem.SAPBranchID, MerchGroupID: this.MerchGroupItem.MerchGroupID }
        
        this.dispService.post(JSON.stringify(MerchListInput), true)
            .subscribe(res => {
                var d: any = res;
                this.routeList = d.Routes;
                
            },
            error => {
            if (error.status == 401 || error.status == 404) {
            }
          });
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
