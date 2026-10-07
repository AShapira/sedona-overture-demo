// Usage: PLAYWRIGHT_MODULE=/path/to/playwright node scripts/check-notebook-maps.cjs <attempt-dir>...
// Uses a separate headless browser; never touches an existing browser session.
const {chromium} = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const fs = require('node:fs');
const path = require('node:path');
const {pathToFileURL} = require('node:url');
const assert = require('node:assert/strict');

(async () => {
  assert.ok(process.argv.length > 2, 'Provide at least one notebook attempt directory');
  const browser = await chromium.launch({headless: true,
    args: ['--use-gl=angle', '--use-angle=swiftshader', '--enable-unsafe-swiftshader']});
  let failures = 0;
  try {
    for (const directory of process.argv.slice(2)) {
      const reports = [];
      for (const name of fs.readdirSync(directory).filter(n => /^map-\d+\.html$/.test(n)).sort()) {
        const page = await browser.newPage({viewport: {width: 1440, height: 950}});
        const report = {map: name, errors: [], externalRequests: [], status: 'running'};
        page.on('pageerror', e => report.errors.push(e.message));
        page.on('request', r => {if (/^https?:/.test(r.url())) report.externalRequests.push(r.url());});
        await page.route(/^https?:/, route => route.abort());
        try {
          await page.goto(pathToFileURL(path.resolve(directory, name)).href, {waitUntil: 'load'});
          await page.waitForFunction(() => typeof deck !== 'undefined' && deck.layerManager?.getLayers().length > 0,
            null, {timeout: 60000});
          await page.waitForTimeout(1000);
          report.initial = await page.evaluate(() => ({
            view: deck.viewManager.getViewState('MapView'), coordinates: coordinateCounts,
            layers: jsonInput.layers.map(l => ({id: l.id, features: l.data?.features?.length ?? l.data?.length ?? null})),
            canvas: [deck.canvas.width, deck.canvas.height],
          }));
          assert.ok(report.initial.canvas.every(n => n > 0));
          report.portPointStyles = await page.evaluate(() => deck.props.layers
            .filter(layer => ['ports-explicit', 'ports-candidate', 'ports-components'].includes(layer.id))
            .map(layer => ({id: layer.id, units: layer.props.pointRadiusUnits,
              radius: layer.props.getPointRadius, maxPixels: layer.props.pointRadiusMaxPixels})));
          for (const style of report.portPointStyles) {
            assert.equal(style.units, 'pixels');
            assert.equal(style.radius, 5);
            assert.equal(style.maxPixels, 6);
          }
          await page.mouse.move(720, 500);
          await page.mouse.wheel(0, -250);
          await page.waitForTimeout(700);
          const zoomed = await page.evaluate(() => deck.viewManager.getViewState('MapView'));
          assert.ok(zoomed.zoom > report.initial.view.zoom, 'Zoom did not change');
          await page.mouse.move(700, 500); await page.mouse.down();
          await page.mouse.move(810, 560, {steps: 8}); await page.mouse.up();
          await page.waitForTimeout(300);
          const panned = await page.evaluate(() => deck.viewManager.getViewState('MapView'));
          assert.notEqual(panned.longitude, zoomed.longitude, 'Pan did not change');
          report.pan = report.zoom = true;
          report.toggles = [];
          for (const checkbox of await page.locator('#map-toolbar input[type=checkbox]').all()) {
            const id = await checkbox.getAttribute('id');
            const before = await page.evaluate(() => deck.props.layers.map(l => [l.id, l.props.visible]));
            await checkbox.uncheck();
            const hidden = await page.evaluate(() => deck.props.layers.map(l => [l.id, l.props.visible]));
            assert.notDeepEqual(hidden, before, `Toggle ${id} did not change layers`);
            await checkbox.check();
            assert.deepEqual(await page.evaluate(() => deck.props.layers.map(l => [l.id, l.props.visible])), before);
            report.toggles.push(id);
          }
          report.viewButtons = [];
          for (const button of await page.locator('#map-toolbar button[data-view]').all()) {
            await button.click();
            await page.waitForTimeout(350);
            const view = await page.evaluate(() => deck.viewManager.getViewState('MapView'));
            assert.ok(Number.isFinite(view.zoom) && Number.isFinite(view.longitude));
            report.viewButtons.push({name: await button.getAttribute('data-view'), view});
          }
          // Exercise picking at actual feature coordinates, with bounded GPU reads.
          const hit = await page.evaluate(() => {
            const viewport = deck.getViewports()[0];
            const countries = jsonInput.layers.some(layer => layer.id === 'world-countries');
            // Country vertices sit on shared borders. Use interior points and the
            // mouse's zero-radius pick so nearby small countries cannot win.
            const candidates = countries
              ? [[2, 47], [12, 50], [37, 0], [-50, -10], [-100, 40], [135, -25]] : [];
            function coordinates(value) {
              if (!Array.isArray(value)) return;
              if (typeof value[0] === 'number') candidates.push(value);
              else for (const part of value.slice(0, 3)) coordinates(part);
            }
            for (const layer of jsonInput.layers.filter(l => l.pickable)) {
              for (const row of (layer.data?.features || layer.data || []).slice(0, 60)) {
                coordinates(row.geometry?.coordinates || row.position || row.coordinates);
              }
            }
            let attempts = 0;
            for (const coord of candidates) {
              const [x, y] = viewport.project(coord);
              if (x < 2 || y < 2 || x >= deck.width - 2 || y >= deck.height - 2) continue;
              if (++attempts > 30) break;
              const result = deck.pickObject({x, y, radius: countries ? 0 : 4});
              if (result?.object) {
                const rect = deck.canvas.getBoundingClientRect();
                const properties = result.object.properties || result.object;
                const template = tooltip?.text || tooltip?.html || '';
                const expected = [...template.matchAll(/\{(?:properties\.)?(\w+)\}/g)]
                  .map(match => ({field: match[1], value: properties[match[1]]}))
                  .filter(item => typeof item.value === 'string' && item.value &&
                    (item.field.includes('id') || item.field.includes('name') || item.field === 'tooltip_text'));
                return {x: x + rect.left, y: y + rect.top, expected};
              }
            }
            return null;
          });
          if (hit) {
            await page.mouse.move(hit.x, hit.y);
            await page.waitForTimeout(300);
            report.tooltip = await page.locator('.deck-tooltip').innerText();
            assert.ok(report.tooltip.trim(), 'Tooltip is empty');
            for (const item of hit.expected) {
              assert.ok(report.tooltip.includes(item.value), `Tooltip has incorrect ${item.field}: expected ${item.value}`);
            }
            report.tooltipFields = hit.expected;
          } else {
            throw new Error('No visible feature was picked; hover validation is incomplete');
          }
          await page.screenshot({path: path.join(directory, name.replace('.html', '.png'))});
          assert.deepEqual(report.errors, []);
          assert.deepEqual(report.externalRequests, []);
          report.status = 'passed';
        } catch (error) {
          report.status = 'failed'; report.failure = error.stack; failures++;
        } finally {
          await page.close(); reports.push(report);
          fs.writeFileSync(path.join(directory, 'browser-report.json'), JSON.stringify(reports, null, 2));
          console.log(JSON.stringify({directory, map: name, status: report.status, tooltip: report.tooltip, failure: report.failure}));
        }
      }
    }
  } finally {await browser.close();}
  if (failures) process.exitCode = 1;
})().catch(error => {console.error(error); process.exitCode = 1;});
