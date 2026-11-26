"""Summarize the two BehaviorSpace experiments of the Two Foresters learning variant.

    python analyze.py            # reads results/learning-rules.csv and results/proxy-validity.csv, prints tables

Experiment learning-rules: 30 runs per setting, 500 ticks, blocks of 25 ticks. For each forester the model compares,
block by block, the law's prediction S with the observed change in mean harvest percent. -9 marks an undefined value.
Experiment noise-sweep: the toward-payoff rule with both foresters starting at 50, 1000 ticks, blocks of 25, 50 or 100 ticks and exploration of 5, 10 or 20 points.
Experiment proxy-validity: forester 1 held at a fixed harvest percent from 5 to 100, forester 2 fixed at 50, 200 ticks.
Does the wood taken in the first block predict wealth after 200 ticks?
"""
from __future__ import annotations

import pathlib

import numpy as np
import pandas as pd

HERE = pathlib.Path(__file__).parent / "results"


def load(name: str) -> pd.DataFrame:
    return pd.read_csv(HERE / name, skiprows=6)


def tidy(df: pd.DataFrame) -> pd.DataFrame:
    return df.rename(columns={c: c.replace("[", "").replace("]", "") for c in df.columns})


def learning_rules() -> None:
    d = tidy(load("learning-rules.csv"))
    rows = []
    for (priv, rule, c2), g in d.groupby(["Private-forest?", "Learning-rule", "Percent-cut2"]):
        for f in (1, 2):
            corr = g[f"forester-corr one-of farmers{f}"]
            agree = g[f"forester-sign-agreement one-of farmers{f}"]
            ok = corr[corr > -9]
            ag = agree[agree > -9]
            rows.append({
                "forest": "private" if priv else "shared", "rule": rule, "start F2 %": c2, "forester": f,
                "runs": len(g), "r (median)": round(float(ok.median()), 2) if len(ok) else np.nan,
                "r (IQR)": f"{ok.quantile(.25):.2f} to {ok.quantile(.75):.2f}" if len(ok) else "",
                "sign agree (mean)": round(float(ag.mean()), 2) if len(ag) else np.nan,
                "final level % (mean)": round(float(g[f"cut-level of one-of farmers{f}"].mean()), 1),
                "wealth (mean)": round(float(g[f"sum wealth of farmers{f}"].mean()), 0),
            })
        rows[-1]["stock % (mean)"] = round(float(g["forest-stock"].mean()), 1)
    out = pd.DataFrame(rows)
    pd.set_option("display.width", 250, "display.max_columns", 30)
    print(out.to_string(index=False))
    out.to_csv(HERE / "learning-rules-summary.csv", index=False)


def proxy_validity() -> None:
    d = tidy(load("proxy-validity.csv"))
    rows = []
    for priv, g in d.groupby("Private-forest?"):
        m = g.groupby("Percent-cut1").agg(early=("first-block-p of one-of farmers1", "mean"), wealth=("sum wealth of farmers1", "mean"),
                                           other=("sum wealth of farmers2", "mean"), stock=("forest-stock", "mean")).reset_index()
        slope, icpt = np.polyfit(m["early"], m["wealth"], 1)
        r = float(np.corrcoef(m["early"], m["wealth"])[0, 1])
        best = m.loc[m["wealth"].idxmax()]
        peak = m.loc[m["early"].idxmax()]
        rows.append({"forest": "private" if priv else "shared", "slope of wealth on early wood": round(float(slope), 2), "r": round(r, 2),
                     "level with most early wood %": int(peak["Percent-cut1"]), "level with most wealth at 200 %": int(best["Percent-cut1"])})
        m.assign(forest="private" if priv else "shared").to_csv(HERE / f"proxy-validity-{'private' if priv else 'shared'}-by-level.csv", index=False)
    print(pd.DataFrame(rows).to_string(index=False))


def noise_sweep() -> None:
    d = tidy(load("noise-sweep.csv"))
    rows = []
    for (priv, bl, ex), g in d.groupby(["Private-forest?", "Block-length", "Exploration"]):
        r = pd.concat([g["forester-corr one-of farmers1"], g["forester-corr one-of farmers2"]])
        a = pd.concat([g["forester-sign-agreement one-of farmers1"], g["forester-sign-agreement one-of farmers2"]])
        rows.append({"forest": "private" if priv else "shared", "block ticks": bl, "exploration points": ex, "foresters": len(r),
                     "r (median)": round(float(r[r > -9].median()), 2), "sign agree (mean)": round(float(a[a > -9].mean()), 2)})
    out = pd.DataFrame(rows)
    print(out.to_string(index=False))
    out.to_csv(HERE / "noise-sweep-summary.csv", index=False)


if __name__ == "__main__":
    learning_rules()
    print()
    proxy_validity()
    print()
    noise_sweep()
