import { Injectable } from '@angular/core';
import {BehaviorSubject } from 'rxjs/BehaviorSubject';
import {MerchGroup} from '../services/planning';

@Injectable()
export class HeadernavService {
  static instance : HeadernavService;
 
  public navItemSource = new BehaviorSubject<MerchGroup>(new MerchGroup());
  public navItem$ = this.navItemSource.asObservable();

  public navMerchSource = new BehaviorSubject<MerchGroup>(new MerchGroup());
  public navMerchItem$ = this.navMerchSource.asObservable();

  changeNav(number)
  {
    
    this.navItemSource.next(number);
  }

  changeToaddMerchGroup(item)
  {
     this.navMerchSource.next(item);
  }

  constructor() {
   return HeadernavService.instance = HeadernavService.instance || this;
  }

}
