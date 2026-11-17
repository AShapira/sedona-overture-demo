// Usage: PLAYWRIGHT_MODULE=/path/to/playwright node scripts/check-notebook-maps.cjs <attempt-dir>...
// Uses a separate headless browser; never touches an existing browser session.
// Set NOTEBOOK_MAP_SCREENSHOTS=false to test interactions without GPU readback captures.
// Native GPU checks: NOTEBOOK_MAP_BROWSER_CHANNEL=msedge NOTEBOOK_MAP_SOFTWARE_RENDERING=false.
const {chromium} = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const fs = require('node:fs');
const path = require('node:path');
const {pathToFileURL} = require('node:url');
const assert = require('node:assert/strict');
const timeoutMs = Number(process.env.NOTEBOOK_MAP_TIMEOUT_MS || 60000);
assert.ok(Number.isFinite(timeoutMs) && timeoutMs > 0, 'NOTEBOOK_MAP_TIMEOUT_MS must be positive');

(async () => {
  assert.ok(process.argv.length > 2, 'Provide at least one notebook attempt directory');
  const browser = await chromium.launch({headless: true,
    channel: process.env.NOTEBOOK_MAP_BROWSER_CHANNEL || undefined,
    args: process.env.NOTEBOOK_MAP_SOFTWARE_RENDERING === 'false' ? ['--enable-gpu']
      : ['--use-gl=angle', '--use-angle=swiftshader', '--enable-unsafe-swiftshader']});
  let failures = 0;
  try {
    for (const directory of process.argv.slice(2)) {
      const reports = [];
      for (const name of fs.readdirSync(directory).filter(n => /^map-\d+\.html$/.test(n)).sort()) {
        const page = await browser.newPage({viewport: {width: 1440, height: 950}});
        page.setDefaultTimeout(timeoutMs);
        const report = {map: name, errors: [], externalRequests: [], status: 'running'};
        page.on('pageerror', e => report.errors.push(e.message));
        page.on('request', r => {if (/^https?:/.test(r.url())) report.externalRequests.push(r.url());});
        await page.route(/^https?:/, route => route.abort());
        try {
          await page.goto(pathToFileURL(path.resolve(directory, name)).href, {waitUntil: 'load', timeout: timeoutMs});
          await page.waitForFunction(() => typeof deck !== 'undefined' && deck.layerManager?.getLayers().length > 0,
            null, {timeout: timeoutMs});
          await page.waitForTimeout(1000);
          report.initial = await page.evaluate(() => ({
            view: deck.viewManager.getViewState('MapView'), coordinates: coordinateCounts,
            layers: jsonInput.layers.map(l => ({id: l.id, features: l.data?.features?.length ?? l.data?.length ?? null})),
            canvas: [deck.canvas.width, deck.canvas.height],
          }));
          assert.ok(report.initial.canvas.every(n => n > 0));
          report.renderer = await page.evaluate(() => {
            const gl = deck.canvas.getContext('webgl2');
            const info = gl?.getExtension('WEBGL_debug_renderer_info');
            return info ? gl.getParameter(info.UNMASKED_RENDERER_WEBGL) : null;
          });
          if (report.initial.layers.some(layer => layer.id === 'world-countries')) {
            assert.deepEqual(report.initial.layers.map(layer => layer.id), ['world-countries'],
              'Experimental countries must not be displayed');
            const mapsFile = path.join(directory, 'maps.json');
            if (fs.existsSync(mapsFile)) {
              const captured = JSON.parse(fs.readFileSync(mapsFile)).find(m => path.basename(m.path) === name);
              assert.ok(captured, 'Missing captured coordinate counts');
              assert.deepEqual(report.initial.coordinates, captured.coordinate_counts);
            }
            report.coordinateNotice = await page.locator('#map-coordinate-notice').innerText();
            const features = report.initial.layers.reduce((n, layer) => n + layer.features, 0);
            assert.ok(report.coordinateNotice.includes(`${features.toLocaleString('en-US')} features`),
              'Displayed feature count does not match the map data');
            const total = Object.values(report.initial.coordinates).reduce((a, b) => a + b, 0);
            assert.ok(report.coordinateNotice.includes(total.toLocaleString('en-US')),
              'Displayed coordinate notice does not match the map data');
          }
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
            if (await button.getAttribute('data-view') === 'world' && report.initial.layers.some(
                layer => ['world-water-transportation', 'world-flight-routes'].includes(layer.id))) {
              for (const key of ['longitude', 'latitude', 'zoom']) {
                assert.ok(Math.abs(view[key] - report.initial.view[key]) < 0.001,
                  `World view did not reset ${key} after pan/zoom`);
              }
            }
            report.viewButtons.push({name: await button.getAttribute('data-view'), view});
          }
          if (report.initial.layers.some(layer => ['world-water-transportation', 'world-flight-routes'].includes(layer.id))) {
            if (process.env.NOTEBOOK_MAP_SCREENSHOTS !== 'false') {
              await page.screenshot({path: path.join(directory, name.replace('.html', '-world.png'))});
            }
            // Many ferry segments are smaller than one pixel in a world view.
            // Zoom to a real route before testing precise zero-radius picking.
            report.hoverFocus = await page.evaluate(() => {
              const layer = jsonInput.layers.find(l => ['world-water-transportation', 'world-flight-routes'].includes(l.id));
              for (const feature of layer.data.features) {
                const lines = feature.geometry.type === 'LineString'
                  ? [feature.geometry.coordinates] : feature.geometry.coordinates;
                const points = lines.flat();
                const xs = points.map(p => p[0]), ys = points.map(p => p[1]);
                const xmin = Math.min(...xs), xmax = Math.max(...xs);
                const ymin = Math.min(...ys), ymax = Math.max(...ys);
                if (Math.max(Math.abs(ymin), Math.abs(ymax)) > 70 || xmax - xmin > 90 ||
                    xmax - xmin + ymax - ymin < 0.01) continue;
                const bounds = [[xmin - 0.02, ymin - 0.02], [xmax + 0.02, ymax + 0.02]];
                const fitted = deck.getViewports()[0].fitBounds(bounds, {padding: 60, maxZoom: 13});
                deck.setProps({initialViewState: {longitude: fitted.longitude, latitude: fitted.latitude,
                  zoom: fitted.zoom, bearing: 0, pitch: 0}});
                window.routeHoverFeature = feature;
                return {source_id: feature.properties.source_id, bounds};
              }
              throw new Error('No suitable route found for hover test');
            });
            await page.waitForTimeout(500);
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
              else for (const index of [...new Set([0, Math.floor(value.length / 4),
                Math.floor(value.length / 2), Math.floor(value.length * 3 / 4), value.length - 1])]) {
                if (index >= 0) coordinates(value[index]);
              }
            }
            if (window.routeHoverFeature) {
              const geometry = window.routeHoverFeature.geometry;
              const line = geometry.type === 'LineString' ? geometry.coordinates : geometry.coordinates[0];
              const a = viewport.project(line[0]), b = viewport.project(line[1]);
              candidates.push(viewport.unproject([(a[0] + b[0]) / 2, (a[1] + b[1]) / 2]));
              coordinates(geometry.coordinates);
            }
            for (const layer of jsonInput.layers.filter(l => l.pickable)) {
              for (const row of (layer.data?.features || layer.data || []).slice(0, 200)) {
                coordinates(row.geometry?.coordinates || row.position || row.coordinates);
              }
            }
            let attempts = 0;
            for (const coord of candidates) {
              const [x, y] = viewport.project(coord).map(Math.round);
              if (x < 2 || y < 2 || x >= deck.width - 2 || y >= deck.height - 2) continue;
              if (++attempts > 30) break;
              // Match the real mouse's zero-radius pick. A wider query can
              // choose the neighbouring carriageway and falsely fail hover.
              const result = deck.pickObject({x, y, radius: 0});
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
          report.screenshots = process.env.NOTEBOOK_MAP_SCREENSHOTS !== 'false';
          if (report.screenshots) {
            await page.screenshot({path: path.join(directory, name.replace('.html', '.png'))});
          }
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
