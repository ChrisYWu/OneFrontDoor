"use strict";
var MyPage = (function () {
    function MyPage() {
    }
    MyPage.prototype.navigateTo = function () {
        return browser.get('/');
    };
    MyPage.prototype.getParagraphText = function () {
        return element(by.css('my-app h1')).getText();
    };
    return MyPage;
}());
exports.MyPage = MyPage;
//# sourceMappingURL=C:/Users/GADSX005/Merc/DPSG.Web.Merchandiser/src/WebApp/e2e/app.po.js.map