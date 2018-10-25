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
var idleexpiry_1 = require('./idleexpiry');
var SimpleExpiry = (function (_super) {
    __extends(SimpleExpiry, _super);
    function SimpleExpiry() {
        _super.call(this);
        this.lastValue = null;
    }
    SimpleExpiry.prototype.last = function (value) {
        if (value !== void 0) {
            this.lastValue = value;
        }
        return this.lastValue;
    };
    return SimpleExpiry;
}(idleexpiry_1.IdleExpiry));
exports.SimpleExpiry = SimpleExpiry;

//# sourceMappingURL=simpleexpiry.js.map
