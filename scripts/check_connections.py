#!/usr/bin/env python3
"""Check models/<slug>/connections.yaml against the other OpenEvo bases and
write assets/connections.json.

What it does
  1. Reads every models/*/connections.yaml.
  2. Confirms each id exists in the base it names (ConceptBase, CompetencyBase,
     TheoryBase, LiteratureBase, TeachingBase, and the openevo-graph anchors and
     thinking tools). A vanished or renamed id fails the check.
  3. Writes assets/connections.json, which the explorer and the OpenEvo.net build
     read. The file holds ids and the plain-language label and why text written in
     the yaml. It holds no text copied from the bases.

Usage
  python scripts/check_connections.py             # check and rewrite assets/connections.json
  python scripts/check_connections.py --check     # check, and fail if connections.json is out of date
  python scripts/check_connections.py --bases-dir D:/dev/openevo-ccs-lab

The bases are expected as sibling folders of this repo (conceptbase, theorybase, ...).
Needs Python 3.9+ and PyYAML.
"""
import argparse
import glob
import json
import os
import re
import sys

try:
    import yaml
except ImportError:  # pragma: no cover
    sys.exit("PyYAML is required: pip install pyyaml")

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(REPO, "assets", "connections.json")
SCHEMA_VERSION = 1

# How each kind of connection is looked up. "glob" patterns are relative to the
# bases folder. "mode" says how ids are found.
KINDS = {
    "anchors":       {"base": "openevo-graph",  "files": ["openevo-graph/nodes/content_anchors.json"], "mode": "json-ids"},
    "thinkingTools": {"base": "openevo-graph",  "files": ["openevo-graph/nodes/thinking_tools.json"],  "mode": "json-ids"},
    "concepts":      {"base": "conceptbase",    "files": ["conceptbase/registry/concept/{id}.json"],   "mode": "file-exists"},
    "competencies":  {"base": "competencybase", "files": ["competencybase/records/*.yaml"],            "mode": "yaml-ids", "prefix": "OE-COMPETENCY-"},
    "theories":      {"base": "theorybase",     "files": ["theorybase/records/*.yaml"],                "mode": "yaml-ids"},
    "literature":    {"base": "literaturebase", "files": ["literaturebase/records/*.yaml"],            "mode": "yaml-ids", "prefix": "OE-LITERATURE-"},
    "teachingbase":  {"base": "teachingbase",   "files": ["teachingbase/records/{id}.yaml"],           "mode": "file-exists"},
}

# These kinds come from private bases whose records have not been cleared to be
# named in this public repo. Entries for them are refused until the lab says
# otherwise. To clear one, move it into KINDS above with its lookup rule.
HELD_BACK_KINDS = {
    "questions": ("questionbase", "questionbase/records/*.yaml", "yaml-ids"),
    "methods": ("methodsbase", "methodsbase/records/*.yaml", "yaml-ids"),
    "quotes": ("quotebase", "quotebase/records/*.yaml", "yaml-ids"),
}

# Public addresses, only for records that have one.
CONCEPT_URL = "https://github.com/openevo-ccs/conceptbase/blob/main/registry/concept/{id}.json"
TEACHINGBASE_URL = "https://openevo.eva.mpg.de/teachingbase/{id}/"


ID_LINE = re.compile(r"""^[ 	]*(?:-[ 	]+)?(?:id|slug):[ 	]*["']?([^\s"'#]+)""", re.M)


def load_file(path):
    with open(path, encoding="utf8") as f:
        if path.endswith(".json"):
            return json.load(f)
        return yaml.safe_load(f)


def collect_ids(node, out):
    if isinstance(node, dict):
        for key in ("id", "slug"):
            v = node.get(key)
            if isinstance(v, str):
                out.add(v)
        for v in node.values():
            collect_ids(v, out)
    elif isinstance(node, list):
        for v in node:
            collect_ids(v, out)


class Index:
    def __init__(self, bases_dir):
        self.bases_dir = bases_dir
        self.cache = {}

    def ids_for(self, kind):
        if kind in self.cache:
            return self.cache[kind]
        spec = KINDS[kind]
        found = set()
        for pattern in spec["files"]:
            for path in glob.glob(os.path.join(self.bases_dir, pattern)):
                try:
                    if spec["mode"] == "json-ids":
                        collect_ids(load_file(path), found)
                    else:
                        # The base folders hold thousands of yaml files. A line scan
                        # for id and slug fields is far quicker than a full parse.
                        with open(path, encoding="utf8", errors="replace") as f:
                            for match in ID_LINE.finditer(f.read()):
                                found.add(match.group(1))
                except Exception as exc:  # unreadable file: report, keep going
                    print(f"  warning: could not read {path}: {exc}")
        self.cache[kind] = found
        return found

    def exists(self, kind, ident):
        spec = KINDS[kind]
        if spec["mode"] == "file-exists":
            path = os.path.join(self.bases_dir, spec["files"][0].format(id=ident))
            return os.path.isfile(path)
        # Quick path: most records sit in a file named after their id. Read just that
        # file and confirm the id inside it. If that fails, scan the whole base.
        prefix = spec.get("prefix")
        if prefix and ident.startswith(prefix):
            stem = ident[len(prefix):]
            folder = os.path.join(self.bases_dir, os.path.dirname(spec["files"][0]))
            for candidate in (stem, "lit-" + stem):
                path = os.path.join(folder, candidate + ".yaml")
                if os.path.isfile(path):
                    with open(path, encoding="utf8", errors="replace") as f:
                        if ident in {m.group(1) for m in ID_LINE.finditer(f.read())}:
                            return True
        return ident in self.ids_for(kind)

    def base_present(self, kind):
        return os.path.isdir(os.path.join(self.bases_dir, KINDS[kind]["base"]))


def url_for(kind, ident):
    if kind == "concepts":
        return CONCEPT_URL.format(id=ident)
    if kind == "teachingbase":
        return TEACHINGBASE_URL.format(id=ident)
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--bases-dir", default=os.path.dirname(REPO), help="folder holding the base repos (default: the folder above this repo)")
    ap.add_argument("--check", action="store_true", help="do not write; fail if assets/connections.json differs")
    args = ap.parse_args()

    index = Index(args.bases_dir)
    errors = []
    models = {}

    missing_bases = sorted({s["base"] for k, s in KINDS.items() if not index.base_present(k)})
    if missing_bases:
        sys.exit("Cannot check: these base folders were not found in %s: %s" % (args.bases_dir, ", ".join(missing_bases)))

    known_models = set()
    mj = os.path.join(REPO, "assets", "models.json")
    if os.path.isfile(mj):
        known_models = {m["slug"] for m in json.load(open(mj, encoding="utf8"))}

    for path in sorted(glob.glob(os.path.join(REPO, "models", "*", "connections.yaml"))):
        slug = os.path.basename(os.path.dirname(path))
        rel = os.path.relpath(path, REPO).replace("\\", "/")
        data = load_file(path) or {}

        if data.get("model") != slug:
            errors.append(f"{rel}: 'model' is {data.get('model')!r}, expected {slug!r}")
        if known_models and slug not in known_models:
            errors.append(f"{rel}: {slug!r} is not in assets/models.json")
        if data.get("reviewed") is True and not (data.get("reviewedBy") and data.get("reviewedOn")):
            errors.append(f"{rel}: reviewed is true but reviewedBy and reviewedOn are missing")

        groups = {}
        for key, value in data.items():
            if key in ("model", "status", "reviewed", "reviewedBy", "reviewedOn", "note"):
                continue
            if key in HELD_BACK_KINDS:
                errors.append(f"{rel}: '{key}' is held back. Records from {HELD_BACK_KINDS[key][0]} are not yet cleared to be named in this public repo.")
                continue
            if key not in KINDS:
                errors.append(f"{rel}: unknown section {key!r}")
                continue
            if not isinstance(value, list):
                errors.append(f"{rel}: section {key!r} must be a list")
                continue
            seen = set()
            entries = []
            for i, item in enumerate(value, 1):
                if not isinstance(item, dict) or "id" not in item:
                    errors.append(f"{rel}: {key} entry {i} needs an id")
                    continue
                ident = item["id"]
                if ident in seen:
                    errors.append(f"{rel}: {key} lists {ident} twice")
                    continue
                seen.add(ident)
                for field in ("label", "why"):
                    if not str(item.get(field, "")).strip():
                        errors.append(f"{rel}: {key} {ident} has no {field}")
                if not index.exists(key, ident):
                    errors.append(f"{rel}: {key} id not found in {KINDS[key]['base']}: {ident}")
                entry = {"id": ident, "label": str(item.get("label", "")).strip(), "why": str(item.get("why", "")).strip()}
                u = url_for(key, ident)
                if u:
                    entry["url"] = u
                entries.append(entry)
            groups[key] = entries

        models[slug] = {
            "status": data.get("status", "draft"),
            "reviewed": bool(data.get("reviewed", False)),
            "note": str(data.get("note", "")).strip(),
            "connections": groups,
        }

    if errors:
        print("Connections check failed:")
        for e in errors:
            print("  -", e)
        return 1

    payload = {
        "schemaVersion": SCHEMA_VERSION,
        "comment": "Generated by scripts/check_connections.py from models/*/connections.yaml. Do not edit by hand.",
        "models": models,
    }
    text = json.dumps(payload, indent=2, ensure_ascii=False) + "\n"

    total = sum(len(v) for m in models.values() for v in m["connections"].values())
    summary = f"{len(models)} models, {total} connections, all ids found"

    if args.check:
        current = open(OUT, encoding="utf8", newline="").read().replace("\r\n", "\n") if os.path.isfile(OUT) else ""
        if current != text:
            print("assets/connections.json is out of date. Run: python scripts/check_connections.py")
            return 1
        print("OK: " + summary + ", assets/connections.json is current")
        return 0

    with open(OUT, "w", encoding="utf8", newline="\n") as f:
        f.write(text)
    print("OK: " + summary + ". Wrote assets/connections.json")
    return 0


if __name__ == "__main__":
    sys.exit(main())
