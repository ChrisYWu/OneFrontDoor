/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
import { IdleExpiry } from './idleexpiry';
export class SimpleExpiry extends IdleExpiry {
    constructor() {
        super();
        this.lastValue = null;
    }
    last(value) {
        if (value !== void 0) {
            this.lastValue = value;
        }
        return this.lastValue;
    }
}

//# sourceMappingURL=simpleexpiry.js.map
