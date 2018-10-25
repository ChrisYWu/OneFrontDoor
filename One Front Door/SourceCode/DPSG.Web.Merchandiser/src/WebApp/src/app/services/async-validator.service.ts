import { Injectable } from '@angular/core';
import {Http, Response} from "@angular/http";
import {Observable} from "rxjs";
import 'rxjs/Rx';

@Injectable()
export class AsyncValidatorService {

   public sourceUrl: string;
  

  constructor(private http:Http) {}

   getRemoteData(): Observable<Response> {

     
     
     let url = "";
     url = this.sourceUrl;
    
    
    return this.http.get(url)
      .map( resp => resp.json())
      .map( resp => {
        var list = resp.data  || resp;
        // if (this.pathToData) {
        //   var paths = this.pathToData.split('.');
        //   paths.forEach(function(el) {
        //     list = list[el];
        //   });
        // }
        return list;
      });
   }

}
