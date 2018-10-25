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
import { PlMerchInfoSelectComponent } from './pl-merch-info-select.component';

describe('Component: PlMerchInfoSelect', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [PlMerchInfoSelectComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([PlMerchInfoSelectComponent],
      (component: PlMerchInfoSelectComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(PlMerchInfoSelectComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(PlMerchInfoSelectComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-pl-merch-info-select></app-pl-merch-info-select>
  `,
  directives: [PlMerchInfoSelectComponent]
})
class PlMerchInfoSelectComponentTestController {
}

