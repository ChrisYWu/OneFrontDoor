import {
  Component,
  OnInit,
  Input
} from '@angular/core';

@Component({
  moduleId: module.id,
  selector: 'route-info',
  templateUrl: 'route-info.component.html',
  styleUrls: ['route-info.component.css']
})
export class RouteInfoComponent implements OnInit {

  @Input() dispatch: any;
  public circle_css: string = "circle-gray"

  constructor() {}

  getCircleColor() {

    //debugger;

    if (this.dispatch != null) {
      let _status = this.dispatch.RouteStatusLabel.toLowerCase()

      if (_status.indexOf("star") >= 0) {
        this.circle_css = "circle-orange"
      }

      if (_status.indexOf("complete") >= 0) {
        this.circle_css = "circle-green"
      }

      if (_status.indexOf("pending") >= 0) {
        this.circle_css = "circle-red"
      }

      this.circle_css = 'img-persion ' + this.circle_css;
    }
  }

  ngOnInit() {

    this.getCircleColor()

  }

}