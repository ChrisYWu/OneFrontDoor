import {
    Component,
    OnInit
} from '@angular/core';
import {
    DispatchRowComponent
} from './dispatch-row';
import {
    FilterPipe
} from '../pipes/filter.pipe';
import * as moment from 'moment';
import {
    MonitorService
} from '../services/monitor.service'

import {Subscription} from 'rxjs/Subscription';
import {MerchGroup} from '../services/planning';
import { HeadernavService } from '../services/headernav.service';
import { SpinnerComponent } from '../common/spinner';

@Component({
    moduleId: module.id,
    selector: 'dispatch',
    templateUrl: 'dispatch.component.html',
    styleUrls: ['dispatch.component.css'],
    directives: [DispatchRowComponent, SpinnerComponent],
    pipes: [FilterPipe],
    providers: [MonitorService, HeadernavService]
})

export class DispatchComponent implements OnInit {

    //debugger;
    public isRequesting: boolean;
    public monitorData: any[];
    public isShowDropDown: boolean = false;
    public ddDates: any[] = [];
    public selectedDate: string = moment().format('MMM D, YYYY');
    public selectedIndex: number = 0;
    public refreshTime: string = '';
    public msgText = "";
    public errText = "";
    item: MerchGroup = new MerchGroup();
    subscription: Subscription;


    getDdDates() {
        for (let i = 0; i <= 7; i++) {
            this.ddDates.push(moment().subtract(i, 'days').format("MMM D, YYYY"));
        };

    }

    nextDate() {
        this.isShowDropDown = false

        if (this.selectedIndex == 7) {
            this.selectedIndex = 0;
        } else {
            this.selectedIndex = this.selectedIndex + 1;
        }

        this.setSelectedDate()
        this.getMonitorData();
    }

    priorDate() {
        this.isShowDropDown = false

        if (this.selectedIndex == 0) {
            this.selectedIndex = 7;
        } else {
            this.selectedIndex = this.selectedIndex - 1;
        }

        this.setSelectedDate()
        this.getMonitorData();
    }

    setSelectedDate() {
        // this.selectedDate = moment().subtract(this.selectedIndex, 'days').format("MMM D, YYYY");
        this.selectedDate = moment('2016-09-19').format("MMM D, YYYY");
    }

    ddDateSelected(i: number) {
        this.isShowDropDown = false
        this.selectedIndex = i;

        this.setSelectedDate()
        this.getMonitorData();
    }

    //  to remove -   refreshData() { //to move at getMonitorData
    //        this.refreshTime = moment().format("h:mm:ss A");
    //    }

    constructor(private monitorService: MonitorService, public navService: HeadernavService) {
        this.getDdDates();
        //Note - belw will relpaced with getMonitorData and getMonitorDataStatic() function to remove 
        //this.getMonitorDataStatic();
    }

    private stopRefreshing() {
        this.isRequesting = false;
    }

    ngOnInit() {
        this.msgText = "";
        this.errText = "";
        this.subscription = this.navService.navItem$.subscribe(item => { this.item = item; this.loadMonitorData(this.item); });
    }

    loadMonitorData(item: MerchGroup) {
        this.item = item;
        if (this.item != null || this.item != undefined) {
            // debugger;  
            this.monitorData = [];
            this.msgText = "";
            this.errText = "";

            // to remove static data, it is for test to get all combination 
            this.getMonitorData();
            //this.getMonitorDataStatic();
        }

    }
    ngOnDestroy() {
        // prevent memory leak when component is destroyed
        this.msgText = "";
        this.errText = "";
        this.subscription.unsubscribe();
    }

    getMonitorData() {

        // debugger
        this.msgText = "";
        this.errText = "";
        let _selectedDate: string = moment(this.selectedDate).format('YYYY-MM-DD');
        //bug: 69 fix
        if ((this.item != null || this.item != undefined) && (this.item.MerchGroupID != undefined || this.item.MerchGroupID != null)) {

            this.isRequesting = true;
            this.monitorService.getMonitoringData(_selectedDate, this.item.MerchGroupID)
                .subscribe(res => {
                    var data: any[] = res.json();
                    this.errText = "";
                    if (data.length <= 0) {
                        this.msgText = "No data found for " + this.selectedDate;
                    } else {
                        this.msgText = "";
                        this.monitorData = data;
                        this.refreshTime = moment().format("h:mm A");
                    }
                },
                () => this.stopRefreshing(),
                () => this.stopRefreshing()
                );
        }

    }
}