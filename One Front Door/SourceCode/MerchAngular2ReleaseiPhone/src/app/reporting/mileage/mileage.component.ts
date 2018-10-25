import { Component, OnInit, Input, ViewEncapsulation } from '@angular/core';
//import {FORM_DIRECTIVES} from '@angular/common';
//import {bootstrap}     from '@angular/platform-browser-dynamic';
import { DispserviceService } from '../../services/dispservice.service';
import {MileageInput, Mileage, UserMerchGroupInput, UserMerchGroup} from './mileageclass';
import {SearchPipe} from "ng2-easy-table/app/pipes/header-pipe";
import {PaginationPipe} from "ng2-easy-table/app/pipes/pagination-pipe";
import {GlobalSearchPipe} from "ng2-easy-table/app/pipes/global-search-pipe";
// import {FiltersService} from "ng2-easy-table/app/services/filters-service";
// import {ConfigService} from "ng2-easy-table/app/services/config-service";
// import {ResourceService} from "ng2-easy-table/app/services/resource-service";
import {GlobalSearch} from "ng2-easy-table/app/components/global-search/global-search.component";
import {CsvExport} from "ng2-easy-table/app/components/dropdown/csv-export.component";
import {Header} from "ng2-easy-table/app/components/header/header.component";
import {Pagination} from "ng2-easy-table/app/components/pagination/pagination.component";
import {DatePicker} from 'ng2-datepicker/ng2-datepicker';
import {ChangeNamePipe} from '../StoreService/NamePipe';
import {MerchConstant} from '../../../app/MerchAppConstant';
import {MultiselectDropdown, IMultiSelectOption, IMultiSelectSettings, IMultiSelectTexts} from '../StoreService/multiselect-dropdown';
import {Subscription} from 'rxjs/Subscription';
import { HeadernavService } from '../../services/headernav.service';
import {MerchGroup} from '../../services/planning';


@Component({
   // moduleId: module.id,
    selector: 'app-mileage',
    templateUrl: 'mileage.component.html',
    styleUrls: ['mileage.component.css'],
   // directives: [Header, Pagination, GlobalSearch, CsvExport, DatePicker, MultiselectDropdown],
   // providers: [FiltersService, ResourceService, ConfigService, DispserviceService, HeadernavService],
      providers: [ DispserviceService, HeadernavService],
  //  pipes: [SearchPipe, PaginationPipe, GlobalSearchPipe, ChangeNamePipe]

})
export class MileageComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;

    item: MerchGroup = new MerchGroup();
    subscription: Subscription;

    public mileInput: MileageInput;
    public usrGeo: UserMerchGroupInput;
    public usrAllGeo: UserMerchGroup;
    public reportdata: Array<Mileage>;
    public keys: Array<any>;
    public numberOfItems: number;
    public FromDate: string;
    public ToDate: string;
    public selectedGeo: Array<any> = [];
    public showNoDataMessage: Boolean = false;



    private mySettings: IMultiSelectSettings = {
        pullRight: false,
        enableSearch: false,
        checkedStyle: 'checkboxes',
        buttonClasses: 'btn btn-default',
        selectionLimit: 5,
        closeOnSelect: false,
        showCheckAll: false,
        showUncheckAll: false,
        dynamicTitleMaxItems: 0,
        maxHeight: '300px',
    };

    private myTexts: IMultiSelectTexts = {
        checkAll: 'Check all',
        uncheckAll: 'Uncheck all',
        checked: 'checked',
        checkedPlural: 'checked',
        searchPlaceholder: 'Search...',
        defaultTitle: 'Select Groups',
    };


    constructor(
       // public filtersService: FiltersService,
      //  public config: ConfigService,
       // public resource: ResourceService,
        public dispService: DispserviceService,
        public navService: HeadernavService
    ) {
        this.numberOfItems = 1;
       // this.config.rows = 25;
    }


    ngOnInit() {
        // Set previous week from and to date
        var curr = new Date; // get current date

        var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay() - 7));
        var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 6));

        this.FromDate = firstday.toISOString().split('T')[0];
        this.ToDate = lastday.toISOString().split('T')[0];
        this.subscription = this.navService.navItem$
            .subscribe(item => {
                this.item = item;
                if (this.item.MerchGroupID) {
                    this.getMerchGroups(this.item);
                    this.selectedGeo = [];
                    this.selectedGeo[0] = this.item.MerchGroupID;
                    this.loadData();
                }
            }
            );
    }

    optionsUpdated($event) {
        this.selectedGeo = $event;
    }

    getMerchGroups(itemMerchGroup: MerchGroup): void {
        this.dispService.set(this._webapi + 'api/Merc/GetUserMerchGroups/');
        this.usrGeo = new UserMerchGroupInput(itemMerchGroup.LoggedInUser);
        this.getUserMerchGroups(this.usrGeo);
    }

    getUserMerchGroups(inputdata: UserMerchGroupInput) {
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(res => {
                var d: any = res;
                this.usrAllGeo = d.UserMerchGroups;
            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });
    }

    loadData(): void {

        this.dispService.set(this._webapi + 'api/Merc/GetMileageReport/');
        this.mileInput = new MileageInput(this.selectedGeo.join(','), new Date(this.FromDate), new Date(this.ToDate));
        this.getAllStoreReport(this.mileInput);
    }

    getAllStoreReport(inputdata: MileageInput) {
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(res => {
                var d: any = res;
                this.reportdata = d.Mileages;
                this.numberOfItems = d.Mileages.length;
                if (d.Mileages.length > 0) {
                    this.showNoDataMessage = false;
                    this.keys = Object.keys(d.Mileages[0]);
                   // this.resource.keys = this.keys;
                }
                else {
                    this.showNoDataMessage = true;
                }

            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });
    }

    FilterReportData() {

        if (this.ToDate < this.FromDate) {
            alert("To Date cannot be less than From Date.");
            return;
        }
        else if (this.selectedGeo.length <= 0) {
            alert("Please select Geo.");
            return;
        }
        else if (this.days_between(this.ToDate, this.FromDate) > 31) {
            alert("Date range cannot exceed 31 days.")
            return;
        }

        this.mileInput = new MileageInput(this.selectedGeo.join(','), new Date(this.FromDate), new Date(this.ToDate));
        this.getAllStoreReport(this.mileInput);
    }

    public orderBy(key: string) {
      //  this.reportdata = this.resource.sortBy(key);
    }

    public parseDate(input) {
        var parts = input.match(/(\d+)/g);
        return new Date(parts[0], parts[1] - 1, parts[2]); // months are 0-based
    }


    public days_between(date1, date2) {

        // The number of milliseconds in one day
        var ONE_DAY = 1000 * 60 * 60 * 24

        var d1 = this.parseDate(date1);
        var d2 = this.parseDate(date2);

        // Convert both dates to milliseconds
        var date1_ms = d1.getTime();
        var date2_ms = d2.getTime();

        // Calculate the difference in milliseconds
        var difference_ms = Math.abs(date1_ms - date2_ms);

        // Convert back to days and return
        return Math.round(difference_ms / ONE_DAY);
    }

}
