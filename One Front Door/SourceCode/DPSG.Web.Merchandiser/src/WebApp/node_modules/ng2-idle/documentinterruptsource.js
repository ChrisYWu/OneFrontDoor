/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var eventtargetinterruptsource_1 = require('./eventtargetinterruptsource');
var DocumentInterruptSource = (function (_super) {
    __extends(DocumentInterruptSource, _super);
    function DocumentInterruptSource(events, throttleDelay) {
        if (throttleDelay === void 0) { throttleDelay = 500; }
        _super.call(this, document.documentElement, events, throttleDelay);
    }
    DocumentInterruptSource.prototype.filterEvent = function (event) {
        if (event.type === 'mousemove'
            && ((event.originalEvent && event.originalEvent.movementX === 0 &&
                event.originalEvent.movementY === 0)
                || (event.movementX !== void 0 && !event.movementX || !event.movementY))) {
            return true;
        }
        return false;
    };
    return DocumentInterruptSource;
}(eventtargetinterruptsource_1.EventTargetInterruptSource));
exports.DocumentInterruptSource = DocumentInterruptSource;

//# sourceMappingURL=documentinterruptsource.js.map
