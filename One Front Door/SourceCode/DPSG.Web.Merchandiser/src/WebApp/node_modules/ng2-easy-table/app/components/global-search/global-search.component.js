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
    var GlobalSearch;
    return {
        setters:[
            function (core_1_1) {
                core_1 = core_1_1;
            }],
        execute: function() {
            GlobalSearch = (function () {
                function GlobalSearch() {
                    this.globalUpdate = new core_1.EventEmitter();
                }
                __decorate([
                    core_1.Output(), 
                    __metadata('design:type', Object)
                ], GlobalSearch.prototype, "globalUpdate", void 0);
                GlobalSearch = __decorate([
                    core_1.Component({
                        selector: 'global-search',
                        template: "<div class=\"input-group\">\n<label class=\"input-group-addon report-search-addon\" for=\"search\">\n    <i class=\"fa fa-search\"></i> </label><input type=\"text\"\n           id=\"search\"\n           class=\"form-control menu-input\"\n           #input\n           (input)=\"globalUpdate.emit({value: input.value})\"\n           placeholder=\"Search\" />\n<div>"
                    }), 
                    __metadata('design:paramtypes', [])
                ], GlobalSearch);
                return GlobalSearch;
            }());
            exports_1("GlobalSearch", GlobalSearch);
        }
    }
});
//# sourceMappingURL=global-search.component.js.map