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
var Rx_1 = require('rxjs/Rx');
var interruptargs_1 = require('./interruptargs');
var interruptsource_1 = require('./interruptsource');
var EventTargetInterruptSource = (function (_super) {
    __extends(EventTargetInterruptSource, _super);
    function EventTargetInterruptSource(target, events, throttleDelay) {
        var _this = this;
        if (throttleDelay === void 0) { throttleDelay = 500; }
        _super.call(this, null, null);
        this.target = target;
        this.events = events;
        this.throttleDelay = throttleDelay;
        this.eventSrc = new Array;
        this.eventSubscription = new Array;
        var self = this;
        events.split(' ').forEach(function (event) {
            var src = Rx_1.Observable.fromEvent(target, event);
            if (self.throttleDelay > 0) {
                src = src.throttleTime(self.throttleDelay);
            }
            self.eventSrc.push(src);
        });
        var handler = function (innerArgs) {
            if (self.filterEvent(innerArgs)) {
                return;
            }
            var args = new interruptargs_1.InterruptArgs(this, innerArgs);
            self.onInterrupt.emit(args);
        };
        this.attachFn = function () {
            _this.eventSrc.forEach(function (src) { self.eventSubscription.push(src.subscribe(handler)); });
        };
        this.detachFn = function () {
            _this.eventSubscription.forEach(function (sub) { sub.unsubscribe(); });
            _this.eventSubscription.length = 0;
        };
    }
    EventTargetInterruptSource.prototype.filterEvent = function (event) { return false; };
    return EventTargetInterruptSource;
}(interruptsource_1.InterruptSource));
exports.EventTargetInterruptSource = EventTargetInterruptSource;

//# sourceMappingURL=eventtargetinterruptsource.js.map
