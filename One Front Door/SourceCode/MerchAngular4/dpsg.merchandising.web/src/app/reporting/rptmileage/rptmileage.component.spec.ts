/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { RptmileageComponent } from './rptmileage.component';

describe('RptmileageComponent', () => {
  let component: RptmileageComponent;
  let fixture: ComponentFixture<RptmileageComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RptmileageComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RptmileageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
