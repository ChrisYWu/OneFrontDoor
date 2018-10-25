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
var common_1 = require('@angular/common');
var ng2_dnd_1 = require('ng2-dnd/ng2-dnd');
var dispservice_service_1 = require('../../services/dispservice.service');
var RouteStoreAssignment_1 = require('../RouteStoreAssignment');
var _1 = require('../rsaddstore/');
var _2 = require('../rsstorereassign/');
var MerchAppConstant_1 = require('../../../app/MerchAppConstant');
var RsrouteComponent = (function () {
    function RsrouteComponent(dispService) {
        this.dispService = dispService;
        this._webapi = MerchAppConstant_1.MerchConstant.WebAPI_ENDPOINT;
        this.routeReassigned = new core_1.EventEmitter();
        this.accountSelected = new core_1.EventEmitter();
    }
    RsrouteComponent.prototype.setselectedAcct = function ($event) {
        this.accountSelected.emit({ $event: $event });
    };
    RsrouteComponent.prototype.setupdatedroute = function ($event) {
        this.routeReassigned.emit({ value: $event });
    };
    RsrouteComponent.prototype.dropStore = function (moveFrom) {
        var moveTo;
        for (var i = 0; i < this.routeData.Stores.length; i++) {
            if (moveFrom == this.routeData.Stores[i].Sequence) {
                moveTo = i + 1;
            }
        }
        for (var i = 0; i < this.routeData.Stores.length; i++) {
            if (i + 1 != this.routeData.Stores[i].Sequence) {
                this.routeData.Stores[i].Sequence = i + 1;
            }
        }
        this.dispService.set(this._webapi + 'api/Merc/UpdateStoreSequence/');
        var resequenceInput;
        resequenceInput = new RouteStoreAssignment_1.ResequenceInput(this.selectedWeekDayInput, this.routeData.RouteID, moveFrom, moveTo, this.lastModifiedByInput);
        this.updateSequence(resequenceInput);
    };
    RsrouteComponent.prototype.pullInfoUpdate = function () {
        var tempStores = this.routeData.Stores.slice();
        for (var j = 0; j < tempStores.length; j++) {
            var pullcount = 0;
            for (var k = 0; k < this.routeData.Stores.length; k++) {
                if (tempStores[j].AccountID == this.routeData.Stores[k].AccountID) {
                    pullcount++;
                    if (pullcount == 1) {
                        this.routeData.Stores[k].PullNumber = "";
                    }
                    else if (pullcount == 2) {
                        this.routeData.Stores[k].PullNumber = pullcount + "nd Pull";
                    }
                    else if (pullcount == 3) {
                        this.routeData.Stores[k].PullNumber = pullcount + "rd Pull";
                    }
                    else {
                        this.routeData.Stores[k].PullNumber = pullcount + "th Pull";
                    }
                }
            }
        }
    };
    RsrouteComponent.prototype.removeStore = function (sequence) {
        var _this = this;
        this.dispService.set(this._webapi + 'api/Merc/RemoveStoreByWeekDay/');
        var removeStoreInput;
        removeStoreInput = new RouteStoreAssignment_1.RemoveStoreinput(this.selectedWeekDayInput, this.routeData.RouteID, sequence, this.lastModifiedByInput);
        this.dispService.post(JSON.stringify(removeStoreInput))
            .subscribe(function (res) {
            var data = res;
            _this.resultInsert = data;
            _this.routeData.Stores.splice(sequence - 1, 1);
            for (var i = sequence - 1; i < _this.routeData.Stores.length; i++) {
                _this.routeData.Stores[i].Sequence = _this.routeData.Stores[i].Sequence - 1;
            }
            _this.pullInfoUpdate();
            _this.accountSelected.emit({});
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    RsrouteComponent.prototype.updateSequence = function (resequenceInput) {
        var _this = this;
        this.dispService.post(JSON.stringify(resequenceInput))
            .subscribe(function (res) {
            var data = res;
            _this.resultInsert = data;
            if (_this.resultInsert.ReturnStatus == 1) {
                _this.pullInfoUpdate();
            }
        }, function (error) {
            if (error.status == 401 || error.status == 404) {
            }
        });
    };
    RsrouteComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', RouteStoreAssignment_1.Store)
    ], RsrouteComponent.prototype, "selectedacct", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], RsrouteComponent.prototype, "routeName", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RsrouteComponent.prototype, "unassignedInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RsrouteComponent.prototype, "allInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RsrouteComponent.prototype, "otherInputAccts", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Date)
    ], RsrouteComponent.prototype, "dispatchDateInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', String)
    ], RsrouteComponent.prototype, "lastModifiedByInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', RouteStoreAssignment_1.Dispatches)
    ], RsrouteComponent.prototype, "routeData", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], RsrouteComponent.prototype, "routeIdInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], RsrouteComponent.prototype, "routesInput", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Number)
    ], RsrouteComponent.prototype, "selectedWeekDayInput", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], RsrouteComponent.prototype, "routeReassigned", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], RsrouteComponent.prototype, "accountSelected", void 0);
    RsrouteComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            selector: 'app-rsroute',
            templateUrl: 'rsroute.component.html',
            styleUrls: ['rsroute.component.css'],
            directives: [common_1.CORE_DIRECTIVES, _1.RsaddstoreComponent, ng2_dnd_1.DND_DIRECTIVES, _2.RsstorereassignComponent],
            providers: [dispservice_service_1.DispserviceService, ng2_dnd_1.DND_PROVIDERS]
        }), 
        __metadata('design:paramtypes', [dispservice_service_1.DispserviceService])
    ], RsrouteComponent);
    return RsrouteComponent;
}());
exports.RsrouteComponent = RsrouteComponent;
//# sourceMappingURL=rsroute.component.js.map