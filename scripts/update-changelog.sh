#!/bin/bash
# Update CHANGELOG from completed sessions
# Scans for completed sessions and adds them to the [Unreleased] section of CHANGELOG.md

set -e

SESSIONS_DIR="docs/sessions"
CHANGELOG="docs/CHANGELOG.md"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Update CHANGELOG from Sessions ===${NC}\n"

# Check if CHANGELOG.md exists
if [ ! -f "$CHANGELOG" ]; then
    echo -e "${RED}Error: $CHANGELOG not found${NC}"
    exit 1
fi

# Ensure [Unreleased] section exists
if ! grep -F -q "## [Unreleased]" "$CHANGELOG"; then
    echo -e "${RED}Error: '## [Unreleased]' section not found in $CHANGELOG${NC}"
    echo "Please add it to the top of your changelog file."
    exit 1
fi

echo -e "${YELLOW}🔍 Scanning for completed sessions not yet in CHANGELOG...${NC}"

# 1. Find all completed sessions
completed_sessions=()
while IFS= read -r file; do
    if grep -q "Status\*\*: ✅ Completed" "$file"; then
        completed_sessions+=("$file")
    fi
done < <(find "$SESSIONS_DIR" -type f -name "*.md" ! -name "README.md" ! -name "template.md" | sort -r)

if [ ${#completed_sessions[@]} -eq 0 ]; then
    echo -e "${GREEN}No completed sessions found.${NC}"
    exit 0
fi

# 2. Check which ones are not yet in CHANGELOG
new_entries=()
for session in "${completed_sessions[@]}"; do
    session_relpath="${session#docs/}"
    # Check if the session path is already in the changelog
    if ! grep -q "($session_relpath)" "$CHANGELOG"; then
        # Extract info
        date=$(grep "^\*\*Date\*\*:" "$session" | sed 's/.*: //' | tr -d '[:space:]')
        title=$(grep "^# " "$session" | head -n 1 | sed 's/# //')
        issue=$(grep "^\*\*Issue\*\*:" "$session" | sed 's/.*#//' | tr -d '[:space:]')

        # Format entry
        entry="- **$date**: $title ([Session]($session_relpath))"
        if [ -n "$issue" ]; then
            entry+=" (Issue #${issue})"
        fi
        new_entries+=("$entry")
        echo "  ${GREEN}Found new entry:${NC} $title"
    fi
done

if [ ${#new_entries[@]} -eq 0 ]; then
    echo -e "\n${GREEN}✅ CHANGELOG is already up to date!${NC}"
    exit 0
fi

echo -e "\n${YELLOW}Adding ${#new_entries[@]} new entries to $CHANGELOG...${NC}"

# Create a temporary file with the new entries

# Create a temporary file with the new entries
new_content_file=$(mktemp)
echo "" >> "$new_content_file"
echo "### Sessions" >> "$new_content_file"
echo "" >> "$new_content_file"
printf "%s\n" "${new_entries[@]}" >> "$new_content_file"

# Use sed to insert the content of the temp file after the '[Unreleased]' line
sed -i'.bak' -e "/## \[Unreleased\]/r $new_content_file" "$CHANGELOG"

# Clean up temp files
rm "$new_content_file"
rm "$CHANGELOG.bak"


echo -e "\n${GREEN}✅ CHANGELOG updated successfully!${NC}"
echo ""
echo "Please review the changes:"
echo "  git diff $CHANGELOG"
