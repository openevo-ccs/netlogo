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
  };

  var els = {
    list: document.getElementById("model-list"),
    search: document.getElementById("search"),
    conceptFilter: document.getElementById("filter-concept"),
    gradeFilter: document.getElementById("filter-grade"),
    frame: document.getElementById("model-frame"),
    details: document.getElementById("details-content"),
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
    state.filtered.forEach(function (m) {
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

      li.appendChild(h3);
      li.appendChild(meta);
      li.addEventListener("click", function () { selectModel(m.slug); });
      li.addEventListener("keydown", function (e) {
        if (e.key === "Enter" || e.key === " ") { e.preventDefault(); selectModel(m.slug); }
      });
      els.list.appendChild(li);
    });

    if (state.filtered.length === 0) {
      var empty = document.createElement("li");
      empty.className = "meta-line";
      empty.style.padding = "0.5rem";
      empty.textContent = "No models match these filters.";
      els.list.appendChild(empty);
    }
  }

  function chipList(items) {
    var wrap = document.createElement("div");
    wrap.className = "chips";
    (items || []).forEach(function (item) {
      var chip = document.createElement("span");
      chip.className = "chip";
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

    var openBtn = document.createElement("a");
    openBtn.className = "btn";
    openBtn.href = m.htmlApp;
    openBtn.target = "_blank";
    openBtn.rel = "noopener";
    openBtn.textContent = "Open full-screen ↗";
    els.details.appendChild(openBtn);

    var nlogoBtn = document.createElement("a");
    nlogoBtn.className = "btn";
    nlogoBtn.href = m.nlogoSource;
    nlogoBtn.textContent = "Download .nlogo";
    els.details.appendChild(nlogoBtn);

    var conceptsTitle = document.createElement("div");
    conceptsTitle.className = "section-title";
    conceptsTitle.textContent = "Concepts";
    els.details.appendChild(conceptsTitle);
    els.details.appendChild(chipList(m.concepts));

    var subjectsTitle = document.createElement("div");
    subjectsTitle.className = "section-title";
    subjectsTitle.textContent = "Subject areas";
    els.details.appendChild(subjectsTitle);
    els.details.appendChild(chipList(m.subjects));

    var gradesTitle = document.createElement("div");
    gradesTitle.className = "section-title";
    gradesTitle.textContent = "Grade levels";
    els.details.appendChild(gradesTitle);
    els.details.appendChild(chipList(m.grades));

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
    state.activeSlug = slug;
    els.frame.src = m.htmlApp;
    renderList();
    renderDetails(m);
    if (history.replaceState) {
      history.replaceState(null, "", "#" + slug);
    }
  }

  function init(models) {
    state.models = models;
    populateFilters(models);
    renderList();

    var initialSlug = (location.hash || "").replace("#", "") || (models[0] && models[0].slug);
    if (initialSlug) selectModel(initialSlug);

    els.search.addEventListener("input", function (e) {
      state.search = e.target.value;
      renderList();
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

  fetch("assets/models.json")
    .then(function (r) { return r.json(); })
    .then(init)
    .catch(function (err) {
      els.list.textContent = "Could not load model index: " + err;
    });
})();
