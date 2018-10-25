/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var core_1 = require('@angular/core');
var idleexpiry_1 = require('./idleexpiry');
var interrupt_1 = require('./interrupt');
var keepalivesvc_1 = require('./keepalivesvc');
(function (AutoResume) {
    AutoResume[AutoResume["disabled"] = 0] = "disabled";
    AutoResume[AutoResume["idle"] = 1] = "idle";
    AutoResume[AutoResume["notIdle"] = 2] = "notIdle";
})(exports.AutoResume || (exports.AutoResume = {}));
var AutoResume = exports.AutoResume;
var Idle = (function () {
    function Idle(expiry, keepaliveSvc) {
        this.expiry = expiry;
        this.idle = 20 * 60;
        this.timeoutVal = 30;
        this.autoResume = AutoResume.idle;
        this.interrupts = new Array;
        this.running = false;
        this.idling = false;
        this.keepaliveEnabled = false;
        this.onIdleStart = new core_1.EventEmitter;
        this.onIdleEnd = new core_1.EventEmitter;
        this.onTimeoutWarning = new core_1.EventEmitter();
        this.onTimeout = new core_1.EventEmitter();
        this.onInterrupt = new core_1.EventEmitter;
        if (keepaliveSvc) {
            this.keepaliveSvc = keepaliveSvc;
            this.keepaliveEnabled = true;
        }
    }
    Idle.prototype.getKeepaliveEnabled = function () { return this.keepaliveEnabled; };
    Idle.prototype.setKeepaliveEnabled = function (value) {
        if (!this.keepaliveSvc) {
            throw new Error('Cannot enable keepalive integration because no KeepaliveSvc has been provided.');
        }
        return this.keepaliveEnabled = value;
    };
    Idle.prototype.getTimeout = function () { return this.timeoutVal; };
    Idle.prototype.setTimeout = function (seconds) {
        if (seconds === false) {
            this.timeoutVal = 0;
        }
        else if (typeof seconds === 'number' && seconds >= 0) {
            this.timeoutVal = seconds;
        }
        else {
            throw new Error('\'seconds\' can only be \'false\' or a positive number.');
        }
        return this.timeoutVal;
    };
    Idle.prototype.getIdle = function () { return this.idle; };
    Idle.prototype.setIdle = function (seconds) {
        if (seconds <= 0) {
            throw new Error('\'seconds\' must be greater zero');
        }
        return this.idle = seconds;
    };
    Idle.prototype.getAutoResume = function () { return this.autoResume; };
    Idle.prototype.setAutoResume = function (value) { return this.autoResume = value; };
    Idle.prototype.setInterrupts = function (sources) {
        this.clearInterrupts();
        var self = this;
        for (var _i = 0, sources_1 = sources; _i < sources_1.length; _i++) {
            var source = sources_1[_i];
            var sub = new interrupt_1.Interrupt(source);
            sub.subscribe(function (args) { self.interrupt(args.force, args.innerArgs); });
            this.interrupts.push(sub);
        }
        return this.interrupts;
    };
    Idle.prototype.getInterrupts = function () { return this.interrupts; };
    Idle.prototype.clearInterrupts = function () {
        for (var _i = 0, _a = this.interrupts; _i < _a.length; _i++) {
            var sub = _a[_i];
            sub.pause();
            sub.unsubscribe();
        }
        this.interrupts.length = 0;
    };
    Idle.prototype.isRunning = function () { return this.running; };
    Idle.prototype.isIdling = function () { return this.idling; };
    Idle.prototype.watch = function (skipExpiry) {
        var _this = this;
        this.safeClearInterval('idleHandle');
        this.safeClearInterval('timeoutHandle');
        var timeout = !this.timeoutVal ? 0 : this.timeoutVal;
        if (!skipExpiry) {
            var value = new Date(this.expiry.now().getTime() + ((this.idle + timeout) * 1000));
            this.expiry.last(value);
        }
        if (this.idling) {
            this.toggleState();
        }
        if (!this.running) {
            this.startKeepalive();
            this.toggleInterrupts(true);
        }
        this.running = true;
        this.idleHandle = setInterval(function () { _this.toggleState(); }, this.idle * 1000);
    };
    Idle.prototype.stop = function () {
        this.stopKeepalive();
        this.toggleInterrupts(false);
        this.safeClearInterval('idleHandle');
        this.safeClearInterval('timeoutHandle');
        this.idling = false;
        this.running = false;
        this.expiry.last(null);
    };
    Idle.prototype.timeout = function () {
        this.stopKeepalive();
        this.toggleInterrupts(false);
        this.safeClearInterval('idleHandle');
        this.safeClearInterval('timeoutHandle');
        this.idling = true;
        this.running = false;
        this.countdown = 0;
        this.onTimeout.emit(null);
    };
    Idle.prototype.interrupt = function (force, eventArgs) {
        if (!this.running) {
            return;
        }
        if (this.timeoutVal && this.expiry.isExpired()) {
            this.timeout();
            return;
        }
        this.onInterrupt.emit(eventArgs);
        if (force === true || this.autoResume === AutoResume.idle ||
            (this.autoResume === AutoResume.notIdle && !this.idling)) {
            this.watch(force);
        }
    };
    Idle.prototype.toggleState = function () {
        var _this = this;
        this.idling = !this.idling;
        if (this.idling) {
            this.onIdleStart.emit(null);
            this.stopKeepalive();
            if (this.timeoutVal > 0) {
                this.countdown = this.timeoutVal;
                this.doCountdown();
                this.timeoutHandle = setInterval(function () { _this.doCountdown(); }, 1000);
            }
        }
        else {
            this.toggleInterrupts(true);
            this.onIdleEnd.emit(null);
            this.startKeepalive();
        }
        this.safeClearInterval('idleHandle');
    };
    Idle.prototype.toggleInterrupts = function (resume) {
        for (var _i = 0, _a = this.interrupts; _i < _a.length; _i++) {
            var interrupt = _a[_i];
            if (resume) {
                interrupt.resume();
            }
            else {
                interrupt.pause();
            }
        }
    };
    Idle.prototype.doCountdown = function () {
        if (!this.idling) {
            return;
        }
        if (this.countdown <= 0) {
            this.timeout();
            return;
        }
        this.onTimeoutWarning.emit(this.countdown);
        this.countdown--;
    };
    Idle.prototype.safeClearInterval = function (handleName) {
        if (this[handleName]) {
            clearInterval(this[handleName]);
            this[handleName] = null;
        }
    };
    Idle.prototype.startKeepalive = function () {
        if (!this.keepaliveSvc || !this.keepaliveEnabled) {
            return;
        }
        if (this.running) {
            this.keepaliveSvc.ping();
        }
        this.keepaliveSvc.start();
    };
    Idle.prototype.stopKeepalive = function () {
        if (!this.keepaliveSvc || !this.keepaliveEnabled) {
            return;
        }
        this.keepaliveSvc.stop();
    };
    Idle.prototype.ngOnDestroy = function () {
        this.stop();
        this.clearInterrupts();
    };
    Idle = __decorate([
        core_1.Injectable(),
        __param(1, core_1.Optional()), 
        __metadata('design:paramtypes', [idleexpiry_1.IdleExpiry, keepalivesvc_1.KeepaliveSvc])
    ], Idle);
    return Idle;
}());
exports.Idle = Idle;

//# sourceMappingURL=idle.js.map
