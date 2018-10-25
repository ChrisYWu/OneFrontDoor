import {
  Component,
  OnInit,
  Input,
  Output,
  EventEmitter
} from '@angular/core';
import {
  CORE_DIRECTIVES
} from '@angular/common';
import {
  MODAL_DIRECTIVES,
  BS_VIEW_PROVIDERS
} from 'ng2-bootstrap/ng2-bootstrap';
import {
  MonitorPopupComponent
} from '../monitor-popup'
import {
  MonitorService
} from '../../services/monitor.service'

import {
  ImageURLInput, Dictionary, ExtendReadSASInput
} from '../../reporting/storeservice/MerchReport';
import {
  MerchConstant
} from '../../../app/MerchAppConstant';
import {
  DispserviceService
} from '../../services/dispservice.service';

export class ImageCaption
{
    public Name1 : string; 
    public Name2 : string; 
    constructor(orginalText: string) {
      var n : number = 25;
      if (orginalText.length > 25) {
        this.Name1 = orginalText.substring(0, 24);
        this.Name2 = orginalText.substring(24, orginalText.length + 1);
      }
      else {
        this.Name1 = orginalText;
        this.Name2 = " ";
      }
    }
}

@Component({
  moduleId: module.id,
  selector: 'route-item',
  templateUrl: 'route-item.component.html',
  styleUrls: ['route-item.component.css'],
  directives: [MODAL_DIRECTIVES, CORE_DIRECTIVES, MonitorPopupComponent],
  viewProviders: [BS_VIEW_PROVIDERS],
  providers: [MonitorService, DispserviceService]
})
export class RouteItemComponent implements OnInit {

  @Input() stop: any;
  @Input() idx: number;
  @Input() count: number;

  public storeDetails: any = {
    CheckInTime: " ",
    CheckOutTime: " ",
    UserMileage: 0,
    AtAccountTimeInMinute: 0,
    TimeInStore: " ",
    CasesHandeled: 0,
    CaessInBackroom: 0,
    Comments: " "
  };

  public storePictures: any[] = [];

  public displayPictures: any[] = [];

  public storeSignature = {
    ManagerName: "Name not available",
    SignatureName: "",
    ClientTime: "",
    ClientTimeZone: "",
    RelativeURL: "",
    AbsoluteURL: "",
    StorageAccount: "",
    Container: "",
    AccessLevel: "",
    ConnectionString: "",
    azureImageURL: ""
  }

  private mydayWebAPI: string = MerchConstant.MYDAY_WebAPI_ENDPOINT;
  private readSASDictionary: Dictionary = {};

  constructor(
    private monitorService: MonitorService,
    private dispService: DispserviceService
  ) {

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

  showPopup(storeModal, stopMerchStopID): void {
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
          
          //here to add display pictures -- this.displayPictures = this.getDisplayPictures();  

          //below change implement latter on, once all senario check at local data, currently no data for all senarios 
          //  if(isStoreSignature && isStorePictures )
          //  {
          //   storeModal.show();
          //  }

          storeModal.show();

        },
        error => {
          if (error.status == 401 || error.status == 404) {
            //this.notificationService.printErrorMessage('Authentication required');
            //this.utilityService.navigateToSignIn();
          }
        });

    }
  }

  /*
    getDisplayPictures() {
      let _excPictures: any = []
  
      _excPictures
        = [{
            'ImageURL': 'contents/img/store3.PNG',
            'Name': '2016 Dr Pepper Event',
  
          }, {
            'ImageURL': 'contents/img/nostoreimage.PNG',
            'Name': '2016 Dr. Pepper Celebration No Time',
  
          }, {
            'ImageURL': 'contents/img/nostoreimage.PNG',
            'Name': '2016 Canada Dry Celebration No Time',
  
          },
  
          {
            'ImageURL': 'contents/img/nostoreimage.PNG',
            'Name': '2016 Dr. Pepper Celebration No Time 2',
  
          }, {
            'ImageURL': 'contents/img/nostoreimage.PNG',
            'Name': '2016 Canada Dry Celebration No Time 2',
  
          },
        ]
  
      return _excPictures;
    }
    */

  getStopCSS(stop: any): string {
    //[class]="stop.ConnectorType == 'Solid'? 'stop-circle circle-green' : 'stop-circle circle-gray'"
    let css = "stop-circle circle-gray-fill"
    if (stop.ConnectorType.toLowerCase() == 'solid') {
      if (stop.DisplayBuildStatus.toLowerCase() == "not done") {
        css = "stop-circle circle-red-fill";
      } else {
        css = "stop-circle circle-green-fill";
      }
    } else {
      css = "stop-circle circle-gray-fill";
    }

    return css;
  }

  getStoreSignaturePicture(storeSignature) {
    if (storeSignature.IsReadSASValid) {
      this.storeSignature.azureImageURL = storeSignature.AbsoluteURL + storeSignature.ReadSAS;
    }
    else {
      if (!this.readSASDictionary[storeSignature.ContainerID]) {
        this.dispService.set(this.mydayWebAPI + 'api/Imaging/ExtendContainerReadSAS');
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
            }
          });
      }
      else {
        this.storeSignature.azureImageURL = storeSignature.AbsoluteURL + this.readSASDictionary[storeSignature.ContainerID];
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
          'Name2': cap.Name2
        });
      }
      else {
        if (!this.readSASDictionary[storePics[i].ContainerID]) {
          this.dispService.set(this.mydayWebAPI + 'api/Imaging/ExtendContainerReadSAS');
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
                'Name2': cap.Name2
              });
            },
            error => {
              if (error.status == 401 || error.status == 404) {
              }
            });
        }
        else {
          var imageURL = storePics[i].AbsoluteURL + this.readSASDictionary[storePics[i].ContainerID];
          this.storePictures.push({
            'ImageURL': imageURL,
            'Name1': cap.Name1,
            'Name2': cap.Name2
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
          'Name2': cap.Name2
        });
      }
      else {
        if (!this.readSASDictionary[builds[i].ContainerID]) {
          this.dispService.set(this.mydayWebAPI + 'api/Imaging/ExtendContainerReadSAS');
          var extendingReadSASInput = new ExtendReadSASInput();
          extendingReadSASInput.ContainerID = builds[i].ContainerID;
          this.dispService.post(JSON.stringify(extendingReadSASInput), true)
            .subscribe(res => {
              var d: any = res;
              // Add image ReadSAS to Dictionary
              this.readSASDictionary[builds[i].ContainerID] = d.Response;
              var imageURL = builds[i].AbsoluteURL + this.readSASDictionary[builds[i].ContainerID];
              this.displayPictures.push({
                'ImageURL': imageURL,
                'Name1': cap.Name1,
                'Name2': cap.Name2
              });
            },
            error => {
              if (error.status == 401 || error.status == 404) {
              }
            });
        }
        else {
          var imageURL = builds[i].AbsoluteURL + this.readSASDictionary[builds[i].ContainerID];
          this.displayPictures.push({
            'ImageURL': imageURL,
            'Name1': cap.Name1,
            'Name2': cap.Name2
          });
        }
      }
    }
  }

getImageURL(inputdata: ImageURLInput): string {
  let azureImgURL: string = "";
  this.dispService.set(this.mydayWebAPI + 'MerchWebAPI/api/Imaging/GetReadOnlyImageURL');
  this.dispService.post(JSON.stringify(inputdata), true)
    .subscribe(res => {

      //  debugger;
      var d: any = res;
      // Add image URL in imageList
      azureImgURL = d.Response;

    },
    error => {
      //   debugger;
      if (error.status == 401 || error.status == 404) { }
    });

  return azureImgURL;
}

ngOnInit() {
  this.seprateStoreCode();
}

}
