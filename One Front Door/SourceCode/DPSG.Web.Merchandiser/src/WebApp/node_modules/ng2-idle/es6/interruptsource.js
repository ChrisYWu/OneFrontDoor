/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
import { EventEmitter } from '@angular/core';
export class InterruptSource {
    constructor(attachFn, detachFn) {
        this.attachFn = attachFn;
        this.detachFn = detachFn;
        this.isAttached = false;
        this.onInterrupt = new EventEmitter();
    }
    attach() {
        if (!this.isAttached && this.attachFn) {
            this.attachFn(this);
        }
        this.isAttached = true;
    }
    detach() {
        if (this.isAttached && this.detachFn) {
            this.detachFn(this);
        }
        this.isAttached = false;
    }
}

//# sourceMappingURL=interruptsource.js.map
