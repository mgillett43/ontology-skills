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
# archive is self-contained. LICENSE lives inside the skill directory (matching
# the convention used by Anthropic's own skills), so the terms travel with the
# skill however it is distributed -- plugin install, folder copy, or this ZIP.
cp -RL "$SRC" "$STAGE/$SKILL_NAME"

if [[ ! -f "$STAGE/$SKILL_NAME/LICENSE" ]]; then
  echo "error: LICENSE missing from $SRC" >&2
  exit 1
fi

# Stamp provenance into the archive. The version is read from plugin.json --
# the single source of truth -- rather than maintained separately here, so the
# two can't drift. Without this, a downloaded copy is unidentifiable.
MANIFEST="$REPO_ROOT/plugins/$SKILL_NAME/.claude-plugin/plugin.json"
VERSION="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$MANIFEST" | head -1)"
if [[ -z "$VERSION" ]]; then
  echo "error: could not read version from $MANIFEST" >&2
  exit 1
fi
COMMIT="$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown")"

cat > "$STAGE/$SKILL_NAME/VERSION" <<EOF
ontology-building $VERSION
https://github.com/mgillett43/ontology-skills
built from commit $COMMIT
EOF

# Drop macOS cruft before archiving.
find "$STAGE" -name '.DS_Store' -delete

( cd "$STAGE" && zip -rq "$DIST/$SKILL_NAME.zip" "$SKILL_NAME" -x '*.DS_Store' )

echo "Built $DIST/$SKILL_NAME.zip  (version $VERSION, commit $COMMIT)"
unzip -l "$DIST/$SKILL_NAME.zip" | tail -n 3
