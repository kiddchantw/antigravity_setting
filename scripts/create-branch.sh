#!/bin/bash
# Create Branch from Session
# Reads session file and creates branch if specified

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SESSIONS_DIR="docs/sessions"

echo -e "${BLUE}=== Create Branch from Session ===${NC}\n"

# Check if session file path provided
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Usage: $0 <session-file-path>${NC}"
    echo "Example: $0 docs/sessions/2025-11/26-feature-name.md"
    exit 1
fi

session_file="$1"

# Check if session file exists
if [ ! -f "$session_file" ]; then
    echo -e "${RED}Error: Session file not found: $session_file${NC}"
    exit 1
fi

# Extract branch name from session file
branch_line=$(grep "^\*\*Branch\*\*:" "$session_file" || true)

if [ -z "$branch_line" ]; then
    echo -e "${RED}Error: No Branch field found in session file${NC}"
    exit 1
fi

# Extract branch name (remove **Branch**: and brackets)
branch_name=$(echo "$branch_line" | sed 's/\*\*Branch\*\*: //g' | sed 's/\[//g' | sed 's/\]//g' | xargs)

# Check if branch name is placeholder or empty
if [ -z "$branch_name" ] || [ "$branch_name" = "new-branch-name" ]; then
    echo -e "${YELLOW}No branch name specified in session file.${NC}"
    echo -e "${YELLOW}Branch field: $branch_name${NC}"
    echo ""
    echo "To create a branch, please:"
    echo "1. Edit the session file: $session_file"
    echo "2. Update the Branch field: **Branch**: [your-branch-name]"
    echo "3. Run this script again"
    exit 0
fi

echo -e "${BLUE}Branch name found: ${GREEN}$branch_name${NC}\n"

# Determine base branch (develop or main)
echo -e "${YELLOW}Select base branch:${NC}"
echo "1) develop (default)"
echo "2) main"
read -p "Choice [1]: " base_choice

case $base_choice in
    2)
        base_branch="main"
        ;;
    *)
        base_branch="develop"
        ;;
esac

echo -e "\n${BLUE}Will create branch from: ${GREEN}$base_branch${NC}"
echo -e "${BLUE}New branch name: ${GREEN}$branch_name${NC}\n"

# Confirm
read -p "Proceed? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  Warning: You have uncommitted changes.${NC}"
    echo ""
    git status --short
    echo ""
    read -p "Do you want to stash them? (y/n): " stash_choice

    if [ "$stash_choice" = "y" ]; then
        echo -e "\n${BLUE}Stashing changes...${NC}"
        git stash push -m "Auto-stash before creating branch $branch_name"
        echo -e "${GREEN}✅ Changes stashed${NC}\n"
        stashed=true
    else
        echo -e "${RED}Please commit or stash your changes first.${NC}"
        exit 1
    fi
fi

# Switch to base branch
echo -e "${BLUE}Checking out $base_branch...${NC}"
if ! git checkout "$base_branch"; then
    echo -e "${RED}Error: Failed to checkout $base_branch${NC}"
    exit 1
fi

# Pull latest changes
echo -e "\n${BLUE}Pulling latest changes from origin/$base_branch...${NC}"
if ! git pull origin "$base_branch"; then
    echo -e "${RED}Error: Failed to pull from origin/$base_branch${NC}"
    echo -e "${YELLOW}You may need to resolve conflicts or check your remote configuration.${NC}"
    exit 1
fi

# Create and checkout new branch
echo -e "\n${BLUE}Creating new branch: $branch_name${NC}"
if ! git checkout -b "$branch_name"; then
    echo -e "${RED}Error: Failed to create branch $branch_name${NC}"
    echo -e "${YELLOW}Branch may already exist. Use 'git branch -d $branch_name' to delete it first.${NC}"
    exit 1
fi

echo -e "\n${GREEN}✅ Successfully created and switched to branch: $branch_name${NC}"

# Restore stashed changes if any
if [ "$stashed" = true ]; then
    echo -e "\n${BLUE}Restoring stashed changes...${NC}"
    if git stash pop; then
        echo -e "${GREEN}✅ Changes restored${NC}"
    else
        echo -e "${YELLOW}⚠️  Stash pop had conflicts. Please resolve them manually.${NC}"
        echo -e "${YELLOW}Your stash is still available: git stash list${NC}"
    fi
fi

echo -e "\n${BLUE}Current branch:${NC}"
git branch --show-current

echo -e "\n${GREEN}🎉 Ready to start development!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Start implementing your feature"
echo "2. Make commits following the git-commit-tw.md conventions"
echo "3. When done, run: .agent/scripts/archive-session.sh"
