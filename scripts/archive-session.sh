#!/bin/bash
# Session Completion Tool
# Guides user to update INDEX files based on session tags and marks session as complete.

set -e

SESSIONS_DIR="docs/sessions"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Session Completion Tool ===${NC}\n"

# 1. Check if session file path is provided as argument
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide a session file path${NC}"
    echo "Usage: $0 <session-file-path>"
    echo "Example: $0 docs/sessions/2025-11/26-fix-product-api-locale.md"
    exit 1
fi

# Session file path provided as argument
session_file="$1"

# Validate file exists
if [ ! -f "$session_file" ]; then
    echo -e "${RED}Error: File not found: $session_file${NC}"
    exit 1
fi

# Validate it's a markdown file
if [[ ! "$session_file" =~ \.md$ ]]; then
    echo -e "${RED}Error: File must be a .md file${NC}"
    exit 1
fi

# Convert to absolute path for project type detection
session_file_abs=$(cd "$(dirname "$session_file")" && pwd)/$(basename "$session_file")

echo -e "${YELLOW}Processing session: $session_file${NC}\n"
session_filename=$(basename "$session_file")
session_relpath="${session_file#docs/}"
date=$(grep "^\*\*Date\*\*:" "$session_file" | sed 's/.*: //')
month_dir=$(dirname "${session_file#$SESSIONS_DIR/}")

echo -e "\n${BLUE}Completing: $session_relpath${NC}\n"

# 2. Read Tags
tags=$(grep "^\*\*Tags\*\*:" "$session_file" | sed 's/.*: //' | sed 's/<!--.*-->//g' | tr -d '[:space:]')

echo -e "${YELLOW}Found tags: ${NC}${tags:-None}"

# 3. Based on Tags, prompt to update INDEX files
echo -e "\n${BLUE}--- 📝 INDEX Update ---${NC}"
echo "Based on the session's tags, please add a summary to the following INDEX file(s)."
echo "The session file will be marked as '✅ Completed' but will NOT be moved."
echo -e "------------------------\n"

prompt_shown=false

if [[ $tags == *#decisions* ]]; then
    prompt_shown=true
    echo -e "${GREEN}1. Update docs/INDEX-decisions.md${NC}"
    echo "   Template:"
    echo "   ---"
    cat <<EOF
#### [$date] [Decision Title]
- **決策**: [What was decided]
- **原因**: [Why this was chosen]
- **替代方案**: [Other options considered]
- **完整內容**: [Session]($session_relpath)
EOF
    echo -e "   ---\n"
fi

if [[ $tags == *#architecture* ]]; then
    prompt_shown=true
    echo -e "${GREEN}2. Update docs/INDEX-architecture.md${NC}"
    echo "   Template:"
    echo "   ---"
    cat <<EOF
#### [$date] [Pattern/Change Title]
- **模式/變更**: [Brief description of the change or pattern]
- **適用場景**: [When to use this]
- **完整說明**: [Session]($session_relpath)
EOF
    echo -e "   ---\n"
fi

# Check for #product or #screen (including #screen=xxx format)
if [[ $tags =~ \#product ]] || [[ $tags =~ \#screen(=|,|$) ]]; then
    prompt_shown=true
    issue_num=$(grep "^\*\*Issue\*\*:" "$session_file" | sed 's/.*#//' | tr -d '[:space:]')
    issue_link_placeholder="[#$issue_num](https://github.com/.../issues/$issue_num)"
    if [ -z "$issue_num" ]; then
        issue_link_placeholder="[#XX](...)"
    fi

    # Extract API endpoints from session file
    # Look for patterns like: GET /api/v1/..., POST /api/v1/..., etc.
    api_endpoints=$(grep -o -E '(GET|POST|PUT|DELETE|PATCH) /api/[^ ]*' "$session_file" | sort -u)

    # Format API endpoints for display
    api_display=""
    if [ -n "$api_endpoints" ]; then
        # Convert to comma-separated list with backticks
        api_display=$(echo "$api_endpoints" | awk '{printf "`%s`, ", $0}' | sed 's/, $//')
        api_display="<br>API: $api_display"
    fi

    # Detect project type based on session path
    if [[ $session_file_abs == *"a126_kompraa_flutter"* ]]; then
        # Flutter project - detailed table format
        echo -e "${GREEN}3. Update a126_kompraa_flutter/docs/INDEX-product.md${NC}"
        echo "   Template (add to appropriate Screen section):"
        echo "   ---"
        if [ -n "$api_endpoints" ]; then
            echo "   Detected APIs in session:"
            echo "$api_endpoints" | while read -r api; do
                echo "     - $api"
            done
            echo ""
        fi
        cat <<EOF
| 功能名稱 | 說明 | Session |
| --- | --- | --- |
| [Feature Name] | [功能描述]$api_display | [$session_filename]($session_relpath) |
EOF
        echo -e "   ---\n"
    else
        # Web project - simple checkbox format
        echo -e "${GREEN}3. Update docs_web/INDEX-product.md${NC}"
        echo "   Template (add to 功能狀態總覽 section):"
        echo "   ---"
        if [ -n "$api_endpoints" ]; then
            echo "   Detected APIs in session:"
            echo "$api_endpoints" | while read -r api; do
                echo "     - $api"
            done
            echo ""
        fi
        cat <<EOF
- [x] **[Feature Name]**: [Brief description] (v1.x)
EOF
        echo -e "   ---\n"
    fi
fi

# 4. If no tags, analyze content and suggest
if [ "$prompt_shown" = false ]; then
    echo -e "${YELLOW}⚠️ No tags found in session file.${NC}"
    echo "Analyzing content to suggest tags..."
    suggestions=""

    if grep -q -i -E "Approach Analysis|Option A|Option B|決策" "$session_file"; then
        suggestions+="#decisions "
    fi
    if grep -q -i -E "Design Pattern|Architecture|設計模式|架構" "$session_file"; then
        suggestions+="#architecture "
    fi
    if grep -q -i -E "POST /api|GET /api|API endpoint" "$session_file"; then
        suggestions+="#api "
    fi
    if grep -q -i -E "screen|page|頁面|畫面|UI|component|widget|螢幕|Screen|Page|Component|Widget" "$session_file"; then
        suggestions+="#screen "
    fi
    if grep -q -i "Issue.*#[0-9]\+\|feature\|功能" "$session_file" && ! grep -q -i "#refactor\|#infrastructure" "$session_file"; then
        suggestions+="#product "
    fi

    if [ -n "$suggestions" ]; then
        echo -e "${GREEN}💡 Suggested tags based on content:${NC} $suggestions"
        read -p "Would you like to add these tags to the session file now? (y/n): " add_tags
        if [ "$add_tags" = "y" ]; then
            # Add tags to the file
            sed -i'.bak' "s|^\(\*\*Tags\*\*:\).*|\1 ${suggestions}|" "$session_file"
            rm "${session_file}.bak"
            echo "Tags added. Please re-run the script to get INDEX templates."
            exit 0
        fi
    else
        echo "Could not automatically suggest any tags."
    fi
fi

# 5. Update session status
echo -e "\n${YELLOW}Updating session status to '✅ Completed'...${NC}"
# Use a temp file for sed to work reliably on macOS
sed -i'.bak' "s/\*\*Status\*\*: 🔄 In Progress/\*\*Status\*\*: ✅ Completed/" "$session_file"
rm "${session_file}.bak"

# 6. Remind to update completion date
current_date=$(date +%Y-%m-%d)
echo -e "\n${YELLOW}Reminder:${NC} Don't forget to manually update the following in the session file:"
echo "  - **Completed Date**: $current_date"
echo "  - **Session Duration**: [Actual] hours"

# 7. Final message
echo -e "\n${GREEN}✅ Session status updated successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Manually update the INDEX files as prompted above."
echo "2. Update the 'Completed Date' and 'Duration' in the session file."
echo "3. Commit your changes."

# 8. Automatically run update-changelog.sh
echo -e "\n${BLUE}=== Auto-updating CHANGELOG ===${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/update-changelog.sh" ]; then
    "$SCRIPT_DIR/update-changelog.sh"
else
    echo -e "${YELLOW}⚠️  update-changelog.sh not found in $SCRIPT_DIR${NC}"
    echo "Please run it manually: ./scripts/update-changelog.sh"
fi