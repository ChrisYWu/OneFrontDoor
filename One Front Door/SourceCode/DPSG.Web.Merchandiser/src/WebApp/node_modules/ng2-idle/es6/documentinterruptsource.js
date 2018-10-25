/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
import { EventTargetInterruptSource } from './eventtargetinterruptsource';
export class DocumentInterruptSource extends EventTargetInterruptSource {
    constructor(events, throttleDelay = 500) {
        super(document.documentElement, events, throttleDelay);
    }
    filterEvent(event) {
        if (event.type === 'mousemove'
            && ((event.originalEvent && event.originalEvent.movementX === 0 &&
                event.originalEvent.movementY === 0)
                || (event.movementX !== void 0 && !event.movementX || !event.movementY))) {
            return true;
        }
        return false;
    }
}

//# sourceMappingURL=documentinterruptsource.js.map
