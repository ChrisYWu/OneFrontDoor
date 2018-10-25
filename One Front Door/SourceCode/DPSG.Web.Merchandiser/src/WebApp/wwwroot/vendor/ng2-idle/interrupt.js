/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
"use strict";
var Interrupt = (function () {
    function Interrupt(source) {
        this.source = source;
    }
    Interrupt.prototype.subscribe = function (fn) {
        this.sub = this.source.onInterrupt.subscribe(fn);
    };
    Interrupt.prototype.unsubscribe = function () {
        this.sub.unsubscribe();
        this.sub = null;
    };
    Interrupt.prototype.resume = function () { this.source.attach(); };
    Interrupt.prototype.pause = function () { this.source.detach(); };
    return Interrupt;
}());
exports.Interrupt = Interrupt;

//# sourceMappingURL=interrupt.js.map
