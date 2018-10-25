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
import { AddmerchpopupComponent } from './addmerchpopup.component';

describe('Component: Addmerchpopup', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [AddmerchpopupComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([AddmerchpopupComponent],
      (component: AddmerchpopupComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(AddmerchpopupComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(AddmerchpopupComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-addmerchpopup></app-addmerchpopup>
  `,
  directives: [AddmerchpopupComponent]
})
class AddmerchpopupComponentTestController {
}

