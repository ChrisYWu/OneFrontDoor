import {
  beforeEachProviders,
  it,
  describe,
  expect,
  inject
} from '@angular/core/testing';
import { DispserviceService } from './dispservice.service';

describe('Dispservice Service', () => {
  beforeEachProviders(() => [DispserviceService]);

  it('should ...',
      inject([DispserviceService], (service: DispserviceService) => {
    expect(service).toBeTruthy();
  }));
});
