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
import { PlMerchInfoComponent } from './pl-merch-info.component';

describe('Component: PlMerchInfo', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [PlMerchInfoComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([PlMerchInfoComponent],
      (component: PlMerchInfoComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(PlMerchInfoComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(PlMerchInfoComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-pl-merch-info></app-pl-merch-info>
  `,
  directives: [PlMerchInfoComponent]
})
class PlMerchInfoComponentTestController {
}

