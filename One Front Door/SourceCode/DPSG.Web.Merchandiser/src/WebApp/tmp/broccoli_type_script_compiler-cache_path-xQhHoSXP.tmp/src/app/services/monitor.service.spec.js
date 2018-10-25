"use strict";
var testing_1 = require('@angular/core/testing');
var monitor_service_1 = require('./monitor.service');
testing_1.describe('Monitor Service', function () {
    testing_1.beforeEachProviders(function () { return [monitor_service_1.MonitorService]; });
    testing_1.it('should ...', testing_1.inject([monitor_service_1.MonitorService], function (service) {
        testing_1.expect(service).toBeTruthy();
    }));
});
//# sourceMappingURL=monitor.service.spec.js.map