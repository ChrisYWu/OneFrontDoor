import { Routes, RouterModule } from '@angular/router';
import { DispatchComponent }  from '../../dispatch';
import { MercMainComponent }    from '../../merc-main';
import { AuthGuardService } from '../../services/auth-guard.service';
import { PlMerchComponent }   from '../../pl-merch';
import { RptmileageComponent } from '../../reporting/rptmileage/rptmileage.component';
import { RptstoreserviceComponent } from '../../reporting/rptstoreservice/rptstoreservice.component';
import { MerchsetupmainComponent } from '../../planning/MerchSetup/merchsetupmain';
import { StoresetupMainComponent }  from '../../planning/StoreSetup/storesetup-main';
import { RsassignmentComponent }  from '../../planning/rsassignment';
import { CreateMerchGroupComponent }  from '../../planning/create-merch-group';
import { MobileMerchMainComponent } from '../../mobile-merch-main/mobile-merch-main.component';


const routes: Routes = [
    { path: '', component: DispatchComponent },
    { path: 'merchandise', component: MercMainComponent, canActivate: [AuthGuardService] },
    { path: 'monitor', component: DispatchComponent },
    { path: 'plmerch', component: PlMerchComponent, canActivate: [AuthGuardService] },
    { path: 'rptnewmileage', component: RptmileageComponent, canActivate: [AuthGuardService] },
    {path: 'rptnewstoreservice', component:RptstoreserviceComponent, canActivate: [AuthGuardService]},
    { path: 'plnmerchsetup', component: MerchsetupmainComponent, canActivate: [AuthGuardService] },
    { path: 'plnstore', component: StoresetupMainComponent, canActivate: [AuthGuardService] },
     { path: 'plnrsassignment', component: RsassignmentComponent, canActivate: [AuthGuardService] },
    { path: 'plnmerchgroup', component: CreateMerchGroupComponent, canActivate: [AuthGuardService] },
    { path: 'mobileschedule', component: MobileMerchMainComponent, canActivate: [AuthGuardService] },
    
 
];



export const merchrouting = RouterModule.forRoot(routes,{ useHash: true });
