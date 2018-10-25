"use strict";
var app_po_1 = require('./app.po');
describe('my App', function () {
    var page;
    beforeEach(function () {
        page = new app_po_1.MyPage();
    });
    it('should display message saying app works', function () {
        page.navigateTo();
        expect(page.getParagraphText()).toEqual('my works!');
    });
});
//# sourceMappingURL=C:/Users/GADSX005/Merc/DPSG.Web.Merchandiser/src/WebApp/e2e/app.e2e.js.map