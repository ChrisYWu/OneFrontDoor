
import {Component, OnInit, Input, ViewEncapsulation, ViewChild} from '@angular/core';
import {CORE_DIRECTIVES, FORM_DIRECTIVES} from '@angular/common';
import {MODAL_DIRECTIVES, BS_VIEW_PROVIDERS, ModalDirective} from 'ng2-bootstrap/ng2-bootstrap';
import {bootstrap}     from '@angular/platform-browser-dynamic';
import { DispserviceService } from '../../services/dispservice.service';
import {StoreServiceInput, StoreService, UserMerchGroupInput, UserMerchGroup, ImageInput, ImageDetail, ImageURLInput, Dictionary, ExtendReadSASInput} from './MerchReport';
import {SearchPipe} from "ng2-easy-table/app/pipes/header-pipe";
import {PaginationPipe} from "ng2-easy-table/app/pipes/pagination-pipe";
import {GlobalSearchPipe} from "ng2-easy-table/app/pipes/global-search-pipe";
import {FiltersService} from "ng2-easy-table/app/services/filters-service";
import {ConfigService} from "ng2-easy-table/app/services/config-service";
import {ResourceService} from "ng2-easy-table/app/services/resource-service";
import {GlobalSearch} from "ng2-easy-table/app/components/global-search/global-search.component";
import {CsvExport} from "ng2-easy-table/app/components/dropdown/csv-export.component";
import {Header} from "ng2-easy-table/app/components/header/header.component";
import {Pagination} from "ng2-easy-table/app/components/pagination/pagination.component";
import {DatePicker} from 'ng2-datepicker/ng2-datepicker';
import {ChangeNamePipe} from './NamePipe';
import {MerchConstant} from '../../../app/MerchAppConstant';
import {MultiselectDropdown, IMultiSelectOption, IMultiSelectSettings, IMultiSelectTexts} from './multiselect-dropdown';
import {Subscription} from 'rxjs/Subscription';
import { HeadernavService } from '../../services/headernav.service';
import {MerchGroup} from '../../services/planning';
import { SpinnerComponent } from '../../common/spinner';

@Component({
    moduleId: module.id,
    selector: 'app-storeservice',
    templateUrl: 'storeservice.component.html',
    styleUrls: ['storeservice.component.css'],
    directives: [Header, Pagination, GlobalSearch, CsvExport, DatePicker, FORM_DIRECTIVES, MultiselectDropdown, MODAL_DIRECTIVES, CORE_DIRECTIVES, SpinnerComponent],
    providers: [FiltersService, ResourceService, ConfigService, DispserviceService, HeadernavService],
    viewProviders: [BS_VIEW_PROVIDERS],
    pipes: [SearchPipe, PaginationPipe, GlobalSearchPipe, ChangeNamePipe]

})


export class StoreserviceComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    private mydayWebAPI: string = MerchConstant.MYDAY_WebAPI_ENDPOINT;

    public isRequesting: boolean;

    @ViewChild('lgModal') lgModal: ModalDirective;
    item: MerchGroup = new MerchGroup();
    subscription: Subscription;

    public storeInput: StoreServiceInput;
    public usrGeo: UserMerchGroupInput;
    public usrAllGeo: UserMerchGroup;
    public imgInput: ImageInput;
    public imgDetail: Array<ImageDetail>;
    public imgURLInput: ImageURLInput;
    public reportdata: Array<StoreService>;
    public keys: Array<any>;
    public numberOfItems: number;
    public FromDate: string;
    public ToDate: string;
    public selectedGeo: Array<any> = [];
    public showNoDataMessage: Boolean = false;
    public imgURLList: Array<string> = [];
    public readSASDictionary : Dictionary = {};

    private mySettings: IMultiSelectSettings = {
        pullRight: false,
        enableSearch: false,
        checkedStyle: 'checkboxes',
        buttonClasses: 'btn btn-default',
        selectionLimit: 50,
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


    constructor(public filtersService: FiltersService,
        public config: ConfigService,
        public resource: ResourceService,
        public dispService: DispserviceService,
        public navService: HeadernavService) {
        this.numberOfItems = 1;
        this.config.rows = 25;
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

    getImageDetails(imageBlobID: any) {
       this.imgURLList = [];
        if (imageBlobID) {
            //  //Call WebAPI to get the details
            this.dispService.set(this._webapi + 'api/Merc/GetImageDetailByBlobID/');
            this.imgInput = new ImageInput(imageBlobID);
            this.getImageDetailByBlobID(this.imgInput);
        }
        else {
            alert("There is no image.");
        }
    }

    getEachImageURL() {
        // // Call WebAPI to get list of image URLs
        for (var i = 0; i < this.imgDetail.length; i++) {
            // Call web service to get the URL              
            this.imgURLInput = new ImageURLInput(
                this.imgDetail[i].AbsoluteURL,
                this.imgDetail[i].ContainerID,
                this.imgDetail[i].ReadSAS,
                this.imgDetail[i].IsReadSASValid
            );
            this.getImageURL(this.imgURLInput);
        }
        this.lgModal.show();                                
    }

    getImageURL(inputdata: ImageURLInput) {
        var imageURL : string;

        if (inputdata.IsReadSASValid == true)
        {
            imageURL = inputdata.AbsoluteURL + inputdata.ReadSAS;
            this.imgURLList.push(imageURL);
        }
        else 
        {
            if (!this.readSASDictionary[inputdata.ContainerID])
            {
                this.dispService.set(this.mydayWebAPI + 'api/Imaging/ExtendContainerReadSAS');
                var extendingReadSASInput = new ExtendReadSASInput();
                extendingReadSASInput.ContainerID = inputdata.ContainerID;
                this.dispService.post(JSON.stringify(extendingReadSASInput), true)
                    .subscribe(res => {
                        var d: any = res;
                        // Add image ReadSAS to Dictionary
                        this.readSASDictionary[inputdata.ContainerID] = d.Response;
                        imageURL = inputdata.AbsoluteURL + this.readSASDictionary[inputdata.ContainerID];            
                        this.imgURLList.push(imageURL);
                    },
                    error => {
                        if (error.status == 401 || error.status == 404) {
                        }
                    });
            }
            else {
                imageURL = inputdata.AbsoluteURL + this.readSASDictionary[inputdata.ContainerID];            
                this.imgURLList.push(imageURL);
            }
        }
    }
  
    getImageDetailByBlobID(inputdata: ImageInput) {
        this.isRequesting = true;
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(res => {
                var d: any = res;
                this.imgDetail = d.Images;
                this.getEachImageURL();
            },
             () => this.stopRefreshing(),
             () => this.stopRefreshing()
            // error => {
            //     if (error.status == 401 || error.status == 404) {
            //     }
            // }            
            );
    }

      private stopRefreshing() {
        this.isRequesting = false;
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
        this.storeInput = new StoreServiceInput(this.selectedGeo.join(','), new Date(this.FromDate), new Date(this.ToDate));
        this.getAllStoreReport(this.storeInput);
    }

    getAllStoreReport(inputdata: StoreServiceInput) {
        this.dispService.set(this._webapi + 'api/Merc/GetStoreServicedReport/');
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(res => {
                var d: any = res;
                this.reportdata = d.StoreServices;
                this.numberOfItems = d.StoreServices.length;
                if (d.StoreServices.length > 0) {
                    this.showNoDataMessage = false;
                    this.keys = Object.keys(d.StoreServices[0]);
                    this.resource.keys = this.keys;
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

        this.storeInput = new StoreServiceInput(this.selectedGeo.join(','), new Date(this.FromDate), new Date(this.ToDate));
        this.getAllStoreReport(this.storeInput);
    }

    public orderBy(key: string) {
        this.reportdata = this.resource.sortBy(key);
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
