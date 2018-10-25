"use strict";
var testing_1 = require('@angular/core/testing');
var my_component_1 = require('../app/my.component');
testing_1.beforeEachProviders(function () { return [my_component_1.MyAppComponent]; });
testing_1.describe('App: My', function () {
    testing_1.it('should create the app', testing_1.inject([my_component_1.MyAppComponent], function (app) {
        testing_1.expect(app).toBeTruthy();
    }));
    testing_1.it('should have as title \'my works!\'', testing_1.inject([my_component_1.MyAppComponent], function (app) {
        testing_1.expect(app.title).toEqual('my works!');
    }));
});
//# sourceMappingURL=my.component.spec.js.map