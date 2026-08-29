/**
 * NetLogoBridge — a generic, same-origin postMessage bridge to a running
 * NetLogo 7 Web model embedded in an <iframe>, configured from that model's
 * own agent-manifest.json (produced by netlogo-agent-toolkit) rather than
 * hand-authored per-model config.
 *
 * The postMessage protocol itself (nlw-run-code / nlw-query /
 * nlw-query-response) is NetLogo 7 Web's own real, undocumented-but-stable
 * embedding surface — reverse-engineered and proven live in ccs-workshop's
 * shared/js/netlogo-bridge.js. This file ports that protocol and its core
 * drive/query primitives (run/setVar/report/getState); scoped down
 * deliberately to just those, since sequencing/animation and DOM
 * highlight-overlay concerns are consumer-specific presentation logic, not
 * generic infrastructure — a consumer that needs those can build them on top
 * of run()/report() the same way ccs-workshop's own animateTicks/applyOps do.
 *
 * Only works same-origin (the model iframe is served by the same static
 * host as this page), which is always true for this Explorer.
 */
(function () {
  "use strict";

  // Only one model is ever driven at a time (the Explorer shows one model in
  // its viewer pane) — a single `mounted` slot, not a registry.
  var mounted = null; // { modelId, iframe, stateReporters, ready, seq, pendingQueries }
  var listenerInstalled = false;

  function handleMessage(e) {
    if (!mounted) return;
    var data = e.data;
    if (!data || typeof data !== "object" || data.type !== "nlw-query-response") return;
    var resolve = mounted.pendingQueries.get(data.sourceInfo);
    if (!resolve) return; // not one of ours, or already timed out
    mounted.pendingQueries.delete(data.sourceInfo);
    resolve((data.results && data.results[0]) || null);
  }

  function postToModel(msg) {
    if (!mounted) return;
    try {
      mounted.iframe.contentWindow.postMessage(msg, "*");
    } catch (e) {
      console.warn("[NetLogoBridge] postMessage failed:", e);
    }
  }

  // (iframe, String, Object<string,string>, Function=) — mounts a model:
  // modelId is just a caller-chosen identifier (matched back on every call
  // below so a stale call against a since-swapped model is a safe no-op),
  // stateReporters maps a semantic key -> NetLogo reporter code (normally
  // agent-manifest.json's own `available_reporters`, see attachFromManifest
  // below), onReady fires once the model is confirmed actually compiled and
  // accepting messages (not just that the iframe's `load` event fired, which
  // happens well before the model finishes compiling).
  function attach(iframe, modelId, stateReporters, onReady) {
    mounted = {
      modelId: modelId, iframe: iframe, stateReporters: stateReporters || {},
      ready: false, seq: 0, pendingQueries: new Map()
    };
    if (!listenerInstalled) {
      window.addEventListener("message", handleMessage);
      listenerInstalled = true;
    }
    function markReady() {
      if (!mounted || mounted.iframe !== iframe || mounted.ready) return;
      mounted.ready = true;
      if (typeof onReady === "function") onReady();
    }
    // No compile-complete event to rely on -- poll with a reporter query
    // instead. Deliberately "count patches", not a bare literal like "1":
    // a literal can succeed before the engine's internal World object is
    // actually constructed, and running e.g. `setup` against that
    // not-really-ready state throws inside the engine itself ("Cannot read
    // properties of undefined (reading 'world')") even though the
    // readiness query appeared to succeed. Every NetLogo model has patches,
    // so this only returns a real number once the world genuinely exists.
    function pollUntilReady() {
      if (!mounted || mounted.iframe !== iframe || mounted.ready) return;
      queryReporter(modelId, "count patches").then(function (v) {
        if (!mounted || mounted.iframe !== iframe || mounted.ready) return;
        if (v !== undefined) markReady();
        else setTimeout(pollUntilReady, 200);
      });
    }
    iframe.addEventListener("load", function () { setTimeout(pollUntilReady, 200); });
    setTimeout(pollUntilReady, 200); // in case the iframe already finished loading before attach() ran
  }

  function detach(iframe) {
    if (mounted && mounted.iframe === iframe) mounted = null;
  }

  function mountedModelId() {
    return mounted && mounted.ready ? mounted.modelId : null;
  }

  function isMounted(modelId) {
    return !!mounted && mounted.ready && mounted.modelId === modelId;
  }

  // (String, String) => Boolean — runs arbitrary NetLogo command code (e.g.
  // "setup", "go"), same as pressing a button. Fire-and-forget: no response
  // message for this one, but same-target postMessage delivery is FIFO, so
  // sequential run() calls still execute in the order sent. Returns whether
  // it was actually sent, not whether it succeeded -- a compile/runtime
  // error inside the model has no response message to report it through.
  function run(modelId, code) {
    if (!isMounted(modelId)) return false;
    postToModel({ type: "nlw-run-code", code: code });
    return true;
  }

  // (String, String, Number|Boolean|String) => Boolean — the same
  // "set VarName value" primitive a slider/switch drag issues.
  function setVar(modelId, name, value) {
    if (!/^[A-Za-z][A-Za-z0-9_-]*\??$/.test(name)) {
      console.warn("[NetLogoBridge] refusing to set suspicious variable name:", name);
      return false;
    }
    var literal =
      typeof value === "boolean" ? (value ? "true" : "false") :
      typeof value === "number" ? String(value) :
      JSON.stringify(String(value));
    return run(modelId, "set " + name + " " + literal);
  }

  // (String, {type, ...}) => Promise<Object|null> — the raw nlw-query
  // primitive: sends exactly one query, resolves with its one result object
  // (or null on timeout/not-mounted).
  function queryOne(modelId, query) {
    return new Promise(function (resolve) {
      if (!mounted || mounted.modelId !== modelId) { resolve(null); return; }
      mounted.seq += 1;
      var id = "nlq" + mounted.seq;
      mounted.pendingQueries.set(id, resolve);
      postToModel({ type: "nlw-query", queries: [query], sourceInfo: id });
      // A lost/never-sent response should never hang a caller forever.
      setTimeout(function () {
        if (mounted && mounted.pendingQueries.has(id)) {
          mounted.pendingQueries.delete(id);
          resolve(null);
        }
      }, 4000);
    });
  }

  function queryReporter(modelId, code) {
    return queryOne(modelId, { type: "reporter", code: code }).then(function (r) {
      return r && r.success ? r.value : undefined;
    });
  }

  // (String, String) => Promise<Any|undefined> — evaluates a NetLogo
  // reporter expression and returns its real value (undefined on any
  // compile/runtime error, or if the model isn't mounted -- never a
  // fabricated fallback).
  function report(modelId, code) {
    if (!isMounted(modelId)) return Promise.resolve(undefined);
    return queryReporter(modelId, code);
  }

  // (String) => Promise<Object|null> — runs every reporter in this model's
  // stateReporters map and returns a plain {key: value} snapshot, or null if
  // the model isn't mounted/ready.
  function getState(modelId) {
    if (!isMounted(modelId)) return Promise.resolve(null);
    var reporters = mounted.stateReporters || {};
    var keys = Object.keys(reporters);
    return Promise.all(keys.map(function (k) { return report(modelId, reporters[k]); }))
      .then(function (values) {
        var out = {};
        keys.forEach(function (k, i) { out[k] = values[i]; });
        return out;
      });
  }

  // ---- agent-manifest.json integration ----

  // (String) => Promise<Object> — fetches and parses a model's
  // agent-manifest.json (from netlogo-agent-toolkit's generated output,
  // committed alongside each model's app.html).
  function loadManifest(modelSlug) {
    return fetch("models/" + modelSlug + "/agent-manifest.json").then(function (r) {
      if (!r.ok) throw new Error("agent-manifest.json not found for " + modelSlug);
      return r.json();
    });
  }

  // (iframe, String, Object, Function=) — attach(), but deriving
  // stateReporters straight from a fetched manifest's `available_reporters`
  // instead of hand-authoring them per model.
  function attachFromManifest(iframe, modelSlug, manifest, onReady) {
    attach(iframe, modelSlug, (manifest && manifest.available_reporters) || {}, onReady);
  }

  window.NetLogoBridge = {
    attach: attach,
    detach: detach,
    mountedModelId: mountedModelId,
    isMounted: isMounted,
    run: run,
    setVar: setVar,
    report: report,
    getState: getState,
    loadManifest: loadManifest,
    attachFromManifest: attachFromManifest
  };
})();
