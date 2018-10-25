import {
  Component,
  OnInit,
  Input,
  Output,
  EventEmitter
} from '@angular/core';



@Component({
  moduleId: module.id,
  selector: 'image-list',
  templateUrl: 'image-list.component.html',
  styleUrls: ['image-list.component.css']
})


export class ImageListComponent implements OnInit {

  @Input() images: any[];

  /*
     imageInit(img:any)
      {
        debugger;
        if(img.Name.length > 30)
        {
          img.Name1 = img.Name.substring(0, 29);
          img.Name2 = img.Name.substring(30, img.Name.length-1);
        }else{
          img.Name1 = img.Name;
          img.Name2 = " ";
        }

      }
  */

  checkImageNme() {
 //    debugger;
    for (let i = 0; i < this.images.length; i++) {
      let img = this.images[i];

      if (img.Name.length > 25) {
        img.Name1 = img.Name.substring(0, 24);
        img.Name2 = img.Name.substring(24, img.Name.length+1);
      } else {
        img.Name1 = img.Name;
        img.Name2 = " ";
      }
    }
  }

  constructor() {}

  ngOnInit() {
     this.checkImageNme();
  }

}