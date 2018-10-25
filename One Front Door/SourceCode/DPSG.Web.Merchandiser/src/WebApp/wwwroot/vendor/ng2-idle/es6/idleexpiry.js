/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
export class IdleExpiry {
    constructor() {
        this.idValue = new Date();
    }
    id(value) {
        if (value !== void 0) {
            if (!value) {
                throw new Error('A value must be specified for the ID.');
            }
            this.idValue = value;
        }
        return this.idValue;
    }
    now() { return new Date(); }
    isExpired() {
        let expiry = this.last();
        return expiry != null && expiry <= this.now();
    }
}

//# sourceMappingURL=idleexpiry.js.map
