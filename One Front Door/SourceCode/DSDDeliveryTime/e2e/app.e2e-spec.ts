import { DSDDeliveryTimePage } from './app.po';

describe('dsddelivery-time App', function() {
  let page: DSDDeliveryTimePage;

  beforeEach(() => {
    page = new DSDDeliveryTimePage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
