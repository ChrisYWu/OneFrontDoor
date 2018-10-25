/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
"use strict";
var InterruptArgs = (function () {
    function InterruptArgs(source, innerArgs, force) {
        if (force === void 0) { force = false; }
        this.source = source;
        this.innerArgs = innerArgs;
        this.force = force;
    }
    return InterruptArgs;
}());
exports.InterruptArgs = InterruptArgs;

//# sourceMappingURL=interruptargs.js.map
