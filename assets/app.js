/**
 * NetLogo Explorer — model browser, details panel, and the Digital Lab
 * Notebook. (Compare and Assess are being redesigned as teacher-facing
 * features — see the LPM/UI roadmap — so their previous hard-coded data/
 * logic was removed here rather than carried forward unreachable.)
 */
(function () {
  "use strict";

  var REPO_BLOB_BASE = "https://github.com/openevo-ccs/netlogo/blob/main/";

  // Public address of the OpenEvo.net app pages (ending in a slash). Empty
  // while the site is only served privately: the thinking tools that live on
  // the site stay hidden until this is filled in, so nobody meets a dead link.
  var OPENEVO_SITE_BASE = "";

  var THINKING_TOOLS = [
    { name: "Tinbergen's Questions", url: "thinking-tools/tinbergen-questions.html", local: true },
    { name: "Causal Mapping", url: "tool-causal-mapping.html" },
    { name: "Payoff Matrices", url: "tool-payoff-matrices.html" },
    { name: "Analogy Mapping", url: "tool-analogy-mapping.html" },
    { name: "Structure of Knowledge", url: "tool-structure-of-knowledge.html" }
  ];

  // The explorer shows one page at a time on phones and tablets.
  var NARROW = window.matchMedia("(max-width: 1024px)");

  // NetLogo draws its interface at a fixed width. Narrower frames show it
  // scaled down so the whole model is visible.
  var MODEL_DESIGN_WIDTH = 1320;
  var DEFAULT_LICENSE = "CC BY-SA 4.0";

  var state = {
    models: [],
    filtered: [],
    activeSlug: null,
    search: "",
    concept: "",
    grade: "",
    recentlyViewed: [],
    favorites: new Set(),
    mode: "explore",
    pane: "run",
    meta: {},
    assessmentSlugs: {}
  };

  var labNotebookEntry = null;

  var els = {
    list: document.getElementById("model-list"),
    search: document.getElementById("search"),
    conceptFilter: document.getElementById("filter-concept"),
    gradeFilter: document.getElementById("filter-grade"),
    frame: document.getElementById("model-frame"),
    frameWrap: document.getElementById("model-frame-wrap"),
    frameScroll: document.getElementById("model-frame-scroll"),
    frameSizer: document.getElementById("model-frame-sizer"),
    frameLoading: document.getElementById("model-frame-loading"),
    details: document.getElementById("details-content"),
    breadcrumbCurrent: document.getElementById("breadcrumb-current")
  };

  function getCurrentModel() {
    return state.models.find(function (m) { return m.slug === state.activeSlug; }) || null;
  }

  function escapeHtml(value) {
    return String(value == null ? "" : value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  var noticeTimer = null;
  function showNotice(message) {
    var box = document.getElementById("notice");
    if (!box) return;
    box.textContent = message;
    box.hidden = false;
    clearTimeout(noticeTimer);
    noticeTimer = setTimeout(function () { box.hidden = true; }, 6000);
  }

  function uniqueSorted(values) {
    return Array.from(new Set(values)).sort(function (a, b) {
      return a.localeCompare(b);
    });
  }

  function populateFilters(models) {
    var concepts = uniqueSorted(models.reduce(function (acc, m) {
      return acc.concat(m.concepts || []);
    }, []));
    var grades = uniqueSorted(models.reduce(function (acc, m) {
      return acc.concat(m.grades || []);
    }, []));

    concepts.forEach(function (c) {
      var opt = document.createElement("option");
      opt.value = c;
      opt.textContent = c;
      els.conceptFilter.appendChild(opt);
    });
    grades.forEach(function (g) {
      var opt = document.createElement("option");
      opt.value = g;
      opt.textContent = g;
      els.gradeFilter.appendChild(opt);
    });
  }

  function matchesFilters(m) {
    var q = state.search.trim().toLowerCase();
    if (q) {
      var haystack = (m.title + " " + m.description + " " + (m.concepts || []).join(" ")).toLowerCase();
      if (haystack.indexOf(q) === -1) return false;
    }
    if (state.concept && (m.concepts || []).indexOf(state.concept) === -1) return false;
    if (state.grade && (m.grades || []).indexOf(state.grade) === -1) return false;
    return true;
  }

  function renderList() {
    state.filtered = state.models.filter(matchesFilters);
    els.list.innerHTML = "";

    // Group models by category
    var sections = {
      favorites: { title: "⭐ Favorites", models: [] },
      recent: { title: "🕐 Recently Viewed", models: [] },
      all: { title: "📁 All Models", models: [] }
    };

    state.filtered.forEach(function (m) {
      if (state.favorites.has(m.slug)) sections.favorites.models.push(m);
    });

    // Add recently viewed models (skipping favorites, which already show above)
    state.recentlyViewed.forEach(function(slug) {
      var model = state.models.find(function(m) { return m.slug === slug; });
      if (model && matchesFilters(model) && !state.favorites.has(slug)) {
        sections.recent.models.push(model);
      }
    });

    // Everything else
    state.filtered.forEach(function(m) {
      if (sections.recent.models.indexOf(m) === -1 && sections.favorites.models.indexOf(m) === -1) {
        sections.all.models.push(m);
      }
    });

    // Render sections
    Object.keys(sections).forEach(function(sectionKey) {
      var section = sections[sectionKey];
      if (section.models.length === 0) return;

      var sectionHeader = document.createElement("div");
      sectionHeader.className = "section-header";
      sectionHeader.innerHTML = "<h3>" + section.title + "</h3>";
      els.list.appendChild(sectionHeader);

      section.models.forEach(function(m) {
        var li = document.createElement("li");
        li.className = "model-item" + (m.slug === state.activeSlug ? " active" : "");
        li.setAttribute("role", "button");
        li.setAttribute("tabindex", "0");
        li.dataset.slug = m.slug;

        var h3 = document.createElement("h3");
        h3.textContent = m.title;

        var meta = document.createElement("div");
        meta.className = "meta-line";
        meta.textContent = (m.grades || []).join(", ");

        var description = document.createElement("p");
        description.className = "model-description";
        description.textContent = m.description.substring(0, 80) + (m.description.length > 80 ? "..." : "");
        description.style.fontSize = "var(--text-xs)";
        description.style.color = "var(--text-secondary)";
        description.style.margin = "var(--space-2) 0 0 0";

        li.appendChild(h3);
        li.appendChild(description);
        li.appendChild(meta);
        li.addEventListener("click", function () { selectModel(m.slug); });
        li.addEventListener("keydown", function (e) {
          if (e.key === "Enter" || e.key === " ") { e.preventDefault(); selectModel(m.slug); }
        });
        els.list.appendChild(li);
      });
    });

    if (state.filtered.length === 0) {
      var empty = document.createElement("div");
      empty.className = "empty-state";
      empty.innerHTML = "<p>No models match these filters.</p><button class=\"btn btn-outline\" onclick=\"clearFilters()\">Clear Filters</button>";
      els.list.appendChild(empty);
    }
  }

  function chipList(items, type) {
    var wrap = document.createElement("div");
    wrap.className = "chips";
    (items || []).forEach(function (item) {
      var chip = document.createElement("span");
      chip.className = "chip chip-" + (type || "");
      chip.textContent = item;
      wrap.appendChild(chip);
    });
    return wrap;
  }

  function sectionTitle(text) {
    var t = document.createElement("div");
    t.className = "section-title";
    t.textContent = text;
    return t;
  }

  function externalLink(href, text, className) {
    var a = document.createElement("a");
    a.className = className === undefined ? "link-line" : className;
    a.href = href;
    a.target = "_blank";
    a.rel = "noopener";
    a.textContent = text;
    return a;
  }

  function loadMeta(slug) {
    if (state.meta[slug]) return Promise.resolve(state.meta[slug]);
    return fetch("models/" + slug + "/metadata.json")
      .then(function (r) { return r.ok ? r.json() : {}; })
      .catch(function () { return {}; })
      .then(function (meta) { state.meta[slug] = meta; return meta; });
  }

  function hasAssessment(slug) {
    if (slug in state.assessmentSlugs) return Promise.resolve(state.assessmentSlugs[slug]);
    return fetch("assessments/" + slug + ".json", { method: "HEAD" })
      .then(function (r) { return r.ok; })
      .catch(function () { return false; })
      .then(function (ok) { state.assessmentSlugs[slug] = ok; return ok; });
  }

  function licenseOf(m) {
    return m.license || DEFAULT_LICENSE;
  }

  function mutedNote(text) {
    var p = document.createElement("p");
    p.className = "muted-note";
    p.textContent = text;
    return p;
  }

  function fillTeachingMaterials(m, box) {
    loadMeta(m.slug).then(function (meta) {
      if (state.activeSlug !== m.slug || !box.isConnected) return;
      var tm = (meta && meta.teachingMaterials) || {};
      var found = false;
      box.innerHTML = "";
      if (tm.lessonPlan) {
        box.appendChild(externalLink(tm.lessonPlan, "Lesson plan (opens in Google Docs) →"));
        found = true;
      }
      if (tm.uiOverview) {
        box.appendChild(externalLink(tm.uiOverview, "Slide deck for the class →"));
        found = true;
      }
      (tm.related || []).forEach(function (r) {
        if (r && r.url) {
          box.appendChild(externalLink(r.url, (r.title || "Related lesson") + " →"));
          found = true;
        }
      });
      if (!found) {
        box.appendChild(mutedNote("No lesson plan or slides are linked for this model yet."));
      }
    });
  }

  function fillAssessment(m, box) {
    hasAssessment(m.slug).then(function (ok) {
      if (state.activeSlug !== m.slug || !box.isConnected) return;
      box.innerHTML = "";
      if (!ok) {
        box.appendChild(mutedNote("No question set for this model yet."));
        return;
      }
      box.appendChild(mutedNote("A short set of questions about this model, for practice and discussion. These are drafts that no expert has reviewed yet."));
      var btn = document.createElement("button");
      btn.type = "button";
      btn.className = "btn btn-outline";
      btn.textContent = "Start the questions";
      btn.onclick = function () { openAssessment(m); };
      box.appendChild(btn);
    });
  }

  function renderDetails(m) {
    els.details.innerHTML = "";

    var h2 = document.createElement("h2");
    h2.textContent = m.title;
    els.details.appendChild(h2);

    var p = document.createElement("p");
    p.textContent = m.description;
    els.details.appendChild(p);

    var actions = document.createElement("div");
    actions.className = "model-actions";

    actions.appendChild(externalLink(m.htmlApp, "🚀 Open Full Screen ↗", "btn btn-primary"));

    var notebookBtn = document.createElement("button");
    notebookBtn.className = "btn btn-secondary";
    notebookBtn.textContent = "📓 Open Notebook";
    notebookBtn.onclick = function () {
      if (window.toggleLabNotebook) {
        window.toggleLabNotebook();
      }
    };
    actions.appendChild(notebookBtn);

    var favoriteBtn = document.createElement("button");
    favoriteBtn.className = "btn btn-outline";
    favoriteBtn.textContent = state.favorites.has(m.slug) ? "⭐ Remove Favorite" : "☆ Add to Favorites";
    favoriteBtn.onclick = function () {
      toggleFavorite(m.slug);
      renderDetails(m);
      renderList();
    };
    actions.appendChild(favoriteBtn);

    els.details.appendChild(actions);

    if (m.htmlAppLegacy || m.htmlAppVersion) {
      var versionNote = document.createElement("p");
      versionNote.className = "version-note";
      versionNote.appendChild(document.createTextNode("Running " + (m.htmlAppVersion || "the current version") + "."));
      if (m.htmlAppLegacy) {
        versionNote.appendChild(document.createTextNode(" Having trouble? Try the "));
        versionNote.appendChild(externalLink(m.htmlAppLegacy, m.htmlAppLegacyVersion || "previous version", ""));
        versionNote.appendChild(document.createTextNode("."));
      }
      els.details.appendChild(versionNote);
    }

    els.details.appendChild(sectionTitle("Teach with this model"));
    var teaching = document.createElement("div");
    teaching.className = "details-box";
    teaching.textContent = "Looking for lesson materials…";
    els.details.appendChild(teaching);
    fillTeachingMaterials(m, teaching);

    els.details.appendChild(sectionTitle("Check your thinking"));
    var quiz = document.createElement("div");
    quiz.className = "details-box";
    els.details.appendChild(quiz);
    fillAssessment(m, quiz);

    els.details.appendChild(sectionTitle("Ideas in this model"));
    els.details.appendChild(chipList(m.concepts, "concept"));

    els.details.appendChild(sectionTitle("School subjects"));
    els.details.appendChild(chipList(m.subjects));

    els.details.appendChild(sectionTitle("Grades"));
    els.details.appendChild(chipList(m.grades, "grade"));

    els.details.appendChild(sectionTitle("Learning path (draft)"));
    els.details.appendChild(mutedNote("A draft of how students could build up to this model over several grades. No expert has reviewed it yet."));
    els.details.appendChild(externalLink(REPO_BLOB_BASE + m.lpmStrand, "Read the draft learning path →"));

    els.details.appendChild(sectionTitle("Source files and licence"));
    els.details.appendChild(mutedNote("Licence: " + licenseOf(m) + "." + (m.licenseNote ? " " + m.licenseNote : "")));
    els.details.appendChild(externalLink(REPO_BLOB_BASE + m.modelPage + "README.md", "Model README on GitHub (source, licence) →"));
  }

  // -------------------------------------------------------------------
  // Check your thinking (question sets)
  // -------------------------------------------------------------------

  function openAssessment(m) {
    var dlg = document.getElementById("assessment-dialog");
    var host = document.getElementById("assessment-host");
    if (!dlg || !host || !window.AssessmentEngine) return;
    host.textContent = "Loading the questions…";
    if (dlg.showModal && !dlg.open) dlg.showModal();
    else dlg.setAttribute("open", "");
    window.AssessmentEngine.loadAssessment("assessments/" + m.slug + ".json")
      .then(function (assessment) {
        assessment.title = "Questions about " + m.title;
        window.AssessmentEngine.render(host);
      })
      .catch(function () { host.textContent = "The questions could not be loaded. Please try again later."; });
  }

  function closeAssessment() {
    var dlg = document.getElementById("assessment-dialog");
    if (!dlg) return;
    if (dlg.close) dlg.close();
    else dlg.removeAttribute("open");
  }

  // -------------------------------------------------------------------
  // Model frame: scale the model to fit
  // -------------------------------------------------------------------

  // The model's own page lays itself out at a width of about 1200 to 1400
  // pixels. Measure that natural width once per load, then show the model at
  // that width scaled down to fit, but never smaller than MIN_SCALE. Below
  // MIN_SCALE the model scrolls sideways instead of turning unreadable.
  var MIN_SCALE = 0.5;

  function measureNaturalWidth(f) {
    try {
      var doc = f.contentDocument;
      if (!doc || !doc.body || !doc.body.children.length) return 0;
      f.style.width = "300px";
      var w = doc.documentElement.scrollWidth;
      return Math.max(800, Math.min(w, 1600));
    } catch (e) { return 0; }
  }

  function fitModelFrame(remeasure) {
    var wrap = els.frameWrap, f = els.frame, sizer = els.frameSizer, scroller = els.frameScroll;
    if (!wrap || !f || !sizer || !scroller) return;
    if (document.fullscreenElement === wrap) return;   // full-screen CSS takes over
    var avail = scroller.clientWidth;
    if (!avail) return;

    if (remeasure === true || !f.dataset.naturalW) {
      var measured = measureNaturalWidth(f);
      if (measured) f.dataset.naturalW = String(measured);
    }
    var natural = parseInt(f.dataset.naturalW, 10) || MODEL_DESIGN_WIDTH;
    var scale = Math.max(MIN_SCALE, Math.min(1, avail / natural));
    var width = scale < 1 ? natural : avail;
    f.style.width = width + "px";

    var contentH = 0;
    try {
      var doc = f.contentDocument;
      if (doc && doc.documentElement) {
        contentH = Math.max(doc.documentElement.scrollHeight, doc.body ? doc.body.scrollHeight : 0);
      }
    } catch (e) { /* cross-origin frame: fall back to a fixed height */ }
    if (!contentH) contentH = 900;
    // Keep very short models from collapsing and very tall ones from running away.
    contentH = Math.max(560, Math.min(contentH, 1600));

    f.style.height = contentH + "px";
    f.style.transformOrigin = "top left";
    f.style.transform = scale < 1 ? "scale(" + scale + ")" : "none";
    sizer.style.width = Math.round(width * scale) + "px";
    sizer.style.height = Math.round(contentH * scale) + "px";
  }

  function scheduleFit() {
    fitModelFrame(true);
    // NetLogo builds its interface a moment after the page loads.
    setTimeout(function () { fitModelFrame(true); }, 800);
    setTimeout(function () { fitModelFrame(true); }, 2500);
  }

  function selectModel(slug, opts) {
    var m = state.models.find(function (x) { return x.slug === slug; });
    if (!m) return;
    opts = opts || {};
    var changed = state.activeSlug !== slug;
    state.activeSlug = slug;
    if (changed) {
      // Each newly selected model starts its own notebook entry.
      labNotebookEntry = null;
    }
    if (els.frameLoading) {
      els.frameLoading.classList.remove("hidden");
    }
    if (changed || !els.frame.getAttribute("src")) {
      els.frame.src = m.htmlApp;
    }

    addToRecentlyViewed(slug);
    updateBreadcrumb(m.title);
    var lic = document.getElementById("viewer-license");
    if (lic) lic.textContent = "Licence: " + licenseOf(m);

    renderList();
    renderDetails(m);
    if (NARROW.matches && !opts.keepPane) {
      setPane("run");
    } else {
      writeHash();
    }
  }

  function addToRecentlyViewed(slug) {
    var index = state.recentlyViewed.indexOf(slug);
    if (index > -1) {
      state.recentlyViewed.splice(index, 1);
    }
    state.recentlyViewed.unshift(slug);
    if (state.recentlyViewed.length > 5) {
      state.recentlyViewed.pop();
    }
    try {
      localStorage.setItem("netlogo-recent", JSON.stringify(state.recentlyViewed));
    } catch (e) { /* storage may be blocked; the list just resets each visit */ }
  }

  function toggleFavorite(slug) {
    if (state.favorites.has(slug)) {
      state.favorites.delete(slug);
    } else {
      state.favorites.add(slug);
    }
    try {
      localStorage.setItem("netlogo-favorites", JSON.stringify(Array.from(state.favorites)));
    } catch (e) {
      console.error("Failed to save favorites:", e);
    }
  }

  function updateBreadcrumb(title) {
    if (els.breadcrumbCurrent) {
      els.breadcrumbCurrent.textContent = title || "Explore";
    }
  }

  // ---------------------------------------------------------------------
  // Web address: #model=<slug>&view=graph&pane=models|about
  // A bare #<slug> (older links) still works.
  // ---------------------------------------------------------------------

  function parseHash() {
    var h = (location.hash || "").replace(/^#/, "");
    var out = {};
    if (!h) return out;
    if (h.indexOf("=") === -1) { out.model = decodeURIComponent(h); return out; }
    h.split("&").forEach(function (kv) {
      var i = kv.indexOf("=");
      if (i > 0) out[kv.slice(0, i)] = decodeURIComponent(kv.slice(i + 1));
    });
    return out;
  }

  function writeHash() {
    if (!history.replaceState) return;
    var parts = [];
    if (state.activeSlug) parts.push("model=" + encodeURIComponent(state.activeSlug));
    if (state.mode === "graph") parts.push("view=graph");
    if (NARROW.matches && state.mode === "explore" && state.pane !== "run") parts.push("pane=" + state.pane);
    history.replaceState(null, "", parts.length ? "#" + parts.join("&") : location.pathname + location.search);
  }

  // Phone and tablet: show the model list, the model, or the details, one at a time.
  function setPane(pane) {
    if (["models", "run", "about"].indexOf(pane) === -1) pane = "run";
    state.pane = pane;
    var layout = document.getElementById("layout");
    if (layout) layout.setAttribute("data-pane", pane);
    document.querySelectorAll("#pane-tabs button").forEach(function (b) {
      b.setAttribute("aria-selected", b.getAttribute("data-pane") === pane ? "true" : "false");
    });
    writeHash();
    if (pane === "run") scheduleFit();
    window.scrollTo(0, 0);
  }

  function clearFilters() {
    state.search = "";
    state.concept = "";
    state.grade = "";
    els.search.value = "";
    els.conceptFilter.value = "";
    els.gradeFilter.value = "";
    renderList();
  }

  function navigateTo(page) {
    if (page === "home") {
      clearFilters();
      if (state.mode !== "explore") setMode("explore");
    } else if (page === "models") {
      els.list.scrollIntoView({ behavior: "smooth" });
    }
  }

  // ---------------------------------------------------------------------
  // Mode switching (Explore / Graph)
  // ---------------------------------------------------------------------

  function setMode(mode) {
    state.mode = mode;
    document.body.setAttribute("data-mode", mode);
    document.querySelectorAll('.app-tab').forEach(function(btn) {
      var isActive = btn.dataset.mode === mode;
      btn.classList.toggle('active', isActive);
      btn.setAttribute('aria-selected', isActive ? 'true' : 'false');
    });

    var modelFrameWrap = document.getElementById('model-frame-wrap');
    var graphMode = document.getElementById('graph-mode');
    var modelList = document.getElementById('model-list');
    var filters = document.querySelector('.filters');

    if (modelFrameWrap) {
      modelFrameWrap.style.display = mode === 'explore' ? 'block' : 'none';
    }
    if (graphMode) {
      graphMode.style.display = mode === 'graph' ? 'flex' : 'none';
      if (mode === 'graph' && window.GraphExplorer) {
        window.GraphExplorer.onShow();
      }
    }
    if (modelList) {
      modelList.style.display = mode === 'explore' ? 'block' : 'none';
    }
    if (filters) {
      filters.style.display = mode === 'explore' ? 'flex' : 'none';
    }

    if (mode !== 'explore') {
      var detailsContent = document.getElementById('details-content');
      if (detailsContent) {
        detailsContent.innerHTML = '';
      }
    } else {
      // Returning to Explore: repopulate the details panel for whichever
      // model is still active, rather than leaving it blank until the next click.
      var current = getCurrentModel();
      if (current) renderDetails(current);
      scheduleFit();
    }
    writeHash();
  }

  // ---------------------------------------------------------------------
  // Digital Lab Notebook
  // ---------------------------------------------------------------------

  function toggleLabNotebook() {
    var panel = document.getElementById('lab-notebook-panel');
    if (panel) {
      panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
    }
  }

  function showNotebookTab(tabName, evt) {
    document.querySelectorAll('.notebook-section').forEach(function(section) {
      section.classList.remove('active');
    });
    document.querySelectorAll('.notebook-tab').forEach(function(tab) {
      tab.classList.remove('active');
    });

    var section = document.getElementById('notebook-' + tabName);
    if (section) {
      section.classList.add('active');
    }

    if (evt && evt.target) {
      evt.target.classList.add('active');
    }
  }

  function ensureNotebookEntry() {
    if (labNotebookEntry) return labNotebookEntry;
    var current = getCurrentModel();
    if (!current) {
      showNotice('Pick a model first, then write your note.');
      return null;
    }
    if (window.LabNotebook) {
      labNotebookEntry = window.LabNotebook.startEntry(current.slug, current.title);
    }
    return labNotebookEntry;
  }

  function addObservation() {
    var input = document.getElementById('observation-input');
    if (!input) return;

    var text = input.value.trim();
    if (!text) {
      showNotice('Type what you noticed first, then press Add Observation.');
      return;
    }

    if (!ensureNotebookEntry()) return;

    var current = getCurrentModel();
    if (window.LabNotebook) {
      window.LabNotebook.addObservation(text, {
        model: current ? current.slug : null,
        timestamp: new Date().toISOString()
      });
    }

    input.value = '';
    displayObservations();
  }

  function displayObservations() {
    var list = document.getElementById('observations-list');
    if (!list) return;

    if (!labNotebookEntry) {
      list.innerHTML = '<p>No observations yet. Start exploring a model and record what you notice!</p>';
      return;
    }

    var observationsHtml = labNotebookEntry.observations.map(function(obs) {
      return '<div class="observation-item">' +
        '<div class="observation-time">' + new Date(obs.time).toLocaleTimeString() + '</div>' +
        '<p>' + escapeHtml(obs.text) + '</p>' +
        '</div>';
    }).join('');

    var screenshotsHtml = (labNotebookEntry.screenshots || []).map(function(shot) {
      return '<div class="observation-item">' +
        '<div class="observation-time">' + new Date(shot.time).toLocaleTimeString() + '</div>' +
        '<img src="' + shot.data + '" alt="Model screenshot" style="max-width:100%;border-radius:4px;">' +
        '</div>';
    }).join('');

    list.innerHTML = observationsHtml + screenshotsHtml ||
      '<p>No observations yet. Start exploring a model and record what you notice!</p>';
  }

  function captureModelScreenshot() {
    var iframe = document.getElementById('model-frame');
    if (!iframe) {
      showNotice('No model is open yet.');
      return;
    }

    var canvas;
    try {
      var frameDoc = iframe.contentDocument || iframe.contentWindow.document;
      canvas = frameDoc.querySelector('canvas');
    } catch (e) {
      showNotice('The picture could not be taken. Make sure a model is open and running.');
      return;
    }

    if (!canvas) {
      showNotice('No picture to take yet. Make sure the model is open and running.');
      return;
    }

    var dataUrl;
    try {
      dataUrl = canvas.toDataURL('image/png');
    } catch (e) {
      showNotice('The picture could not be taken: ' + e.message);
      return;
    }

    if (!ensureNotebookEntry()) return;

    var current = getCurrentModel();
    if (window.LabNotebook) {
      window.LabNotebook.addScreenshot(dataUrl, current ? current.title : '');
    }

    displayObservations();
  }

  function saveReflections() {
    if (!ensureNotebookEntry()) return;

    if (window.LabNotebook) {
      var patterns = document.getElementById('reflection-patterns');
      var surprises = document.getElementById('reflection-surprises');
      var questions = document.getElementById('reflection-questions');
      var connections = document.getElementById('reflection-connections');

      if (patterns) window.LabNotebook.addReflection('patterns', patterns.value);
      if (surprises) window.LabNotebook.addReflection('surprises', surprises.value);
      if (questions) window.LabNotebook.addReflection('questions', questions.value);
      if (connections) window.LabNotebook.addReflection('connections', connections.value);
    }

    showNotice('Reflections saved in this browser.');
  }

  function clearNotebook() {
    if (confirm('Are you sure you want to clear all notebook entries?')) {
      if (window.LabNotebook) {
        window.LabNotebook.clearAll();
      }
      labNotebookEntry = null;

      var observationInput = document.getElementById('observation-input');
      var patterns = document.getElementById('reflection-patterns');
      var surprises = document.getElementById('reflection-surprises');
      var questions = document.getElementById('reflection-questions');
      var connections = document.getElementById('reflection-connections');

      if (observationInput) observationInput.value = '';
      if (patterns) patterns.value = '';
      if (surprises) surprises.value = '';
      if (questions) questions.value = '';
      if (connections) connections.value = '';

      displayObservations();
    }
  }

  function exportNotebook() {
    if (!window.LabNotebook) return;

    var data = window.LabNotebook.exportAll();
    var blob = new Blob([data], { type: 'application/json' });
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = 'lab-notebook-' + new Date().toISOString().split('T')[0] + '.json';
    a.click();
    URL.revokeObjectURL(url);
  }

  function renderThinkingTools() {
    var list = document.getElementById("thinking-tools-list");
    if (!list) return;
    list.innerHTML = "";
    var hidden = 0;
    THINKING_TOOLS.forEach(function (tool) {
      var url = tool.local ? tool.url : (OPENEVO_SITE_BASE ? OPENEVO_SITE_BASE + tool.url : "");
      if (!url) { hidden += 1; return; }
      list.appendChild(externalLink(url, tool.name + " ↗", "btn btn-outline"));
    });
    if (hidden) {
      list.appendChild(mutedNote("More thinking tools (causal mapping, payoff matrices, analogy mapping) will be linked here once OpenEvo.net is public."));
    }
  }

  // ---------------------------------------------------------------------
  // Boot
  // ---------------------------------------------------------------------

  function init(models) {
    state.models = models;
    populateFilters(models);

    if (els.frame && els.frameLoading) {
      els.frame.addEventListener("load", function () {
        els.frameLoading.classList.add("hidden");
        delete els.frame.dataset.naturalW;
        scheduleFit();
      });
    }

    try {
      var savedFavorites = localStorage.getItem("netlogo-favorites");
      if (savedFavorites) {
        state.favorites = new Set(JSON.parse(savedFavorites));
      }
    } catch (e) {
      console.error("Failed to load favorites:", e);
    }

    try {
      var savedRecent = JSON.parse(localStorage.getItem("netlogo-recent") || "[]");
      if (Array.isArray(savedRecent)) {
        state.recentlyViewed = savedRecent.filter(function (slug) {
          return models.some(function (m) { return m.slug === slug; });
        }).slice(0, 5);
      }
    } catch (e) { /* storage unavailable */ }

    renderThinkingTools();
    renderList();

    var fromHash = parseHash();
    var initialSlug = fromHash.model;
    if (!initialSlug || !models.some(function (m) { return m.slug === initialSlug; })) {
      initialSlug = models[0] && models[0].slug;
    }
    state.pane = ["models", "run", "about"].indexOf(fromHash.pane) > -1 ? fromHash.pane : "run";
    if (initialSlug) selectModel(initialSlug, { keepPane: true });
    setPane(state.pane);
    if (fromHash.view === "graph") setMode("graph");
    else document.body.setAttribute("data-mode", "explore");

    if (window.ResizeObserver && els.frameWrap) {
      new ResizeObserver(function () { fitModelFrame(); }).observe(els.frameWrap);
    }
    document.addEventListener("fullscreenchange", function () { setTimeout(function () { fitModelFrame(true); }, 50); });

    var searchTimeout;
    els.search.addEventListener("input", function (e) {
      clearTimeout(searchTimeout);
      searchTimeout = setTimeout(function() {
        state.search = e.target.value;
        renderList();
      }, 300);
    });

    els.conceptFilter.addEventListener("change", function (e) {
      state.concept = e.target.value;
      renderList();
    });
    els.gradeFilter.addEventListener("change", function (e) {
      state.grade = e.target.value;
      renderList();
    });
  }

  window.clearFilters = clearFilters;
  window.navigateTo = navigateTo;
  window.toggleFavorite = toggleFavorite;
  window.selectModel = selectModel;
  window.setMode = setMode;
  window.toggleLabNotebook = toggleLabNotebook;
  window.showNotebookTab = showNotebookTab;
  window.addObservation = addObservation;
  window.captureModelScreenshot = captureModelScreenshot;
  window.saveReflections = saveReflections;
  window.clearNotebook = clearNotebook;
  window.exportNotebook = exportNotebook;
  window.setPane = setPane;
  window.closeAssessment = closeAssessment;

  fetch("assets/models.json")
    .then(function (r) { return r.json(); })
    .then(init)
    .catch(function (err) {
      els.list.textContent = "Could not load model index: " + err;
    });
})();
