#!/bin/bash

# Git Configuration Setup Script
# This script configures your Git identity and preferences

set -e  # Exit on error

echo "======================================"
echo "Git Configuration Setup"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git is not installed. Installing...${NC}"
    sudo pacman -S --needed --noconfirm git
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values (your configuration)
DEFAULT_NAME="ajthkmr"
DEFAULT_EMAIL="ajiiitth@gmail.com"

echo -e "${BLUE}Current Git Configuration:${NC}"
git config --global --list 2>/dev/null || echo "No global configuration found"
echo ""

# Ask if user wants to use default values or customize
echo -e "${YELLOW}Do you want to use the default configuration?${NC}"
echo "  Name:  $DEFAULT_NAME"
echo "  Email: $DEFAULT_EMAIL"
echo ""
read -p "Use defaults? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    GIT_NAME="$DEFAULT_NAME"
    GIT_EMAIL="$DEFAULT_EMAIL"
else
    read -p "Enter your Git username: " GIT_NAME
    read -p "Enter your Git email: " GIT_EMAIL
fi

echo ""
echo -e "${GREEN}Configuring Git with:${NC}"
echo "  Name:  $GIT_NAME"
echo "  Email: $GIT_EMAIL"
echo ""

# Configure Git
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# Set up recommended Git configurations
echo -e "${GREEN}Setting up recommended Git configurations...${NC}"

# Default branch name
git config --global init.defaultBranch main

# Colored output
git config --global color.ui auto

# Editor (use vim/neovim if available)
if command -v nvim &> /dev/null; then
    git config --global core.editor "nvim"
elif command -v vim &> /dev/null; then
    git config --global core.editor "vim"
fi

# Credential helper (store credentials for 1 hour)
git config --global credential.helper 'cache --timeout=3600'

# Pull strategy
git config --global pull.rebase false

# Push default
git config --global push.default simple

# Diff and merge tools
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global difftool.prompt false

# Aliases for common commands
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --graph --oneline --decorate --all'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Line ending configuration
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    git config --global core.autocrlf input
fi

echo -e "${GREEN}✓ Git configuration complete!${NC}"
echo ""

# Display final configuration
echo -e "${BLUE}Your Git Configuration:${NC}"
echo ""
git config --global --list
echo ""

echo -e "${GREEN}======================================"
echo "Git Setup Complete!"
echo "======================================${NC}"
echo ""
echo -e "${YELLOW}Useful Git aliases created:${NC}"
echo "  git st       - git status"
echo "  git co       - git checkout"
echo "  git br       - git branch"
echo "  git ci       - git commit"
echo "  git unstage  - unstage files"
echo "  git last     - show last commit"
echo "  git visual   - visual log"
echo "  git lg       - pretty log"
echo ""
echo -e "${YELLOW}Next step: Set up GitHub authentication${NC}"
echo "Run: ./setup-github.sh"
echo ""
