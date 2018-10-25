/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var keepalivesvc_1 = require('../keepalivesvc');
var MockKeepaliveSvc = (function (_super) {
    __extends(MockKeepaliveSvc, _super);
    function MockKeepaliveSvc() {
        _super.apply(this, arguments);
        this.isRunning = false;
    }
    MockKeepaliveSvc.prototype.start = function () { this.isRunning = true; };
    MockKeepaliveSvc.prototype.stop = function () { this.isRunning = false; };
    MockKeepaliveSvc.prototype.ping = function () {
    };
    return MockKeepaliveSvc;
}(keepalivesvc_1.KeepaliveSvc));
exports.MockKeepaliveSvc = MockKeepaliveSvc;

//# sourceMappingURL=mockkeepalivesvc.js.map
