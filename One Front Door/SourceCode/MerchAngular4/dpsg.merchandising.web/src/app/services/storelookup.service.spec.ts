import {
  beforeEachProviders,
  it,
  describe,
  expect,
  inject
} from '@angular/core/testing';
import { StorelookupService } from './storelookup.service';

describe('Storelookup Service', () => {
  beforeEachProviders(() => [StorelookupService]);

  it('should ...',
      inject([StorelookupService], (service: StorelookupService) => {
    expect(service).toBeTruthy();
  }));
});
