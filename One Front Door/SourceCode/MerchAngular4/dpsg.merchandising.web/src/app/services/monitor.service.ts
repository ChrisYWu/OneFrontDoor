
import { Http,Headers, Response } from '@angular/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Rx';
///<reference path="./../typings/browser/ambient/es6-shim/index.d.ts"/>
//import { bootstrap } from "@angular/platform-browser-dynamic";
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';
// import 'rxjs/Rx'; this will load all features
import { enableProdMode } from '@angular/core';
import { Title } from '@angular/platform-browser';
import {MerchConstant} from '../../app/MerchAppConstant';

@Injectable()
export class MonitorService {

    public _baseUri: string = MerchConstant.WebAPI_ENDPOINT;

    constructor(public http: Http) {

    }

    set(baseUri: string): void {
        this._baseUri = baseUri;
    }


    getMonitoringData(selectedDate:String, merchGroupID:number) {
        //"2016-06-11" 
        var uri = this._baseUri ;
        var uri =  this._baseUri + "api/Monitoring/GetMornitoringLanding?dispatchDate=" + selectedDate + "&merchGroupID=" + merchGroupID;

        return this.http.get(uri)
            .map(response => (<Response>response));
    }

    getStoreDetailsData(merchStopID:number) {
        //debugger
        //merchStopID=3
        var uri = this._baseUri ;
        var uri =  this._baseUri + "api/Monitoring/GetMornitoringDetail?merchStopID=" + merchStopID ;

        return this.http.get(uri)
            .map(response => (<Response>response));
    }


    getRouteMerchandiserByMerchGroupID(merchGroupID:number) {
       // debugger
        //merchStopID=3
        var uri = this._baseUri ;
        var uri =  this._baseUri + "api/Monitoring/GetRouteMerchandiserByMerchGroupID?merchGroupID=" + merchGroupID ;

        return this.http.get(uri)
            .map(response => (<Response>response));
    }


    editRouteMerchandiser(routeID:number, dayOfWeek:number, GSN:string, isForDelete:Boolean  )  {
       // debugger
        //merchStopID=3
        var uri = this._baseUri ;
        var uri =  this._baseUri + "api/Monitoring/EditRouteMerchandiser?routeID=" + routeID + "&dayOfWeek=" + dayOfWeek + "&GSN=" + GSN  + "&isForDelete=" + isForDelete ;

        return this.http.get(uri)
            .map(response => (<Response>response));
    }



//Todo: if get time to creat a custome global Observable, to manage service better and easy way 

//  getMonitoringDataOb (): Observable<any[]> {
    // var uri = this._baseUri ;
//     var uri = "http://vh-portal3/DPSG.Webapi.Merchandiser/api/Monitoring/GetMornitoringLanding?dispatchDate=2016-06-11&merchGroupID=101"
  
//    return this.http.get(uri)
  //                  .map(this.extractData)
  //                  .catch(this.handleError);
 // }

//  private extractData(res: Response) {
 //   let body = res.json();
 //   return body.data || { };
 // }

 // private handleError (error: any) {
 //   let errMsg = (error.message) ? error.message :
 //     error.status ? `${error.status} - ${error.statusText}` : 'Server error';
 //   console.error(errMsg); // log to console instead
 //   return Observable.throw(errMsg);
 // }

}
