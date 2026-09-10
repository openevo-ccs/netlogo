/**
 * NetLogo Explorer — model browser, details panel, and the Digital Lab
 * Notebook. (Compare and Assess are being redesigned as teacher-facing
 * features — see the LPM/UI roadmap — so their previous hard-coded data/
 * logic was removed here rather than carried forward unreachable.)
 */
(function () {
  "use strict";

  var REPO_BLOB_BASE = "https://github.com/openevo-ccs/netlogo/blob/main/";

  var state = {
    models: [],
    filtered: [],
    activeSlug: null,
    search: "",
    concept: "",
    grade: "",
    recentlyViewed: [],
    favorites: new Set()
  };

  var labNotebookEntry = null;

  var els = {
    list: document.getElementById("model-list"),
    search: document.getElementById("search"),
    conceptFilter: document.getElementById("filter-concept"),
    gradeFilter: document.getElementById("filter-grade"),
    frame: document.getElementById("model-frame"),
    frameLoading: document.getElementById("model-frame-loading"),
    details: document.getElementById("details-content"),
    breadcrumbCurrent: document.getElementById("breadcrumb-current")
  };

  function getCurrentModel() {
    return state.models.find(function (m) { return m.slug === state.activeSlug; }) || null;
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
      recent: { title: "🕐 Recently Viewed", models: [] },
      all: { title: "📁 All Models", models: [] }
    };

    // Add recently viewed models
    state.recentlyViewed.forEach(function(slug) {
      var model = state.models.find(function(m) { return m.slug === slug; });
      if (model && matchesFilters(model)) {
        sections.recent.models.push(model);
      }
    });

    // Add all filtered models
    state.filtered.forEach(function(m) {
      if (sections.recent.models.indexOf(m) === -1) {
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
    actions.style.display = "flex";
    actions.style.flexWrap = "wrap";
    actions.style.gap = "var(--space-2)";

    var openBtn = document.createElement("a");
    openBtn.className = "btn btn-primary";
    openBtn.href = m.htmlApp;
    openBtn.target = "_blank";
    openBtn.rel = "noopener";
    openBtn.innerHTML = "🚀 Open Full Screen ↗";
    actions.appendChild(openBtn);

    var notebookBtn = document.createElement("button");
    notebookBtn.className = "btn btn-secondary";
    notebookBtn.innerHTML = "📓 Open Notebook";
    notebookBtn.onclick = function() {
      if (window.toggleLabNotebook) {
        window.toggleLabNotebook();
      }
    };
    actions.appendChild(notebookBtn);

    var favoriteBtn = document.createElement("button");
    favoriteBtn.className = "btn btn-outline";
    favoriteBtn.innerHTML = state.favorites.has(m.slug) ? "⭐ Remove Favorite" : "☆ Add to Favorites";
    favoriteBtn.onclick = function() {
      toggleFavorite(m.slug);
      renderDetails(m);
    };
    actions.appendChild(favoriteBtn);

    els.details.appendChild(actions);

    if (m.htmlAppLegacy) {
      var versionNote = document.createElement("p");
      versionNote.className = "version-note";
      versionNote.style.fontSize = "0.85em";
      versionNote.style.opacity = "0.75";
      versionNote.innerHTML = "Running " + (m.htmlAppVersion || "the current version") +
        ". Having trouble? Try the <a href=\"" + m.htmlAppLegacy + "\" target=\"_blank\" rel=\"noopener\">" +
        (m.htmlAppLegacyVersion || "previous version") + "</a>.";
      els.details.appendChild(versionNote);
    } else if (m.htmlAppVersion) {
      var versionNoteOnly = document.createElement("p");
      versionNoteOnly.className = "version-note";
      versionNoteOnly.style.fontSize = "0.85em";
      versionNoteOnly.style.opacity = "0.75";
      versionNoteOnly.textContent = "Running " + m.htmlAppVersion + ".";
      els.details.appendChild(versionNoteOnly);
    }

    var conceptsTitle = document.createElement("div");
    conceptsTitle.className = "section-title";
    conceptsTitle.textContent = "Concepts";
    els.details.appendChild(conceptsTitle);
    els.details.appendChild(chipList(m.concepts, "concept"));

    var subjectsTitle = document.createElement("div");
    subjectsTitle.className = "section-title";
    subjectsTitle.textContent = "Subject areas";
    els.details.appendChild(subjectsTitle);
    els.details.appendChild(chipList(m.subjects));

    var gradesTitle = document.createElement("div");
    gradesTitle.className = "section-title";
    gradesTitle.textContent = "Grade levels";
    els.details.appendChild(gradesTitle);
    els.details.appendChild(chipList(m.grades, "grade"));

    var lpmTitle = document.createElement("div");
    lpmTitle.className = "section-title";
    lpmTitle.textContent = "LPM strand";
    els.details.appendChild(lpmTitle);

    var lpmLink = document.createElement("a");
    lpmLink.className = "link-line";
    lpmLink.href = REPO_BLOB_BASE + m.lpmStrand;
    lpmLink.target = "_blank";
    lpmLink.rel = "noopener";
    lpmLink.textContent = "View / develop this model's LPM strand →";
    els.details.appendChild(lpmLink);

    var repoTitle = document.createElement("div");
    repoTitle.className = "section-title";
    repoTitle.textContent = "In the repository";
    els.details.appendChild(repoTitle);

    var modelPageLink = document.createElement("a");
    modelPageLink.className = "link-line";
    modelPageLink.href = REPO_BLOB_BASE + m.modelPage + "README.md";
    modelPageLink.target = "_blank";
    modelPageLink.rel = "noopener";
    modelPageLink.textContent = "Model README (source, license, teaching materials) →";
    els.details.appendChild(modelPageLink);
  }

  function selectModel(slug) {
    var m = state.models.find(function (x) { return x.slug === slug; });
    if (!m) return;
    var changed = state.activeSlug !== slug;
    state.activeSlug = slug;
    if (changed) {
      // Each newly selected model starts its own notebook entry.
      labNotebookEntry = null;
    }
    if (els.frameLoading) {
      els.frameLoading.classList.remove("hidden");
    }
    els.frame.src = m.htmlApp;

    addToRecentlyViewed(slug);
    updateBreadcrumb(m.title);

    renderList();
    renderDetails(m);
    if (history.replaceState) {
      history.replaceState(null, "", "#" + slug);
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
      if (els.breadcrumbCurrent) {
        els.breadcrumbCurrent.textContent = "Explore";
      }
    } else if (page === "models") {
      els.list.scrollIntoView({ behavior: "smooth" });
    }
  }

  // ---------------------------------------------------------------------
  // Mode switching (Explore / Graph)
  // ---------------------------------------------------------------------

  function setMode(mode) {
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
    }
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
      alert('Please select a model first.');
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
      alert('Please enter an observation.');
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
        '<p>' + obs.text + '</p>' +
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
      alert('No model is currently loaded.');
      return;
    }

    var canvas;
    try {
      var frameDoc = iframe.contentDocument || iframe.contentWindow.document;
      canvas = frameDoc.querySelector('canvas');
    } catch (e) {
      alert('Could not access the model view to capture it. Make sure a model is loaded and running.');
      return;
    }

    if (!canvas) {
      alert('No model view found to capture yet. Make sure a model is loaded and running.');
      return;
    }

    var dataUrl;
    try {
      dataUrl = canvas.toDataURL('image/png');
    } catch (e) {
      alert('Could not capture the model view: ' + e.message);
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

    alert('Reflections saved!');
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

  function openThinkingTool(toolName) {
    var toolUrls = {
      'tinbergen': 'thinking-tools/tinbergen-questions.html',
      'causal-mapping': 'thinking-tools/causal-mapping.html',
      'payoff-matrix': 'thinking-tools/payoff-matrix.html'
    };

    var url = toolUrls[toolName];
    if (url) {
      window.open(url, '_blank', 'width=900,height=700');
    } else {
      alert('Thinking tool not yet available: ' + toolName);
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

    renderList();

    var initialSlug = (location.hash || "").replace("#", "") || (models[0] && models[0].slug);
    if (initialSlug) selectModel(initialSlug);

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
  window.openThinkingTool = openThinkingTool;

  fetch("assets/models.json")
    .then(function (r) { return r.json(); })
    .then(init)
    .catch(function (err) {
      els.list.textContent = "Could not load model index: " + err;
    });
})();
