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
var core_1 = require('@angular/core');
var MaskDirective = (function () {
    function MaskDirective() {
    }
    MaskDirective.prototype.onInputChange = function (event) {
        var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        var sc_REGEXP = '^[a-zA-Z0-9 ]+$';
        var reg = new RegExp(sc_REGEXP);
        if (!reg.test(key)) {
            event.preventDefault();
            return false;
        }
    };
    MaskDirective = __decorate([
        core_1.Directive({
            selector: '[mask]',
            host: {
                '(keypress)': 'onInputChange($event)'
            }
        }), 
        __metadata('design:paramtypes', [])
    ], MaskDirective);
    return MaskDirective;
}());
exports.MaskDirective = MaskDirective;
//# sourceMappingURL=mask.directive.js.map