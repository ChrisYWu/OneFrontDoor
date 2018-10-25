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
import { StoresetupMainComponent } from './storesetup-main.component';

describe('Component: StoresetupMain', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [StoresetupMainComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([StoresetupMainComponent],
      (component: StoresetupMainComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(StoresetupMainComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(StoresetupMainComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-storesetup-main></app-storesetup-main>
  `,
  directives: [StoresetupMainComponent]
})
class StoresetupMainComponentTestController {
}

