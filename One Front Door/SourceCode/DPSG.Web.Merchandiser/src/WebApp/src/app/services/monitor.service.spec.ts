import {
  beforeEachProviders,
  it,
  describe,
  expect,
  inject
} from '@angular/core/testing';
import { MonitorService } from './monitor.service';

describe('Monitor Service', () => {
  beforeEachProviders(() => [MonitorService]);

  it('should ...',
      inject([MonitorService], (service: MonitorService) => {
    expect(service).toBeTruthy();
  }));
});
