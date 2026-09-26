import { defineConfig } from '@playwright/test';
import { withMergify } from '@mergifyio/playwright';

export default withMergify(defineConfig({
  testDir: './tests',
  workers: 1,
  retries: 0,
  reporter: [['line']],
}));
