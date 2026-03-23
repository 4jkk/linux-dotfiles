# Git & GitHub Configuration

Automated scripts to set up Git and GitHub authentication on a fresh system.

## What's Included

### 1. setup-git.sh
Configures your Git identity and preferences:
- Sets user name and email
- Configures default branch (main)
- Sets up useful aliases
- Configures editor, diff tools, and merge tools
- Sets up credential caching

### 2. setup-github.sh
Sets up GitHub authentication with three options:
- **SSH Keys** (Recommended)
- **GitHub CLI** (gh)
- **Personal Access Token**

## Quick Start

### Step 1: Configure Git

```bash
./setup-git.sh
```

This will:
- Install Git if not present
- Configure your identity (default: ajthkmr / ajiiitth@gmail.com)
- Set up useful Git aliases and configurations

### Step 2: Set Up GitHub Authentication

```bash
./setup-github.sh
```

Choose your preferred authentication method:
1. **SSH Key** - Most secure, works everywhere
2. **GitHub CLI** - Easy to use, feature-rich
3. **Personal Access Token** - Alternative method

## Default Configuration

### Git Identity

- **Name**: ajthkmr
- **Email**: ajiiitth@gmail.com

The script will ask if you want to use these defaults or enter custom values.

### Git Aliases

After running setup-git.sh, you'll have these aliases:

```bash
git st        # git status
git co        # git checkout
git br        # git branch
git ci        # git commit
git unstage   # git reset HEAD --
git last      # git log -1 HEAD
git visual    # git log --graph --oneline --decorate --all
git lg        # pretty colored log with graph
```

### Git Configuration

- **Default branch**: main
- **Editor**: nvim (or vim if available)
- **Credential helper**: cache (1 hour timeout)
- **Pull strategy**: merge (not rebase)
- **Diff tool**: vimdiff
- **Line endings**: input (Linux)

## Authentication Methods

### Option 1: SSH Keys (Recommended)

**Advantages**:
- Most secure
- No password prompts
- Works with all Git operations
- Standard authentication method

**Steps**:
1. Run `./setup-github.sh` and choose option 1
2. Script generates SSH key (ed25519)
3. Public key is displayed and copied to clipboard
4. Add key to GitHub: https://github.com/settings/keys
5. Test connection automatically

**What you need**:
- GitHub account
- Access to GitHub settings

### Option 2: GitHub CLI

**Advantages**:
- Easy authentication flow
- Additional GitHub features (create repos, PRs, etc.)
- Handles credentials automatically

**Steps**:
1. Run `./setup-github.sh` and choose option 2
2. Script installs GitHub CLI if needed
3. Follow interactive authentication
4. Choose HTTPS or SSH

**Useful gh commands**:
```bash
gh auth status              # Check authentication
gh repo list               # List your repositories
gh repo create             # Create new repository
gh pr create               # Create pull request
gh pr list                 # List pull requests
gh issue list              # List issues
```

### Option 3: Personal Access Token

**Advantages**:
- Works when SSH is blocked
- Fine-grained permissions

**Steps**:
1. Run `./setup-github.sh` and choose option 3
2. Follow instructions to create token at: https://github.com/settings/tokens
3. Select scopes: `repo`, `workflow`, `user`
4. Use token as password when Git prompts

**Token scopes**:
- `repo` - Full repository access
- `workflow` - GitHub Actions workflows
- `user` - User data access

## Usage Examples

### Clone a Repository (SSH)

```bash
git clone git@github.com:username/repository.git
```

### Clone a Repository (HTTPS)

```bash
git clone https://github.com/username/repository.git
```

### Create a New Repository

```bash
# Initialize local repo
git init
git add .
git commit -m "Initial commit"

# Create GitHub repo (with gh CLI)
gh repo create my-project --public --source=. --push

# Or create on GitHub web, then:
git remote add origin git@github.com:username/my-project.git
git branch -M main
git push -u origin main
```

### Configure Per-Repository Settings

```bash
# Use different email for specific project
cd /path/to/project
git config user.email "work@example.com"

# Use different name
git config user.name "Work Name"
```

## SSH Key Management

### List SSH Keys

```bash
ls -la ~/.ssh/
```

### Add SSH Key to Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Test GitHub Connection

```bash
ssh -T git@github.com
```

Expected output:
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

### Multiple SSH Keys

If you have multiple GitHub accounts:

1. Generate separate keys:
```bash
ssh-keygen -t ed25519 -C "personal@example.com" -f ~/.ssh/id_ed25519_personal
ssh-keygen -t ed25519 -C "work@example.com" -f ~/.ssh/id_ed25519_work
```

2. Create/edit ~/.ssh/config:
```
Host github.com-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal

Host github.com-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
```

3. Clone using custom host:
```bash
git clone git@github.com-personal:username/repo.git
git clone git@github.com-work:company/repo.git
```

## Troubleshooting

### Permission Denied (publickey)

```bash
# Check if key is added to agent
ssh-add -l

# Add key if missing
ssh-add ~/.ssh/id_ed25519

# Verify key is on GitHub
# Visit: https://github.com/settings/keys
```

### Wrong Credentials

```bash
# Clear cached credentials
git credential-cache exit

# Or remove stored credentials
rm ~/.git-credentials

# Next operation will prompt for credentials
```

### SSL Certificate Errors

```bash
# Update CA certificates
sudo pacman -S ca-certificates
sudo update-ca-certificates
```

### Cannot Push to Repository

```bash
# Check remote URL
git remote -v

# Change to SSH if using HTTPS
git remote set-url origin git@github.com:username/repo.git

# Or change to HTTPS if using SSH
git remote set-url origin https://github.com/username/repo.git
```

### Two-Factor Authentication Issues

If using personal access token with 2FA:
- You MUST use a token, regular password won't work
- Token must have appropriate scopes
- Store token securely (use credential helper)

## Advanced Configuration

### Conditional Configuration

Edit ~/.gitconfig to use different configs for different directories:

```ini
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work

[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
```

### GPG Signing

To sign commits with GPG:

```bash
# Generate GPG key
gpg --full-generate-key

# List keys
gpg --list-secret-keys --keyid-format=long

# Configure Git
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true

# Add to GitHub
gpg --armor --export YOUR_KEY_ID
# Add at: https://github.com/settings/keys
```

### Custom Diff and Merge Tools

```bash
# Use meld as diff tool
git config --global diff.tool meld
git config --global difftool.meld.cmd 'meld "$LOCAL" "$REMOTE"'

# Use meld as merge tool
git config --global merge.tool meld
git config --global mergetool.meld.cmd 'meld "$LOCAL" "$BASE" "$REMOTE" --output "$MERGED"'
```

## Security Best Practices

1. **Never share private keys** - ~/.ssh/id_* (without .pub)
2. **Use SSH keys over HTTPS** when possible
3. **Enable 2FA** on GitHub account
4. **Rotate tokens regularly** - Delete old unused tokens
5. **Use credential helper** - Don't store passwords in plain text
6. **Review SSH keys** - Remove unused keys from GitHub
7. **Sign commits** - Use GPG signing for verified commits

## Backup

### Backup Your Configuration

```bash
# Backup Git config
cp ~/.gitconfig ~/backup/.gitconfig

# Backup SSH keys
cp -r ~/.ssh ~/backup/.ssh
```

### Restore Configuration

```bash
# Restore Git config
cp ~/backup/.gitconfig ~/.gitconfig

# Restore SSH keys
cp -r ~/backup/.ssh ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

## References

- [Git Documentation](https://git-scm.com/doc)
- [GitHub SSH Documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Git Credential Storage](https://git-scm.com/docs/gitcredentials)
