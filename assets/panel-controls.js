/**
 * Panel chrome: collapsible sidebar/details panels and a full-screen toggle
 * for the model viewer. Independent of app.js/enhanced-app.js's model state.
 */
(function () {
  "use strict";

  function setLayoutClass(name, on) {
    var layout = document.querySelector(".layout");
    if (layout) layout.classList.toggle(name, on);
  }

  function toggleSidebar() {
    var sidebar = document.getElementById("sidebar-panel");
    var btn = document.getElementById("sidebar-toggle");
    if (!sidebar) return;
    var collapsed = sidebar.classList.toggle("collapsed");
    setLayoutClass("sidebar-collapsed", collapsed);
    if (btn) {
      btn.textContent = collapsed ? "›" : "‹";
      btn.setAttribute("aria-label", collapsed ? "Expand sidebar" : "Collapse sidebar");
      btn.title = btn.getAttribute("aria-label");
    }
    try { localStorage.setItem("netlogo-sidebar-collapsed", collapsed ? "1" : "0"); } catch (e) {}
  }

  function toggleDetails() {
    var details = document.getElementById("details-panel");
    var btn = document.getElementById("details-toggle");
    if (!details) return;
    var collapsed = details.classList.toggle("collapsed");
    setLayoutClass("details-collapsed", collapsed);
    if (btn) {
      btn.textContent = collapsed ? "‹" : "›";
      btn.setAttribute("aria-label", collapsed ? "Expand details panel" : "Collapse details panel");
      btn.title = btn.getAttribute("aria-label");
    }
    try { localStorage.setItem("netlogo-details-collapsed", collapsed ? "1" : "0"); } catch (e) {}
  }

  function requestFs(el) {
    var fn = el.requestFullscreen || el.webkitRequestFullscreen || el.msRequestFullscreen;
    if (!fn) return;
    // requestFullscreen() can reject (blocked by permissions policy, no user
    // gesture in the browser's eyes, etc.) -- swallow it rather than leaving
    // an unhandled rejection; the button just silently stays a no-op.
    var result = fn.call(el);
    if (result && typeof result.catch === "function") result.catch(function () {});
  }

  function exitFs() {
    var fn = document.exitFullscreen || document.webkitExitFullscreen || document.msExitFullscreen;
    if (fn) fn.call(document);
  }

  function currentFsElement() {
    return document.fullscreenElement || document.webkitFullscreenElement || document.msFullscreenElement;
  }

  // Generic fullscreen toggle: any panel with a maximize button follows the
  // same pattern (model viewer, graph explorer, ...) via this one helper
  // rather than a bespoke function per panel.
  var fsTargets = []; // [{elId, btnId, label}]

  function toggleFullscreenFor(elId) {
    var el = document.getElementById(elId);
    if (!el) return;
    if (currentFsElement() === el) {
      exitFs();
    } else if (currentFsElement()) {
      // Already fullscreened on a different panel -- switch targets.
      exitFs();
      requestFs(el);
    } else {
      requestFs(el);
    }
  }

  function registerFullscreenButton(elId, btnId, label) {
    fsTargets.push({ elId: elId, btnId: btnId, label: label });
  }

  function toggleViewerFullscreen() { toggleFullscreenFor("model-frame-wrap"); }
  function toggleGraphFullscreen() { toggleFullscreenFor("graph-mode"); }

  registerFullscreenButton("model-frame-wrap", "viewer-maximize-btn", "model viewer");
  registerFullscreenButton("graph-mode", "graph-maximize-btn", "concept graph");

  ["fullscreenchange", "webkitfullscreenchange", "MSFullscreenChange"].forEach(function (evt) {
    document.addEventListener(evt, function () {
      var current = currentFsElement();
      fsTargets.forEach(function (t) {
        var btn = document.getElementById(t.btnId);
        if (!btn) return;
        var isFs = current && current.id === t.elId;
        btn.textContent = isFs ? "⤡" : "⛶";
        btn.setAttribute("aria-label", isFs ? "Exit full screen" : "Expand " + t.label + " to full screen");
        btn.title = btn.getAttribute("aria-label");
      });
    });
  });

  function restorePanelState() {
    try {
      if (localStorage.getItem("netlogo-sidebar-collapsed") === "1") toggleSidebar();
      if (localStorage.getItem("netlogo-details-collapsed") === "1") toggleDetails();
    } catch (e) {}
  }

  document.addEventListener("DOMContentLoaded", restorePanelState);

  window.toggleSidebar = toggleSidebar;
  window.toggleDetails = toggleDetails;
  window.toggleViewerFullscreen = toggleViewerFullscreen;
  window.toggleGraphFullscreen = toggleGraphFullscreen;
})();
