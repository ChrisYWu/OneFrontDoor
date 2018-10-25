import {BrowserXhr, HTTP_PROVIDERS, BaseRequestOptions, Headers} from '@angular/http';
import {Injectable, provide} from '@angular/core';

// @Injectable()
// export class CORSBrowserXHR extends BrowserXhr{
//     build(): any{
//         var xhr:any = super.build();
//         xhr.withCredentials = true;
//         return xhr;
//     }
// }

export class MyBaseRequestOptions extends BaseRequestOptions {
  headers: Headers = new Headers({
    'X-Requested-With': 'XMLHttpRequest'
  });
  withCredentials: boolean = true;
}