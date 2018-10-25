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
import { MerchsetupmainComponent } from './merchsetupmain.component';

describe('Component: Merchsetupmain', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [MerchsetupmainComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([MerchsetupmainComponent],
      (component: MerchsetupmainComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(MerchsetupmainComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(MerchsetupmainComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-merchsetupmain></app-merchsetupmain>
  `,
  directives: [MerchsetupmainComponent]
})
class MerchsetupmainComponentTestController {
}

