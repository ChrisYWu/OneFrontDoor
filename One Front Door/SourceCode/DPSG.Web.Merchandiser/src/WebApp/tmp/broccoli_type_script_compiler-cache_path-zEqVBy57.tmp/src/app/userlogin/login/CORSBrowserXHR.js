"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var http_1 = require('@angular/http');
// @Injectable()
// export class CORSBrowserXHR extends BrowserXhr{
//     build(): any{
//         var xhr:any = super.build();
//         xhr.withCredentials = true;
//         return xhr;
//     }
// }
var MyBaseRequestOptions = (function (_super) {
    __extends(MyBaseRequestOptions, _super);
    function MyBaseRequestOptions() {
        _super.apply(this, arguments);
        this.headers = new http_1.Headers({
            'X-Requested-With': 'XMLHttpRequest'
        });
        this.withCredentials = true;
    }
    return MyBaseRequestOptions;
}(http_1.BaseRequestOptions));
exports.MyBaseRequestOptions = MyBaseRequestOptions;
//# sourceMappingURL=CORSBrowserXHR.js.map