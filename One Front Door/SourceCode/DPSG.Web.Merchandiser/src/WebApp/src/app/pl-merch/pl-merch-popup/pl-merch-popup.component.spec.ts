import {
  beforeEach,
  beforeEachProviders,
  describe,
  expect,
  it,
  inject,
} from '@angular/core/testing';
import { ComponentFixture, TestComponentBuilder } from '@angular/compiler/testing';
import { Component } from '@angular/core';
import { By } from '@angular/platform-browser';
import { PlMerchPopupComponent } from './pl-merch-popup.component';

describe('Component: PlMerchPopup', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [PlMerchPopupComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([PlMerchPopupComponent],
      (component: PlMerchPopupComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(PlMerchPopupComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(PlMerchPopupComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-pl-merch-popup></app-pl-merch-popup>
  `,
  directives: [PlMerchPopupComponent]
})
class PlMerchPopupComponentTestController {
}

