import {
  Component,
  OnInit,
  Input, Output, EventEmitter
} from '@angular/core';

@Component({
  //moduleId: module.id,
  selector: 'route-info',
  templateUrl: 'route-info.component.html',
  styleUrls: ['route-info.component.css']
})
export class RouteInfoComponent implements OnInit {

  @Output() toggleClick = new EventEmitter();
  @Input() dispatch: any;
  public circle_css: string = "circle-gray"
  public isLongName: boolean = false;
  public isShowIpFulleName:boolean  = false;

  constructor() {}

showFullName(event)
{
  //debugger;
  this.isShowIpFulleName = !this.isShowIpFulleName;
  event.stopPropagation();

}

 getFullName(firstName:String, lastName:string): string
 {  // debugger; 
    let _fullName = firstName + ' ' + lastName; 
   this.isLongName = false; 
      
   //   _fullName = "Frstname aaaaaaaa Lastname bbbbbbbb "

if (_fullName.length > 18) 
{
     _fullName = _fullName.substring(0, 15)+'...'
      this.isLongName = true; 
}


    return _fullName;  
 }

  getCircleColor() {

    if (this.dispatch != null) {
      let _status = this.dispatch.RouteStatusLabel.toLowerCase()

      if (_status.indexOf("star") > 0) {
        this.circle_css = "circle-orange"
      }

      if (_status.indexOf("complete") > 0) {
        this.circle_css = "circle-green"
      }

      if (_status.indexOf("pending") > 0) {
        this.circle_css = "circle-red"
      }

      this.circle_css = 'img-persion ' + this.circle_css;
    }
  }

  ngOnInit() {

    this.getCircleColor()

  }

  onToggleClick()
  {

      //  debugger;
       this.toggleClick.emit({});

  }
}