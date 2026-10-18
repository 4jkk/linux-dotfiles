#!/bin/bash

# Git Configuration Setup Script
# Configures Git identity, secure credential storage, and signing.

set -euo pipefail

echo "======================================"
echo "Git Configuration Setup"
echo "======================================"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git is not installed. Installing...${NC}"
    sudo pacman -S --needed --noconfirm git
fi

# Select the most secure credential helper available.
# Plaintext "store" is intentionally never used.
select_credential_helper() {
    if git credential-libsecret --help &> /dev/null 2>&1; then
        echo "libsecret"
    elif command -v secret-tool &> /dev/null && command -v gnome-keyring-daemon &> /dev/null; then
        echo "libsecret"
    else
        # In-memory cache: credentials are never written to disk.
        echo "cache --timeout=3600"
    fi
}

# --- Identity (no defaults are baked in) ------------------------------
echo -e "${BLUE}Enter your Git identity${NC}"
while true; do
    read -r -p "Git username: " GIT_NAME
    [ -n "$GIT_NAME" ] && break
    echo -e "${RED}Username cannot be empty.${NC}"
done

while true; do
    read -r -p "Git email: " GIT_EMAIL
    if [[ ! "$GIT_EMAIL" =~ ^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$ ]]; then
        echo -e "${RED}Please enter a valid email address.${NC}"
    else
        break
    fi
done

echo ""
echo -e "${GREEN}Configuring Git with:${NC}"
echo "  Name:  $GIT_NAME"
echo "  Email: $GIT_EMAIL"
echo ""

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# --- Core preferences -------------------------------------------------
echo -e "${GREEN}Setting up recommended Git configurations...${NC}"

git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false
git config --global push.default simple
git config --global push.autoSetupRemote true

if command -v nvim &> /dev/null; then
    git config --global core.editor "nvim"
elif command -v vim &> /dev/null; then
    git config --global core.editor "vim"
fi

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global difftool.prompt false

# --- Integrity hardening ---------------------------------------------
# Verify object hashes are well-formed on transfer.
git config --global transfer.fsckObjects true

# --- Credential storage (never plaintext) -----------------------------
CRED_HELPER=$(select_credential_helper)
git config --global credential.helper "$CRED_HELPER"
echo -e "${GREEN}✓ Credential helper: ${CRED_HELPER}${NC}"

# --- Commit signing (SSH) --------------------------------------------
echo ""
read -r -p "Enable SSH commit signing? (recommended) (y/n): " -n 1 -r
echo ""
if [[ ${REPLY:-} =~ ^[Yy]$ ]]; then
    SSH_KEY="${HOME}/.ssh/id_ed25519"
    if [ -f "${SSH_KEY}.pub" ]; then
        git config --global gpg.format ssh
        git config --global user.signingkey "${SSH_KEY}.pub"
        git config --global commit.gpgsign true
        git config --global tag.gpgsign true
        echo -e "${GREEN}✓ Commit signing enabled with ${SSH_KEY}.pub${NC}"
        echo -e "${YELLOW}Add it as a signing key on GitHub: https://github.com/settings/ssh/new (type: Signing Key)${NC}"
    else
        echo -e "${YELLOW}No SSH key at ${SSH_KEY}. Run ./setup-github.sh first, then re-run this step.${NC}"
    fi
fi

# --- Aliases ----------------------------------------------------------
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --graph --oneline --decorate --all'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    git config --global core.autocrlf input
fi

echo ""
echo -e "${GREEN}✓ Git configuration complete!${NC}"
echo ""

echo -e "${BLUE}Your Git Configuration:${NC}"
echo ""
git config --global --list
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
