import {Injectable, ErrorHandler}  from '@angular/core';
import { MerchException } from './MerchException';
import { Http,Headers, Response } from '@angular/http';
import {MerchConstant} from '../../../app/MerchAppConstant';

@Injectable()
export class MerchExceptionHandler implements ErrorHandler {
  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  public merchExcept: MerchException;  
  constructor(public http: Http) { }

    handleError(error){
        //console.log(error);
         this.merchExcept = new MerchException(1, 1, '', '', error.message, error.stack, '');
         this.insertException(this.merchExcept);   
    }

  insertException(inputdata: MerchException) {
    this.WebAPIPostCall(inputdata).subscribe(res => {
                var d: any = res;
            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });  
    }

    WebAPIPostCall(inputdata: MerchException)
      {
        var headers = new Headers();
        var test = MerchConstant.WebAPI_ENDPOINT;
            headers.append('Content-Type', 'application/json');
            return this.http.post(this._webapi + 'api/Merc/InsertException/', JSON.stringify(inputdata), { headers: headers })
                      .map(response => <any>(<Response>response).json());
      }
}


@Injectable()
export class MerchLogger {

  private _webapi: string = MerchConstant.WebAPI_ENDPOINT; 
  public merchExcept: MerchException;
  constructor(public http: Http) { }

  public log(logMsg: string) {
    console.log(logMsg);
  }

  public logError(appliationID: number, severityID: number, source: string, userName: string, detail: string, stackTrace: string){
      this.merchExcept = new MerchException(appliationID, severityID, source, userName, detail, stackTrace, '');
      this.insertErrorLog(this.merchExcept);
  }

  insertErrorLog(inputdata: MerchException) {
      this.WebAPIPostCall(inputdata).subscribe(res => {
                var d: any = res;
            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });  
    }
  
   WebAPIPostCall(inputdata: MerchException)
      {
        var headers = new Headers();
            headers.append('Content-Type', 'application/json');
            return this.http.post(this._webapi + 'api/Merc/InsertException/', JSON.stringify(inputdata), { headers: headers })
                      .map(response => <any>(<Response>response).json());
      }
}
