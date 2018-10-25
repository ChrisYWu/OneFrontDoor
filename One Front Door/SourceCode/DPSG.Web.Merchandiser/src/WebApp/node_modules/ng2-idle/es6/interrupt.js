/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
export class Interrupt {
    constructor(source) {
        this.source = source;
    }
    subscribe(fn) {
        this.sub = this.source.onInterrupt.subscribe(fn);
    }
    unsubscribe() {
        this.sub.unsubscribe();
        this.sub = null;
    }
    resume() { this.source.attach(); }
    pause() { this.source.detach(); }
}

//# sourceMappingURL=interrupt.js.map
