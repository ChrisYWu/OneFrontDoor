import {
  beforeEachProviders,
  it,
  describe,
  expect,
  inject
} from '@angular/core/testing';
import { HeadernavService } from './headernav.service';

describe('Headernav Service', () => {
  beforeEachProviders(() => [HeadernavService]);

  it('should ...',
      inject([HeadernavService], (service: HeadernavService) => {
    expect(service).toBeTruthy();
  }));
});
