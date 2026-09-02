#!/usr/bin/env bash
# Build the distributable ZIP for upload to claude.ai / Claude Desktop
# (Customize -> Skills -> + -> Create skill).
#
# The archive contains a single top-level folder named for the skill, with
# SKILL.md at its root -- the layout the uploader expects.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="ontology-building"
SRC="$REPO_ROOT/plugins/$SKILL_NAME/skills/$SKILL_NAME"
DIST="$REPO_ROOT/dist"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

if [[ ! -f "$SRC/SKILL.md" ]]; then
  echo "error: SKILL.md not found at $SRC" >&2
  exit 1
fi

mkdir -p "$DIST"
rm -f "$DIST/$SKILL_NAME.zip"

# Copy the skill into a clean staging dir, dereferencing any symlinks so the
# archive is self-contained.
cp -RL "$SRC" "$STAGE/$SKILL_NAME"

# Ship the license inside the archive: CC BY 4.0 makes attribution a condition,
# so the terms must travel with the skill when it's uploaded standalone.
cp "$REPO_ROOT/LICENSE" "$STAGE/$SKILL_NAME/LICENSE"

# Drop macOS cruft before archiving.
find "$STAGE" -name '.DS_Store' -delete

( cd "$STAGE" && zip -rq "$DIST/$SKILL_NAME.zip" "$SKILL_NAME" -x '*.DS_Store' )

echo "Built $DIST/$SKILL_NAME.zip"
unzip -l "$DIST/$SKILL_NAME.zip" | tail -n 3
