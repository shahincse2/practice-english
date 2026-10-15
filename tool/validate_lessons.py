#!/usr/bin/env python3
"""Validate guided-lesson content.

Usage: python tool/validate_lessons.py [lessons.json] [--legacy q.json]
                                       [--images-dir DIR]
Exit code 1 when errors are found (warnings never fail).
"""
import argparse, json, re, sys
from pathlib import Path

LEVELS = {
    "kids": ["nursery", "kg", "class1", "class2", "class3", "class4", "class5"],
    "school": ["class6", "class7", "class8", "class9", "class10"],
    "academic": ["hsc", "university"],
    "ielts": ["ielts"], "gre": ["gre"], "spokenEnglish": ["spokenEnglish"],
}
TYPES = {"word", "phrase", "sentence"}
LANG = re.compile(r"^[a-z]{2,3}(-[A-Za-z]{2,4})?$")
IMAGE = re.compile(r"^[a-z0-9_\-]+\.(webp|png|svg)$")


class Report:
    def __init__(self):
        self.errors, self.warnings = [], []

    def error(self, where, msg): self.errors.append(f"ERROR   {where}: {msg}")
    def warn(self, where, msg): self.warnings.append(f"warning {where}: {msg}")


def tokens(text):
    return re.findall(r"[a-z0-9']+", text.lower())


def contains_run(hay, needle):
    n = len(needle)
    return n > 0 and any(hay[i:i + n] == needle for i in range(len(hay) - n + 1))


def check_translations(step, where, rep):
    trans = step.get("translations")
    if not isinstance(trans, dict) or not trans:
        return rep.error(where, "translations must be an object with 'bn'")
    if not str(trans.get("bn", "")).strip():
        rep.error(where, "translations.bn is missing or empty")
    for code, text in trans.items():
        if not LANG.match(code):
            rep.error(where, f"bad language code '{code}'")
        elif not isinstance(text, str) or text != text.strip():
            rep.error(where, f"translation '{code}' has leading/trailing space")
        elif "/" in text:
            rep.warn(where, f"'{code}' uses '/' alternatives; keep one meaning")


def check_step(step, where, rep, images_dir):
    if not isinstance(step, dict):
        return rep.error(where, "step must be an object")
    kind, answer = step.get("type"), step.get("answer")
    if kind not in TYPES:
        rep.error(where, f"type must be one of {sorted(TYPES)}")
    if not isinstance(answer, str) or not answer.strip():
        return rep.error(where, "answer is missing or empty")
    if answer != answer.strip():
        rep.error(where, f"answer '{answer}' has leading/trailing space")
    if "  " in answer:
        rep.error(where, f"answer '{answer}' has a double space")
    if re.search(r"[.,!?;:]$", answer.strip()):
        rep.error(where, f"answer '{answer}' ends with punctuation")
    count = len(answer.split())
    if kind == "word" and count != 1:
        rep.error(where, f"'word' must be one word, got {count}")
    if kind in ("phrase", "sentence") and count < 2:
        rep.error(where, f"'{kind}' needs 2+ words, got {count}")
    check_translations(step, where, rep)
    image = step.get("image")
    if image is not None:
        if not isinstance(image, str) or not IMAGE.match(image):
            rep.error(where, f"image '{image}' must be like boy.webp (lowercase)")
        elif images_dir and not (images_dir / image).exists():
            rep.warn(where, f"image file not found: {images_dir / image}")


def check_lesson(lesson, where, rep, seen, legacy_ids, images_dir):
    lid, seg, lvl = (lesson.get(k) for k in ("lessonId", "segment", "level"))
    if seg not in LEVELS:
        rep.error(where, f"unknown segment '{seg}'")
    elif lvl not in LEVELS[seg]:
        rep.error(where, f"level '{lvl}' does not belong to segment '{seg}'")
    if lid in seen:
        rep.error(where, f"duplicate lessonId '{lid}'")
    seen.add(lid)
    if lid != None and not re.fullmatch(rf"{seg}_{lvl}_lesson_\d{{3}}", str(lid)):
        rep.error(where, f"lessonId must look like '{seg}_{lvl}_lesson_001'")
    steps = lesson.get("steps")
    if not isinstance(steps, list) or not 2 <= len(steps) <= 99:
        return rep.error(where, "steps must be a list of 2..99 items")
    answers, final = [], steps[-1].get("answer", "") if isinstance(steps[-1], dict) else ""
    for number, step in enumerate(steps, 1):
        at = f"{where} step {number}"
        check_step(step, at, rep, images_dir)
        if f"{lid}_s{number:02d}" in legacy_ids:
            rep.error(at, "generated id collides with an existing question id")
        ans = step.get("answer", "") if isinstance(step, dict) else ""
        if ans.strip().lower() in answers:
            rep.warn(at, f"duplicate answer '{ans.strip()}' in this lesson")
        answers.append(ans.strip().lower())
        if not contains_run(tokens(final), tokens(ans)):
            rep.warn(at, f"'{ans.strip()}' does not appear in the final sentence")
    if steps[-1].get("type") != "sentence":
        rep.warn(where, "last step should be the full 'sentence'")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("lessons", nargs="?", default="assets/data/practice_lessons.json")
    ap.add_argument("--legacy", default="assets/data/practice_questions.json")
    ap.add_argument("--images-dir")
    args = ap.parse_args()
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    rep, data = Report(), json.loads(Path(args.lessons).read_text(encoding="utf-8"))
    legacy = Path(args.legacy)
    legacy_ids = {q["id"] for q in json.loads(legacy.read_text(encoding="utf-8"))} if legacy.exists() else set()
    if data.get("version") != 1 or not isinstance(data.get("lessons"), list):
        rep.error("root", "need {'version': 1, 'lessons': [...]}")
    seen, images = set(), Path(args.images_dir) if args.images_dir else None
    for i, lesson in enumerate(data.get("lessons", [])):
        label = f"lessons[{i}] {lesson.get('lessonId', '?')}"
        check_lesson(lesson, label, rep, seen, legacy_ids, images)
    for line in rep.errors + rep.warnings:
        print(line)
    total = sum(len(l.get("steps", [])) for l in data.get("lessons", []))
    print(f"{len(data.get('lessons', []))} lesson(s), {total} step(s): "
          f"{len(rep.errors)} error(s), {len(rep.warnings)} warning(s)")
    sys.exit(1 if rep.errors else 0)


if __name__ == "__main__":
    main()
