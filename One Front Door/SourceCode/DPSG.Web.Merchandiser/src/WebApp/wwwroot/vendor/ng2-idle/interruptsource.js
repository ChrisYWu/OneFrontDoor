/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
"use strict";
var core_1 = require('@angular/core');
var InterruptSource = (function () {
    function InterruptSource(attachFn, detachFn) {
        this.attachFn = attachFn;
        this.detachFn = detachFn;
        this.isAttached = false;
        this.onInterrupt = new core_1.EventEmitter();
    }
    InterruptSource.prototype.attach = function () {
        if (!this.isAttached && this.attachFn) {
            this.attachFn(this);
        }
        this.isAttached = true;
    };
    InterruptSource.prototype.detach = function () {
        if (this.isAttached && this.detachFn) {
            this.detachFn(this);
        }
        this.isAttached = false;
    };
    return InterruptSource;
}());
exports.InterruptSource = InterruptSource;

//# sourceMappingURL=interruptsource.js.map
