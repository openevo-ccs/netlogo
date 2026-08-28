/**
 * Concept & Model Network graph — force-directed explorer of the model
 * collection: model nodes and concept nodes, linked by bipartite
 * model->concept edges plus weighted projections (models sharing concepts,
 * concepts sharing models). Vanilla SVG + a small hand-rolled physics loop —
 * no charting/graph library dependency, consistent with the rest of this
 * offline-first repo.
 */
(function () {
  "use strict";

  var SVG_NS = "http://www.w3.org/2000/svg";
  var VIEW_W = 1000;
  var VIEW_H = 700;

  var built = false;
  var running = false;
  var paused = false;
  var animHandle = null;

  var nodes = [];       // {id, kind:'model'|'concept', label, r, x, y, vx, vy, model?}
  var nodesById = {};
  var edges = [];        // {source, target, type:'bipartite'|'model-model'|'concept-concept', weight}

  var physics = { repulsion: 700, linkStrength: 0.18, linkDistance: 90, damping: 0.8 };

  // Safety bounds independent of the slider ranges: a naive inverse-square
  // repulsion force explodes as two nodes' distance approaches zero (two
  // freshly-placed or dragged-together nodes, especially), which is what
  // "wildly unstable" looked like -- a single huge impulse flinging a node
  // across the whole viewBox in one frame. MIN_DIST floors the distance used
  // in the force calculation; MAX_SPEED caps how far anything can move in a
  // single tick regardless of the computed force. Both apply no matter what
  // the physics sliders are set to.
  var MIN_DIST = 16;
  var MAX_SPEED = 26;

  var filters = { grades: null, concepts: null, modelSearch: "" };
  // filters.grades/concepts are Sets populated after data loads (default: all selected)

  var view = { x: 0, y: 0, w: VIEW_W, h: VIEW_H };
  var focusedId = null;
  var dragNode = null;
  var panDrag = null;

  var els = {};

  function q(id) { return document.getElementById(id); }

  function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }

  function buildGraphData(models) {
    nodes = [];
    nodesById = {};
    edges = [];

    var conceptModels = {}; // conceptName -> [slug,...]

    models.forEach(function (m) {
      var id = "m:" + m.slug;
      var r = clamp(9 + (m.concepts || []).length * 1.3, 9, 24);
      var node = {
        id: id, kind: "model", label: m.title, r: r,
        x: VIEW_W / 2 + (Math.random() - 0.5) * 220,
        y: VIEW_H / 2 + (Math.random() - 0.5) * 220,
        vx: 0, vy: 0, model: m
      };
      nodes.push(node);
      nodesById[id] = node;

      (m.concepts || []).forEach(function (c) {
        if (!conceptModels[c]) conceptModels[c] = [];
        conceptModels[c].push(m.slug);
      });
    });

    var conceptNames = Object.keys(conceptModels).sort(function (a, b) { return a.localeCompare(b); });
    var angleStep = (Math.PI * 2) / Math.max(1, conceptNames.length);
    conceptNames.forEach(function (c, i) {
      var id = "c:" + c;
      var count = conceptModels[c].length;
      var r = clamp(7 + count * 1.1, 7, 20);
      var angle = i * angleStep;
      var ringR = Math.min(VIEW_W, VIEW_H) * 0.4;
      var node = {
        id: id, kind: "concept", label: c, r: r,
        x: VIEW_W / 2 + Math.cos(angle) * ringR,
        y: VIEW_H / 2 + Math.sin(angle) * ringR,
        vx: 0, vy: 0, modelSlugs: conceptModels[c]
      };
      nodes.push(node);
      nodesById[id] = node;
    });

    // Bipartite model -> concept edges
    models.forEach(function (m) {
      (m.concepts || []).forEach(function (c) {
        edges.push({ source: "m:" + m.slug, target: "c:" + c, type: "bipartite", weight: 1 });
      });
    });

    // Model-model projection: weight = number of shared concepts
    for (var i = 0; i < models.length; i++) {
      for (var j = i + 1; j < models.length; j++) {
        var a = models[i].concepts || [], b = models[j].concepts || [];
        var shared = a.filter(function (c) { return b.indexOf(c) !== -1; }).length;
        if (shared > 0) {
          edges.push({ source: "m:" + models[i].slug, target: "m:" + models[j].slug, type: "model-model", weight: shared });
        }
      }
    }

    // Concept-concept projection: weight = number of shared models
    for (var x = 0; x < conceptNames.length; x++) {
      for (var y = x + 1; y < conceptNames.length; y++) {
        var ma = conceptModels[conceptNames[x]], mb = conceptModels[conceptNames[y]];
        var sharedM = ma.filter(function (s) { return mb.indexOf(s) !== -1; }).length;
        if (sharedM > 0) {
          edges.push({ source: "c:" + conceptNames[x], target: "c:" + conceptNames[y], type: "concept-concept", weight: sharedM });
        }
      }
    }

    filters.grades = new Set();
    models.forEach(function (m) { (m.grades || []).forEach(function (g) { filters.grades.add(g); }); });
    filters.allGrades = Array.from(filters.grades).sort();
    filters.selectedGrades = new Set(filters.allGrades);

    filters.allConcepts = conceptNames;
    filters.selectedConcepts = new Set(conceptNames);
  }

  function isNodeVisible(node) {
    if (node.kind === "model") {
      var m = node.model;
      if (filters.modelSearch && m.title.toLowerCase().indexOf(filters.modelSearch) === -1) return false;
      var grades = m.grades || [];
      if (grades.length === 0) return filters.selectedGrades.size === filters.allGrades.length;
      return grades.some(function (g) { return filters.selectedGrades.has(g); });
    }
    // concept node
    return filters.selectedConcepts.has(node.label);
  }

  function edgeTypeEnabled(type) {
    if (type === "bipartite") return els.showBipartite.checked;
    if (type === "model-model") return els.showModelModel.checked;
    if (type === "concept-concept") return els.showConceptConcept.checked;
    return true;
  }

  function refreshVisibility() {
    nodes.forEach(function (n) { n.visible = isNodeVisible(n); });
  }

  // ---------- Rendering ----------

  function buildDom() {
    els.svg = q("graph-svg");
    els.tooltip = q("graph-tooltip");
    els.wrap = els.svg.parentElement;
    els.svg.setAttribute("viewBox", view.x + " " + view.y + " " + view.w + " " + view.h);

    els.svg.innerHTML = "";
    var edgesLayer = document.createElementNS(SVG_NS, "g");
    edgesLayer.id = "edges-layer";
    var nodesLayer = document.createElementNS(SVG_NS, "g");
    nodesLayer.id = "nodes-layer";
    els.svg.appendChild(edgesLayer);
    els.svg.appendChild(nodesLayer);

    edges.forEach(function (e) {
      var line = document.createElementNS(SVG_NS, "line");
      line.setAttribute("class", "gedge gedge-" + e.type);
      line.setAttribute("stroke-width", e.type === "bipartite" ? 1 : clamp(1 + e.weight * 0.8, 1, 8));
      e.el = line;
      edgesLayer.appendChild(line);
    });

    nodes.forEach(function (n) {
      var g = document.createElementNS(SVG_NS, "g");
      g.setAttribute("class", "gnode gnode-" + n.kind);
      g.dataset.id = n.id;

      var circle = document.createElementNS(SVG_NS, "circle");
      circle.setAttribute("r", n.r);
      g.appendChild(circle);

      var text = document.createElementNS(SVG_NS, "text");
      text.setAttribute("dy", n.r + 11);
      text.setAttribute("text-anchor", "middle");
      text.textContent = n.label.length > 22 ? n.label.slice(0, 21) + "…" : n.label;
      g.appendChild(text);

      n.el = g;
      n.circleEl = circle;
      nodesLayer.appendChild(g);

      g.addEventListener("pointerenter", function () { showTooltip(n); });
      g.addEventListener("pointermove", function (evt) { positionTooltip(evt); });
      g.addEventListener("pointerleave", hideTooltip);
      g.addEventListener("pointerdown", function (evt) { startDrag(n, evt); });
      g.addEventListener("click", function (evt) { evt.stopPropagation(); focusNode(n); });
    });

    els.svg.addEventListener("click", function () { focusNode(null); });
    els.svg.addEventListener("wheel", onWheel, { passive: false });
    els.svg.addEventListener("pointerdown", onSvgPointerDown);
    window.addEventListener("pointermove", onPointerMove);
    window.addEventListener("pointerup", onPointerUp);
  }

  function showTooltip(n) {
    var extra;
    if (n.kind === "model") {
      extra = (n.model.concepts || []).length + " concept(s) · " + (n.model.grades || []).join(", ");
    } else {
      extra = n.modelSlugs.length + " model(s): " + n.modelSlugs.join(", ");
    }
    els.tooltip.innerHTML = "<strong>" + n.label + "</strong><br>" + extra;
    els.tooltip.classList.add("visible");
  }

  function positionTooltip(evt) {
    var rect = els.wrap.getBoundingClientRect();
    els.tooltip.style.left = (evt.clientX - rect.left + 14) + "px";
    els.tooltip.style.top = (evt.clientY - rect.top + 10) + "px";
  }

  function hideTooltip() {
    els.tooltip.classList.remove("visible");
  }

  function neighborsOf(id) {
    var set = new Set([id]);
    edges.forEach(function (e) {
      if (!edgeTypeEnabled(e.type)) return;
      if (e.source === id) set.add(e.target);
      if (e.target === id) set.add(e.source);
    });
    return set;
  }

  function focusNode(n) {
    focusedId = n ? n.id : null;
    syncFocusClasses();
  }

  function syncFocusClasses() {
    if (!focusedId) {
      nodes.forEach(function (n) { if (n.el) n.el.classList.remove("dimmed"); });
      edges.forEach(function (e) { if (e.el) e.el.classList.remove("dimmed"); });
      return;
    }
    var keep = neighborsOf(focusedId);
    nodes.forEach(function (n) {
      if (!n.el) return;
      n.el.classList.toggle("dimmed", n.visible && !keep.has(n.id));
    });
    edges.forEach(function (e) {
      if (!e.el) return;
      var relevant = e.source === focusedId || e.target === focusedId;
      e.el.classList.toggle("dimmed", !relevant);
    });
  }

  // ---------- Drag / pan / zoom ----------

  function toSvgPoint(evt) {
    var rect = els.svg.getBoundingClientRect();
    var sx = (evt.clientX - rect.left) / rect.width;
    var sy = (evt.clientY - rect.top) / rect.height;
    return { x: view.x + sx * view.w, y: view.y + sy * view.h };
  }

  function startDrag(n, evt) {
    evt.stopPropagation();
    dragNode = n;
    n.pinned = true;
  }

  function onSvgPointerDown(evt) {
    if (dragNode) return;
    panDrag = { startX: evt.clientX, startY: evt.clientY, viewX: view.x, viewY: view.y };
  }

  function onPointerMove(evt) {
    if (dragNode) {
      var p = toSvgPoint(evt);
      dragNode.x = p.x;
      dragNode.y = p.y;
      dragNode.vx = 0;
      dragNode.vy = 0;
    } else if (panDrag) {
      var rect = els.svg.getBoundingClientRect();
      var dx = (evt.clientX - panDrag.startX) / rect.width * view.w;
      var dy = (evt.clientY - panDrag.startY) / rect.height * view.h;
      view.x = panDrag.viewX - dx;
      view.y = panDrag.viewY - dy;
      applyViewBox();
    }
  }

  function onPointerUp() {
    dragNode = null;
    panDrag = null;
  }

  function onWheel(evt) {
    evt.preventDefault();
    var factor = evt.deltaY > 0 ? 1.1 : 0.9;
    var p = toSvgPoint(evt);
    var newW = clamp(view.w * factor, 200, VIEW_W * 3);
    var newH = clamp(view.h * factor, 140, VIEW_H * 3);
    view.x = p.x - (p.x - view.x) * (newW / view.w);
    view.y = p.y - (p.y - view.y) * (newH / view.h);
    view.w = newW;
    view.h = newH;
    applyViewBox();
  }

  function applyViewBox() {
    els.svg.setAttribute("viewBox", view.x + " " + view.y + " " + view.w + " " + view.h);
  }

  // ---------- Physics ----------

  function tick() {
    if (els.wrap.offsetParent !== null && !paused) {
      step();
      syncDom();
    }
    animHandle = requestAnimationFrame(tick);
  }

  function step() {
    var visibleNodes = nodes.filter(function (n) { return n.visible; });
    var rep = physics.repulsion;
    var minDist2 = MIN_DIST * MIN_DIST;

    for (var i = 0; i < visibleNodes.length; i++) {
      for (var j = i + 1; j < visibleNodes.length; j++) {
        var a = visibleNodes[i], b = visibleNodes[j];
        var dx = b.x - a.x, dy = b.y - a.y;
        var dist2 = dx * dx + dy * dy;
        // Floor the distance used for the force itself so two nodes landing
        // on (near) the same point can't produce a near-infinite 1/dist^2
        // force -- that single-tick impulse was the "wildly unstable" bug.
        if (dist2 < minDist2) dist2 = minDist2;
        var dist = Math.sqrt(dist2);
        // When the raw separation is ~0 the direction (dx,dy) is meaningless;
        // push apart along a stable pseudo-random direction instead of "no
        // direction at all" so coincident nodes actually separate.
        if (dx === 0 && dy === 0) {
          var angle = (i * 37 + j * 13) % 360 * (Math.PI / 180);
          dx = Math.cos(angle); dy = Math.sin(angle);
        }
        var force = rep / dist2;
        var fx = (force * dx) / dist, fy = (force * dy) / dist;
        if (!a.pinned) { a.vx -= fx; a.vy -= fy; }
        if (!b.pinned) { b.vx += fx; b.vy += fy; }
      }
    }

    edges.forEach(function (e) {
      if (!edgeTypeEnabled(e.type)) return;
      var a = nodesById[e.source], b = nodesById[e.target];
      if (!a || !b || !a.visible || !b.visible) return;
      var dx = b.x - a.x, dy = b.y - a.y;
      var dist = Math.sqrt(dx * dx + dy * dy) || 0.01;
      var targetDist = physics.linkDistance / Math.sqrt(e.weight);
      var diff = (dist - targetDist) * physics.linkStrength;
      var fx = (diff * dx) / dist, fy = (diff * dy) / dist;
      if (!a.pinned) { a.vx += fx; a.vy += fy; }
      if (!b.pinned) { b.vx -= fx; b.vy -= fy; }
    });

    var cx = VIEW_W / 2, cy = VIEW_H / 2;
    visibleNodes.forEach(function (n) {
      if (n.pinned) return;
      n.vx += (cx - n.x) * 0.006;
      n.vy += (cy - n.y) * 0.006;
      n.vx *= physics.damping;
      n.vy *= physics.damping;
      // Hard safety net independent of whatever the sliders are set to: no
      // node may move more than MAX_SPEED per tick, so a large transient
      // force (a drag release next to another node, a sudden filter change)
      // can't fling anything across the canvas in a single frame.
      var speed = Math.sqrt(n.vx * n.vx + n.vy * n.vy);
      if (speed > MAX_SPEED) {
        var scale = MAX_SPEED / speed;
        n.vx *= scale;
        n.vy *= scale;
      }
      n.x += n.vx;
      n.y += n.vy;
    });
  }

  function syncDom() {
    nodes.forEach(function (n) {
      if (!n.el) return;
      n.el.style.display = n.visible ? "" : "none";
      if (n.visible) {
        n.el.setAttribute("transform", "translate(" + n.x.toFixed(1) + "," + n.y.toFixed(1) + ")");
      }
    });
    edges.forEach(function (e) {
      if (!e.el) return;
      var a = nodesById[e.source], b = nodesById[e.target];
      var show = a && b && a.visible && b.visible && edgeTypeEnabled(e.type);
      e.el.style.display = show ? "" : "none";
      if (show) {
        e.el.setAttribute("x1", a.x.toFixed(1));
        e.el.setAttribute("y1", a.y.toFixed(1));
        e.el.setAttribute("x2", b.x.toFixed(1));
        e.el.setAttribute("y2", b.y.toFixed(1));
      }
    });
  }

  // ---------- Controls wiring ----------

  function renderChecklist(container, items, selectedSet, onChange) {
    container.innerHTML = "";
    items.forEach(function (item) {
      var label = document.createElement("label");
      var cb = document.createElement("input");
      cb.type = "checkbox";
      cb.checked = selectedSet.has(item);
      cb.addEventListener("change", function () {
        if (cb.checked) selectedSet.add(item); else selectedSet.delete(item);
        onChange();
      });
      label.appendChild(cb);
      label.appendChild(document.createTextNode(" " + item));
      container.appendChild(label);
    });
  }

  function wireControls() {
    els.repulsion = q("graph-repulsion");
    els.linkStrength = q("graph-link-strength");
    els.linkDistance = q("graph-link-distance");
    els.damping = q("graph-damping");
    els.pauseBtn = q("graph-pause-btn");
    els.resetBtn = q("graph-reset-btn");
    els.showBipartite = q("graph-show-bipartite");
    els.showModelModel = q("graph-show-model-model");
    els.showConceptConcept = q("graph-show-concept-concept");
    els.gradeFilters = q("graph-grade-filters");
    els.conceptFilters = q("graph-concept-filters");
    els.conceptSearch = q("graph-concept-search");
    els.modelFilters = q("graph-model-filters");
    els.modelSearch = q("graph-model-search");

    els.repulsion.addEventListener("input", function () { physics.repulsion = +els.repulsion.value; });
    els.linkStrength.addEventListener("input", function () { physics.linkStrength = +els.linkStrength.value; });
    els.linkDistance.addEventListener("input", function () { physics.linkDistance = +els.linkDistance.value; });
    els.damping.addEventListener("input", function () { physics.damping = +els.damping.value; });

    els.pauseBtn.addEventListener("click", function () {
      paused = !paused;
      els.pauseBtn.textContent = paused ? "▶ Play" : "⏸ Pause";
    });

    els.resetBtn.addEventListener("click", function () {
      nodes.forEach(function (n) {
        n.pinned = false;
        n.x = VIEW_W / 2 + (Math.random() - 0.5) * 300;
        n.y = VIEW_H / 2 + (Math.random() - 0.5) * 300;
        n.vx = 0; n.vy = 0;
      });
      view = { x: 0, y: 0, w: VIEW_W, h: VIEW_H };
      applyViewBox();
    });

    [els.showBipartite, els.showModelModel, els.showConceptConcept].forEach(function (cb) {
      cb.addEventListener("change", syncFocusClasses);
    });

    renderChecklist(els.gradeFilters, filters.allGrades, filters.selectedGrades, refreshVisibility);

    function renderConceptChecklist() {
      var q2 = els.conceptSearch.value.trim().toLowerCase();
      var items = filters.allConcepts.filter(function (c) { return !q2 || c.toLowerCase().indexOf(q2) !== -1; });
      renderChecklist(els.conceptFilters, items, filters.selectedConcepts, refreshVisibility);
    }
    renderConceptChecklist();
    els.conceptSearch.addEventListener("input", renderConceptChecklist);

    function renderModelChecklist() {
      var q2 = (els.modelSearch.value || "").trim().toLowerCase();
      filters.modelSearch = q2;
      refreshVisibility();
    }
    els.modelSearch.addEventListener("input", renderModelChecklist);

    var modelNames = nodes.filter(function (n) { return n.kind === "model"; }).map(function (n) { return n.label; });
    els.modelFilters.innerHTML = "<p style=\"font-size:var(--text-xs);color:var(--text-tertiary);margin:0;\">" +
      modelNames.length + " models loaded — use search above to highlight.</p>";
  }

  // ---------- Public API ----------

  function init() {
    fetch("assets/models.json")
      .then(function (r) { return r.json(); })
      .then(function (models) {
        buildGraphData(models);
        refreshVisibility();
        buildDom();
        wireControls();
        syncDom();
        built = true;
        startLoop();
      })
      .catch(function (err) {
        var svg = q("graph-svg");
        if (svg) {
          svg.outerHTML = "<p style='padding:1rem;color:var(--text-secondary);'>Could not load model graph: " + err + "</p>";
        }
      });
  }

  function startLoop() {
    if (running) return;
    running = true;
    animHandle = requestAnimationFrame(tick);
  }

  function onShow() {
    if (!built) {
      init();
    }
  }

  window.GraphExplorer = { onShow: onShow };
})();
