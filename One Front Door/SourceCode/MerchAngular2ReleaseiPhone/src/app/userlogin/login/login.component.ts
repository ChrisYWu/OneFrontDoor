import { Component, OnInit } from '@angular/core';
import { Http, Headers, Response, RequestOptions } from '@angular/http';
import {MerchConstant} from '../../../app/MerchAppConstant';
import { Observable }     from 'rxjs/Observable';
import {LocalStorageService} from 'ng2-webstorage';
import {Idle, DEFAULT_INTERRUPTSOURCES} from 'ng2-idle/core';

@Component({
  //moduleId: module.id,
  selector: 'app-login',
  templateUrl: 'login.component.html',
  styleUrls: ['login.component.css'] //,
 // providers: ['LocalStorageService', NG2_WEBSTORAGE]

})
export class LoginComponent implements OnInit {

  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
 // @SessionStorage() public UserName: string = "";
   

constructor(public http: Http, public localSt: LocalStorageService, public idle: Idle) {
    // let _build = (<any> http)._backend._browserXHR.build;
    // (<any> http)._backend._browserXHR.build = () => {
    //     let _xhr =  _build();
    //     _xhr.withCredentials = true;
    //     return _xhr;
    // };

    this.localSt.store('UserGSN', 'TIWNX001');  
    console.log(this.localSt.retrieve('UserGSN'));

    idle.setIdle(50000);
    idle.setTimeout(50000);
    idle.setInterrupts(DEFAULT_INTERRUPTSOURCES);

    idle.onIdleStart.subscribe(() => {
      console.log('IdleStart');
    });

    idle.onIdleEnd.subscribe(() => {
      console.log('IdleEnd');
    });

    idle.onTimeoutWarning.subscribe((countdown:number) => {
      console.log('TimeoutWarning: ' + countdown);
    });

    idle.onTimeout.subscribe(() => {
      console.log('Timeout');
    });

   idle.watch();
    
  }

  ngOnInit() {

    this.checkUserAuth();
    //this.sendRequest();
  // this.localSt.observe('key')
  //           .subscribe((value) => console.log('new value', value));

  }

  checkUserAuth(): void {
        this.WebAPIPostCall().subscribe(res => {
                var d: any = res;
                if (d.UserInfo.IsValid == 1)
                {
                  this.localSt.store('UserGSN', d.UserInfo.GSN);
                  this.localSt.store('UserName', d.UserInfo.Name);
                  this.localSt.store('UserEmail', d.UserInfo.Email);  

                    console.log(this.localSt.retrieve('UserGSN'));
                    console.log(this.localSt.retrieve('UserName'));
                    console.log(this.localSt.retrieve('UserEmail'));
                }
                else{
                    console.log("User is not valid");
                }                 
               
            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });  
       }

  WebAPIPostCall()
      {
      // let headers = new Headers({ 'Content-Type': 'application/json' });
      //   let options = new RequestOptions({
      //   headers: headers
      //  // , withCredentials: true
      //   });
      //   let body :string = '';
      //   return this.http.post(this._webapi + 'api/Merc/CheckAuthentication/', body, options)
      //   .map((res: Response) => res.json());
      //   //.subscribe(res => {this.result = res;});

      //   // headers.append('Content-Type', 'application/json');
        return this.http.get(this._webapi + 'api/Merc/CheckAuthentication/', {withCredentials:true})
                      .map(response => <any>(<Response>response).json());
      }

  // sendRequest() {
  //   return this.http.get('http://bplnshp02:2000/MerchPortalWebAPI/api/Merc/CheckAuthentication/', { withCredentials:true})
  //         .map((res: Response) => res.json());
  //        // .subscribe(res => {this.result = res;});
  //       // .toPromise()
  //       // .then(response => response.json().data);
  // }


}

