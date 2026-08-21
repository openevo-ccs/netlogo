"""
interface.py
------------
The ~10-verb tool contract every NetLogo runtime backend implements
identically, so an agent (or the MCP/tool-calling layer wrapping it) never
needs to know whether it's talking to:

  - a browser-side Tortoise/NetLogo-Web session (cheap, per-student, sandboxed)
  - a headless NetLogo JVM (BehaviorSpace-grade, for real experiments)
  - ReferenceRuntime in this repo (pure Python, JVM-free, for fast
    agentic iteration / CI / testing the toolkit itself without NetLogo
    installed -- explicitly NOT a substitute for the JVM/Tortoise engines
    when correctness of the actual NetLogo semantics matters)

Every backend must bound and validate `set_param` against the Model Card's
declared parameter ranges (min/max/step from sliders, allowed values from
switches/choosers) -- see the security note in the strategy write-up this
toolkit implements: never let an agent set an unbounded raw NetLogo
statement through this interface.
"""
from __future__ import annotations
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Any, Dict, List, Optional


@dataclass
class RunRecord:
    """Reproducibility record every run should be able to produce."""
    model_slug: str
    model_content_hash: str
    backend: str
    seed: Optional[int]
    parameters: Dict[str, Any]
    ticks_run: int
    tool_calls: List[dict]


class ModelRuntime(ABC):
    """Backend-agnostic contract. All 10 verbs from the strategy doc."""

    @abstractmethod
    def describe(self) -> dict:
        """Return the Model Card (or a reference to it) plus current
        runtime state (loaded?, ticks, backend name)."""

    @abstractmethod
    def set_param(self, name: str, value: Any) -> None:
        """Set a parameter. MUST validate against the Model Card's
        declared bounds before touching the model -- raise ValueError
        on out-of-range or unknown parameters, never pass through
        silently."""

    @abstractmethod
    def setup(self) -> None:
        """Run the model's setup entry point."""

    @abstractmethod
    def step(self, n: int = 1) -> dict:
        """Advance the model n ticks. Returns per-tick values for every
        widget-declared output (monitors/plot pens) so the agent doesn't
        have to separately call report() for things already on the
        interface."""

    @abstractmethod
    def report(self, reporter_key: str) -> Any:
        """Evaluate a reporter. `reporter_key` must be one of the
        allowlisted reporter expressions taken directly from the model's
        own monitors/plot pens (see Model Card `outputs`) -- backends
        MUST NOT accept arbitrary free-text NetLogo code here."""

    @abstractmethod
    def sample_agents(self, breed: str, n: int, attributes: List[str]) -> List[dict]:
        """Sample up to n agents of `breed`, returning `attributes` for
        each as plain dicts."""

    @abstractmethod
    def patch_grid(self, attribute: str) -> List[List[Any]]:
        """Return a 2D grid (row-major, [pycor][pxcor]) of a patch
        attribute, for heatmap-style rendering."""

    @abstractmethod
    def snapshot(self) -> dict:
        """A serializable snapshot of full world state: tick, globals,
        per-breed agent lists. Not a PNG in this reference backend (no
        graphics engine); real backends may additionally return an image."""

    @abstractmethod
    def world_hash(self) -> str:
        """A content hash of current world state, for reproducibility
        checks (same seed + same parameters + same tick count should
        produce the same hash)."""

    @abstractmethod
    def run_record(self) -> RunRecord:
        """Everything needed to replay this session exactly."""
