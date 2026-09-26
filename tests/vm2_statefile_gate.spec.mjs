import { test, expect } from '@mergifyio/playwright';
import { appState } from '../src/app.mjs';

test('trusted security sentinel', async () => {
  expect(appState).toBe('safe');
});
