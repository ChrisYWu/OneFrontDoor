"use strict";
var MerchException = (function () {
    function MerchException(appliationID, severityID, source, userName, detail, stackTrace, lastModified) {
        this.AppliationID = appliationID;
        this.SeverityID = severityID;
        this.Source = source;
        this.UserName = userName;
        this.Detail = detail;
        this.StackTrace = stackTrace;
        this.LastModified = lastModified;
    }
    return MerchException;
}());
exports.MerchException = MerchException;
//# sourceMappingURL=MerchException.js.map