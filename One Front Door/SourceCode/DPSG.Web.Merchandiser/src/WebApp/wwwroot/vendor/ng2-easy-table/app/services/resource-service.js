System.register(["@angular/core"], function(exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
        var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
        if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
        else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
        return c > 3 && r && Object.defineProperty(target, key, r), r;
    };
    var __metadata = (this && this.__metadata) || function (k, v) {
        if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
    };
    var core_1;
    var ResourceService;
    return {
        setters:[
            function (core_1_1) {
                core_1 = core_1_1;
            }],
        execute: function() {
            ResourceService = (function () {
                function ResourceService() {
                    this.data = [];
                    this.keys = [];
                    this.order = [];
                    this.previousData = [];
                }
                ResourceService.getPipedData = function () {
                    if (!this._pipedDataEmitter) {
                        this._pipedDataEmitter = new core_1.EventEmitter();
                    }
                    return this._pipedDataEmitter;
                };
                ResourceService.prototype.getOrder = function () {
                    return this.order[this.key];
                };
                ;
                ResourceService.prototype.sortBy = function (key) {
                    var _this = this;
                    this.key = key;
                    if (Object.keys(this.order).length === 0) {
                        this.order[this.key] = 'asc';
                    }
                    if (this.order[this.key] === 'asc') {
                        this.order = [];
                        this.order[this.key] = 'desc';
                        this.data.sort(function (a, b) { return _this.compare(a, b); });
                    }
                    else {
                        this.order = [];
                        this.order[this.key] = 'asc';
                        this.data.sort(function (a, b) { return _this.compare(b, a); });
                    }
                    return this.data;
                };
                ;
                ResourceService.prototype.compare = function (a, b) {
                    if ((isNaN(parseFloat(a[this.key])) || !isFinite(a[this.key])) || (isNaN(parseFloat(b[this.key])) || !isFinite(b[this.key]))) {
                        if (a[this.key] + ''.toLowerCase() < b[this.key] + ''.toLowerCase()) {
                            return -1;
                        }
                        if (a[this.key] + ''.toLowerCase() > b[this.key] + ''.toLowerCase()) {
                            return 1;
                        }
                    }
                    else {
                        if (parseFloat(a[this.key]) < parseFloat(b[this.key])) {
                            return -1;
                        }
                        if (parseFloat(a[this.key]) > parseFloat(b[this.key])) {
                            return 1;
                        }
                    }
                    return 0;
                };
                ;
                ResourceService = __decorate([
                    core_1.Injectable(), 
                    __metadata('design:paramtypes', [])
                ], ResourceService);
                return ResourceService;
            }());
            exports_1("ResourceService", ResourceService);
        }
    }
});
//# sourceMappingURL=resource-service.js.map