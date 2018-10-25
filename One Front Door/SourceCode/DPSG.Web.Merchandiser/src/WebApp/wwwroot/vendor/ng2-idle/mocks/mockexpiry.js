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
var idleexpiry_1 = require('../idleexpiry');
var MockExpiry = (function (_super) {
    __extends(MockExpiry, _super);
    function MockExpiry() {
        _super.apply(this, arguments);
    }
    MockExpiry.prototype.last = function (value) {
        if (value !== void 0) {
            this.lastDate = value;
        }
        return this.lastDate;
    };
    MockExpiry.prototype.now = function () { return this.mockNow || new Date(); };
    return MockExpiry;
}(idleexpiry_1.IdleExpiry));
exports.MockExpiry = MockExpiry;

//# sourceMappingURL=mockexpiry.js.map
