#!/bin/bash

# --- FONCTIONS UTILITAIRES ---
append_if_missing() {
    local line="$1"
    local file="$2"
    if grep -Fxq "$line" "$file"; then
        echo "⚠️  Déjà présent : $line"
    else
        echo "$line" >> "$file"
        echo "✅ Ajouté : $line"
    fi
}

install_plugin() {
    local name=$1
    local repo=$2
    if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
        git clone "$repo" "$ZSH_CUSTOM/plugins/$name"
        echo "✅ Plugin $name installé."
    else
        echo "⚠️  Plugin $name déjà présent."
    fi
}

echo "🚀 Démarrage du setup (Version Ultimate)..."

# --- 1. MISE À JOUR & INSTALLATION DES PAQUETS ---
echo "📦 Mise à jour des dépôts..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installation de la liste complète des paquets..."

# Liste organisée pour la lisibilité
PACKAGES_SYSTEM=(
    curl wget git gitk grep tree nano zsh
    sshpass telnet ftp zip unzip
)

PACKAGES_DEV_C=(
    gcc g++ gdb cpp make valgrind emacs
)

PACKAGES_PYTHON=(
    python3 python3-pip python3-venv python3-pil
)

PACKAGES_WEB=(
    php php-cli php-pgsql php-xml composer
)

PACKAGES_DB=(
    postgresql postgresql-client postgresql-contrib
    mysql-server
)

# Installation en une seule commande (plus rapide)
sudo apt install -y "${PACKAGES_SYSTEM[@]}" "${PACKAGES_DEV_C[@]}" "${PACKAGES_PYTHON[@]}" "${PACKAGES_WEB[@]}" "${PACKAGES_DB[@]}"

echo "✅ Tous les paquets apt sont installés."

# --- 2. INSTALLATION LAZYGIT ---
if [ ! -f "/usr/local/bin/lazygit" ]; then
    echo "💤 Installation de Lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
    echo "✅ Lazygit installé."
else
    echo "⚠️  Lazygit est déjà installé."
fi

# --- 3. INSTALLATION LAZYDOCKER ---
if [ ! -f "/usr/local/bin/lazydocker" ]; then
    echo "🐳 Installation de Lazydocker..."
    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazydocker.tar.gz lazydocker
    sudo install lazydocker /usr/local/bin
    rm lazydocker lazydocker.tar.gz
    echo "✅ Lazydocker installé."
else
    echo "⚠️  Lazydocker est déjà installé."
fi

# --- 4. INSTALLATION DOCKER (CE, CLI, COMPOSER-PLUGIN) ---
# Le script officiel installe : docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin
if ! command -v docker &> /dev/null; then
    echo "🐳 Installation de Docker (CE, CLI, Compose)..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker installé."
else
    echo "⚠️  Docker est déjà installé."
fi

# --- 5. NVM (Node Version Manager) ---
if [ ! -d "$HOME/.nvm" ]; then
    echo "📦 Installation de NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    # Chargement temporaire pour installer Node
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    echo "✅ NVM et Node (LTS) installés."
else
    echo "⚠️  NVM est déjà installé."
fi

# --- 6. OH MY ZSH ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🎨 Installation de Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installé."
else
    echo "⚠️  Oh My Zsh est déjà installé."
fi

# --- 7. PLUGINS ZSH ---
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

echo "🔌 Vérification des plugins Zsh..."
install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
install_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions"
install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"

# --- 8. CONFIGURATION DU .ZSHRC ---
ZSHRC="$HOME/.zshrc"
echo "⚙️  Mise à jour de la configuration .zshrc..."

# Configuration des plugins (Force l'ajout de docker et nvm)
if grep -q "plugins=(.*docker.*)" "$ZSHRC" && grep -q "plugins=(.*nvm.*)" "$ZSHRC"; then
    echo "⚠️  Les plugins (incluant docker et nvm) sont déjà configurés."
else
    echo "🔧 Ajout des plugins (git, docker, nvm, highlighting, completions, autosuggestions)..."
    # Cette regex remplace toute ligne plugins=(...) par la bonne configuration
    sed -i 's/^plugins=(.*)/plugins=(git docker nvm zsh-syntax-highlighting zsh-completions zsh-autosuggestions)/' "$ZSHRC"
    echo "✅ Plugins mis à jour."
fi

# Variables d'environnement
append_if_missing 'export DISPLAY=:0' "$ZSHRC"
append_if_missing 'export PIP_BREAK_SYSTEM_PACKAGES=1' "$ZSHRC"

# --- 9. AJOUT DES ALIAS (EN BLOC IDEMPOTENT) ---
HEADER="# --- MES ALIAS PERSO ---"

if grep -Fq "$HEADER" "$ZSHRC"; then
    echo "⚠️  Le bloc d'alias personnels existe déjà."
else
    echo "✍️  Ajout de tes alias..."
    cat <<EOT >> "$ZSHRC"

$HEADER
alias c='clear'
alias t='tree'
alias dbstart="sudo service postgresql start && sudo service mysql start"

# GIT
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpu="git pull"
alias gs="git status"
alias lg="lazygit"
alias ld="lazydocker"

# SYSTÈME
alias maj="sudo apt update && sudo apt upgrade -y"

# WEB
alias host="php -S localhost:8000"
EOT
    echo "✅ Alias ajoutés avec succès."
fi

# --- 10. FINALISATION ---
echo "🔄 Changement du shell par défaut vers Zsh..."
# Redirige les erreurs au cas où le shell est déjà zsh
sudo chsh -s $(which zsh) $USER > /dev/null 2>&1

echo "🎉 Setup terminé ! Tu es prêt à coder."
echo "👉 Ferme ce terminal et rouvre-le pour que Docker et Zsh soient actifs."