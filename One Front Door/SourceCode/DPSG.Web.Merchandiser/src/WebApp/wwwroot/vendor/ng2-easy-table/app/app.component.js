System.register(['@angular/core', 'rxjs/add/operator/map', "@angular/http", "./pipes/header-pipe", "./pipes/pagination-pipe", "./pipes/global-search-pipe", "./services/filters-service", "./services/config-service", "./services/resource-service", "./services/http-service", "./components/global-search/global-search.component", "./components/dropdown/csv-export.component", "./components/header/header.component", "./components/pagination/pagination.component"], function(exports_1, context_1) {
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
    var core_1, http_1, header_pipe_1, pagination_pipe_1, global_search_pipe_1, filters_service_1, config_service_1, resource_service_1, http_service_1, global_search_component_1, csv_export_component_1, header_component_1, pagination_component_1;
    var AppComponent;
    return {
        setters:[
            function (core_1_1) {
                core_1 = core_1_1;
            },
            function (_1) {},
            function (http_1_1) {
                http_1 = http_1_1;
            },
            function (header_pipe_1_1) {
                header_pipe_1 = header_pipe_1_1;
            },
            function (pagination_pipe_1_1) {
                pagination_pipe_1 = pagination_pipe_1_1;
            },
            function (global_search_pipe_1_1) {
                global_search_pipe_1 = global_search_pipe_1_1;
            },
            function (filters_service_1_1) {
                filters_service_1 = filters_service_1_1;
            },
            function (config_service_1_1) {
                config_service_1 = config_service_1_1;
            },
            function (resource_service_1_1) {
                resource_service_1 = resource_service_1_1;
            },
            function (http_service_1_1) {
                http_service_1 = http_service_1_1;
            },
            function (global_search_component_1_1) {
                global_search_component_1 = global_search_component_1_1;
            },
            function (csv_export_component_1_1) {
                csv_export_component_1 = csv_export_component_1_1;
            },
            function (header_component_1_1) {
                header_component_1 = header_component_1_1;
            },
            function (pagination_component_1_1) {
                pagination_component_1 = pagination_component_1_1;
            }],
        execute: function() {
            AppComponent = (function () {
                function AppComponent(filtersService, config, resource, httpService) {
                    this.filtersService = filtersService;
                    this.config = config;
                    this.resource = resource;
                    this.httpService = httpService;
                }
                AppComponent.prototype.ngOnInit = function () {
                    var _this = this;
                    if (this.configuration) {
                        this.config = this.configuration;
                    }
                    this.numberOfItems = 0;
                    //this.itemsObservables = this.httpService.getData(this.config.resourceUrl);
                    this.itemsObservables.subscribe(function (res) {
                        _this.data = res;
                        _this.numberOfItems = res.length;
                        _this.keys = Object.keys(_this.data[0]);
                        _this.resource.keys = _this.keys;
                    });
                };
                AppComponent.prototype.orderBy = function (key) {
                    this.data = this.resource.sortBy(key);
                };
                ;
                __decorate([
                    core_1.Input(), 
                    __metadata('design:type', config_service_1.ConfigService)
                ], AppComponent.prototype, "configuration", void 0);
                __decorate([
                     core_1.Input(),
                     __metadata('design:type', Object)
                ], AppComponent.prototype, "itemsObservables", void 0);
                AppComponent = __decorate([
                    core_1.Component({
                        selector: 'ng2-table',
                        providers: [http_service_1.HttpService, filters_service_1.FiltersService, resource_service_1.ResourceService, config_service_1.ConfigService, http_1.HTTP_PROVIDERS],
                        directives: [header_component_1.Header, pagination_component_1.Pagination, global_search_component_1.GlobalSearch, csv_export_component_1.CsvExport],
                        pipes: [header_pipe_1.SearchPipe, pagination_pipe_1.PaginationPipe, global_search_pipe_1.GlobalSearchPipe],
                        template: "\n  <global-search\n        *ngIf=\"config.globalSearchEnabled\"\n        (globalUpdate)=\"globalSearchTerm = $event\">\n</global-search>\n<csv-export *ngIf=\"config.exportEnabled\"></csv-export>\n\n<table class=\"ng2-table__table--striped\">\n    <thead>\n    <tr>\n        <th [style.display]=\"config.orderEnabled?'':'none' \"\n            *ngFor=\"let key of keys\"\n            (click)=\"orderBy(key)\">\n            {{ key }}\n            <span *ngIf=\"resource.order[key]==='asc' \" class=\"ng2-table__sort-indicator ng2-table__sort-indicator--down\"></span>\n            <span *ngIf=\"resource.order[key]==='desc' \" class=\"ng2-table__sort-indicator ng2-table__sort-indicator--up\"></span>\n        </th>\n        <th [style.display]=\"!config.orderEnabled?'':'none' \"\n            *ngFor=\"let key of keys\">\n            {{ key }}\n        </th>\n        <th *ngIf=\"config.editEnabled\">Actions</th>\n    </tr>\n    <tr *ngIf=\"config.searchEnabled\">\n        <th *ngFor=\"let key of keys\">\n            <table-header (update)=\"term = $event\" [key]=\"key\"></table-header>\n        </th>\n        <th *ngIf=\"config.editEnabled\"></th>\n    </tr>\n    </thead>\n    <tbody>\n    <tr *ngFor=\"let row of data | search : term | global : globalSearchTerm | pagination : range\">\n        <td *ngFor=\"let key of keys\">\n            {{ row[key] }}\n        </td>\n        <td *ngIf=\"config.editEnabled\">\n            <button class=\"ng2-table__button\">Edit</button>\n        </td>\n    </tr>\n    </tbody>\n    <tfoot *ngIf=\"config.footerEnabled\">\n    <tr>\n        <td *ngFor=\"let key of keys\"></td>\n        <td></td>\n    </tr>\n    </tfoot>\n</table>\n\n<pagination *ngIf=\"config.paginationEnabled\" \n            [numberOfItems]=\"numberOfItems\" \n            (updateRange)=\"range = $event\"></pagination>\n  ",
                        styleUrls: [''],
                        encapsulation: core_1.ViewEncapsulation.None,
                    }), 
                    __metadata('design:paramtypes', [filters_service_1.FiltersService, config_service_1.ConfigService, resource_service_1.ResourceService, http_service_1.HttpService])
                ], AppComponent);
                return AppComponent;
            }());
            exports_1("AppComponent", AppComponent);
        }
    }
});
//# sourceMappingURL=app.component.js.map