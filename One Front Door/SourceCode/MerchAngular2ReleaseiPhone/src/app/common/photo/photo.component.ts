import { Component, OnInit } from '@angular/core';


@Component({
  //moduleId: module.id,
  selector: 'app-photo',
  templateUrl: 'photo.component.html',
  styleUrls: ['photo.component.css']
})
export class PhotoComponent implements OnInit {

   public imageDataByWebCam: any;

  constructor() {}

   gotSnapshot(input)
    {       
        this.imageDataByWebCam = input.dataUrl;
        console.log(input);
    }

  ngOnInit() {
  }

}
