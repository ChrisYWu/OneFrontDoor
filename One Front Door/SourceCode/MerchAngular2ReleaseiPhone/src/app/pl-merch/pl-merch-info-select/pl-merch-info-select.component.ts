import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'pl-merch-info-select',
  templateUrl: 'pl-merch-info-select.component.html',
  styleUrls: ['pl-merch-info-select.component.css']
})
export class PlMerchInfoSelectComponent implements OnInit {

@Input() idx: number; 
@Input() Merchandiser: any;

  constructor() {}

  ngOnInit() {
  }

}
