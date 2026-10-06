// Inline map controls: no kernel callbacks or external JavaScript dependencies.
function setupMapControls(map, spec, coordinateCounts) {
  const toolbar = document.getElementById("map-toolbar");
  const status = document.getElementById("map-status");
  if (!map) {
    status.textContent = "The interactive map could not initialize.";
    return;
  }
  const originalLayers = map.props.layers.filter(Boolean);
  const visible = new Map(spec.groups.map(group => [group.id, true]));
  const backgroundGroup = spec.groups.find(group => group.id === "background");
  let backgroundFailed = false;

  if (spec.description) {
    const description = document.createElement("div");
    description.id = "map-extent-description";
    description.style.flexBasis = "100%";
    description.textContent = spec.description;
    toolbar.appendChild(description);
  }

  function updateLayers() {
    const shownCounts = Object.entries(coordinateCounts).filter(([id]) => {
      const group = spec.groups.find(item => item.layer_ids.includes(id));
      return !group || visible.get(group.id);
    });
    const total = shownCounts.reduce((sum, entry) => sum + entry[1], 0);
    const format = number => number.toLocaleString("en-US");
    document.getElementById("map-coordinate-notice").textContent =
      `Drawing map: ${format(total)} coordinate positions` +
      (shownCounts.length ? ` (${shownCounts.map(([id, n]) => `${id}: ${format(n)}`).join("; ")}).` : ".");
    map.setProps({layers: originalLayers.map(layer => {
      const group = spec.groups.find(item => item.layer_ids.includes(layer.id));
      return layer.clone({visible: !group || visible.get(group.id)});
    })});
  }
  for (const group of spec.groups) {
    const label = document.createElement("label");
    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.id = `layer-${group.id}`;
    checkbox.checked = true;
    checkbox.addEventListener("change", () => {
      visible.set(group.id, checkbox.checked);
      updateLayers();
    });
    label.appendChild(checkbox);
    if (group.color) {
      const swatch = document.createElement("span");
      swatch.className = "swatch";
      swatch.style.backgroundColor = `rgb(${group.color.join(",")})`;
      swatch.setAttribute("aria-hidden", "true");
      label.appendChild(swatch);
    }
    label.appendChild(document.createTextNode(group.label));
    toolbar.appendChild(label);
  }

  function fit(bounds) {
    const viewport = map.getViewports()[0];
    if (!viewport || viewport.width <= 1 || viewport.height <= 1) return false;
    const padding = Math.min(45, viewport.width / 8, viewport.height / 8);
    const fitted = viewport.fitBounds(bounds, {padding, maxZoom: 14});
    map.setProps({initialViewState: {
      longitude: fitted.longitude, latitude: fitted.latitude,
      zoom: fitted.zoom, bearing: 0, pitch: 0
    }});
    return true;
  }
  for (const id of ["large", "medium"]) {
    const button = document.createElement("button");
    button.type = "button";
    button.dataset.view = id;
    button.textContent = `Zoom to ${id}`;
    button.addEventListener("click", () => fit(spec.views[id]));
    toolbar.appendChild(button);
  }
  const cityGroup = document.createElement("div");
  cityGroup.className = "control-group";
  const cityLabel = document.createElement("label");
  cityLabel.htmlFor = "map-city";
  cityLabel.textContent = "City";
  const citySelect = document.createElement("select");
  citySelect.id = "map-city";
  for (const city of spec.cities) {
    const option = document.createElement("option");
    option.value = city.id;
    option.textContent = city.label;
    citySelect.appendChild(option);
  }
  const cityButton = document.createElement("button");
  cityButton.type = "button";
  cityButton.dataset.view = "city";
  cityButton.textContent = "Zoom to city";
  cityButton.addEventListener("click", () => {
    const city = spec.cities.find(item => item.id === citySelect.value);
    if (city) fit(city.bounds);
  });
  cityGroup.append(cityLabel, citySelect, cityButton);
  toolbar.appendChild(cityGroup);

  map.setProps({onError: (error, layer) => {
    const backgroundError = backgroundGroup && layer &&
      backgroundGroup.layer_ids.some(id => layer.id.startsWith(id));
    if (backgroundError) {
      if (!backgroundFailed) {
        backgroundFailed = true;
        visible.set("background", false);
        document.getElementById("layer-background").checked = false;
        status.textContent = "Background unavailable. Region boundaries and city controls remain available.";
        updateLayers();
      }
      return;
    }
    console.error(error);
  }});
  let attempts = 0;
  function fitWhenReady() {
    if (!fit(spec.views.large) && ++attempts < 120) requestAnimationFrame(fitWhenReady);
  }
  requestAnimationFrame(fitWhenReady);
}
