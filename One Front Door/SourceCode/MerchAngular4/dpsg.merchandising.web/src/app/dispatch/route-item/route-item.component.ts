import {
  Component,
  OnInit,
  Input,
  Output,
  EventEmitter
} from '@angular/core';
import {
  MonitorService
} from '../../services/monitor.service';
// import {
//   CORE_DIRECTIVES
//} from '@angular/common';
// import {
//   MODAL_DIRECTIVES,
//   BS_VIEW_PROVIDERS
// } from 'ng2-bootstrap/ng2-bootstrap';


import {
  ImageURLInput,
  Dictionary,
  ExtendReadSASInput
} from '../../reporting/storeservice/MerchReport';

import {
  MerchConstant
} from '../../../app/MerchAppConstant';
import {
  DispserviceService
} from '../../services/dispservice.service';


import {StoreSignature, StoreDetails} from '../monitorclass';


export class ImageCaption {
  public Name1: string;
  public Name2: string = '';
  public istoolTip: boolean = false;


  constructor(orginalText: string) {
    var n: number = 25;
    this.Name1 = orginalText;


    if (orginalText.length > 25) {
      var prNames = orginalText.split(' ');
      var prName: string = '';
      var names = [];
      for (let i = 0; i < prNames.length; i++) {
        if (prName.length < 25) {
          if ((prName + ' ' + prNames[i]).length < 25) {
            prName = prName + ' ' + prNames[i];

          } else {
            names.push(prName);
            prName = '';
            prName = prName + prNames[i];
          }

        } else {
          names.push(prName);
          prName = '';
          prName = prName + prNames[i];
        }

        if (i == prNames.length - 1) {
          names.push(prName);
        }


      }

      if (names.length >= 2) {
        this.Name1 = names[0].substring(1, names[0].length + 1);
        this.Name2 = names[1];
        if (names.length > 2 || this.Name2.length > 22)
          this.istoolTip = true;
      } else {
        this.Name1 = names[0].substring(1, names[0].length + 1);
        this.Name2 = '';
      }

    } else {
      this.Name1 = orginalText;
    }
  }
}
@Component({
  //moduleId: module.id,
  selector: 'route-item',
  templateUrl: 'route-item.component.html',
  styleUrls: ['route-item.component.css'],
  providers: [MonitorService, DispserviceService]

  // viewProviders: [BS_VIEW_PROVIDERS],
  // providers: [MonitorService]
})
export class RouteItemComponent implements OnInit {

  @Input() stop: any;
  @Input() idx: number;
  @Input() count: number;
  @Output() ipStoreDetails: EventEmitter<any> = new EventEmitter();

  public storeDetails:StoreDetails  = new StoreDetails("","", 0,0,"",0,0,"","","","","");

  public storePictures: any[] = [];

  public displayPictures: any[] = [];

  //Popup 2 changes,
  public allPictures: any[] = [];

  public storeSignature:StoreSignature = new StoreSignature("Manager Name Not Available","","","","","","","","","","");

  private _webapi: string = MerchConstant.WebAPI_ENDPOINT;
  
  public readSASDictionary: Dictionary = {};

  constructor(
    private monitorService: MonitorService,
    private dispService: DispserviceService
  ) {

  }

  getLineTopText(endMileage: string, endDriveTime: string): string {
    let lineTopText: string = "";
    if ((endMileage != null) && (endDriveTime != null)) {
      if ((endDriveTime.trim() != '') && (endMileage.trim() != '')) {
        lineTopText = endMileage.trim() + '  |  ' + endDriveTime.trim();
      }

      if ((endDriveTime.trim() != '') && (endMileage.trim() == '')) {
        lineTopText = endDriveTime.trim();
      }

      if ((endDriveTime.trim() == '') && (endMileage.trim() != '')) {
        lineTopText = endMileage.trim();
      }

      if ((endDriveTime.trim() == '') && (endMileage.trim() == '')) {
        lineTopText = '';
      }

    }

    if ((endMileage == null) && (endDriveTime != null)) {
      if (endDriveTime.trim() != '') {
        lineTopText = endDriveTime.trim();
      }

    }

    if ((endMileage != null) && (endDriveTime == null)) {
      if (endMileage.trim() != '') {
        lineTopText = endMileage.trim();
      }
    }

    if ((endMileage == null) && (endDriveTime == null)) {
      lineTopText = '';
    }

    return "  " + lineTopText + "  ";
  }

  seprateStoreCode(): void {
    if (this.stop != null) {
      let _accountName = this.stop.AccountName;
      let _lastIndex = _accountName.lastIndexOf(" ");
      let _length = _accountName.length;
      let _accName = _accountName.substring(0, _lastIndex);
      let _accNo = _accountName.substring(_lastIndex, _length);
      this.stop.accName = _accName.trim();
      this.stop.accNo = _accNo.trim();
    }

  }

  showPopup(storeModal, stopMerchStopID, isForIp): void {
    if (stopMerchStopID > 0) {
      this.monitorService.getStoreDetailsData(stopMerchStopID)
        .subscribe(res => {
          var data: any = res.json();
          this.storeDetails = data.Details[0];
          if (data.StoreSignature[0] != null || data.StoreSignature[0] != undefined) {
            this.storeSignature = data.StoreSignature[0];
            if (this.storeSignature != null) {
              this.getStoreSignaturePicture(this.storeSignature);
            }
          }

          if (data.StorePictures != null || data.StorePictures != undefined) {
            let _sps = data.StorePictures;
            if (_sps.length > 0) {
              this.getStorePictures(_sps);
            }
          }

          if (data.BuildExecution != null || data.BuildExecution != undefined) {
            if (data.BuildExecution.length > 0) {
              this.getBuildExecution(data.BuildExecution);
            }
          }

          this.allPictures = this.displayPictures.concat(this.storePictures);

          if (isForIp) {
            //emit here
            this.ipStoreDetails.emit({
              'storeDetails': this.storeDetails,
              // 'storePictures': this.storePictures,
              // 'displayPictures': this.displayPictures,
              'allPictures': this.allPictures,
              'storeSignature': this.storeSignature,
              'stop': this.stop
            });
          } else {
            storeModal.show();
          }

        },
        error => {
          if (error.status == 401 || error.status == 404) {
            //this.notificationService.printErrorMessage('Authentication required');
            //this.utilityService.navigateToSignIn();
          }
        });

    }
  }


  getStopPlusCSS(stop: any): string {
    //    [class]="stop.EndConnectorType == 'Dash'? 'circle-plus-gray' : 'circle-plus-green" class="stop-circle circle-plus">
    let css = "stop-circle circle-plus circle-plus-gray"
    if (stop.ConnectorType.toLowerCase() == 'solid') {
      if (stop.DisplayBuildStatus.toLowerCase() == "not done") {
        css = "stop-circle circle-plus circle-plus-yellow";
      } else {
        css = "stop-circle circle-plus circle-plus-green";
      }
    } else {
      css = "stop-circle circle-plus circle-plus-gray";
    }

    return css;
  }
  getStopCSS(stop: any): string {
    //[class]="stop.ConnectorType == 'Solid'? 'stop-circle circle-green' : 'stop-circle circle-gray'"
    let css = "stop-circle circle-gray-fill"
    if (stop.ConnectorType.toLowerCase() == 'solid') {
      if (stop.DisplayBuildStatus.toLowerCase() == "not done") {
        css = "stop-circle circle-yellow-fill";
      } else {
        css = "stop-circle circle-green-fill";
      }
    } else {
      if (stop.DNSReason != '') {
        css = "stop-circle circle-gray-fill-DNS";
      }
      else {
        css = "stop-circle circle-gray-fill";
      }
    }

    return css;
  }
  getStopPlusCSSip(stop: any): string {
    let css = "stop-circle-ip circle-plus-ip circle-plus-gray"
    if (stop.ConnectorType.toLowerCase() == 'solid') {
      if (stop.DisplayBuildStatus.toLowerCase() == "not done") {
        css = "stop-circle-ip circle-plus-ip circle-plus-yellow";
      } else {
        css = "stop-circle-ip circle-plus-ip circle-plus-green";
      }
    } else {
      css = "stop-circle-ip circle-plus-ip circle-plus-gray";
    }

    return css;
  }

  getStopCSSip(stop: any): string {
    let css = "stop-circle-ip circle-gray-fill"
    if (stop.ConnectorType.toLowerCase() == 'solid') {
      if (stop.DisplayBuildStatus.toLowerCase() == "not done") {
        css = "stop-circle-ip circle-yellow-fill";
      } else {
        css = "stop-circle-ip circle-green-fill";
      }
    } else {
      if (stop.DNSReason != '') {
        css = "stop-circle-ip circle-gray-fill-DNS";
      }
      else {
        css = "stop-circle-ip circle-gray-fill";
      }
    }

    return css;
  }

  getStoreSignaturePicture(storeSignature) {
    this.storeSignature.azureImageURL = '';
    if (storeSignature.AbsoluteURL != null) {
      if (storeSignature.IsReadSASValid) {
        this.storeSignature.azureImageURL = storeSignature.AbsoluteURL + storeSignature.ReadSAS;
      }
      else {
        if (!this.readSASDictionary[storeSignature.ContainerID]) {
          this.dispService.set(this._webapi + 'api/Merc/ExtendContainerReadSAS');
          var extendingReadSASInput = new ExtendReadSASInput();
          extendingReadSASInput.ContainerID = storeSignature.ContainerID;
          this.dispService.post(JSON.stringify(extendingReadSASInput), true)
            .subscribe(res => {
              var d: any = res;
              // Add image ReadSAS to Dictionary
              this.readSASDictionary[storeSignature.ContainerID] = d.Response;
              this.storeSignature.azureImageURL = storeSignature.AbsoluteURL + this.readSASDictionary[storeSignature.ContainerID];
            },
            error => {
              if (error.status == 401 || error.status == 404) { 
                console.log(error);
              }
            });
        }
        else {
          this.storeSignature.azureImageURL = storeSignature.AbsoluteURL + this.readSASDictionary[storeSignature.ContainerID];
        }
      }
    }
  }

  getStorePictures(storePics) {
    this.storePictures = [];

    for (let i = 0; i < storePics.length; i++) {
      var cap = new ImageCaption(storePics[i].Caption);
      if (storePics[i].IsReadSASValid) {
        this.storePictures.push({
          'ImageURL': storePics[i].AbsoluteURL + storePics[i].ReadSAS,
          'Name1': cap.Name1,
          'Name2': cap.Name2,
          'Name3': '',
          'istoolTip': false,
          'RefusalReason': '',
          'isSlaePicture': false
        });
      } else {
        if (!this.readSASDictionary[storePics[i].ContainerID]) {
          this.dispService.set(this._webapi + 'api/Merc/ExtendContainerReadSAS');
          var extendingReadSASInput = new ExtendReadSASInput();
          extendingReadSASInput.ContainerID = storePics[i].ContainerID;
          this.dispService.post(JSON.stringify(extendingReadSASInput), true)
            .subscribe(res => {
              var d: any = res;
              // Add image ReadSAS to Dictionary
              this.readSASDictionary[storePics[i].ContainerID] = d.Response;
              var imageURL = storePics[i].AbsoluteURL + this.readSASDictionary[storePics[i].ContainerID];
              this.storePictures.push({
                'ImageURL': imageURL,
                'Name1': cap.Name1,
                'Name2': cap.Name2,
                'Name3': '',
                'istoolTip': false,
                'RefusalReason': '',
                'isSlaePicture': false
              });
            },
            error => {
              if (error.status == 401 || error.status == 404) { }
            });
        } else {
          var imageURL = storePics[i].AbsoluteURL + this.readSASDictionary[storePics[i].ContainerID];
          this.storePictures.push({
            'ImageURL': imageURL,
            'Name1': cap.Name1,
            'Name2': cap.Name2,
            'Name3': '',
            'istoolTip': false,
            'RefusalReason': '',
            'isSlaePicture': false
          });
        }
      }
    }
  }

  getBuildExecution(builds) {
    this.displayPictures = [];

    for (let i = 0; i < builds.length; i++) {
      var cap = new ImageCaption(builds[i].PromotionName);
      if (builds[i].IsReadSASValid) {
        this.displayPictures.push({
          'ImageURL': builds[i].AbsoluteURL + builds[i].ReadSAS,
          'Name1': cap.Name1,
          'Name2': cap.Name2,
          'Name3': builds[i].PromotionName,
          'istoolTip': cap.istoolTip,
          'RefusalReason': builds[i].RefusalReason,
          'isSlaePicture': true
        });
      } else {
        if (builds[i].BuildStatus == 'Not Built' && builds[i].ContainerID == null) {
          this.displayPictures.push({
            'ImageURL': "/assets/img/display-notexecuted.png",
            'Name1': cap.Name1,
            'Name2': cap.Name2,
            'Name3': builds[i].PromotionName,
            'istoolTip': cap.istoolTip,
            'RefusalReason': builds[i].RefusalReason,
            'isSlaePicture': true
          });
        } else {
          if (!this.readSASDictionary[builds[i].ContainerID]) {
            this.dispService.set(this._webapi + 'api/Merc/ExtendContainerReadSAS');
            var extendingReadSASInput = new ExtendReadSASInput();
            extendingReadSASInput.ContainerID = builds[i].ContainerID;
            this.dispService.post(JSON.stringify(extendingReadSASInput), true)
              .subscribe(res => {
                var d: any = res;
                // Add image ReadSAS to Dictionary
                this.readSASDictionary[builds[i].ContainerID] = d.Response;
                var imageURL = builds[i].AbsoluteURL + this.readSASDictionary[builds[i].ContainerID];
                var prcap = new ImageCaption(builds[i].PromotionName);
                this.displayPictures.push({
                  'ImageURL': imageURL,
                  'Name1': prcap.Name1,
                  'Name2': prcap.Name2,
                  'Name3': builds[i].PromotionName,
                  'istoolTip': cap.istoolTip,
                  'RefusalReason': builds[i].RefusalReason,
                  'isSlaePicture': true
                });
              },
              error => {
                if (error.status == 401 || error.status == 404) { }
              });
          } else {
            var imageURL = builds[i].AbsoluteURL + this.readSASDictionary[builds[i].ContainerID];
            this.displayPictures.push({
              'ImageURL': imageURL,
              'Name1': cap.Name1,
              'Name2': cap.Name2,
              'Name3': builds[i].PromotionName,
              'istoolTip': cap.istoolTip,
              'RefusalReason': builds[i].RefusalReason,
              'isSlaePicture': true
            });
          }
        }
      }

    }
  }

  ngOnInit() {
    this.seprateStoreCode();
  }

}

