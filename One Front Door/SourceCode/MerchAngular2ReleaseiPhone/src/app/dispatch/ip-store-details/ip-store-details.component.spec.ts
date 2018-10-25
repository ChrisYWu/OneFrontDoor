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
import { IpStoreDetailsComponent } from './ip-store-details.component';

describe('Component: IpStoreDetails', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [IpStoreDetailsComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([IpStoreDetailsComponent],
      (component: IpStoreDetailsComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(IpStoreDetailsComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(IpStoreDetailsComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-ip-store-details></app-ip-store-details>
  `,
  directives: [IpStoreDetailsComponent]
})
class IpStoreDetailsComponentTestController {
}

