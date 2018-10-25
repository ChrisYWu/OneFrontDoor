import { Component, OnInit } from '@angular/core';
import {MileageInput, Mileage, UserMerchGroupInput, UserMerchGroup, RouteInput, RouteStop} from './mileageclass';
import { GridDataResult, SortDescriptor, orderBy, PageChangeEvent} from '@progress/kendo-angular-grid';
import { DispserviceService } from '../services/dispservice.service';

@Component({
  selector: 'app-report',
  templateUrl: './report.component.html',
  styleUrls: ['./report.component.css'],
   providers: [DispserviceService]
})
export class ReportComponent implements OnInit {

  private _webapi: string = "http://localhost/DPSG.DSDDeliveryTime.WebAPI/";
  public reportdata: Array<RouteStop>;
  public keys: Array<any>;
  public  merchGroupIDs: string;

  public routeInput: RouteInput ;
  public mileInput: MileageInput;
  private sort: SortDescriptor[] = [];
  private gridView: GridDataResult;
  private pageSize: number = 10;
  private skip: number = 0;
  private buttonCount: number = 5;
  private info: boolean = true;
  private type: 'numeric' | 'input' = 'numeric';
  private pageSizes: boolean = false;
  private previousNext: boolean = true;

  constructor(public dispService: DispserviceService) { }

  ngOnInit() {       
        this.loadData()
  }

  loadData(): void {
        this.dispService.set(this._webapi + 'api/Delivery/GetDeliveryByRoute/');
        this.routeInput = new RouteInput('110802221', new Date('2017-03-24'));
        this.getAllStoreReport(this.routeInput);
    }


    LoadMyData()
    {
        this.loadData()
    }
  

 getAllStoreReport(inputdata: RouteInput) {
        this.dispService.post(JSON.stringify(inputdata), true)
            .subscribe(res => {
                var d: any = res;
                this.reportdata = d.DeliveryStops;                
                if (this.reportdata != null)
                {
                  this.gridView = {
                      data: this.reportdata,
                      total: this.reportdata.length
                  };
                }
            },
            error => {
                if (error.status == 401 || error.status == 404) {
                }
            });
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
}
