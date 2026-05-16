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
    curl wget git gitk grep tree nano zsh fzf
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

# Initialisation de base si le fichier est vide ou sans Oh My Zsh
if ! grep -q "source \$ZSH/oh-my-zsh.sh" "$ZSHRC"; then
    echo "📝 Ajout de la configuration de base Oh My Zsh..."
    # On insère au début du fichier
    sed -i '1i export ZSH="$HOME/.oh-my-zsh"\nZSH_THEME="robbyrussell"\nplugins=(git)\nsource $ZSH/oh-my-zsh.sh\n' "$ZSHRC"
fi

# Configuration du thème
THEME="robbyrussell" 
echo "🎨 Application du thème Zsh ($THEME)..."
sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$THEME\"/" "$ZSHRC"

# Configuration des plugins
echo "🔧 Mise à jour des plugins dans .zshrc..."
PLUGINS="git docker nvm fzf sudo zsh-syntax-highlighting zsh-completions zsh-autosuggestions"
sed -i "s/^plugins=(.*/plugins=($PLUGINS)/" "$ZSHRC"
echo "✅ Plugins mis à jour : $PLUGINS"

# Variables d'environnement
append_if_missing 'export DISPLAY=:0' "$ZSHRC"
append_if_missing 'export PIP_BREAK_SYSTEM_PACKAGES=1' "$ZSHRC"

# --- 9. AJOUT DES ALIAS (MAINTENANCE FACILE) ---
HEADER="# --- MES ALIAS PERSO ---"
FOOTER="# --- FIN DES ALIAS PERSO ---"

# On supprime l'ancien bloc s'il existe pour pouvoir le mettre à jour
if grep -q "$HEADER" "$ZSHRC"; then
    echo "🔧 Mise à jour du bloc d'alias..."
    sed -i "/$HEADER/,/$FOOTER/d" "$ZSHRC"
    # Au cas où il n'y avait pas de footer (ancienne version)
    sed -i "/$HEADER/d" "$ZSHRC"
fi

echo "✍️  Ajout des alias..."
cat <<EOT >> "$ZSHRC"

$HEADER
alias c='clear'
alias t='tree'
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -lah"
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
$FOOTER
EOT
echo "✅ Alias mis à jour avec succès."

# --- 10. INSTALLATION DES EXTENSIONS ANTIGRAVITY ---
echo "🔌 Installation des extensions Antigravity..."

# Liste des extensions actuellement utilisées
EXTENSIONS=(
    "jlcodes.antigravity-cockpit"
    "ms-python.python"
    "ms-python.debugpy"
    "ms-python.vscode-python-envs"
    "ms-python.black-formatter"
    "ms-azuretools.vscode-containers"
    "davidanson.vscode-markdownlint"
    "bmewburn.vscode-intelephense-client"
    "jebbs.plantuml"
    "esbenp.prettier-vscode"
    "foxundermoon.shell-format"
    "mtxr.sqltools"
    "redhat.vscode-xml"
    "michaelzhou.fleet-theme"
    "pkief.material-icon-theme"
)

# On vérifie si la commande antigravity est disponible ET si le tunnel de communication est actif
if command -v antigravity &> /dev/null && [ -S "$VSCODE_IPC_HOOK_CLI" ]; then
    # On récupère la liste des extensions déjà installées pour éviter les erreurs
    INSTALLED_EXTS=$(antigravity --list-extensions 2>/dev/null)
    
    for ext in "${EXTENSIONS[@]}"; do
        if echo "$INSTALLED_EXTS" | grep -iq "$ext"; then
            echo "⚠️  Extension $ext déjà présente."
        else
            echo "📦 Installation de $ext..."
            antigravity --install-extension "$ext" &> /dev/null
            if [ $? -eq 0 ]; then
                echo "✅ $ext installée."
            else
                echo "❌ Échec de l'installation de $ext (Vérifiez la connexion IDE)."
            fi
        fi
    done
else
    echo "⚠️  L'IDE n'est pas détecté ou la commande 'antigravity' est absente."
    echo "👉 Lancez ce script depuis le terminal intégré d'Antigravity pour installer les extensions."
fi

# --- 11. CONFIGURATION DES PARAMÈTRES ANTIGRAVITY ---
echo "⚙️  Application des paramètres settings.json..."

SETTINGS_SRC="$(dirname "$0")/settings.json"
SETTINGS_DEST="$HOME/.antigravity-server/data/Machine/settings.json"

if [ -f "$SETTINGS_SRC" ]; then
    mkdir -p "$(dirname "$SETTINGS_DEST")"
    cp "$SETTINGS_SRC" "$SETTINGS_DEST"
    echo "✅ Paramètres appliqués vers $SETTINGS_DEST"
else
    echo "⚠️  Fichier $SETTINGS_SRC non trouvé, saut de la configuration."
fi

# --- 12. FINALISATION ---
echo "🔄 Changement du shell par défaut vers Zsh..."
# Redirige les erreurs au cas où le shell est déjà zsh
sudo chsh -s $(which zsh) $USER > /dev/null 2>&1

echo "🎉 Setup terminé ! Tu es prêt à coder."
echo "👉 Ferme ce terminal et rouvre-le pour que Docker et Zsh soient actifs."