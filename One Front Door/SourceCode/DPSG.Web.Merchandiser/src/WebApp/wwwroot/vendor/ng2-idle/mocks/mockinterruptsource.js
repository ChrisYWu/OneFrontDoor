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
var interruptargs_1 = require('../interruptargs');
var interruptsource_1 = require('../interruptsource');
var MockInterruptSource = (function (_super) {
    __extends(MockInterruptSource, _super);
    function MockInterruptSource(attach, detach) {
        _super.call(this, attach, detach);
    }
    MockInterruptSource.prototype.trigger = function (innerArgs) { this.onInterrupt.emit(new interruptargs_1.InterruptArgs(this, innerArgs)); };
    return MockInterruptSource;
}(interruptsource_1.InterruptSource));
exports.MockInterruptSource = MockInterruptSource;

//# sourceMappingURL=mockinterruptsource.js.map
