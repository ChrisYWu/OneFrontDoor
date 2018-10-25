import {
  Component,
  OnInit,
  Input,
  Output,
  EventEmitter
} from '@angular/core';



@Component({
  //moduleId: module.id,
  selector: 'image-list',
  templateUrl: 'image-list.component.html',
  styleUrls: ['image-list.component.css']
})


export class ImageListComponent implements OnInit {

  @Input() images: any[];

   @Output() showDPImage = new EventEmitter();

  /*
     imageInit(img:any)
      {
 
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

  getImageName(name)
  {
    return name.substring(0,21);
  }

  showDisplayImage(imageURL)
  {
      var result: any = { ImageURL: imageURL };
      this.showDPImage.emit(result);
  }

  constructor() {}

  ngOnInit() {
     this.checkImageNme();
  }

}