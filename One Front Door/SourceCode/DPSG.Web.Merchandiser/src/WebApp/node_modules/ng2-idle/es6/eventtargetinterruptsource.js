/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
import { Observable } from 'rxjs/Rx';
import { InterruptArgs } from './interruptargs';
import { InterruptSource } from './interruptsource';
export class EventTargetInterruptSource extends InterruptSource {
    constructor(target, events, throttleDelay = 500) {
        super(null, null);
        this.target = target;
        this.events = events;
        this.throttleDelay = throttleDelay;
        this.eventSrc = new Array;
        this.eventSubscription = new Array;
        let self = this;
        events.split(' ').forEach(function (event) {
            let src = Observable.fromEvent(target, event);
            if (self.throttleDelay > 0) {
                src = src.throttleTime(self.throttleDelay);
            }
            self.eventSrc.push(src);
        });
        let handler = function (innerArgs) {
            if (self.filterEvent(innerArgs)) {
                return;
            }
            let args = new InterruptArgs(this, innerArgs);
            self.onInterrupt.emit(args);
        };
        this.attachFn = () => {
            this.eventSrc.forEach((src) => { self.eventSubscription.push(src.subscribe(handler)); });
        };
        this.detachFn = () => {
            this.eventSubscription.forEach((sub) => { sub.unsubscribe(); });
            this.eventSubscription.length = 0;
        };
    }
    filterEvent(event) { return false; }
}

//# sourceMappingURL=eventtargetinterruptsource.js.map
