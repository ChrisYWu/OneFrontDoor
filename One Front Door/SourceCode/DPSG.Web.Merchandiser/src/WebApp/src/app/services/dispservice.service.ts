
import { Http,Headers, Response } from '@angular/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';

///<reference path="./../typings/browser/ambient/es6-shim/index.d.ts"/>
import { bootstrap } from "@angular/platform-browser-dynamic";

import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';
// import 'rxjs/Rx'; this will load all features
import { enableProdMode } from '@angular/core';
import { Title } from '@angular/platform-browser';


@Injectable()
export class DispserviceService {


    public _baseUri: string;

    constructor(public http: Http) {

    }

    set(baseUri: string): void {
        this._baseUri = baseUri;
    }

    get() {
        var uri = this._baseUri ;

        return this.http.get(uri)
            .map(response => (<Response>response));
    }

    post(data?: any, mapJson: boolean = true) {
        var headers = new Headers();
        headers.append('Content-Type', 'application/json');

        if (mapJson)
            return this.http.post(this._baseUri, data, { headers: headers })
                .map(response => <any>(<Response>response).json());
        else
            return this.http.post(this._baseUri, data);
    }

    delete(id: number) {
        return this.http.delete(this._baseUri + '/' + id.toString())
            .map(response => <any>(<Response>response).json())
    }

    deleteResource(resource: string) {
        return this.http.delete(resource)
            .map(response => <any>(<Response>response).json())
    }
}
