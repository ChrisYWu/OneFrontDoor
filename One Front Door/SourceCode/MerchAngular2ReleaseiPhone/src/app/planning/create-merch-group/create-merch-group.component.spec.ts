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
import { CreateMerchGroupComponent } from './create-merch-group.component';

describe('Component: CreateMerchGroup', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [CreateMerchGroupComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([CreateMerchGroupComponent],
      (component: CreateMerchGroupComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(CreateMerchGroupComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(CreateMerchGroupComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-create-merch-group></app-create-merch-group>
  `,
  directives: [CreateMerchGroupComponent]
})
class CreateMerchGroupComponentTestController {
}

