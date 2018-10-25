
import { NgModule, ErrorHandler} from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import {ModalModule, TabsModule, DropdownModule} from 'ng2-bootstrap/ng2-bootstrap';
import { DatePickerModule, DatePickerOptions} from 'ng2-datepicker/ng2-datepicker';

import {DndModule} from 'ng2-dnd';
import {merchrouting} from './common/header-route-providers';
import { LocationStrategy, HashLocationStrategy } from '@angular/common';
import { MerchExceptionHandler, MerchLogger } from './common/ExceptionHandler/MerchExceptionHandler';
//import {ExceptionHandler }  from '@angular/core';
import {Ng2Webstorage } from 'ng2-webstorage';
import {IDLE_PROVIDERS } from 'ng2-idle/core';
import {GridModule } from '@progress/kendo-angular-grid';

import { MerchAppComponent } from './app.component';
import { MercMainComponent }    from './merc-main';

import {FilterPipe} from './pipes/filter.pipe';
//import { DispserviceService } from './services/dispservice.service';
import { RouteComponent} from './common/route/'

import {HeaderComponent} from './common/header';
import {FooterComponent} from './common/footer';


import {MerchConstant} from './MerchAppConstant';

//import { HeadernavService } from './services/headernav.service';

//import { StorelistPopupComponent } from './planning/StoreSetup/storelist-popup';

import {TabsComponent} from './common/tabs/';

import {AddstoreComponent} from './common/addstore/';
import {StorereassignComponent} from './common/storereassign/';
import {MerchreassignComponent} from './common/merchreassign/';
import {StorelistComponent} from './common/storelist/';
//siraj
import { RouteInfoComponent } from './dispatch/route-info';
import { RouteItemComponent } from './dispatch/route-item';
import {ImageListComponent} from './dispatch/image-list';
import { DispatchComponent }  from './dispatch';
import {  MonitorPopupComponent} from './dispatch/monitor-popup';
//import {  MonitorService} from './services/monitor.service';

import {    DispatchRowComponent} from './dispatch/dispatch-row';


import{PlMerchPopupComponent } from './pl-merch/pl-merch-popup';

import { PlRouteSelectComponent } from './pl-merch/pl-route-select';
import { PlMerchInfoComponent } from './pl-merch/pl-merch-info';
import { PlMerchItemComponent } from './pl-merch/pl-merch-item';
import {  PlRoutePopupComponent} from './pl-merch/pl-route-popup'
import { PlMerchInfoSelectComponent } from './pl-merch/pl-merch-info-select';
import { PlRouteInfoComponent } from './pl-merch/pl-route-info';
import { PlRouteItemComponent } from './pl-merch/pl-route-item';

import {  PlMerchRowComponent} from './pl-merch/pl-merch-row';
import {  PlRouteRowComponent} from './pl-merch/pl-route-row';
import { PlMerchComponent }   from './pl-merch';



import { PhotoBooth } from './common/photo/photo-booth';
import { SpinnerComponent } from './common/spinner';
import {MultiselectDropdown} from './reporting/StoreService/multiselect-dropdown';
import { RptstoreserviceComponent } from './reporting/rptstoreservice/rptstoreservice.component';
import { RptmileageComponent } from './reporting/rptmileage/rptmileage.component';


import { MerchsetupmainComponent } from './planning/MerchSetup/merchsetupmain';
import { AddmerchpopupComponent } from './planning/MerchSetup/addmerchpopup';
import { MerchlistComponent } from './planning/MerchSetup/merchlist';
import { MerchdetailComponent } from './planning/MerchSetup/merchdetail';
import { AddmerchComponent } from './planning/MerchSetup/addmerch';

import {StoresetupMainComponent} from './planning/StoreSetup/storesetup-main';
import {StorelistPopupComponent} from './planning/StoreSetup/storelist-popup';
import {StoreitemComponent} from './planning/StoreSetup/storeitem';
import {StoredetailComponent} from './planning/StoreSetup/storedetail';
import {StoresListComponent} from './planning/StoreSetup/stores-list';

import {Ng2MapModule} from 'ng2-map/dist' 

import {MaskDirective} from './directives/mask.directive';

 import {Ng2AutoCompleteModule } from 'ng2-auto-complete';
 import {CreateMerchGroupComponent} from './planning/create-merch-group';

 import {RsaddstoreComponent} from './planning/rsaddstore';
 import {RsassignmentComponent} from './planning/rsassignment';
 import { RsrouteComponent} from './planning/rsroute';
 import { RsstorelistComponent } from './planning/rsstorelist';
 import { RsstorereassignComponent } from './planning/rsstorereassign';
 import { RstabsComponent} from './planning/rstabs';
 import { IpStoreDetailsComponent } from './dispatch/ip-store-details';
 import { IpMainComponent } from './dispatch/ip-main';
import { MobileMerchMainComponent } from './mobile-merch-main/mobile-merch-main.component';
import { MobileRouteComponent } from './common/mobile-route/mobile-route.component';
import { MobileMerchreassignComponent } from './common/mobile-merchreassign/mobile-merchreassign.component';
import { MobileAddstoreComponent } from './common/mobile-addstore/mobile-addstore.component';
import { MobileStorereassignComponent } from './common/mobile-storereassign/mobile-storereassign.component';
import { MobileTabsComponent } from './common/mobile-tabs/mobile-tabs.component';
import { MobileStorelistComponent } from './common/mobile-storelist/mobile-storelist.component';
import { MonitorPopup2Component } from './dispatch/monitor-popup2/monitor-popup2.component';
import { IpStoreDetails2Component } from './dispatch/ip-store-details2/ip-store-details2.component';


@NgModule({
  declarations: [
      MerchAppComponent, FilterPipe,MercMainComponent,HeaderComponent, FooterComponent, RouteComponent,TabsComponent,AddstoreComponent,
      StorereassignComponent,  MerchreassignComponent,StorelistComponent,SpinnerComponent,
      DispatchComponent,RouteInfoComponent, RouteItemComponent,ImageListComponent,MonitorPopupComponent,DispatchRowComponent,PlMerchPopupComponent,PlRouteSelectComponent,
      PlMerchInfoComponent,PlMerchItemComponent,PlRoutePopupComponent,PlMerchInfoSelectComponent,PlRouteInfoComponent,PlRouteItemComponent,PlMerchRowComponent,
      PlRouteRowComponent,PlMerchComponent, RptmileageComponent, MultiselectDropdown, RptstoreserviceComponent
      ,PhotoBooth
      ,MerchsetupmainComponent, AddmerchpopupComponent, MerchlistComponent,MerchdetailComponent, AddmerchComponent
      , StoresetupMainComponent, StorelistPopupComponent, StoreitemComponent, StoredetailComponent, StoresListComponent
      , RsaddstoreComponent, RsassignmentComponent, RsrouteComponent, RsstorelistComponent, RsstorereassignComponent, RstabsComponent
      , CreateMerchGroupComponent
      , MaskDirective, IpMainComponent, IpStoreDetailsComponent, MobileMerchMainComponent, MobileRouteComponent, MobileMerchreassignComponent, MobileAddstoreComponent, MobileStorereassignComponent, MobileTabsComponent, MobileStorelistComponent, MonitorPopup2Component, IpStoreDetails2Component
     
  ],
  imports: [
    ModalModule, TabsModule, DropdownModule,
    BrowserModule,
    DndModule.forRoot(),
    FormsModule, 
    
    ReactiveFormsModule,  
    merchrouting,
      HttpModule,
      Ng2Webstorage,
      GridModule,
      Ng2MapModule,
      Ng2AutoCompleteModule,
      DatePickerModule
   
  ],
    providers: [IDLE_PROVIDERS, { provide: ErrorHandler, useClass: MerchExceptionHandler }],
    entryComponents: [MerchAppComponent],
    bootstrap: [MerchAppComponent]
})
export class AppModule { }

