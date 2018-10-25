/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
"use strict";
function __export(m) {
    for (var p in m) if (!exports.hasOwnProperty(p)) exports[p] = m[p];
}
var documentinterruptsource_1 = require('./documentinterruptsource');
var idle_1 = require('./idle');
var idleexpiry_1 = require('./idleexpiry');
var simpleexpiry_1 = require('./simpleexpiry');
__export(require('./idle'));
__export(require('./interruptargs'));
__export(require('./interruptsource'));
__export(require('./eventtargetinterruptsource'));
__export(require('./documentinterruptsource'));
__export(require('./windowinterruptsource'));
__export(require('./keepalivesvc'));
__export(require('./idleexpiry'));
__export(require('./simpleexpiry'));
exports.IDLE_PROVIDERS = [simpleexpiry_1.SimpleExpiry, { provide: idleexpiry_1.IdleExpiry, useExisting: simpleexpiry_1.SimpleExpiry }, idle_1.Idle];
exports.DEFAULT_INTERRUPTSOURCES = [new documentinterruptsource_1.DocumentInterruptSource('mousemove keydown DOMMouseScroll mousewheel mousedown touchstart touchmove scroll')];
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = { providers: [exports.IDLE_PROVIDERS] };

//# sourceMappingURL=core.js.map
