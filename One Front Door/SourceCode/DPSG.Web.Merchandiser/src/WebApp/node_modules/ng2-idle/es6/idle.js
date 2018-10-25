/**
 * ng2-idle - A module for responding to idle users in Angular2 applications.
 # @author Mike Grabski <me@mikegrabski.com> (http://mikegrabski.com/)
 * @version v1.0.0-alpha.15
 * @link https://github.com/HackedByChinese/ng2-idle.git#readme
 * @license MIT
 */
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
import { EventEmitter, Injectable, Optional } from '@angular/core';
import { IdleExpiry } from './idleexpiry';
import { Interrupt } from './interrupt';
import { KeepaliveSvc } from './keepalivesvc';
export var AutoResume;
(function (AutoResume) {
    AutoResume[AutoResume["disabled"] = 0] = "disabled";
    AutoResume[AutoResume["idle"] = 1] = "idle";
    AutoResume[AutoResume["notIdle"] = 2] = "notIdle";
})(AutoResume || (AutoResume = {}));
export let Idle = class Idle {
    constructor(expiry, keepaliveSvc) {
        this.expiry = expiry;
        this.idle = 20 * 60;
        this.timeoutVal = 30;
        this.autoResume = AutoResume.idle;
        this.interrupts = new Array;
        this.running = false;
        this.idling = false;
        this.keepaliveEnabled = false;
        this.onIdleStart = new EventEmitter;
        this.onIdleEnd = new EventEmitter;
        this.onTimeoutWarning = new EventEmitter();
        this.onTimeout = new EventEmitter();
        this.onInterrupt = new EventEmitter;
        if (keepaliveSvc) {
            this.keepaliveSvc = keepaliveSvc;
            this.keepaliveEnabled = true;
        }
    }
    getKeepaliveEnabled() { return this.keepaliveEnabled; }
    setKeepaliveEnabled(value) {
        if (!this.keepaliveSvc) {
            throw new Error('Cannot enable keepalive integration because no KeepaliveSvc has been provided.');
        }
        return this.keepaliveEnabled = value;
    }
    getTimeout() { return this.timeoutVal; }
    setTimeout(seconds) {
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
    }
    getIdle() { return this.idle; }
    setIdle(seconds) {
        if (seconds <= 0) {
            throw new Error('\'seconds\' must be greater zero');
        }
        return this.idle = seconds;
    }
    getAutoResume() { return this.autoResume; }
    setAutoResume(value) { return this.autoResume = value; }
    setInterrupts(sources) {
        this.clearInterrupts();
        let self = this;
        for (let source of sources) {
            let sub = new Interrupt(source);
            sub.subscribe((args) => { self.interrupt(args.force, args.innerArgs); });
            this.interrupts.push(sub);
        }
        return this.interrupts;
    }
    getInterrupts() { return this.interrupts; }
    clearInterrupts() {
        for (let sub of this.interrupts) {
            sub.pause();
            sub.unsubscribe();
        }
        this.interrupts.length = 0;
    }
    isRunning() { return this.running; }
    isIdling() { return this.idling; }
    watch(skipExpiry) {
        this.safeClearInterval('idleHandle');
        this.safeClearInterval('timeoutHandle');
        let timeout = !this.timeoutVal ? 0 : this.timeoutVal;
        if (!skipExpiry) {
            let value = new Date(this.expiry.now().getTime() + ((this.idle + timeout) * 1000));
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
        this.idleHandle = setInterval(() => { this.toggleState(); }, this.idle * 1000);
    }
    stop() {
        this.stopKeepalive();
        this.toggleInterrupts(false);
        this.safeClearInterval('idleHandle');
        this.safeClearInterval('timeoutHandle');
        this.idling = false;
        this.running = false;
        this.expiry.last(null);
    }
    timeout() {
        this.stopKeepalive();
        this.toggleInterrupts(false);
        this.safeClearInterval('idleHandle');
        this.safeClearInterval('timeoutHandle');
        this.idling = true;
        this.running = false;
        this.countdown = 0;
        this.onTimeout.emit(null);
    }
    interrupt(force, eventArgs) {
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
    }
    toggleState() {
        this.idling = !this.idling;
        if (this.idling) {
            this.onIdleStart.emit(null);
            this.stopKeepalive();
            if (this.timeoutVal > 0) {
                this.countdown = this.timeoutVal;
                this.doCountdown();
                this.timeoutHandle = setInterval(() => { this.doCountdown(); }, 1000);
            }
        }
        else {
            this.toggleInterrupts(true);
            this.onIdleEnd.emit(null);
            this.startKeepalive();
        }
        this.safeClearInterval('idleHandle');
    }
    toggleInterrupts(resume) {
        for (let interrupt of this.interrupts) {
            if (resume) {
                interrupt.resume();
            }
            else {
                interrupt.pause();
            }
        }
    }
    doCountdown() {
        if (!this.idling) {
            return;
        }
        if (this.countdown <= 0) {
            this.timeout();
            return;
        }
        this.onTimeoutWarning.emit(this.countdown);
        this.countdown--;
    }
    safeClearInterval(handleName) {
        if (this[handleName]) {
            clearInterval(this[handleName]);
            this[handleName] = null;
        }
    }
    startKeepalive() {
        if (!this.keepaliveSvc || !this.keepaliveEnabled) {
            return;
        }
        if (this.running) {
            this.keepaliveSvc.ping();
        }
        this.keepaliveSvc.start();
    }
    stopKeepalive() {
        if (!this.keepaliveSvc || !this.keepaliveEnabled) {
            return;
        }
        this.keepaliveSvc.stop();
    }
    ngOnDestroy() {
        this.stop();
        this.clearInterrupts();
    }
};
Idle = __decorate([
    Injectable(),
    __param(1, Optional()), 
    __metadata('design:paramtypes', [IdleExpiry, KeepaliveSvc])
], Idle);

//# sourceMappingURL=idle.js.map
