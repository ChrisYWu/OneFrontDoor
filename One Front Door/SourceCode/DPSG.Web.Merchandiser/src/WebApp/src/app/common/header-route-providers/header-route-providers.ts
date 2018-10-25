import { provideRouter, RouterConfig } from '@angular/router';

import { DispatchComponent }  from '../../dispatch';
import { MercMainComponent }    from '../../merc-main';
import { StoreserviceComponent  }    from '../../reporting/storeservice';
import { MileageComponent  }    from '../../reporting/mileage';
import { CreateMerchGroupComponent }  from '../../planning/create-merch-group';
import { RsassignmentComponent }  from '../../planning/rsassignment';
import { StoresetupMainComponent }  from '../../planning/StoreSetup/storesetup-main';
import { PhotoComponent }  from '../photo';
import { PlMerchComponent }   from '../../pl-merch';
import { MerchsetupmainComponent } from '../../planning/MerchSetup/merchsetupmain';
// import {} from ''


const routes: RouterConfig = [
    { path: '', component: DispatchComponent },
    { path: 'merchandise', component: MercMainComponent },
    
    { path: 'monitor', component: DispatchComponent },
    { path: 'plmerch', component: PlMerchComponent },
    
    { path: 'rptstoreservice', component: StoreserviceComponent },
    { path: 'rptmileage', component: MileageComponent },
    
    { path: 'plnmerchgroup', component: CreateMerchGroupComponent },
    { path: 'plnmerchsetup', component: MerchsetupmainComponent },

    { path: 'plnrsassignment', component: RsassignmentComponent },
    { path: 'plnstore', component: StoresetupMainComponent },

    { path: 'playphoto', component: PhotoComponent }

];

export const headerRouteProviders = [
    provideRouter(routes)
];

