import { Component, OnInit } from '@angular/core';
import { DatePickerModule, DatePickerOptions, DateModel } from 'ng2-datepicker/ng2-datepicker';
import { MerchConstant } from '../../../app/MerchAppConstant';
import { MileageInput, Mileage, UserMerchGroupInput, UserMerchGroup } from './mileageclass';
import { MerchGroup } from '../../services/planning';
import { MultiselectDropdown, IMultiSelectOption, IMultiSelectSettings, IMultiSelectTexts } from '../multiselect-dropdown';
import { HeadernavService } from '../../services/headernav.service';
import { DispserviceService } from '../../services/dispservice.service';
import { Subscription } from 'rxjs/Subscription';
import { GridDataResult, SortDescriptor, orderBy, PageChangeEvent } from '@progress/kendo-angular-grid';


@Component({
    selector: 'app-rptmileage',
    templateUrl: 'rptmileage.component.html',
    styleUrls: ['rptmileage.component.scss'],
    providers: [DispserviceService, HeadernavService]
})
export class RptmileageComponent implements OnInit {

    private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
    item: MerchGroup = new MerchGroup();
    subscription: Subscription;

    public mileInput: MileageInput;
    public usrGeo: UserMerchGroupInput;
    public usrAllGeo: UserMerchGroup;
    public reportdata: Array<Mileage>;
    public keys: Array<any>;
    public FromDate: DateModel;
    public ToDate: DateModel;
    public selectedGeo: Array<any> = [];
    public showNoDataMessage: Boolean = false;

    private sort: SortDescriptor[] = [];
    private gridView: GridDataResult;
    private pageSize: number = 10;
    private skip: number = 0;
    private buttonCount: number = 5;
    private info: boolean = true;
    private type: 'numeric' | 'input' = 'numeric';
    private pageSizes: boolean = false;
    private previousNext: boolean = true;
    private filter: string;
    customFromDate: DatePickerOptions;
    customToDate: DatePickerOptions;


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

        // this.FromDate = firstday.toISOString().split('T')[0];
        // this.ToDate = lastday.toISOString().split('T')[0];



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


    private SearchFilter() {
        this.loadSearchData(this.reportdata.filter(Mileage =>
            (this.checkNullValues(Mileage.Merchandiser, this.filter.toLowerCase()) >= 0)
            || (this.checkNullValues(Mileage.Supervisor, this.filter.toLowerCase()) >= 0)
            || (this.checkNullValues(Mileage.CalculatedMiles, this.filter) >= 0)
            || (this.checkNullValues(Mileage.AdjustedMiles, this.filter) >= 0)
            || (this.checkNullValues(Mileage.GroupName, this.filter.toLowerCase()) >= 0)
        )

        );
    }

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

        this.dispService.set(this._webapi + 'api/Merc/GetMileageReport/');
        this.mileInput = new MileageInput(this.selectedGeo.join(','), new Date(fromdate), new Date(todate));
        this.getAllStoreReport(this.mileInput);
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

        this.mileInput = new MileageInput(this.selectedGeo.join(','), new Date(this.FromDate.year + "-" + this.FromDate.month + "-" + this.FromDate.day),
            new Date(this.ToDate.year + "-" + this.ToDate.month + "-" + this.ToDate.day));
        this.getAllStoreReport(this.mileInput);
    }


    getAllStoreReport(inputdata: MileageInput) {
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(res => {
                var d: any = res;
                this.reportdata = d.Mileages;
                this.keys = Object.keys(d.Mileages[0]);
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
        var data = this.reportdata;
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
