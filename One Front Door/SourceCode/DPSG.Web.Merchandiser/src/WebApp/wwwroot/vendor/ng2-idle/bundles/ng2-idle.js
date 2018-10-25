System.registerDynamic("ng2-idle/windowinterruptsource", ["ng2-idle/eventtargetinterruptsource"], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var __extends = (this && this.__extends) || function(d, b) {
    for (var p in b)
      if (b.hasOwnProperty(p))
        d[p] = b[p];
    function __() {
      this.constructor = d;
    }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
  var eventtargetinterruptsource_1 = $__require('ng2-idle/eventtargetinterruptsource');
  var WindowInterruptSource = (function(_super) {
    __extends(WindowInterruptSource, _super);
    function WindowInterruptSource(events, throttleDelay) {
      if (throttleDelay === void 0) {
        throttleDelay = 500;
      }
      _super.call(this, window, events, throttleDelay);
    }
    return WindowInterruptSource;
  }(eventtargetinterruptsource_1.EventTargetInterruptSource));
  exports.WindowInterruptSource = WindowInterruptSource;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/simpleexpiry", ["ng2-idle/idleexpiry"], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var __extends = (this && this.__extends) || function(d, b) {
    for (var p in b)
      if (b.hasOwnProperty(p))
        d[p] = b[p];
    function __() {
      this.constructor = d;
    }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
  var idleexpiry_1 = $__require('ng2-idle/idleexpiry');
  var SimpleExpiry = (function(_super) {
    __extends(SimpleExpiry, _super);
    function SimpleExpiry() {
      _super.call(this);
      this.lastValue = null;
    }
    SimpleExpiry.prototype.last = function(value) {
      if (value !== void 0) {
        this.lastValue = value;
      }
      return this.lastValue;
    };
    return SimpleExpiry;
  }(idleexpiry_1.IdleExpiry));
  exports.SimpleExpiry = SimpleExpiry;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/keepalivesvc", [], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var KeepaliveSvc = (function() {
    function KeepaliveSvc() {}
    return KeepaliveSvc;
  }());
  exports.KeepaliveSvc = KeepaliveSvc;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/interrupt", [], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var Interrupt = (function() {
    function Interrupt(source) {
      this.source = source;
    }
    Interrupt.prototype.subscribe = function(fn) {
      this.sub = this.source.onInterrupt.subscribe(fn);
    };
    Interrupt.prototype.unsubscribe = function() {
      this.sub.unsubscribe();
      this.sub = null;
    };
    Interrupt.prototype.resume = function() {
      this.source.attach();
    };
    Interrupt.prototype.pause = function() {
      this.source.detach();
    };
    return Interrupt;
  }());
  exports.Interrupt = Interrupt;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/idleexpiry", [], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var IdleExpiry = (function() {
    function IdleExpiry() {
      this.idValue = new Date();
    }
    IdleExpiry.prototype.id = function(value) {
      if (value !== void 0) {
        if (!value) {
          throw new Error('A value must be specified for the ID.');
        }
        this.idValue = value;
      }
      return this.idValue;
    };
    IdleExpiry.prototype.now = function() {
      return new Date();
    };
    IdleExpiry.prototype.isExpired = function() {
      var expiry = this.last();
      return expiry != null && expiry <= this.now();
    };
    return IdleExpiry;
  }());
  exports.IdleExpiry = IdleExpiry;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/idle", ["@angular/core", "ng2-idle/idleexpiry", "ng2-idle/interrupt", "ng2-idle/keepalivesvc"], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var __decorate = (this && this.__decorate) || function(decorators, target, key, desc) {
    var c = arguments.length,
        r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc,
        d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function")
      r = Reflect.decorate(decorators, target, key, desc);
    else
      for (var i = decorators.length - 1; i >= 0; i--)
        if (d = decorators[i])
          r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
  };
  var __metadata = (this && this.__metadata) || function(k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function")
      return Reflect.metadata(k, v);
  };
  var __param = (this && this.__param) || function(paramIndex, decorator) {
    return function(target, key) {
      decorator(target, key, paramIndex);
    };
  };
  var core_1 = $__require('@angular/core');
  var idleexpiry_1 = $__require('ng2-idle/idleexpiry');
  var interrupt_1 = $__require('ng2-idle/interrupt');
  var keepalivesvc_1 = $__require('ng2-idle/keepalivesvc');
  (function(AutoResume) {
    AutoResume[AutoResume["disabled"] = 0] = "disabled";
    AutoResume[AutoResume["idle"] = 1] = "idle";
    AutoResume[AutoResume["notIdle"] = 2] = "notIdle";
  })(exports.AutoResume || (exports.AutoResume = {}));
  var AutoResume = exports.AutoResume;
  var Idle = (function() {
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
    Idle.prototype.getKeepaliveEnabled = function() {
      return this.keepaliveEnabled;
    };
    Idle.prototype.setKeepaliveEnabled = function(value) {
      if (!this.keepaliveSvc) {
        throw new Error('Cannot enable keepalive integration because no KeepaliveSvc has been provided.');
      }
      return this.keepaliveEnabled = value;
    };
    Idle.prototype.getTimeout = function() {
      return this.timeoutVal;
    };
    Idle.prototype.setTimeout = function(seconds) {
      if (seconds === false) {
        this.timeoutVal = 0;
      } else if (typeof seconds === 'number' && seconds >= 0) {
        this.timeoutVal = seconds;
      } else {
        throw new Error('\'seconds\' can only be \'false\' or a positive number.');
      }
      return this.timeoutVal;
    };
    Idle.prototype.getIdle = function() {
      return this.idle;
    };
    Idle.prototype.setIdle = function(seconds) {
      if (seconds <= 0) {
        throw new Error('\'seconds\' must be greater zero');
      }
      return this.idle = seconds;
    };
    Idle.prototype.getAutoResume = function() {
      return this.autoResume;
    };
    Idle.prototype.setAutoResume = function(value) {
      return this.autoResume = value;
    };
    Idle.prototype.setInterrupts = function(sources) {
      this.clearInterrupts();
      var self = this;
      for (var _i = 0,
          sources_1 = sources; _i < sources_1.length; _i++) {
        var source = sources_1[_i];
        var sub = new interrupt_1.Interrupt(source);
        sub.subscribe(function(args) {
          self.interrupt(args.force, args.innerArgs);
        });
        this.interrupts.push(sub);
      }
      return this.interrupts;
    };
    Idle.prototype.getInterrupts = function() {
      return this.interrupts;
    };
    Idle.prototype.clearInterrupts = function() {
      for (var _i = 0,
          _a = this.interrupts; _i < _a.length; _i++) {
        var sub = _a[_i];
        sub.pause();
        sub.unsubscribe();
      }
      this.interrupts.length = 0;
    };
    Idle.prototype.isRunning = function() {
      return this.running;
    };
    Idle.prototype.isIdling = function() {
      return this.idling;
    };
    Idle.prototype.watch = function(skipExpiry) {
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
      this.idleHandle = setInterval(function() {
        _this.toggleState();
      }, this.idle * 1000);
    };
    Idle.prototype.stop = function() {
      this.stopKeepalive();
      this.toggleInterrupts(false);
      this.safeClearInterval('idleHandle');
      this.safeClearInterval('timeoutHandle');
      this.idling = false;
      this.running = false;
      this.expiry.last(null);
    };
    Idle.prototype.timeout = function() {
      this.stopKeepalive();
      this.toggleInterrupts(false);
      this.safeClearInterval('idleHandle');
      this.safeClearInterval('timeoutHandle');
      this.idling = true;
      this.running = false;
      this.countdown = 0;
      this.onTimeout.emit(null);
    };
    Idle.prototype.interrupt = function(force, eventArgs) {
      if (!this.running) {
        return;
      }
      if (this.timeoutVal && this.expiry.isExpired()) {
        this.timeout();
        return;
      }
      this.onInterrupt.emit(eventArgs);
      if (force === true || this.autoResume === AutoResume.idle || (this.autoResume === AutoResume.notIdle && !this.idling)) {
        this.watch(force);
      }
    };
    Idle.prototype.toggleState = function() {
      var _this = this;
      this.idling = !this.idling;
      if (this.idling) {
        this.onIdleStart.emit(null);
        this.stopKeepalive();
        if (this.timeoutVal > 0) {
          this.countdown = this.timeoutVal;
          this.doCountdown();
          this.timeoutHandle = setInterval(function() {
            _this.doCountdown();
          }, 1000);
        }
      } else {
        this.toggleInterrupts(true);
        this.onIdleEnd.emit(null);
        this.startKeepalive();
      }
      this.safeClearInterval('idleHandle');
    };
    Idle.prototype.toggleInterrupts = function(resume) {
      for (var _i = 0,
          _a = this.interrupts; _i < _a.length; _i++) {
        var interrupt = _a[_i];
        if (resume) {
          interrupt.resume();
        } else {
          interrupt.pause();
        }
      }
    };
    Idle.prototype.doCountdown = function() {
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
    Idle.prototype.safeClearInterval = function(handleName) {
      if (this[handleName]) {
        clearInterval(this[handleName]);
        this[handleName] = null;
      }
    };
    Idle.prototype.startKeepalive = function() {
      if (!this.keepaliveSvc || !this.keepaliveEnabled) {
        return;
      }
      if (this.running) {
        this.keepaliveSvc.ping();
      }
      this.keepaliveSvc.start();
    };
    Idle.prototype.stopKeepalive = function() {
      if (!this.keepaliveSvc || !this.keepaliveEnabled) {
        return;
      }
      this.keepaliveSvc.stop();
    };
    Idle.prototype.ngOnDestroy = function() {
      this.stop();
      this.clearInterrupts();
    };
    Idle = __decorate([core_1.Injectable(), __param(1, core_1.Optional()), __metadata('design:paramtypes', [idleexpiry_1.IdleExpiry, keepalivesvc_1.KeepaliveSvc])], Idle);
    return Idle;
  }());
  exports.Idle = Idle;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/interruptsource", ["@angular/core"], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var core_1 = $__require('@angular/core');
  var InterruptSource = (function() {
    function InterruptSource(attachFn, detachFn) {
      this.attachFn = attachFn;
      this.detachFn = detachFn;
      this.isAttached = false;
      this.onInterrupt = new core_1.EventEmitter();
    }
    InterruptSource.prototype.attach = function() {
      if (!this.isAttached && this.attachFn) {
        this.attachFn(this);
      }
      this.isAttached = true;
    };
    InterruptSource.prototype.detach = function() {
      if (this.isAttached && this.detachFn) {
        this.detachFn(this);
      }
      this.isAttached = false;
    };
    return InterruptSource;
  }());
  exports.InterruptSource = InterruptSource;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/interruptargs", [], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var InterruptArgs = (function() {
    function InterruptArgs(source, innerArgs, force) {
      if (force === void 0) {
        force = false;
      }
      this.source = source;
      this.innerArgs = innerArgs;
      this.force = force;
    }
    return InterruptArgs;
  }());
  exports.InterruptArgs = InterruptArgs;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/eventtargetinterruptsource", ["rxjs/Rx", "ng2-idle/interruptargs", "ng2-idle/interruptsource"], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var __extends = (this && this.__extends) || function(d, b) {
    for (var p in b)
      if (b.hasOwnProperty(p))
        d[p] = b[p];
    function __() {
      this.constructor = d;
    }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
  var Rx_1 = $__require('rxjs/Rx');
  var interruptargs_1 = $__require('ng2-idle/interruptargs');
  var interruptsource_1 = $__require('ng2-idle/interruptsource');
  var EventTargetInterruptSource = (function(_super) {
    __extends(EventTargetInterruptSource, _super);
    function EventTargetInterruptSource(target, events, throttleDelay) {
      var _this = this;
      if (throttleDelay === void 0) {
        throttleDelay = 500;
      }
      _super.call(this, null, null);
      this.target = target;
      this.events = events;
      this.throttleDelay = throttleDelay;
      this.eventSrc = new Array;
      this.eventSubscription = new Array;
      var self = this;
      events.split(' ').forEach(function(event) {
        var src = Rx_1.Observable.fromEvent(target, event);
        if (self.throttleDelay > 0) {
          src = src.throttleTime(self.throttleDelay);
        }
        self.eventSrc.push(src);
      });
      var handler = function(innerArgs) {
        if (self.filterEvent(innerArgs)) {
          return;
        }
        var args = new interruptargs_1.InterruptArgs(this, innerArgs);
        self.onInterrupt.emit(args);
      };
      this.attachFn = function() {
        _this.eventSrc.forEach(function(src) {
          self.eventSubscription.push(src.subscribe(handler));
        });
      };
      this.detachFn = function() {
        _this.eventSubscription.forEach(function(sub) {
          sub.unsubscribe();
        });
        _this.eventSubscription.length = 0;
      };
    }
    EventTargetInterruptSource.prototype.filterEvent = function(event) {
      return false;
    };
    return EventTargetInterruptSource;
  }(interruptsource_1.InterruptSource));
  exports.EventTargetInterruptSource = EventTargetInterruptSource;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/documentinterruptsource", ["ng2-idle/eventtargetinterruptsource"], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  var __extends = (this && this.__extends) || function(d, b) {
    for (var p in b)
      if (b.hasOwnProperty(p))
        d[p] = b[p];
    function __() {
      this.constructor = d;
    }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
  var eventtargetinterruptsource_1 = $__require('ng2-idle/eventtargetinterruptsource');
  var DocumentInterruptSource = (function(_super) {
    __extends(DocumentInterruptSource, _super);
    function DocumentInterruptSource(events, throttleDelay) {
      if (throttleDelay === void 0) {
        throttleDelay = 500;
      }
      _super.call(this, document.documentElement, events, throttleDelay);
    }
    DocumentInterruptSource.prototype.filterEvent = function(event) {
      if (event.type === 'mousemove' && ((event.originalEvent && event.originalEvent.movementX === 0 && event.originalEvent.movementY === 0) || (event.movementX !== void 0 && !event.movementX || !event.movementY))) {
        return true;
      }
      return false;
    };
    return DocumentInterruptSource;
  }(eventtargetinterruptsource_1.EventTargetInterruptSource));
  exports.DocumentInterruptSource = DocumentInterruptSource;
  global.define = __define;
  return module.exports;
});

System.registerDynamic("ng2-idle/core", ["ng2-idle/documentinterruptsource", "ng2-idle/idle", "ng2-idle/idleexpiry", "ng2-idle/simpleexpiry", "ng2-idle/interruptargs", "ng2-idle/interruptsource", "ng2-idle/eventtargetinterruptsource", "ng2-idle/windowinterruptsource", "ng2-idle/keepalivesvc"], true, function($__require, exports, module) {
  "use strict";
  ;
  var global = this,
      __define = global.define;
  global.define = undefined;
  function __export(m) {
    for (var p in m)
      if (!exports.hasOwnProperty(p))
        exports[p] = m[p];
  }
  var documentinterruptsource_1 = $__require('ng2-idle/documentinterruptsource');
  var idle_1 = $__require('ng2-idle/idle');
  var idleexpiry_1 = $__require('ng2-idle/idleexpiry');
  var simpleexpiry_1 = $__require('ng2-idle/simpleexpiry');
  __export($__require('ng2-idle/idle'));
  __export($__require('ng2-idle/interruptargs'));
  __export($__require('ng2-idle/interruptsource'));
  __export($__require('ng2-idle/eventtargetinterruptsource'));
  __export($__require('ng2-idle/documentinterruptsource'));
  __export($__require('ng2-idle/windowinterruptsource'));
  __export($__require('ng2-idle/keepalivesvc'));
  __export($__require('ng2-idle/idleexpiry'));
  __export($__require('ng2-idle/simpleexpiry'));
  exports.IDLE_PROVIDERS = [simpleexpiry_1.SimpleExpiry, {
    provide: idleexpiry_1.IdleExpiry,
    useExisting: simpleexpiry_1.SimpleExpiry
  }, idle_1.Idle];
  exports.DEFAULT_INTERRUPTSOURCES = [new documentinterruptsource_1.DocumentInterruptSource('mousemove keydown DOMMouseScroll mousewheel mousedown touchstart touchmove scroll')];
  Object.defineProperty(exports, "__esModule", {value: true});
  exports.default = {providers: [exports.IDLE_PROVIDERS]};
  global.define = __define;
  return module.exports;
});

//# sourceMappingURL=ng2-idle.js.map