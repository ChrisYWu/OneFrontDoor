import { bootstrap } from '@angular/platform-browser-dynamic';
import { enableProdMode, provide } from '@angular/core';
import {  } from '@angular/forms';
import {DND_PROVIDERS} from 'ng2-dnd/ng2-dnd';
import { MerchAppComponent, environment } from './app';
import { HTTP_PROVIDERS } from '@angular/http';
import {headerRouteProviders} from './app/common/header-route-providers/';
import {LocationStrategy, HashLocationStrategy} from '@angular/common';
import { MerchExceptionHandler, MerchLogger } from './app/common/ExceptionHandler/MerchExceptionHandler';
import {ExceptionHandler}  from '@angular/core';
import {NG2_WEBSTORAGE} from 'ng2-webstorage';
import {IDLE_PROVIDERS} from 'ng2-idle/core';


//if (environment.production) {
    enableProdMode();
//}

bootstrap
 (
    MerchAppComponent, 
    [
        HTTP_PROVIDERS,
        headerRouteProviders,
        DND_PROVIDERS,
        MerchLogger,
        provide(ExceptionHandler, { useClass: MerchExceptionHandler })
        ,{provide: LocationStrategy, useClass: HashLocationStrategy}  
        ,[NG2_WEBSTORAGE]
        ,IDLE_PROVIDERS
    ]
 ).catch(err => console.error(err));
