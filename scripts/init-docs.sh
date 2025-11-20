#!/bin/bash
# Initialize Documentation Structure
# Usage: ./init-docs.sh [target_directory]

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
AGENT_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$AGENT_ROOT/templates"

# Target directory (default to current directory)
TARGET_DIR="${1:-.}"

echo -e "${BLUE}=== Initialize Documentation Structure ===${NC}\n"
echo -e "Target Directory: ${YELLOW}$TARGET_DIR${NC}"

# Check if templates exist
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo -e "${RED}Error: Templates directory not found at $TEMPLATES_DIR${NC}"
    exit 1
fi

# Create docs directory
echo -e "\n${YELLOW}Creating directories...${NC}"
mkdir -p "$TARGET_DIR/docs/sessions"
echo -e "  ${GREEN}✓${NC} docs/sessions"

# Copy templates
echo -e "\n${YELLOW}Copying templates...${NC}"

# Function to copy template if destination doesn't exist
copy_template() {
    local src="$1"
    local dest="$2"
    local filename=$(basename "$src")
    
    if [ -f "$dest" ]; then
        echo -e "  ${YELLOW}!${NC} $filename already exists (skipped)"
    else
        cp "$src" "$dest"
        echo -e "  ${GREEN}✓${NC} $filename created"
    fi
}

copy_template "$TEMPLATES_DIR/session.md" "$TARGET_DIR/docs/sessions/template.md"
copy_template "$TEMPLATES_DIR/GUIDE.md" "$TARGET_DIR/docs/sessions/GUIDE.md"
copy_template "$TEMPLATES_DIR/INDEX-product.md" "$TARGET_DIR/docs/INDEX-product.md"
copy_template "$TEMPLATES_DIR/INDEX-architecture.md" "$TARGET_DIR/docs/INDEX-architecture.md"
copy_template "$TEMPLATES_DIR/INDEX-decisions.md" "$TARGET_DIR/docs/INDEX-decisions.md"

# Setup GEMINI.md
echo -e "\n${YELLOW}Setting up GEMINI.md...${NC}"
GEMINI_FILE="$TARGET_DIR/GEMINI.md"

if [ -f "$GEMINI_FILE" ]; then
    echo -e "  ${YELLOW}!${NC} GEMINI.md already exists"
    read -p "  Do you want to append the AI instructions to it? (y/n): " append_gemini
    if [ "$append_gemini" = "y" ]; then
        echo -e "\n" >> "$GEMINI_FILE"
        cat "$TEMPLATES_DIR/GEMINI.md" >> "$GEMINI_FILE"
        echo -e "  ${GREEN}✓${NC} Appended instructions to GEMINI.md"
    fi
else
    cp "$TEMPLATES_DIR/GEMINI.md" "$GEMINI_FILE"
    echo -e "  ${GREEN}✓${NC} GEMINI.md created"
fi

echo -e "\n${GREEN}✅ Documentation initialization complete!${NC}"
echo -e "\nNext steps:"
echo "1. Edit GEMINI.md to update project description"
echo "2. Run '/session-create' to start your first session"
