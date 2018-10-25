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
import { PlRoutePopupComponent } from './pl-route-popup.component';

describe('Component: PlRoutePopup', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [PlRoutePopupComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([PlRoutePopupComponent],
      (component: PlRoutePopupComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(PlRoutePopupComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(PlRoutePopupComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-pl-route-popup></app-pl-route-popup>
  `,
  directives: [PlRoutePopupComponent]
})
class PlRoutePopupComponentTestController {
}

