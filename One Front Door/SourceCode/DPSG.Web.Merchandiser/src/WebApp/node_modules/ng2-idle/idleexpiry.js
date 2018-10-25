/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
"use strict";
var IdleExpiry = (function () {
    function IdleExpiry() {
        this.idValue = new Date();
    }
    IdleExpiry.prototype.id = function (value) {
        if (value !== void 0) {
            if (!value) {
                throw new Error('A value must be specified for the ID.');
            }
            this.idValue = value;
        }
        return this.idValue;
    };
    IdleExpiry.prototype.now = function () { return new Date(); };
    IdleExpiry.prototype.isExpired = function () {
        var expiry = this.last();
        return expiry != null && expiry <= this.now();
    };
    return IdleExpiry;
}());
exports.IdleExpiry = IdleExpiry;

//# sourceMappingURL=idleexpiry.js.map
