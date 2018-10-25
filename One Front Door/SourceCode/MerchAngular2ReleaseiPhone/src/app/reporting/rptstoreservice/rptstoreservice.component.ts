import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDirective } from 'ng2-bootstrap/ng2-bootstrap';
import { DatePickerModule, DatePickerOptions, DateModel } from 'ng2-datepicker/ng2-datepicker';
import { MerchConstant } from '../../../app/MerchAppConstant';
import { MerchGroup } from '../../services/planning';
import { MultiselectDropdown, IMultiSelectOption, IMultiSelectSettings, IMultiSelectTexts } from '../multiselect-dropdown';
import { HeadernavService } from '../../services/headernav.service';
import { DispserviceService } from '../../services/dispservice.service';
import { Subscription } from 'rxjs/Subscription';
import { GridDataResult, SortDescriptor, orderBy, PageChangeEvent } from '@progress/kendo-angular-grid';
import { StoreServiceInput, StoreService, UserMerchGroupInput, UserMerchGroup, ImageInput, ImageDetail, ImageURLInput, Dictionary, ExtendReadSASInput } from './MerchReport';
import { SpinnerComponent } from '../../common/spinner';


@Component({
    selector: 'app-rptstoreservice',
    templateUrl: './rptstoreservice.component.html',
    styleUrls: ['./rptstoreservice.component.scss'],
    providers: [DispserviceService, HeadernavService]
})

export class RptstoreserviceComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;

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
    public FromDate: DateModel;
    public ToDate: DateModel;
    public selectedGeo: Array<any> = [];
    public showNoDataMessage: Boolean = false;
    public imgURLList: Array<string> = [];
    public readSASDictionary: Dictionary = {};


    private sort: SortDescriptor[] = [];
    private gridView: GridDataResult;
    private pageSize: number = 10;
    private skip: number = 0;
    private buttonCount: number = 5;
    private info: boolean = true;
    private type: 'numeric' | 'input' = 'numeric';
    private pageSizes: boolean = false;
    private previousNext: boolean = true;
    private filterRpt: string;
    customFromDate: DatePickerOptions;
    customToDate: DatePickerOptions;
    tempFromDate: DateModel;
    tempToDate: DateModel;

    // private MerchColFilter: string;
    // private ChainColFilter: string;
    // private StoreColFilter: string;
    // private ManagerNameColFilter: string; 


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

    constructor(public dispService: DispserviceService,
        public navService: HeadernavService) { }

    ngOnInit() {

        // Set previous week from and to date
        var curr = new Date; // get current date
        var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay() - 7));
        var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 6));
        this.customFromDate = new DatePickerOptions(
            {
                autoApply: true,
                format: "dddd, MMM DD",
                firstWeekdaySunday: true,
                initialDate: firstday,

            }
        )
        this.customToDate = new DatePickerOptions(
            {
                autoApply: true,
                format: "dddd, MMM DD",
                firstWeekdaySunday: true,
                initialDate: lastday,

            }
        )

        this.subscription = this.navService.navItem$
            .subscribe(item => {
            this.item = item;
                if (this.item.MerchGroupID) {
                    this.getMerchGroups(this.item, firstday, lastday);
                }
            }
            );
    }

    protected sortChange(sort: SortDescriptor[]): void {
        this.sort = sort;
        this.loadRptSortData();
    }

    private loadRptSortData(): void {
        this.gridView = {
            data: orderBy(this.reportdata, this.sort),
            total: this.reportdata.length
        };
    }

    protected pageChange(event: PageChangeEvent): void {
        this.skip = event.skip;
        this.loadReportPaging();
    }

    private loadReportPaging(): void {
        this.gridView = {
            data: this.reportdata.slice(this.skip, this.skip + this.pageSize),
            total: this.reportdata.length
        };
    }

    private loadSearchData(filterRecords): void {
        this.gridView = {
            data: orderBy(filterRecords, this.sort),
            total: filterRecords.length
        };
    }


    private checkNullValues(colValue, filterValue) {
        if (colValue) {
            return colValue.toString().toLowerCase().indexOf(filterValue);
        }
    }

    private SearchFilterRpt() {
        this.loadSearchData(this.reportdata.filter(StoreService =>
            (this.checkNullValues(StoreService.Branch, this.filterRpt.toLowerCase()) >= 0)
            || (this.checkNullValues(StoreService.Merchandiser, this.filterRpt.toLowerCase()) >= 0)
            || (this.checkNullValues(StoreService.Chain, this.filterRpt.toLowerCase()) >= 0)
            || (this.checkNullValues(StoreService.StoreName, this.filterRpt.toLowerCase()) >= 0)
            || (this.checkNullValues(StoreService.ManagerName, this.filterRpt.toLowerCase()) >= 0)
            || (this.checkNullValues(StoreService.CasesWorked, this.filterRpt) >= 0)
            || (this.checkNullValues(StoreService.CasesInBackStop, this.filterRpt) >= 0)
            || (this.checkNullValues(StoreService.PicsLocation, this.filterRpt.toLowerCase()) >= 0)
            || (this.checkNullValues(StoreService.Comments, this.filterRpt.toLowerCase()) >= 0)
        )

        );
    }

    //      private ColumnFilterChange(columnName){

    //        if (columnName === "Chain")  
    //        {
    //           this.loadSearchData(this.reportdata.filter(StoreService => 
    //           (this.checkNullValues(StoreService.Chain, this.ChainColFilter.toLowerCase()) >= 0)
    //           ));
    //        }
    //       else if(columnName === "StoreName")
    //         {
    //             this.loadSearchData(this.reportdata.filter(StoreService => 
    //             (this.checkNullValues(StoreService.StoreName, this.StoreColFilter.toLowerCase()) >= 0)
    //             ));
    //         }
    //      else if(columnName === "Merchandiser")
    //         {
    //             this.loadSearchData(this.reportdata.filter(StoreService => 
    //             (this.checkNullValues(StoreService.Merchandiser, this.MerchColFilter.toLowerCase()) >= 0)
    //             ));
    //         }
    //      else if(columnName === "ManagerName")
    //         {
    //             this.loadSearchData(this.reportdata.filter(StoreService => 
    //             (this.checkNullValues(StoreService.ManagerName, this.ManagerNameColFilter.toLowerCase()) >= 0)
    //             ));
    //         }
    //    }   

    optionsUpdated($event) {
        this.selectedGeo = $event;
    }

    getMerchGroups(itemMerchGroup: MerchGroup, firstday: Date, lastday: Date): void {
        this.dispService.set(this._webapi + 'api/Merc/GetUserMerchGroups/');
        this.usrGeo = new UserMerchGroupInput(itemMerchGroup.LoggedInUser);
        this.getUserMerchGroups(this.usrGeo, firstday, lastday);
    }

    getUserMerchGroups(inputdata: UserMerchGroupInput, firstday: Date, lastday: Date) {
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(res => {
                var d: any = res;
                this.usrAllGeo = d.UserMerchGroups;
                this.selectedGeo = [];
                this.selectedGeo[0] = this.item.MerchGroupID;
                this.loadData(firstday, lastday);
            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });
    }
    loadData(fromdate, todate): void {
        this.storeInput = new StoreServiceInput(this.selectedGeo.join(','), new Date(fromdate), new Date(todate));
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
                }
                else {
                    this.showNoDataMessage = true;
                }

                this.gridView = {
                    data: this.reportdata,
                    total: this.reportdata.length
                };

            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });
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
            );
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
        var imageURL: string;

        if (inputdata.IsReadSASValid == true) {
            imageURL = inputdata.AbsoluteURL + inputdata.ReadSAS;
            this.imgURLList.push(imageURL);
        }
        else {
            if (!this.readSASDictionary[inputdata.ContainerID]) {
                this.dispService.set(this._webapi + 'api/Merc/ExtendContainerReadSAS');
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


    private stopRefreshing() {
        this.isRequesting = false;
    }


    FilterReportData() {

        if (this.parseDate(this.ToDate.year + "-" + this.ToDate.month + "-" + this.ToDate.day) < this.parseDate(this.FromDate.year + "-" + this.FromDate.month + "-" + this.FromDate.day)) {
            alert("To Date cannot be less than From Date.");
            return;
        }
        else if (this.selectedGeo.length <= 0) {
            alert("Please select Geo.");
            return;
        }
        else if (this.days_between(this.ToDate.year + "-" + this.ToDate.month + "-" + this.ToDate.day, this.FromDate.year + "-" + this.FromDate.month + "-" + this.FromDate.day) > 31) {
            alert("Date range cannot exceed 31 days.")
            return;
        }

        this.storeInput = new StoreServiceInput(this.selectedGeo.join(','), new Date(this.FromDate.year + "-" + this.FromDate.month + "-" + this.FromDate.day),
            new Date(this.ToDate.year + "-" + this.ToDate.month + "-" + this.ToDate.day));

        //this.storeInput = new StoreServiceInput(this.selectedGeo.join(','), new Date(this.FromDate), new Date(this.ToDate));
        this.getAllStoreReport(this.storeInput);
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

    exportData() {
        var data = this.reportdata
        var csvContent = "";
        var dataString = "";
        var x = [];
        data.forEach(function (row, index) {
            x[index] = [];
            for (var i in row) {
                if (row.hasOwnProperty(i)) {
                    if (typeof row[i] === "object") {
                        row[i] = ""; //"Object"; // so far just change object to "Object" string
                    }
                    x[index].push(row[i]);
                }
            }
        });
        var header = this.keys.join(",");
        csvContent += header + "\n";
        x.forEach(function (row, index) {
            dataString = row.join(",");
            csvContent += index < data.length ? dataString + "\n" : dataString;
        });

        var link = document.createElement("a");

        if (navigator.msSaveBlob) { // IE 10+
            var fileName = "MerchReport.csv";
            var blob = new Blob([csvContent], {
                "type": "text/csv;charset=utf8;"
            });
            navigator.msSaveBlob(blob, fileName);
        }
        else {
            var csvdatacontent = "data:text/csv;charset=utf-8," + csvContent;
            var encodedUri = encodeURI(csvdatacontent);
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", "MerchReport.csv");
            link.click();
        }
    }

}
