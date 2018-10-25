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
import { MonitorPopupComponent } from './monitor-popup.component';

describe('Component: MonitorPopup', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [MonitorPopupComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([MonitorPopupComponent],
      (component: MonitorPopupComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(MonitorPopupComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(MonitorPopupComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-monitor-popup></app-monitor-popup>
  `,
  directives: [MonitorPopupComponent]
})
class MonitorPopupComponentTestController {
}

