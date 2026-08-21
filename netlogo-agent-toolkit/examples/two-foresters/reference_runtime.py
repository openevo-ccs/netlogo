"""
reference_runtime.py
---------------------
A pure-Python, JVM-free re-implementation of the Two Foresters model's
*specific* rules, wired up behind the ModelRuntime interface (interface.py).

WHY THIS EXISTS / WHAT IT IS NOT:
This environment has no Java runtime and no way to download the NetLogo
desktop application (network egress is restricted to package registries and
source-code hosts; ccl.northwestern.edu is not reachable), so the two
production backends described in the toolkit strategy -- headless NetLogo
JVM and browser-side Tortoise/NetLogo-Web -- cannot actually be exercised
here. This reference runtime is the honest substitute: a hand-written
Python translation of the exact procedures extracted into the Model Card
(setup / setup-forests / setup-trees / setup-farmers / go / cut-trees /
harvest-private / harvest-commons / regrow), used to:
  (a) prove the toolkit's tool contract (setup/step/report/sample_agents/
      patch_grid/snapshot/world_hash) is implementable and usable end to end,
  (b) give fast, dependency-free iteration for agent development and CI,
  (c) demonstrate teaching-facing outputs (tick-by-tick series, agent
      samples, reproducible seeded runs) without waiting on a JVM.

It is explicitly NOT a substitute for real NetLogo when correctness of the
actual simulation matters for a class -- it is a hand-translation and can
contain translation bugs the real engine wouldn't. Production deployment
should route `setup`/`step`/experiments through the JVM headless launcher or
Tortoise, and reserve this backend for fast local iteration and testing the
agent/tool layer itself. See runtime/interface.py for the shared contract
both would implement.

The only reporter expressions this runtime supports are the model's own
declared monitor/plot-pen expressions (extracted into the Model Card as
`outputs`), evaluated by a small dispatch table below rather than a general
NetLogo expression interpreter -- this is a deliberate allowlist, consistent
with the "never accept arbitrary free-text NetLogo through the tool
interface" rule in interface.py.
"""
from __future__ import annotations
import hashlib
import json
import math
import random
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional

import sys, os
_TOOLKIT_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, _TOOLKIT_ROOT)
from runtime.interface import ModelRuntime, RunRecord


PARAM_DEFAULTS = {
    "Percent-cut1": 50.0,
    "Percent-cut2": 90.0,
    "Growth-Rate": 0.1,
    "Max-Treeheight": 100.0,
    "Private-forest?": True,
}
PARAM_BOUNDS = {
    "Percent-cut1": (0.0, 100.0),
    "Percent-cut2": (0.0, 100.0),
    "Growth-Rate": (0.0, 1.0),
    "Max-Treeheight": (0.0, 100.0),
}

WORLD_MINX, WORLD_MAXX = 0, 9
WORLD_MINY, WORLD_MAXY = 0, 4


@dataclass
class Tree:
    x: int
    y: int
    height: float


@dataclass
class Forester:
    label: str  # "forester1" | "forester2"
    x: float
    y: float
    amount: float = 0.0
    harvest: float = 0.0
    wealth: float = 0.0
    home: str = "forest1"  # which side this forester belongs to


class TwoForestersReferenceRuntime(ModelRuntime):
    def __init__(self, model_card: dict, model_content_hash: str, seed: Optional[int] = None):
        self.card = model_card
        self.model_content_hash = model_content_hash
        self.seed = seed if seed is not None else random.randrange(2**31)
        self._rng = random.Random(self.seed)
        self.params: Dict[str, Any] = dict(PARAM_DEFAULTS)
        self.ticks = -1  # -1 = not set up yet, matches NetLogo's pre-setup state
        self.trees: Dict[tuple, Tree] = {}
        self.foresters: List[Forester] = []
        self._tool_calls: List[dict] = []
        self._series: Dict[str, List[float]] = {}

    # -- internal helpers ---------------------------------------------
    def _log(self, call: str, **kw):
        self._tool_calls.append({"call": call, **kw})

    def _forest1_patches(self):
        return [(x, y) for x in range(WORLD_MINX, 5) for y in range(WORLD_MINY, WORLD_MAXY + 1)]

    def _forest2_patches(self):
        return [(x, y) for x in range(5, WORLD_MAXX + 1) for y in range(WORLD_MINY, WORLD_MAXY + 1)]

    def _dist(self, ax, ay, bx, by):
        return math.hypot(ax - bx, ay - by)

    def _trees_in_radius(self, cx, cy, radius, restrict_patches=None):
        out = []
        for (x, y), t in self.trees.items():
            if restrict_patches is not None and (x, y) not in restrict_patches:
                continue
            if self._dist(cx, cy, x, y) <= radius + 1e-9:
                out.append(t)
        return out

    def _max_height_tree(self, trees: List[Tree]) -> Tree:
        if not trees:
            raise RuntimeError("max-one-of on an empty agentset")
        best = max(t.height for t in trees)
        # NetLogo breaks ties randomly among all agents achieving the max
        ties = [t for t in trees if abs(t.height - best) < 1e-9]
        return self._rng.choice(ties)

    # -- ModelRuntime interface -----------------------------------------
    def describe(self) -> dict:
        return {
            "model_card_slug": self.card.get("slug"),
            "backend": "reference-python (NOT authoritative NetLogo -- see module docstring)",
            "loaded": self.ticks >= 0,
            "ticks": self.ticks,
            "seed": self.seed,
            "params": dict(self.params),
        }

    def set_param(self, name: str, value: Any) -> None:
        known = {p["variable"] for p in self.card.get("parameters", [])}
        if name not in known:
            raise ValueError(f"Unknown parameter '{name}'. Known: {sorted(known)}")
        if name in PARAM_BOUNDS:
            lo, hi = PARAM_BOUNDS[name]
            if not (lo <= float(value) <= hi):
                raise ValueError(f"'{name}'={value} out of bounds [{lo}, {hi}]")
        if name == "Private-forest?" and not isinstance(value, bool):
            raise ValueError("'Private-forest?' must be a bool")
        self.params[name] = value
        self._log("set_param", name=name, value=value)

    def setup(self) -> None:
        self.trees = {}
        for x in range(WORLD_MINX, WORLD_MAXX + 1):
            for y in range(WORLD_MINY, WORLD_MAXY + 1):
                self.trees[(x, y)] = Tree(x=x, y=y, height=float(self.params["Max-Treeheight"]))
        self.foresters = [
            Forester(label="forester1", x=2, y=1, home="forest1"),
            Forester(label="forester2", x=6, y=1, home="forest2"),
        ]
        self.ticks = 0
        self._series = {"tick": []}
        self._log("setup")
        self._record_series_point()

    def _record_series_point(self):
        self._series.setdefault("tick", []).append(self.ticks)
        for key, val in self._all_outputs().items():
            self._series.setdefault(key, []).append(val)

    def step(self, n: int = 1) -> dict:
        if self.ticks < 0:
            raise RuntimeError("Call setup() before step().")
        for _ in range(n):
            self._go_once()
        return {"ticks": self.ticks, "outputs": self._all_outputs()}

    def _go_once(self):
        private = bool(self.params["Private-forest?"])
        f1 = [f for f in self.foresters if f.home == "forest1"]
        f2 = [f for f in self.foresters if f.home == "forest2"]
        for f in f1:
            f.amount = float(self.params["Percent-cut1"])
        for f in f2:
            f.amount = float(self.params["Percent-cut2"])

        if private:
            self._harvest_private(f1, self._forest1_patches())
            self._harvest_private(f2, self._forest2_patches())
        else:
            self._harvest_commons(self.foresters)

        for f in self.foresters:
            f.wealth += f.harvest

        for t in self.trees.values():
            self._regrow(t)

        self.ticks += 1
        self._record_series_point()
        self._log("go", tick=self.ticks)

    def _harvest_private(self, farmers: List[Forester], home_patches):
        home_set = set(home_patches)
        for f in farmers:
            if (round(f.x), round(f.y)) not in home_set:
                px, py = self._rng.choice(list(home_set))
                f.x, f.y = px, py
            candidates = self._trees_in_radius(f.x, f.y, 1, restrict_patches=home_set)
            tree = self._max_height_tree(candidates)
            f.x, f.y = tree.x, tree.y
            f.harvest = tree.height * f.amount / 100.0
            tree.height = tree.height - (tree.height * f.amount / 100.0)

    def _harvest_commons(self, farmers: List[Forester]):
        for f in farmers:
            candidates = self._trees_in_radius(f.x, f.y, 2)
            tree = self._max_height_tree(candidates)
            f.x, f.y = tree.x, tree.y
            f.harvest = tree.height * f.amount / 100.0
            tree.height = tree.height - (tree.height * f.amount / 100.0)

    def _regrow(self, t: Tree):
        max_h = float(self.params["Max-Treeheight"])
        growth = float(self.params["Growth-Rate"])
        if t.height > 0:
            t.height = t.height + (growth * t.height) * (1 - (t.height / max_h))
        else:
            t.height = 0.01

    # -- allowlisted reporters, taken verbatim from the model's own
    #    monitors/plot pens (Model Card `outputs`) ------------------------
    def _all_outputs(self) -> Dict[str, float]:
        f1 = [f for f in self.foresters if f.home == "forest1"]
        f2 = [f for f in self.foresters if f.home == "forest2"]
        forest1 = self._forest1_patches()
        forest2 = self._forest2_patches()
        max_h = float(self.params["Max-Treeheight"])
        return {
            "forest1_stock_pct": (sum(self.trees[p].height for p in forest1) / (max_h * len(forest1))) * 100,
            "forest2_stock_pct": (sum(self.trees[p].height for p in forest2) / (max_h * len(forest2))) * 100,
            "total_stock_pct": (sum(t.height for t in self.trees.values()) / (max_h * len(self.trees))) * 100,
            "forester1_harvest": sum(f.harvest for f in f1),
            "forester2_harvest": sum(f.harvest for f in f2),
            "forester1_wealth": sum(f.wealth for f in f1),
            "forester2_wealth": sum(f.wealth for f in f2),
        }

    # Substring heuristics used to bind the model's *actual* declared
    # monitor/pen reporter text (extracted verbatim into the Model Card's
    # `outputs`) to a value this reference runtime knows how to compute.
    # This keeps report()'s allowlist grounded in what the model itself
    # exposes rather than an invented API -- see interface.py's contract
    # that report() must not accept arbitrary free-text NetLogo.
    _BIND_RULES = [
        (lambda s: "wealth] of farmers1" in s, "forester1_wealth"),
        (lambda s: "wealth] of farmers2" in s, "forester2_wealth"),
        (lambda s: "harvest] of farmers1" in s, "forester1_harvest"),
        (lambda s: "harvest] of farmers2" in s, "forester2_harvest"),
        (lambda s: "trees-on forest1" in s, "forest1_stock_pct"),
        (lambda s: "trees-on forest2" in s, "forest2_stock_pct"),
        (lambda s: "of trees /" in s or "of trees/" in s, "total_stock_pct"),
    ]

    def _build_reporter_map(self) -> Dict[str, str]:
        mapping = {}
        for out in self.card.get("outputs", []):
            texts = []
            if out.get("widget") == "monitor" and out.get("reporter"):
                texts.append(out["reporter"])
            for pen in out.get("pens", []):
                if pen.get("update"):
                    texts.append(pen["update"])
            for text in texts:
                for predicate, key in self._BIND_RULES:
                    if predicate(text):
                        mapping[text.strip()] = key
                        break
        return mapping

    def report(self, reporter_key: str) -> Any:
        reporter_map = self._build_reporter_map()
        if reporter_key not in reporter_map:
            raise ValueError(
                f"'{reporter_key}' is not one of this model's declared "
                f"monitor/pen reporter expressions. Allowed (verbatim from "
                f"the Model Card's `outputs`): {sorted(reporter_map)}"
            )
        return self._all_outputs()[reporter_map[reporter_key]]

    def sample_agents(self, breed: str, n: int, attributes: List[str]) -> List[dict]:
        if breed == "foresters":
            pool = self.foresters
        elif breed == "trees":
            pool = list(self.trees.values())
        else:
            raise ValueError(f"Unknown breed '{breed}' for sample_agents")
        sample = pool if len(pool) <= n else self._rng.sample(pool, n)
        out = []
        for a in sample:
            out.append({attr: getattr(a, attr, None) for attr in attributes})
        return out

    def patch_grid(self, attribute: str) -> List[List[Any]]:
        if attribute != "tree-height":
            raise ValueError("Only 'tree-height' is supported by this reference runtime")
        grid = []
        for y in range(WORLD_MAXY, WORLD_MINY - 1, -1):  # row-major, north row first
            row = [round(self.trees[(x, y)].height, 2) for x in range(WORLD_MINX, WORLD_MAXX + 1)]
            grid.append(row)
        return grid

    def snapshot(self) -> dict:
        return {
            "ticks": self.ticks,
            "params": dict(self.params),
            "trees": [{"x": t.x, "y": t.y, "height": round(t.height, 4)} for t in self.trees.values()],
            "foresters": [
                {"label": f.label, "x": f.x, "y": f.y, "amount": f.amount,
                 "harvest": round(f.harvest, 4), "wealth": round(f.wealth, 4)}
                for f in self.foresters
            ],
            "outputs": self._all_outputs(),
        }

    def world_hash(self) -> str:
        payload = json.dumps(self.snapshot(), sort_keys=True)
        return hashlib.sha256(payload.encode()).hexdigest()[:16]

    def run_record(self) -> RunRecord:
        return RunRecord(
            model_slug=self.card.get("slug", "unknown"),
            model_content_hash=self.model_content_hash,
            backend="reference-python",
            seed=self.seed,
            parameters=dict(self.params),
            ticks_run=self.ticks,
            tool_calls=list(self._tool_calls),
        )

    def series(self) -> Dict[str, List[float]]:
        """Tick-by-tick time series accumulated across step() calls --
        convenience for charting, not part of the abstract interface since
        not every backend need buffer this in-process."""
        return dict(self._series)
