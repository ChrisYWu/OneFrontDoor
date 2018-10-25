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
var eventtargetinterruptsource_1 = require('./eventtargetinterruptsource');
var WindowInterruptSource = (function (_super) {
    __extends(WindowInterruptSource, _super);
    function WindowInterruptSource(events, throttleDelay) {
        if (throttleDelay === void 0) { throttleDelay = 500; }
        _super.call(this, window, events, throttleDelay);
    }
    return WindowInterruptSource;
}(eventtargetinterruptsource_1.EventTargetInterruptSource));
exports.WindowInterruptSource = WindowInterruptSource;

//# sourceMappingURL=windowinterruptsource.js.map
