#!/bin/bash

# GitHub Authentication Setup Script
# This script helps you set up SSH keys for GitHub authentication

set -e  # Exit on error

echo "======================================"
echo "GitHub Authentication Setup"
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
    echo -e "${RED}Git is not installed. Please run setup-git.sh first${NC}"
    exit 1
fi

# Get Git user info
GIT_EMAIL=$(git config --global user.email)
GIT_NAME=$(git config --global user.name)

if [ -z "$GIT_EMAIL" ]; then
    echo -e "${RED}Git email not configured. Please run setup-git.sh first${NC}"
    exit 1
fi

echo -e "${BLUE}GitHub Authentication Methods:${NC}"
echo "1. SSH Key (Recommended)"
echo "2. GitHub CLI (gh)"
echo "3. Personal Access Token (Manual setup)"
echo ""
read -p "Select authentication method (1-3): " -n 1 -r AUTH_METHOD
echo ""
echo ""

case $AUTH_METHOD in
    1)
        # SSH Key Setup
        echo -e "${GREEN}[SSH Key Setup]${NC}"
        echo ""

        SSH_DIR="$HOME/.ssh"
        SSH_KEY="$SSH_DIR/id_ed25519"

        # Check if SSH key already exists
        if [ -f "$SSH_KEY" ]; then
            echo -e "${YELLOW}SSH key already exists at $SSH_KEY${NC}"
            echo ""
            read -p "Do you want to use the existing key? (y/n): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${YELLOW}Enter a new filename (or press Enter for default):${NC}"
                read -p "Filename: " CUSTOM_NAME
                if [ ! -z "$CUSTOM_NAME" ]; then
                    SSH_KEY="$SSH_DIR/$CUSTOM_NAME"
                fi
            fi
        fi

        # Generate SSH key if it doesn't exist
        if [ ! -f "$SSH_KEY" ]; then
            echo -e "${GREEN}Generating new SSH key...${NC}"
            ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY"
            echo -e "${GREEN}✓ SSH key generated${NC}"
        fi

        # Start ssh-agent and add key
        echo -e "${GREEN}Adding SSH key to ssh-agent...${NC}"
        eval "$(ssh-agent -s)"
        ssh-add "$SSH_KEY"
        echo -e "${GREEN}✓ SSH key added to agent${NC}"
        echo ""

        # Display public key
        echo -e "${BLUE}Your SSH Public Key:${NC}"
        echo -e "${YELLOW}================================================${NC}"
        cat "${SSH_KEY}.pub"
        echo -e "${YELLOW}================================================${NC}"
        echo ""

        # Copy to clipboard if possible
        if command -v wl-copy &> /dev/null; then
            cat "${SSH_KEY}.pub" | wl-copy
            echo -e "${GREEN}✓ SSH key copied to clipboard!${NC}"
        elif command -v xclip &> /dev/null; then
            cat "${SSH_KEY}.pub" | xclip -selection clipboard
            echo -e "${GREEN}✓ SSH key copied to clipboard!${NC}"
        else
            echo -e "${YELLOW}Install wl-clipboard to auto-copy keys${NC}"
        fi

        echo ""
        echo -e "${YELLOW}To add this key to GitHub:${NC}"
        echo "1. Go to: https://github.com/settings/keys"
        echo "2. Click 'New SSH key'"
        echo "3. Give it a title (e.g., 'Arch Linux PC')"
        echo "4. Paste the key shown above"
        echo "5. Click 'Add SSH key'"
        echo ""
        read -p "Press Enter when you've added the key to GitHub..."
        echo ""

        # Test connection
        echo -e "${GREEN}Testing GitHub connection...${NC}"
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            echo -e "${GREEN}✓ GitHub authentication successful!${NC}"
        else
            echo -e "${YELLOW}Testing connection (you may see a warning, this is normal)${NC}"
            ssh -T git@github.com || true
        fi

        # Configure Git to use SSH
        echo ""
        echo -e "${YELLOW}Configuring Git to use SSH URLs by default...${NC}"
        git config --global url."git@github.com:".insteadOf "https://github.com/"
        echo -e "${GREEN}✓ Git configured to use SSH${NC}"
        ;;

    2)
        # GitHub CLI Setup
        echo -e "${GREEN}[GitHub CLI Setup]${NC}"
        echo ""

        # Install gh if not present
        if ! command -v gh &> /dev/null; then
            echo -e "${YELLOW}Installing GitHub CLI...${NC}"
            sudo pacman -S --needed --noconfirm github-cli
        fi

        echo -e "${GREEN}GitHub CLI installed. Starting authentication...${NC}"
        echo ""
        gh auth login

        echo ""
        echo -e "${GREEN}✓ GitHub CLI authentication complete!${NC}"

        # Test
        echo -e "${GREEN}Testing GitHub connection...${NC}"
        gh auth status
        ;;

    3)
        # Personal Access Token
        echo -e "${GREEN}[Personal Access Token Setup]${NC}"
        echo ""
        echo -e "${YELLOW}To create a Personal Access Token:${NC}"
        echo "1. Go to: https://github.com/settings/tokens"
        echo "2. Click 'Generate new token (classic)'"
        echo "3. Give it a name (e.g., 'Arch Linux PC')"
        echo "4. Select scopes: 'repo', 'workflow', 'user'"
        echo "5. Click 'Generate token'"
        echo "6. Copy the token (you won't see it again!)"
        echo ""
        echo -e "${BLUE}After generating:${NC}"
        echo "- Use the token as your password when prompted by Git"
        echo "- Or store it with: git config --global credential.helper store"
        echo "- Then do a git operation, and enter the token as password"
        echo ""

        read -p "Have you created your token? (y/n): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git config --global credential.helper store
            echo -e "${GREEN}✓ Credential helper configured${NC}"
            echo -e "${YELLOW}Next time you push/pull, enter your token as the password${NC}"
        fi
        ;;

    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}======================================"
echo "GitHub Setup Complete!"
echo "======================================${NC}"
echo ""
echo -e "${YELLOW}Test your setup with:${NC}"
echo "  git clone git@github.com:$GIT_NAME/<repository>.git"
echo ""
echo -e "${BLUE}Useful GitHub configurations:${NC}"
echo "  View your GitHub username: gh api user | grep login"
echo "  List your repositories: gh repo list"
echo "  Create a new repo: gh repo create"
echo ""
