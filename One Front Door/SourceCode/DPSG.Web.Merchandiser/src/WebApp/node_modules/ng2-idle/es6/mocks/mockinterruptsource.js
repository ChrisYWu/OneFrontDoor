/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
import { InterruptArgs } from '../interruptargs';
import { InterruptSource } from '../interruptsource';
export class MockInterruptSource extends InterruptSource {
    constructor(attach, detach) {
        super(attach, detach);
    }
    trigger(innerArgs) { this.onInterrupt.emit(new InterruptArgs(this, innerArgs)); }
}

//# sourceMappingURL=mockinterruptsource.js.map
