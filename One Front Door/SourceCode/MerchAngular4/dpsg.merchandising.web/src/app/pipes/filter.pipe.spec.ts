import {
  it,
  describe,
  expect,
  inject,
  beforeEachProviders
} from '@angular/core/testing';
import { FilterPipe } from './filter.pipe';

describe('Filter Pipe', () => {
  beforeEachProviders(() => [FilterPipe]);

  it('should transform the input', inject([FilterPipe], (pipe: FilterPipe) => {
    //  expect(pipe.transform(true)).toBe(null);
  }));
});
