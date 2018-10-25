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
import { RsstorereassignComponent } from './rsstorereassign.component';

describe('Component: Rsstorereassign', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [RsstorereassignComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([RsstorereassignComponent],
      (component: RsstorereassignComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(RsstorereassignComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(RsstorereassignComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-rsstorereassign></app-rsstorereassign>
  `,
  directives: [RsstorereassignComponent]
})
class RsstorereassignComponentTestController {
}

