#!/usr/bin/env python3
"""Make web-sized WebP copies of site images. Originals are never touched.

Usage (from the repo root, system python3 with Pillow):
    python3 scripts/optimize_images.py images/people --max-width 480 --target-kb 80
    python3 scripts/optimize_images.py images/lab_pictures --max-width 1600 --target-kb 120

For every JPG/PNG found under <dir> (recursively, skipping any existing "web/"
folder) one file is written to <dir>/web/<relative path without extension>.webp,
e.g. images/people/omama.png -> images/people/web/omama.webp and
images/lab_pictures/rss2022/IMG_0828.jpeg -> images/lab_pictures/web/rss2022/IMG_0828.webp.

Behaviour:
  * Images wider than --max-width are scaled down (never up); EXIF rotation is applied.
  * Quality starts at --quality (default 80). If --target-kb is given and the file is
    larger, quality is lowered step by step (to 55), then the width is reduced.
  * Idempotent: a WebP newer than its source is skipped unless --force is passed.
  * Prints a before/after size table.
"""
import argparse
import sys
from pathlib import Path

from PIL import Image, ImageOps

EXTS = {".jpg", ".jpeg", ".png"}


def encode(img, out, quality, width, max_bytes):
    """Save img as WebP, shrinking quality then width until it fits max_bytes (if set)."""
    while True:
        im = img
        if im.width > width:
            im = im.resize((width, round(im.height * width / im.width)), Image.LANCZOS)
        q = quality
        while True:
            im.save(out, "WEBP", quality=q, method=6)
            if not max_bytes or out.stat().st_size <= max_bytes or q <= 55:
                break
            q -= 5
        if not max_bytes or out.stat().st_size <= max_bytes or width <= 240:
            return
        width = int(width * 0.9)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("dir", help="image directory, e.g. images/people")
    ap.add_argument("--max-width", type=int, default=1600)
    ap.add_argument("--quality", type=int, default=80)
    ap.add_argument("--target-kb", type=int, default=0, help="size budget per file (0 = none)")
    ap.add_argument("--force", action="store_true", help="re-encode even if up to date")
    a = ap.parse_args()

    root = Path(a.dir)
    webdir = root / "web"
    if not root.is_dir():
        sys.exit(f"not a directory: {root}")
    rows, tot_in, tot_out = [], 0, 0
    for src in sorted(p for p in root.rglob("*") if p.suffix.lower() in EXTS and webdir not in p.parents):
        out = (webdir / src.relative_to(root)).with_suffix(".webp")
        out.parent.mkdir(parents=True, exist_ok=True)
        status = "kept"
        if a.force or not out.exists() or out.stat().st_mtime < src.stat().st_mtime:
            with Image.open(src) as im:
                im = ImageOps.exif_transpose(im)
                im = im.convert("RGBA" if "A" in im.getbands() else "RGB")
                encode(im, out, a.quality, a.max_width, a.target_kb * 1000)
            status = "wrote"
        i, o = src.stat().st_size, out.stat().st_size
        with Image.open(out) as w:
            dims = f"{w.width}x{w.height}"
        rows.append((str(src.relative_to(root)), i, o, dims, status))
        tot_in += i
        tot_out += o
    width = max([len(r[0]) for r in rows] + [4])
    print(f"{'file':<{width}}  {'before':>10}  {'after':>9}  {'dims':>10}  status")
    for n, i, o, d, s in rows:
        print(f"{n:<{width}}  {i/1000:>8.0f}KB  {o/1000:>7.1f}KB  {d:>10}  {s}")
    print(f"{'TOTAL':<{width}}  {tot_in/1000:>8.0f}KB  {tot_out/1000:>7.1f}KB")


if __name__ == "__main__":
    main()
