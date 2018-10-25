import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot } from '@angular/router';
import { LocalStorageService } from 'ng2-webstorage';
import { UserAuthorization} from './userauthorized';


@Injectable()
export class AuthGuardService implements CanActivate {
  private isAuthorized:boolean;
  

  constructor(private localSt: LocalStorageService, public router: Router) { }
  
  canActivate(route: ActivatedRouteSnapshot): boolean {
    
    if (this.localSt != null) {
        
      if (this.localSt.retrieve('IsAuthorized') != null) {
        this.isAuthorized = this.localSt.retrieve('IsAuthorized');
        
        var result:boolean = this.isAccessible(route.routeConfig.path);

        if (!result)
          window.location.href = "/";

        return result;

      }
    }

  }

  isAccessible(cmp: string) {
 
    if (cmp == 'monitor')
    {
      return true;
    }
    else if (cmp == 'rptnewmileage')
    {
      return true;
    }
    else if (cmp == 'rptnewstoreservice')
    {
      return true;
    }
    else if (cmp == 'merchandise' && this.isAuthorized)
    {
        return true;
    }
    else if (cmp == 'plmerch' && this.isAuthorized)
    {
        return true;
    }
    else if (cmp == 'plnmerchsetup' && this.isAuthorized)
    {
        return true;
    }
    else if (cmp == 'plnstore' && this.isAuthorized)
    {
        return true;
    }
    else if (cmp == 'plnrsassignment' && this.isAuthorized)
    {
        return true;
    }
    else if (cmp == 'plnmerchgroup' && this.isAuthorized)
    {
        return true;
    }
    else if (cmp == 'mobileschedule' && this.isAuthorized)
    {
        return true;
    }
    else
    {
      return false;
    }

  }

  // canLoad(route: Route): boolean {
  //   let url = `/${route.path}`;

  //   if (this.sessionSt != null) {

  //     if (this.sessionSt.retrieve('UserDetail')) {
  //       this.user = this.sessionSt.retrieve('UserDetail');
  //       this.userAccess = this.user.UserAccess;

  //       var result = false;

  //       result = this.isAccessible(route.data.expectedTeam);

  //       return result;

  //     }
  //   }

  // }


}
