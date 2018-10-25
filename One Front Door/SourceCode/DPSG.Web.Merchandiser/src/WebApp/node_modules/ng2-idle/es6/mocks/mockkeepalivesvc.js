/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
import { KeepaliveSvc } from '../keepalivesvc';
export class MockKeepaliveSvc extends KeepaliveSvc {
    constructor(...args) {
        super(...args);
        this.isRunning = false;
    }
    start() { this.isRunning = true; }
    stop() { this.isRunning = false; }
    ping() {
    }
}

//# sourceMappingURL=mockkeepalivesvc.js.map
