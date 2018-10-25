/*
* Angular 2 Dropdown Multiselect for Bootstrap
* Current version: 0.1.0
*
* Simon Lindh
* https://github.com/softsimon/angular-2-dropdown-multiselect
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
var core_1 = require('@angular/core');
var common_1 = require('@angular/common');
var SearchFilter = (function () {
    function SearchFilter() {
    }
    SearchFilter.prototype.transform = function (options, args) {
        // return options.filter((option: IMultiSelectOption) => option.name.toLowerCase().indexOf(args[0].toLowerCase()) > -1);
        return options.filter(function (option) { return option.name.indexOf(args[0]) > -1; });
    };
    SearchFilter = __decorate([
        core_1.Pipe({
            name: 'searchFilter'
        }), 
        __metadata('design:paramtypes', [])
    ], SearchFilter);
    return SearchFilter;
}());
var MultiselectDropdown = (function () {
    function MultiselectDropdown(element) {
        this.element = element;
        this.selectedModel = [];
        this.model = new core_1.EventEmitter();
        this.selectionLimitReached = new core_1.EventEmitter();
        this.numSelected = 0;
        this.isVisible = false;
        this.search = new common_1.Control();
        this.searchFilterText = '';
        this.defaultSettings = {
            pullRight: false,
            enableSearch: false,
            checkedStyle: 'checkboxes',
            buttonClasses: 'btn btn-default',
            selectionLimit: 0,
            closeOnSelect: false,
            showCheckAll: false,
            showUncheckAll: false,
            dynamicTitleMaxItems: 3,
            maxHeight: '300px',
        };
        this.defaultTexts = {
            checkAll: 'Check all',
            uncheckAll: 'Uncheck all',
            checked: 'checked',
            checkedPlural: 'checked',
            searchPlaceholder: 'Search...',
            defaultTitle: 'Select',
        };
    }
    MultiselectDropdown.prototype.onClick = function (target) {
        var parentFound = false;
        while (target !== null && !parentFound) {
            if (target === this.element.nativeElement) {
                parentFound = true;
            }
            target = target.parentElement;
        }
        if (!parentFound) {
            this.isVisible = false;
        }
    };
    MultiselectDropdown.prototype.ngOnInit = function () {
        var _this = this;
        this.settings = Object.assign(this.defaultSettings, this.settings);
        this.texts = Object.assign(this.defaultTexts, this.texts);
        this.updateNumSelected();
        this.search.valueChanges
            .subscribe(function (text) {
            _this.searchFilterText = text;
        });
    };
    MultiselectDropdown.prototype.clearSearch = function () {
        this.search.updateValue('');
    };
    MultiselectDropdown.prototype.toggleDropdown = function () {
        this.isVisible = !this.isVisible;
    };
    MultiselectDropdown.prototype.modelChanged = function () {
        this.updateNumSelected();
        this.model.emit(this.selectedModel);
    };
    MultiselectDropdown.prototype.isSelected = function (option) {
        return this.selectedModel.indexOf(option.id) > -1;
    };
    MultiselectDropdown.prototype.setSelected = function (event, option) {
        var index = this.selectedModel.indexOf(option.id);
        if (index > -1) {
            this.selectedModel.splice(index, 1);
        }
        else {
            if (this.settings.selectionLimit === 0 || this.selectedModel.length < this.settings.selectionLimit) {
                this.selectedModel.push(option.id);
            }
            else {
                this.selectionLimitReached.emit(this.selectedModel.length);
                return;
            }
        }
        if (this.settings.closeOnSelect) {
            this.toggleDropdown();
        }
        this.modelChanged();
    };
    MultiselectDropdown.prototype.getTitle = function () {
        var _this = this;
        if (this.selectedModel.length === 0) {
            return this.texts.defaultTitle;
        }
        if (this.settings.dynamicTitleMaxItems >= this.numSelected) {
            return this.options
                .filter(function (option) { return _this.selectedModel.indexOf(option.id) > -1; })
                .map(function (option) { return option.name; })
                .join(', ');
        }
        // return this.numSelected + ' ' + (this.numSelected === 1 ? this.texts.checked : this.texts.checkedPlural);
        return this.selectedModel.length + ' ' + (this.selectedModel.length === 1 ? this.texts.checked : this.texts.checkedPlural);
    };
    MultiselectDropdown.prototype.updateNumSelected = function () {
        this.numSelected = this.selectedModel.length;
    };
    MultiselectDropdown.prototype.checkAll = function () {
        this.selectedModel = this.options.map(function (option) { return option.id; });
        this.modelChanged();
    };
    MultiselectDropdown.prototype.uncheckAll = function () {
        this.selectedModel = [];
        this.modelChanged();
    };
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Array)
    ], MultiselectDropdown.prototype, "options", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MultiselectDropdown.prototype, "settings", void 0);
    __decorate([
        core_1.Input(), 
        __metadata('design:type', Object)
    ], MultiselectDropdown.prototype, "texts", void 0);
    __decorate([
        core_1.Input('defaultModel'), 
        __metadata('design:type', Array)
    ], MultiselectDropdown.prototype, "selectedModel", void 0);
    __decorate([
        core_1.Output('selectedModel'), 
        __metadata('design:type', Object)
    ], MultiselectDropdown.prototype, "model", void 0);
    __decorate([
        core_1.Output(), 
        __metadata('design:type', Object)
    ], MultiselectDropdown.prototype, "selectionLimitReached", void 0);
    __decorate([
        core_1.HostListener('document: click', ['$event.target']), 
        __metadata('design:type', Function), 
        __metadata('design:paramtypes', [Object]), 
        __metadata('design:returntype', void 0)
    ], MultiselectDropdown.prototype, "onClick", null);
    MultiselectDropdown = __decorate([
        core_1.Component({
            selector: 'ss-multiselect-dropdown',
            pipes: [SearchFilter],
            styles: ["\n\t\t    a { outline: none; }\n\t       "],
            template: "\n        <div class=\"btn-group\">\n            <button type=\"button\" class=\"dropdown-toggle btn\" [ngClass]=\"settings.buttonClasses\" (click)=\"toggleDropdown()\">{{ getTitle() }}&nbsp;<span class=\"caret\"></span></button>\n            <ul *ngIf=\"isVisible\" class=\"dropdown-menu\" [class.pull-right]=\"settings.pullRight\" [style.max-height]=\"settings.maxHeight\" style=\"display: block; height: auto; overflow-y: auto;\">\n                <li style=\"margin: 0px 5px 5px 5px;\" *ngIf=\"settings.enableSearch\">\n                    <div class=\"input-group input-group-sm\">\n                        <span class=\"input-group-addon\" id=\"sizing-addon3\"><i class=\"fa fa-search\"></i></span>\n                        <input type=\"text\" class=\"form-control\" placeholder=\"{{ texts.searchPlaceholder }}\" aria-describedby=\"sizing-addon3\" [ngFormControl]=\"search\">\n                        <span class=\"input-group-btn\" *ngIf=\"searchFilterText.length > 0\">\n                            <button class=\"btn btn-default\" type=\"button\" (click)=\"clearSearch()\"><i class=\"fa fa-times\"></i></button>\n                        </span>\n                    </div>\n                </li>\n                <li class=\"divider\" *ngIf=\"settings.enableSearch\"></li>\n                <li *ngIf=\"settings.showCheckAll\">\n                    <a href=\"#\" role=\"menuitem\" tabindex=\"-1\" (click)=\"checkAll()\">\n                        <span style=\"width: 16px;\" class=\"glyphicon glyphicon-ok\"></span>\n                        {{ texts.checkAll }}\n                    </a>\n                </li>\n                <li *ngIf=\"settings.showUncheckAll\">\n                    <a href=\"#\" role=\"menuitem\" tabindex=\"-1\" (click)=\"uncheckAll()\">\n                        <span style=\"width: 16px;\" class=\"glyphicon glyphicon-remove\"></span>\n                        {{ texts.uncheckAll }}\n                    </a>\n                </li>\n                <li *ngIf=\"settings.showCheckAll || settings.showUncheckAll\" class=\"divider\"></li>\n                <li *ngFor=\"let option of options\">\n                    <a href=\"javascript:void(0)\" role=\"menuitem\" tabindex=\"-1\" (click)=\"setSelected($event, option)\">\n                        <input *ngIf=\"settings.checkedStyle == 'checkboxes'\" type=\"checkbox\" [checked]=\"isSelected(option)\" />\n                        <span *ngIf=\"settings.checkedStyle == 'glyphicon'\" style=\"width: 16px;\" class=\"glyphicon\" [class.glyphicon-ok]=\"isSelected(option)\"></span>\n                        {{ option.name }}\n                    </a>\n                </li>            \n            </ul>\n        </div>\n    "
        }), 
        __metadata('design:paramtypes', [core_1.ElementRef])
    ], MultiselectDropdown);
    return MultiselectDropdown;
}());
exports.MultiselectDropdown = MultiselectDropdown;
//# sourceMappingURL=multiselect-dropdown.js.map