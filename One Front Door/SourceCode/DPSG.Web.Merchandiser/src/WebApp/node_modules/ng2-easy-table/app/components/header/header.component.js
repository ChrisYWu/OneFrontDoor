System.register(['@angular/core', "../../services/filters-service"], function(exports_1, context_1) {
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
    var core_1, filters_service_1;
    var Header;
    return {
        setters:[
            function (core_1_1) {
                core_1 = core_1_1;
            },
            function (filters_service_1_1) {
                filters_service_1 = filters_service_1_1;
            }],
        execute: function() {
            Header = (function () {
                function Header(filtersService) {
                    this.filtersService = filtersService;
                    this.update = new core_1.EventEmitter();
                }
                Header.prototype.ngOnInit = function () {
                    this.update.emit({});
                };
                __decorate([
                    core_1.Input(), 
                    __metadata('design:type', Object)
                ], Header.prototype, "key", void 0);
                __decorate([
                    core_1.Output(), 
                    __metadata('design:type', Object)
                ], Header.prototype, "update", void 0);
                Header = __decorate([
                    core_1.Component({
                        selector: 'table-header',
                        template: "\n  <input type=\"text\"\n       placeholder=\"Search for {{ key }}\"\n       class=\"ng2-table__input\"\n       #input\n       (input)=\"update.emit({value: input.value, key: key})\"\n>"
                    }), 
                    __metadata('design:paramtypes', [filters_service_1.FiltersService])
                ], Header);
                return Header;
            }());
            exports_1("Header", Header);
        }
    }
});
//# sourceMappingURL=header.component.js.map