System.register(['@angular/core', "../../services/resource-service"], function(exports_1, context_1) {
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
    var core_1, resource_service_1;
    var CsvExport;
    return {
        setters:[
            function (core_1_1) {
                core_1 = core_1_1;
            },
            function (resource_service_1_1) {
                resource_service_1 = resource_service_1_1;
            }],
        execute: function() {
            CsvExport = (function () {
                function CsvExport(resource) {
                    var _this = this;
                    this.resource = resource;
                    this.exportCsv = function () {
                        var data = _this.resource.data;
                        var csvContent = "data:text/csv;charset=utf-8,";
                        var dataString = "";
                        var x = [];
                        data.forEach(function (row, index) {
                            x[index] = [];
                            for (var i in row) {
                                if (row.hasOwnProperty(i)) {
                                    if (typeof row[i] === "object") {
                                        row[i] = ""; // "Object"; // so far just change object to "Object" string
                                    }
                                    x[index].push(row[i]);
                                }
                            }
                        });
                        var header = _this.resource.keys.join(",");
                        csvContent += header + "\n";
                        x.forEach(function (row, index) {
                            dataString = row.join(",");
                            csvContent += index < data.length ? dataString + "\n" : dataString;
                        });
                        var encodedUri = encodeURI(csvContent);
                        var link = document.createElement("a");
                        link.setAttribute("href", encodedUri);
                        link.setAttribute("download", "MerchReport.csv");
                        link.click();
                    };
                }
                CsvExport = __decorate([
                    core_1.Component({
                        selector: 'csv-export',
                        template: "<button class=\"ng2-table__csv-export-button\"\n                    (click)=\"exportCsv()\">Export to CSV\n                </button>"
                    }), 
                    __metadata('design:paramtypes', [resource_service_1.ResourceService])
                ], CsvExport);
                return CsvExport;
            }());
            exports_1("CsvExport", CsvExport);
        }
    }
});
//# sourceMappingURL=csv-export.component.js.map