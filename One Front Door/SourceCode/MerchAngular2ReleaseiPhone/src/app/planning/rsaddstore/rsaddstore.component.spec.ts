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
import { RsaddstoreComponent } from './rsaddstore.component';

describe('Component: Rsaddstore', () => {
  let builder: TestComponentBuilder;

  beforeEachProviders(() => [RsaddstoreComponent]);
  beforeEach(inject([TestComponentBuilder], function (tcb: TestComponentBuilder) {
    builder = tcb;
  }));

  it('should inject the component', inject([RsaddstoreComponent],
      (component: RsaddstoreComponent) => {
    expect(component).toBeTruthy();
  }));

  it('should create the component', inject([], () => {
    return builder.createAsync(RsaddstoreComponentTestController)
      .then((fixture: ComponentFixture<any>) => {
        let query = fixture.debugElement.query(By.directive(RsaddstoreComponent));
        expect(query).toBeTruthy();
        expect(query.componentInstance).toBeTruthy();
      });
  }));
});

@Component({
  selector: 'test',
  template: `
    <app-rsaddstore></app-rsaddstore>
  `,
  directives: [RsaddstoreComponent]
})
class RsaddstoreComponentTestController {
}

