import { Routes, RouterModule } from '@angular/router';

import { DispatchComponent }  from '../../dispatch';
import { MercMainComponent }    from '../../merc-main';
// import { StoreserviceComponent  }    from '../../reporting/storeservice';
// import { MileageComponent  }    from '../../reporting/mileage';

// import { RsassignmentComponent }  from '../../planning/rsassignment';

import { PhotoComponent }  from '../photo';
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
    { path: 'merchandise', component: MercMainComponent },
    { path: 'monitor', component: DispatchComponent },
    { path: 'plmerch', component: PlMerchComponent },
    { path: 'rptnewmileage', component: RptmileageComponent },
    {path: 'rptnewstoreservice', component:RptstoreserviceComponent},
    { path: 'plnmerchsetup', component: MerchsetupmainComponent },
    { path: 'plnstore', component: StoresetupMainComponent },
     { path: 'plnrsassignment', component: RsassignmentComponent },
    { path: 'plnmerchgroup', component: CreateMerchGroupComponent },
    { path: 'mobileschedule', component: MobileMerchMainComponent },
    
 
];

// export const headerRouteProviders = [
//     provideRouter(routes)
// ];

export const merchrouting = RouterModule.forRoot(routes,{ useHash: true });
