/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
import { EventTargetInterruptSource } from './eventtargetinterruptsource';
export class WindowInterruptSource extends EventTargetInterruptSource {
    constructor(events, throttleDelay = 500) {
        super(window, events, throttleDelay);
    }
}

//# sourceMappingURL=windowinterruptsource.js.map
