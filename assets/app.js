"(function () {
  \"use strict\";

  var REPO_BLOB_BASE = \"https://github.com/openevo-ccs/netlogo/blob/main/\";

  var state = {
    models: [],
    filtered: [],
    activeSlug: null,
    search: \"\",
    concept: \"\",
    grade: \"\",
    recentlyViewed: [],
    favorites: new Set()
  };

  var els = {
    list: document.getElementById(\"model-list\"),
    search: document.getElementById(\"search\"),
    conceptFilter: document.getElementById(\"filter-concept\"),
    gradeFilter: document.getElementById(\"filter-grade\"),
    frame: document.getElementById(\"model-frame\"),
    details: document.getElementById(\"details-content\"),
    breadcrumbCurrent: document.getElementById(\"breadcrumb-current\")
  };

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
      var opt = document.createElement(\"option\");
      opt.value = c;
      opt.textContent = c;
      els.conceptFilter.appendChild(opt);
    });
    grades.forEach(function (g) {
      var opt = document.createElement(\"option\");
      opt.value = g;
      opt.textContent = g;
      els.gradeFilter.appendChild(opt);
    });
  }

  function matchesFilters(m) {
    var q = state.search.trim().toLowerCase();
    if (q) {
      var haystack = (m.title + \" \" + m.description + \" \" + (m.concepts || []).join(\" \")).toLowerCase();
      if (haystack.indexOf(q) === -1) return false;
    }
    if (state.concept && (m.concepts || []).indexOf(state.concept) === -1) return false;
    if (state.grade && (m.grades || []).indexOf(state.grade) === -1) return false;
    return true;
  }

  function renderList() {
    state.filtered = state.models.filter(matchesFilters);
    els.list.innerHTML = \"\";
    
    // Group models by category
    var sections = {
      recent: { title: \"🕐 Recently Viewed\", models: [] },
      all: { title: \"📁 All Models\", models: [] }
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
      
      var sectionHeader = document.createElement(\"div\");
      sectionHeader.className = \"section-header\";
      sectionHeader.innerHTML = \"<h3>\" + section.title + \"</h3>\";
      els.list.appendChild(sectionHeader);
      
      section.models.forEach(function(m) {
        var li = document.createElement(\"li\");
        li.className = \"model-item\" + (m.slug === state.activeSlug ? \" active\" : \"\");
        li.setAttribute(\"role\", \"button\");
        li.setAttribute(\"tabindex\", \"0\");
        li.dataset.slug = m.slug;

        var h3 = document.createElement(\"h3\");
        h3.textContent = m.title;
        
        var meta = document.createElement(\"div\");
        meta.className = \"meta-line\";
        meta.textContent = (m.grades || []).join(\", \");
        
        var description = document.createElement(\"p\");
        description.className = \"model-description\";
        description.textContent = m.description.substring(0, 80) + (m.description.length > 80 ? \"...\" : \"\");
        description.style.fontSize = \"var(--text-xs)\";
        description.style.color = \"var(--text-secondary)\";
        description.style.margin = \"var(--space-2) 0 0 0\";

        li.appendChild(h3);
        li.appendChild(description);
        li.appendChild(meta);
        li.addEventListener(\"click\", function () { selectModel(m.slug); });
        li.addEventListener(\"keydown\", function (e) {
          if (e.key === \"Enter\" || e.key === \" \") { e.preventDefault(); selectModel(m.slug); }
        });
        els.list.appendChild(li);
      });
    });

    if (state.filtered.length === 0) {
      var empty = document.createElement(\"div\");
      empty.className = \"empty-state\";
      empty.innerHTML = \"<p>No models match these filters.</p><button class=\\\"btn btn-outline\\\" onclick=\\\"clearFilters()\\\">Clear Filters</button>\";
      els.list.appendChild(empty);
    }
  }

  function chipList(items, type) {
    var wrap = document.createElement(\"div\");
    wrap.className = \"chips\";
    (items || []).forEach(function (item) {
      var chip = document.createElement(\"span\");
      chip.className = \"chip chip-\" + (type || \"\");
      chip.textContent = item;
      wrap.appendChild(chip);
    });
    return wrap;
  }

  function renderDetails(m) {
    els.details.innerHTML = \"\";

    var h2 = document.createElement(\"h2\");
    h2.textContent = m.title;
    els.details.appendChild(h2);

    var p = document.createElement(\"p\");
    p.textContent = m.description;
    els.details.appendChild(p);

    var actions = document.createElement(\"div\");
    actions.className = \"model-actions\";
    actions.style.display = \"flex\";
    actions.style.flexWrap = \"wrap\";
    actions.style.gap = \"var(--space-2)\";

    var openBtn = document.createElement(\"a\");
    openBtn.className = \"btn btn-primary\";
    openBtn.href = m.htmlApp;
    openBtn.target = \"_blank\";
    openBtn.rel = \"noopener\";
    openBtn.innerHTML = \"🚀 Open Full Screen ↗\";
    actions.appendChild(openBtn);

    var notebookBtn = document.createElement(\"button\");
    notebookBtn.className = \"btn btn-secondary\";
    notebookBtn.innerHTML = \"📓 Open Notebook\";
    notebookBtn.onclick = function() {
      if (window.toggleLabNotebook) {
        window.toggleLabNotebook();
      }
    };
    actions.appendChild(notebookBtn);

    var favoriteBtn = document.createElement(\"button\");
    favoriteBtn.className = \"btn btn-outline\";
    favoriteBtn.innerHTML = state.favorites.has(m.slug) ? \"⭐ Remove Favorite\" : \"☆ Add to Favorites\";
    favoriteBtn.onclick = function() {
      toggleFavorite(m.slug);
      renderDetails(m);
    };
    actions.appendChild(favoriteBtn);

    els.details.appendChild(actions);

    var conceptsTitle = document.createElement(\"div\");
    conceptsTitle.className = \"section-title\";
    conceptsTitle.textContent = \"Concepts\";
    els.details.appendChild(conceptsTitle);
    els.details.appendChild(chipList(m.concepts, \"concept\"));

    var subjectsTitle = document.createElement(\"div\");
    subjectsTitle.className = \"section-title\";
    subjectsTitle.textContent = \"Subject areas\";
    els.details.appendChild(subjectsTitle);
    els.details.appendChild(chipList(m.subjects));

    var gradesTitle = document.createElement(\"div\");
    gradesTitle.className = \"section-title\";
    gradesTitle.textContent = \"Grade levels\";
    els.details.appendChild(gradesTitle);
    els.details.appendChild(chipList(m.grades, \"grade\"));

    var lpmTitle = document.createElement(\"div\");
    lpmTitle.className = \"section-title\";
    lpmTitle.textContent = \"LPM strand\";
    els.details.appendChild(lpmTitle);

    var lpmLink = document.createElement(\"a\");
    lpmLink.className = \"link-line\";
    lpmLink.href = REPO_BLOB_BASE + m.lpmStrand;
    lpmLink.target = \"_blank\";
    lpmLink.rel = \"noopener\";
    lpmLink.textContent = \"View / develop this model's LPM strand →\";
    els.details.appendChild(lpmLink);

    var repoTitle = document.createElement(\"div\");
    repoTitle.className = \"section-title\";
    repoTitle.textContent = \"In the repository\";
    els.details.appendChild(repoTitle);

    var modelPageLink = document.createElement(\"a\");
    modelPageLink.className = \"link-line\";
    modelPageLink.href = REPO_BLOB_BASE + m.modelPage + \"README.md\";
    modelPageLink.target = \"_blank\";
    modelPageLink.rel = \"noopener\";
    modelPageLink.textContent = \"Model README (source, license, teaching materials) →\";
    els.details.appendChild(modelPageLink);
  }

  function selectModel(slug) {
    var m = state.models.find(function (x) { return x.slug === slug; });
    if (!m) return;
    state.activeSlug = slug;
    els.frame.src = m.htmlApp;
    
    // Add to recently viewed
    addToRecentlyViewed(slug);
    
    // Update breadcrumb
    updateBreadcrumb(m.title);
    
    renderList();
    renderDetails(m);
    if (history.replaceState) {
      history.replaceState(null, \"\", \"#\" + slug);
    }
  }

  function addToRecentlyViewed(slug) {
    // Remove if already exists
    var index = state.recentlyViewed.indexOf(slug);
    if (index > -1) {
      state.recentlyViewed.splice(index, 1);
    }
    // Add to beginning
    state.recentlyViewed.unshift(slug);
    // Keep only last 5
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
    // Save to localStorage
    try {
      localStorage.setItem(\"netlogo-favorites\", JSON.stringify(Array.from(state.favorites)));
    } catch (e) {
      console.error(\"Failed to save favorites:\", e);
    }
  }

  function updateBreadcrumb(title) {
    if (els.breadcrumbCurrent) {
      els.breadcrumbCurrent.textContent = title || \"Explore\";
    }
  }

  function clearFilters() {
    state.search = \"\";
    state.concept = \"\";
    state.grade = \"\";
    els.search.value = \"\";
    els.conceptFilter.value = \"\";
    els.gradeFilter.value = \"\";
    renderList();
  }

  function navigateTo(page) {
    if (page === \"home\") {
      clearFilters();
      if (els.breadcrumbCurrent) {
        els.breadcrumbCurrent.textContent = \"Explore\";
      }
    } else if (page === \"models\") {
      // Scroll to model list
      els.list.scrollIntoView({ behavior: \"smooth\" });
    }
  }

  function init(models) {
    state.models = models;
    populateFilters(models);
    
    // Load favorites from localStorage
    try {
      var savedFavorites = localStorage.getItem(\"netlogo-favorites\");
      if (savedFavorites) {
        state.favorites = new Set(JSON.parse(savedFavorites));
      }
    } catch (e) {
      console.error(\"Failed to load favorites:\", e);
    }
    
    renderList();

    var initialSlug = (location.hash || \"\").replace(\"#\", \"\") || (models[0] && models[0].slug);
    if (initialSlug) selectModel(initialSlug);

    var searchTimeout;
    els.search.addEventListener(\"input\", function (e) {
      clearTimeout(searchTimeout);
      searchTimeout = setTimeout(function() {
        state.search = e.target.value;
        renderList();
      }, 300);
    });
    
    els.conceptFilter.addEventListener(\"change\", function (e) {
      state.concept = e.target.value;
      renderList();
    });
    els.gradeFilter.addEventListener(\"change\", function (e) {
      state.grade = e.target.value;
      renderList();
    });
  }

  // Make functions globally available
  window.clearFilters = clearFilters;
  window.navigateTo = navigateTo;
  window.toggleFavorite = toggleFavorite;

  fetch(\"assets/models.json\")
    .then(function (r) { return r.json(); })
    .then(init)
    .catch(function (err) {
      els.list.textContent = \"Could not load model index: \" + err;
    });
})();"
