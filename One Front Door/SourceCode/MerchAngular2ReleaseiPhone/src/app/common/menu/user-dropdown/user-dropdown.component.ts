import { Component, OnInit } from '@angular/core';
import { Http, Headers, Response, RequestOptions } from '@angular/http';
import {LocalStorageService} from 'ng2-webstorage';
import {Idle, DEFAULT_INTERRUPTSOURCES} from 'ng2-idle/core';
import {MerchConstant} from '../../../../app/MerchAppConstant';

@Component({
  //moduleId: module.id,
  selector: 'user-dropdown',
  templateUrl: 'user-dropdown.component.html',
  styleUrls: ['user-dropdown.component.css']
})
export class UserDropdownComponent implements OnInit {
  
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  public userName:string;

  

  constructor(public http: Http, public localSt: LocalStorageService, public idle: Idle) {
     idle.setIdle(1200);
    idle.setTimeout(5);
    idle.setInterrupts(DEFAULT_INTERRUPTSOURCES);


    idle.onTimeout.subscribe(() => {
      console.log('Timeout');
      window.location.href = "/logout.html";
    });

   idle.watch();
  }

  ngOnInit() {
    this.checkUserAuth();
  }


 checkUserAuth(): void {
        this.WebAPIPostCall().subscribe(res => {
                var d: any = res;
                if (d.UserInfo.IsValid == 1)
                {
                  this.localSt.store('UserGSN', d.UserInfo.GSN);
                  this.localSt.store('UserName', d.UserInfo.Name);
                  this.localSt.store('UserEmail', d.UserInfo.Email);  
                  this.userName = d.UserInfo.Name;

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
        return this.http.get(this._webapi + 'api/Merc/CheckAuthentication/', {withCredentials:true})
                      .map(response => <any>(<Response>response).json());
      }
}
