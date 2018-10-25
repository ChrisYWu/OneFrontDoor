"use strict";
var testing_1 = require('@angular/core/testing');
var filter_pipe_1 = require('./filter.pipe');
testing_1.describe('Filter Pipe', function () {
    testing_1.beforeEachProviders(function () { return [filter_pipe_1.FilterPipe]; });
    testing_1.it('should transform the input', testing_1.inject([filter_pipe_1.FilterPipe], function (pipe) {
        //  expect(pipe.transform(true)).toBe(null);
    }));
});
//# sourceMappingURL=filter.pipe.spec.js.map