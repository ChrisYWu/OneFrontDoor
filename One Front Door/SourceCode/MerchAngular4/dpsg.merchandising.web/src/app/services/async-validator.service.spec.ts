import {
  beforeEachProviders,
  it,
  describe,
  expect,
  inject
} from '@angular/core/testing';
import { AsyncValidatorService } from './async-validator.service';

describe('AsyncValidator Service', () => {
  beforeEachProviders(() => [AsyncValidatorService]);

  it('should ...',
      inject([AsyncValidatorService], (service: AsyncValidatorService) => {
    expect(service).toBeTruthy();
  }));
});
