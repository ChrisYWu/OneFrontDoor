import { Component, OnInit, Input } from '@angular/core';

@Component({
  moduleId: module.id,
  selector: 'pl-merch-info',
  templateUrl: 'pl-merch-info.component.html',
  styleUrls: ['pl-merch-info.component.css']
})
export class PlMerchInfoComponent implements OnInit {

@Input() idx: number;
@Input() GSN: string;
@Input() LastName: string ;
@Input() FirstName: string;
@Input() Email: string;
@Input() Phone: string;


    
  constructor() {}

  ngOnInit() {
  }

}
