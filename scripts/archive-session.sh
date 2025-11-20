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

# 1. Find all in-progress session files
echo -e "${YELLOW}Searching for 'In Progress' sessions...${NC}"
sessions=()
while IFS= read -r file; do
    if grep -q "Status\*\*: 🔄 In Progress" "$file"; then
        sessions+=("$file")
    fi
done < <(find "$SESSIONS_DIR" -type f -name "*.md" ! -name "README.md" ! -name "template.md" | sort -r)


if [ ${#sessions[@]} -eq 0 ]; then
    echo -e "${GREEN}No 'In Progress' sessions found. All clean!${NC}"
    exit 0
fi

# Display sessions with numbers
echo -e "\n${YELLOW}Available sessions to complete:${NC}"
for i in "${!sessions[@]}"; do
    filepath="${sessions[$i]}"
    relpath="${filepath#$SESSIONS_DIR/}"
    echo "  [$i] $relpath"
done

echo ""
read -p "Select session number to complete (or 'q' to quit): " selection

if [ "$selection" = "q" ]; then
    echo "Cancelled."
    exit 0
fi

# Validate selection
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -ge "${#sessions[@]}" ]; then
    echo -e "${RED}Invalid selection${NC}"
    exit 1
fi

session_file="${sessions[$selection]}"
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

if [[ $tags == *#api* ]]; then
    prompt_shown=true
    echo -e "${GREEN}3. Update docs/INDEX-api.md${NC}"
    echo "   Template:"
    echo "   ---"
    cat <<EOF
### [$date] [API Change Title]
- **新增/修改**: [e.g., POST /api/sync/batch]
- **Breaking Change**: 是/否
- **完整說明**: [Session]($session_relpath)
EOF
    echo -e "   ---\n"
fi

if [[ $tags == *#product* ]]; then
    prompt_shown=true
    issue_num=$(grep "^\*\*Issue\*\*:" "$session_file" | sed 's/.*#//' | tr -d '[:space:]')
    issue_link_placeholder="[#$issue_num](https://github.com/.../issues/$issue_num)"
    if [ -z "$issue_num" ]; then
        issue_link_placeholder="[#XX](...)"
    fi

    echo -e "${GREEN}4. Update docs/INDEX-product.md${NC}"
    echo "   Template:"
    echo "   ---"
    cat <<EOF
#### [Feature Name]
- **狀態**: ✅ Production
- **版本**: v1.x.0
- **功能描述**: [Brief description of the feature]
- **相關**:
  - Session: [$session_filename]($session_relpath)
  - Issue: $issue_link_placeholder
EOF
    echo -e "   ---\n"
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

echo ""
read -p "Press Enter to continue and mark the session as 'Completed'..."

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
echo "3. When ready to release, run: ${GREEN}./scripts/update-changelog.sh${NC}"
echo "4. Commit your changes."