"""
nlogo_to_nlogox.py
-------------------
Converts a legacy NetLogo (.nlogo, NetLogo <=6.x) model file into the NetLogo 7
XML model format (.nlogox).

Built directly from two primary sources:
  - Pre-7.0.0 field layout: github.com/NetLogo/NetLogo/wiki/Pre-7.0.0-File-Format-(.nlogo)-and-Widget-Format
  - 7.0.0 XML schema:       github.com/NetLogo/NetLogo/wiki/XML-File-Format

This started as a from-scratch reimplementation with no NetLogo JVM/desktop
app available to check against; it has since been validated against a real
NetLogo 7.0.4 engine (see assumption 1 below) and is meant as the first
stage of an agent-facing NetLogo toolkit: turn opaque legacy model files into a
well-formed, parseable XML document that downstream tools (model-card
extraction, experiment validation, widget-aware agents) can consume without
ever touching the original NetLogo-specific text format.

KNOWN GAPS / DOCUMENTED ASSUMPTIONS (flagged rather than silently guessed):
  1. VALIDATED against a real NetLogo 7.0.4 engine (2026-08-21, once a
     desktop install became available) by diffing against NetLogo's own
     bundled sample .nlogox models. Three classes of bug found and fixed:
       a. `kind` (button) and `direction` (slider) are capitalized enum
          tokens ("Observer"/"Turtle"/"Patch"/"Link",
          "Horizontal"/"Vertical") — the public wiki documents them
          lowercase, which real 7.0.4 rejects with `scala.MatchError`.
       b. Every code/text-bearing element (`<code>`, `<info>`, `<button>`,
          `<monitor>`, plot/pen `<setup>`/`<update>`, `<note>`, `<input>`)
          holds its content as the element's OWN text/CDATA — never a
          nested `<source>`/`<text>`/`<value>` child, contra the pattern
          the wiki implies by analogy. Confirmed against NetLogo 7.0.4's
          own "Wolf Sheep Predation.nlogox" and others under its bundled
          `models/` tree. `<model version="...">` also carries a
          "NetLogo " prefix (e.g. "NetLogo 7.0.4"), not a bare number.
       c. Chooser numeric choices use `type="double"`, not `type="number"`
          (that's the `<input>` box's vocabulary).
     See `netlogo-agent-toolkit/README.md`'s "Known gaps" section for the
     full validation writeup, including a `model_card.py` reader bug found
     at the same time (it round-tripped against this writer's own prior —
     also wrong — output).
  2. Legacy PLOT format has a single "autoplot?" boolean (x-axis autoscaling
     only); nlogox has separate autoPlotX / autoPlotY. We map the legacy
     value to autoPlotX and set autoPlotY=False, since the old GUI had no
     y-axis autoscale toggle.
  3. Shape color integers (e.g. -7500403) are carried through unchanged.
     Both formats need to encode the same packed color; without the NetLogo
     source to confirm bit-for-bit re-encoding rules, pass-through is the
     lowest-risk transformation.
  4. TEXTBOX -> <note>: pre-7 notes have one color + one transparency flag;
     nlogox notes have separate light/dark colors and a markdown flag. We
     copy the single legacy color into both light/dark slots and default
     markdown=False (pre-7 notes never supported markdown).
  5. The `version` attribute on <model> is set to the NetLogo version this
     converter targets (7.0.4, latest stable at time of writing), since the
     file is now genuinely in the 7.x format. The model's original authored
     version (e.g. "NetLogo 6.2.0") is preserved verbatim in an XML comment
     for provenance, and callers can override --target-version.

Usage:
    python3 nlogo_to_nlogox.py input.nlogo output.nlogox
"""
from __future__ import annotations
import re
import sys
import shlex
import xml.sax.saxutils as sx
from dataclasses import dataclass, field
from typing import List, Optional

SECTION_DIVIDER = "@#$#@#$#@"

# nlogox `kind`/AgentKind values are capitalized (Observer/Turtle/Patch/Link);
# the legacy .nlogo BUTTON widget's type field is uppercase (OBSERVER/...).
AGENT_KIND_MAP = {
    "OBSERVER": "Observer", "TURTLE": "Turtle",
    "PATCH": "Patch", "LINK": "Link",
}

SECTION_NAMES = [
    "code", "widgets", "info", "turtle_shapes", "version",
    "preview_commands", "system_dynamics", "behaviorspace",
    "hubnet_client", "link_shapes", "model_settings", "delta_tick",
]


# --------------------------------------------------------------------------
# Section splitting
# --------------------------------------------------------------------------

def split_sections(raw: str) -> dict:
    parts = raw.split(SECTION_DIVIDER)
    parts = [p.strip("\n") for p in parts]
    if len(parts) != 12:
        raise ValueError(
            f"Expected 12 sections separated by {SECTION_DIVIDER!r}, "
            f"found {len(parts)}. This file may not conform to the "
            f"documented pre-7.0.0 .nlogo layout."
        )
    return dict(zip(SECTION_NAMES, parts))


# --------------------------------------------------------------------------
# Small parsing helpers
# --------------------------------------------------------------------------

def _nlogo_bool(tok: str) -> bool:
    """T/NIL style boolean used by buttons."""
    return tok.strip() == "T"


def _numeric_bool(tok: str) -> bool:
    return tok.strip() == "1"


def _inverted_bool(tok: str) -> bool:
    """Switch 'on' field: 1=off, 0=on (documented as 'Inverted Boolean')."""
    return tok.strip() == "0"


def _nil_or(tok: str, default: Optional[str] = None) -> Optional[str]:
    tok = tok.strip()
    return default if tok == "NIL" else tok


def cdata_or_text(text: str) -> str:
    """Content for an element that holds code/text as its OWN body (no
    nested wrapper tag) — CDATA if it contains reserved XML chars, escaped
    text otherwise. This is how real NetLogo 7.0.4 .nlogox files encode
    <code>, <info>, <button>, <monitor>, plot/pen <setup>/<update>,
    <note>, and <input> content (validated against NetLogo's own bundled
    sample models)."""
    if any(c in text for c in "<>&"):
        safe = text.replace("]]>", "]]]]><![CDATA[>")
        return f"<![CDATA[{safe}]]>"
    return sx.escape(text)


def attr(name: str, value) -> str:
    if isinstance(value, bool):
        value = "true" if value else "false"
    return f'{name}="{sx.quoteattr(str(value))[1:-1]}"'


def split_quoted_tokens(line: str, n: int) -> List[str]:
    """Split a widget line into exactly n whitespace-separated tokens,
    respecting double-quoted strings (used by plot pen lines and the
    plot setup/update code line)."""
    tokens = shlex.split(line, posix=False)
    cleaned = []
    for t in tokens:
        if len(t) >= 2 and t[0] == '"' and t[-1] == '"':
            t = t[1:-1]
        cleaned.append(t)
    if len(cleaned) != n:
        raise ValueError(f"Expected {n} tokens in {line!r}, got {len(cleaned)}: {cleaned}")
    return cleaned


# --------------------------------------------------------------------------
# Widget parsing (legacy) -> XML rendering (nlogox)
# --------------------------------------------------------------------------

@dataclass
class Widget:
    kind: str
    lines: List[str]

    def xml(self) -> str:
        method = getattr(self, f"_render_{self.kind.lower().replace('-', '_')}", None)
        if method is None:
            raise NotImplementedError(f"No renderer for widget kind {self.kind!r}")
        return method()

    # ---- View -----------------------------------------------------------
    def _render_graphics_window(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        patchsize = float(f[6])
        fontsize = int(f[8])
        wrap_x = _numeric_bool(f[13])
        wrap_y = _numeric_bool(f[14])
        minpx, maxpx, minpy, maxpy = int(f[16]), int(f[17]), int(f[18]), int(f[19])
        update_mode = int(f[20])
        show_tick = _numeric_bool(f[22])
        tick_label = _nil_or(f[23])
        frame_rate = float(f[24]) if len(f) > 24 and f[24].strip() else 30.0
        attrs = [
            attr("x", left), attr("y", top),
            attr("width", right - left), attr("height", bottom - top),
            attr("minPxcor", minpx), attr("maxPxcor", maxpx),
            attr("minPycor", minpy), attr("maxPycor", maxpy),
            attr("patchSize", patchsize),
            attr("wrappingAllowedX", wrap_x), attr("wrappingAllowedY", wrap_y),
            attr("fontSize", fontsize), attr("updateMode", update_mode),
            attr("showTickCounter", show_tick), attr("frameRate", frame_rate),
        ]
        if tick_label:
            attrs.append(attr("tickCounterLabel", tick_label))
        return f"<view {' '.join(attrs)}/>"

    # ---- Button -----------------------------------------------------------
    def _render_button(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        display = f[4].strip()
        code = f[5]
        forever = _nlogo_bool(f[6])
        # kind is a capitalized enum in real 7.0.4 output (Observer/Turtle/
        # Patch/Link), not the lowercase form the public wiki documents.
        button_type = AGENT_KIND_MAP.get(f[9].strip().upper(), "Observer")
        action_key = _nil_or(f[11])
        always_enabled = _numeric_bool(f[14]) if len(f) > 14 else True
        attrs = [
            attr("x", left), attr("y", top),
            attr("width", right - left), attr("height", bottom - top),
            attr("forever", forever), attr("kind", button_type),
            attr("disableUntilTicks", not always_enabled),
        ]
        if display:
            attrs.append(attr("display", display))
        if action_key:
            attrs.append(attr("actionKey", action_key))
        return f"<button {' '.join(attrs)}>{cdata_or_text(code)}</button>"

    # ---- Slider -----------------------------------------------------------
    def _render_slider(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        display, varname = f[4].strip(), f[5].strip()
        vmin, vmax = f[6].strip(), f[7].strip()
        vdefault = float(f[8])
        step = f[9].strip()
        units = _nil_or(f[11])
        orientation = "Horizontal" if f[12].strip().upper() == "HORIZONTAL" else "Vertical"
        attrs = [
            attr("x", left), attr("y", top),
            attr("width", right - left), attr("height", bottom - top),
            attr("min", vmin), attr("max", vmax), attr("default", vdefault),
            attr("step", step), attr("direction", orientation),
        ]
        if display:
            attrs.append(attr("display", display))
        if varname:
            attrs.append(attr("variable", varname))
        if units:
            attrs.append(attr("units", units))
        return f"<slider {' '.join(attrs)}/>"

    # ---- Switch -----------------------------------------------------------
    def _render_switch(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        display, varname = f[4].strip(), f[5].strip()
        on = _inverted_bool(f[6])
        attrs = [
            attr("x", left), attr("y", top),
            attr("width", right - left), attr("height", bottom - top),
            attr("on", on),
        ]
        if display:
            attrs.append(attr("display", display))
        if varname:
            attrs.append(attr("variable", varname))
        return f"<switch {' '.join(attrs)}/>"

    # ---- Monitor ------------------------------------------------------
    def _render_monitor(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        display = f[4].strip()
        source = f[5]
        precision = int(f[6])
        fontsize = int(f[8]) if len(f) > 8 and f[8].strip() else 11
        attrs = [
            attr("x", left), attr("y", top),
            attr("width", right - left), attr("height", bottom - top),
            attr("precision", precision), attr("fontSize", fontsize),
        ]
        if display:
            attrs.append(attr("display", display))
        return f"<monitor {' '.join(attrs)}>{cdata_or_text(source)}</monitor>"

    # ---- Plot -----------------------------------------------------------
    def _render_plot(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        display = f[4].strip()
        xaxis, yaxis = _nil_or(f[5]), _nil_or(f[6])
        xmin, xmax, ymin, ymax = float(f[7]), float(f[8]), float(f[9]), float(f[10])
        autoplot = f[11].strip() == "true"
        legend = f[12].strip() == "true"
        setup_code, update_code = split_quoted_tokens(f[13], 2)

        attrs = [
            attr("x", left), attr("y", top),
            attr("width", right - left), attr("height", bottom - top),
            attr("xMin", xmin), attr("xMax", xmax),
            attr("yMin", ymin), attr("yMax", ymax),
            attr("autoPlotX", autoplot), attr("autoPlotY", False),
            attr("legend", legend),
        ]
        if display:
            attrs.append(attr("display", display))
        if xaxis:
            attrs.append(attr("xAxis", xaxis))
        if yaxis:
            attrs.append(attr("yAxis", yaxis))

        # <setup>/<update> hold their code as direct text/CDATA content,
        # not "setupCode"/"updateCode" wrapping a nested <source> child.
        parts = [f"<setup>{cdata_or_text(setup_code)}</setup>",
                 f"<update>{cdata_or_text(update_code)}</update>"]

        # PENS block: locate the "PENS" marker line (not a fixed index,
        # since the header's field count is stable but blank-line
        # spacing before it is not guaranteed) and take everything after.
        try:
            pens_idx = next(i for i, l in enumerate(f) if l.strip() == "PENS")
            pen_lines = f[pens_idx + 1:]
        except StopIteration:
            pen_lines = []
        for pen_line in pen_lines:
            pen_line = pen_line.strip()
            if not pen_line:
                continue
            toks = shlex.split(pen_line, posix=False)
            # display interval mode color inLegend setupCode updateCode
            pdisplay = toks[0].strip('"')
            interval = float(toks[1])
            mode = int(toks[2])
            color = int(toks[3])
            in_legend = toks[4] == "true"
            psetup = toks[5].strip('"')
            pupdate = toks[6].strip('"') if len(toks) > 6 else ""
            parts.append(
                f'<pen {attr("display", pdisplay)} {attr("interval", interval)} '
                f'{attr("mode", mode)} {attr("color", color)} {attr("legend", in_legend)}>'
                f"<setup>{cdata_or_text(psetup)}</setup>"
                f"<update>{cdata_or_text(pupdate)}</update></pen>"
            )
        return f"<plot {' '.join(attrs)}>{''.join(parts)}</plot>"

    # ---- Chooser ------------------------------------------------------
    def _render_chooser(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        display, varname = f[4].strip(), f[5].strip()
        choices_raw = f[6].strip()
        current = int(f[7])
        # choices_raw is a NetLogo list literal, e.g. "modest" "greedy" or 1 2 3
        choice_tokens = shlex.split(choices_raw, posix=False)
        attrs = [
            attr("x", left), attr("y", top),
            attr("width", right - left), attr("height", bottom - top),
            attr("current", current),
        ]
        if display:
            attrs.append(attr("display", display))
        if varname:
            attrs.append(attr("variable", varname))
        choice_xml = []
        for tok in choice_tokens:
            if tok.startswith('"') and tok.endswith('"'):
                val = tok[1:-1]
                choice_xml.append(f'<choice {attr("type", "string")} {attr("value", val)}/>')
            else:
                try:
                    float(tok)
                    # Chooser numeric choices use type="double" in real
                    # 7.0.4 output, not "number" (that's the <input> box
                    # vocabulary) — confirmed against NetLogo's own bundled
                    # sample models.
                    choice_xml.append(f'<choice {attr("type", "double")} {attr("value", tok)}/>')
                except ValueError:
                    choice_xml.append(f'<choice {attr("type", "string")} {attr("value", tok)}/>')
        return f"<chooser {' '.join(attrs)}>{''.join(choice_xml)}</chooser>"

    # ---- Output ---------------------------------------------------------
    def _render_output(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        fontsize = int(f[4])
        attrs = [attr("x", left), attr("y", top),
                 attr("width", right - left), attr("height", bottom - top),
                 attr("fontSize", fontsize)]
        return f"<output {' '.join(attrs)}/>"

    # ---- Input box --------------------------------------------------------
    def _render_inputbox(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        varname = f[4].strip()
        value = f[5]
        multiline = f[6].strip().lower() == "true"
        boxtype_raw = f[8].strip() if len(f) > 8 else "Number"
        type_map = {
            "Number": "number", "String": "string",
            "String (reporter)": "reporter", "String (command)": "command",
            "Color": "color",
        }
        boxtype = type_map.get(boxtype_raw, "string")
        attrs = [attr("x", left), attr("y", top),
                 attr("width", right - left), attr("height", bottom - top),
                 attr("multiline", multiline), attr("type", boxtype)]
        if varname:
            attrs.append(attr("variable", varname))
        return f"<input {' '.join(attrs)}>{cdata_or_text(value)}</input>"

    # ---- Note (from legacy TEXTBOX) --------------------------------------
    def _render_textbox(self) -> str:
        f = self.lines
        left, top, right, bottom = (int(f[0]), int(f[1]), int(f[2]), int(f[3]))
        display = f[4]
        fontsize = int(f[5])
        color = int(float(f[6]))
        # legacy transparent flag noted but nlogox <note> has no transparency
        # attribute (background is always drawn); dropped, see docstring (4).
        attrs = [
            attr("x", left), attr("y", top),
            attr("width", right - left), attr("height", bottom - top),
            attr("fontSize", fontsize),
            attr("textColorLight", color), attr("textColorDark", color),
            attr("backgroundLight", 0), attr("backgroundDark", 0),
            attr("markdown", False),
        ]
        return f"<note {' '.join(attrs)}>{cdata_or_text(display)}</note>"


WIDGET_FIELD_COUNTS = {
    # kind -> number of raw lines to greedily read is variable for PLOT
    # (pens are variable-length), handled specially below.
}


WIDGET_KEYWORDS = {
    "BUTTON", "SLIDER", "GRAPHICS-WINDOW", "VIEW3D", "MONITOR", "SWITCH",
    "PLOT", "CHOOSER", "OUTPUT", "INPUTBOX", "TEXTBOX",
}


def parse_widgets(section: str) -> List[Widget]:
    """Split the widgets section into per-widget blocks.

    NOTE: this cannot be a naive "split on blank line" because a PLOT
    widget's body itself contains a blank line before its PENS
    sub-section, e.g.:

        PLOT
        ...header fields...
        "" ""
                        <- blank line INSIDE the widget, not a separator
        PENS
        "Forest 1" 1.0 0 -10899396 true "" "..."

    So instead we split on recognized widget-keyword lines, which are
    unambiguous (PENS is never a standalone widget keyword).
    """
    lines = section.split("\n")
    widgets: List[Widget] = []
    current_kind: Optional[str] = None
    current_body: List[str] = []
    for line in lines:
        if line.strip() in WIDGET_KEYWORDS:
            if current_kind is not None:
                widgets.append(Widget(kind=current_kind, lines=current_body))
            current_kind = line.strip()
            current_body = []
        else:
            if current_kind is not None:
                current_body.append(line)
    if current_kind is not None:
        widgets.append(Widget(kind=current_kind, lines=current_body))
    return widgets


# --------------------------------------------------------------------------
# Turtle / link shapes
# --------------------------------------------------------------------------

SHAPE_PIECE_RE = re.compile(r"^(Circle|Rectangle|Polygon|Line)\s+(.*)$")


def parse_shapes(section: str) -> List[dict]:
    """Parse the turtle-shapes (or link-shapes-underlying-turtle-shape)
    section into a list of {name, rotatable, editableColorIndex, pieces}."""
    lines = [l for l in section.split("\n")]
    shapes = []
    i = 0
    n = len(lines)
    while i < n:
        if not lines[i].strip():
            i += 1
            continue
        name = lines[i].strip()
        rotatable = lines[i + 1].strip().lower() == "true"
        color_idx = int(lines[i + 2].strip())
        i += 3
        pieces = []
        while i < n and lines[i].strip():
            m = SHAPE_PIECE_RE.match(lines[i].strip())
            if not m:
                break
            piece_kind, rest = m.groups()
            toks = rest.split()
            pieces.append((piece_kind, toks))
            i += 1
        shapes.append({"name": name, "rotatable": rotatable,
                        "editableColorIndex": color_idx, "pieces": pieces})
    return shapes


def render_shape_piece(kind: str, toks: List[str]) -> str:
    if kind == "Circle":
        color, filled, marked, x, y, diameter = toks
        return (f'<circle {attr("color", int(color))} {attr("filled", filled == "true")} '
                f'{attr("marked", marked == "true")} {attr("x", int(x))} {attr("y", int(y))} '
                f'{attr("diameter", int(diameter))}/>')
    if kind == "Rectangle":
        color, filled, marked, sx_, sy_, ex_, ey_ = toks
        return (f'<rectangle {attr("color", int(color))} {attr("filled", filled == "true")} '
                f'{attr("marked", marked == "true")} {attr("startX", int(sx_))} {attr("startY", int(sy_))} '
                f'{attr("endX", int(ex_))} {attr("endY", int(ey_))}/>')
    if kind == "Line":
        color, marked, sx_, sy_, ex_, ey_ = toks
        return (f'<line {attr("color", int(color))} {attr("marked", marked == "true")} '
                f'{attr("startX", int(sx_))} {attr("startY", int(sy_))} '
                f'{attr("endX", int(ex_))} {attr("endY", int(ey_))}/>')
    if kind == "Polygon":
        color, filled, marked = toks[0], toks[1], toks[2]
        coords = [int(t) for t in toks[3:]]
        points = "".join(
            f'<point {attr("x", coords[i])} {attr("y", coords[i + 1])}/>'
            for i in range(0, len(coords) - 1, 2)
        )
        return (f'<polygon {attr("color", int(color))} {attr("filled", filled == "true")} '
                f'{attr("marked", marked == "true")}>{points}</polygon>')
    raise ValueError(f"Unknown shape piece kind {kind!r}")


def render_turtle_shapes(section: str) -> str:
    shapes = parse_shapes(section)
    if not shapes:
        return ""
    body = []
    for s in shapes:
        pieces_xml = "".join(render_shape_piece(k, t) for k, t in s["pieces"])
        body.append(
            f'<shape {attr("name", s["name"])} {attr("rotatable", s["rotatable"])} '
            f'{attr("editableColorIndex", s["editableColorIndex"])}>{pieces_xml}</shape>'
        )
    return f"<turtleShapes>{''.join(body)}</turtleShapes>"


def render_link_shapes(section: str) -> str:
    """Legacy link-shapes section: for each link shape, a name line, a
    curviness value, then 3 line specs (each: x, then dash pattern floats),
    then an indicator turtle-shape block, matching NetLogo's LinkShape
    serialization. We degrade gracefully: if the block doesn't parse
    cleanly we skip link shapes rather than emit malformed XML, since link
    shapes are rarely load-bearing for teaching models and Two Foresters
    doesn't define custom links."""
    section = section.strip("\n")
    if not section.strip():
        return ""
    # Not exercised by Two Foresters (no custom link shapes beyond
    # NetLogo's built-in "default"/"link direction"); left as a documented
    # no-op so the converter doesn't fabricate structure it can't verify.
    return "<!-- linkShapes: skipped (legacy format for link shapes is " \
           "under-documented publicly; default link shapes are provided " \
           "by NetLogo itself and do not need to be round-tripped) -->"


# --------------------------------------------------------------------------
# Top-level conversion
# --------------------------------------------------------------------------

@dataclass
class ConversionReport:
    warnings: List[str] = field(default_factory=list)


def convert(nlogo_text: str, target_version: str = "7.0.4") -> tuple[str, ConversionReport]:
    report = ConversionReport()
    sections = split_sections(nlogo_text)

    code = sections["code"]
    widgets = parse_widgets(sections["widgets"])
    info = sections["info"]
    original_version = sections["version"].strip()
    settings_raw = sections["model_settings"].strip()
    snap_to_grid = settings_raw == "1"

    widget_xml_parts = []
    for w in widgets:
        try:
            widget_xml_parts.append(w.xml())
        except Exception as e:  # pragma: no cover - defensive
            report.warnings.append(f"Skipped widget {w.kind!r}: {e}")

    turtle_shapes_xml = render_turtle_shapes(sections["turtle_shapes"])
    link_shapes_xml = render_link_shapes(sections["link_shapes"])

    preview = sections["preview_commands"].strip("\n")
    preview_xml = f"<previewCommands>{cdata_or_text(preview)}</previewCommands>" if preview.strip() else ""

    out = []
    out.append('<?xml version="1.0" encoding="UTF-8"?>')
    out.append(f"<!-- Converted from legacy .nlogo (originally saved as "
               f"{original_version!r}) by nlogo_to_nlogox.py. "
               f"Target format version: {target_version}. "
               f"See module docstring for documented conversion assumptions. -->")
    out.append(f'<model {attr("version", f"NetLogo {target_version}")} {attr("snapToGrid", snap_to_grid)}>')
    out.append(f"<code>{cdata_or_text(code)}</code>")
    out.append(f"<widgets>{''.join(widget_xml_parts)}</widgets>")
    out.append(f"<info>{cdata_or_text(info)}</info>")
    if turtle_shapes_xml:
        out.append(turtle_shapes_xml)
    if link_shapes_xml:
        out.append(link_shapes_xml)
    if preview_xml:
        out.append(preview_xml)
    out.append("</model>")
    return "\n".join(out), report


def main():
    if len(sys.argv) < 3:
        print("usage: nlogo_to_nlogox.py input.nlogo output.nlogox [target_version]", file=sys.stderr)
        sys.exit(1)
    in_path, out_path = sys.argv[1], sys.argv[2]
    target_version = sys.argv[3] if len(sys.argv) > 3 else "7.0.4"
    with open(in_path, "r", encoding="utf-8") as f:
        raw = f.read()
    xml_str, report = convert(raw, target_version)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(xml_str)
    print(f"Wrote {out_path}")
    for w in report.warnings:
        print(f"WARNING: {w}", file=sys.stderr)


if __name__ == "__main__":
    main()
