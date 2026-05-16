# 🐧 WSL Ultimate Setup Script

Ce script Bash (`setup_wsl.sh`) permet d'automatiser l'installation et la configuration complète d'un environnement de développement sous WSL (Ubuntu/Debian).

Il est conçu pour être **idempotent** : vous pouvez l'exécuter plusieurs fois sans risque de créer des doublons. Il est également capable de configurer entièrement un fichier `.zshrc` vide de A à Z.

---

## ⚡ Fonctionnalités

Le script transforme une installation WSL vierge en une station de travail prête à l'emploi avec :

### 🛠️ Outils & Langages
* **Système :** `git`, `curl`, `wget`, `tree`, `nano`, `fzf` (Fuzzy Finder), `sshpass`, `zip/unzip`.
* **C / C++ :** `gcc`, `g++`, `make`, `valgrind`, `gdb`.
* **Web :** Node.js (via **NVM**), PHP (8.x), Composer.
* **Python :** `python3`, `pip`, `venv`.
* **Bases de données :** Clients PostgreSQL et MySQL.

### DevOps
* **🐳 Docker :** Engine + CLI + Compose Plugin.
* **💤 Lazygit & Lazydocker :** Interfaces graphiques pour Git et Docker.
* **📦 NVM :** Gestionnaire de versions Node.js.

### 🎨 Shell & Terminal (Zsh)
* Installation de **Zsh** et **Oh My Zsh**.
* Configuration automatique du thème `robbyrussell`.
* **Plugins essentiels pré-configurés :**
  * `fzf` (Recherche floue ultra-rapide avec `CTRL+R`).
  * `sudo` (Ajoute `sudo` devant une commande en appuyant deux fois sur `Echap`).
  * `zsh-syntax-highlighting` (Coloration syntaxique).
  * `zsh-autosuggestions` (Suggestions basées sur l'historique).
  * `zsh-completions` (Tabulations avancées).
  * `git`, `docker`, `nvm` (Autocomplétions dédiées).

---

## 🚀 Installation

**1. Récupérer le script :**

```bash
git clone https://github.com/votre-repo/setup-wsl.git
cd setup-wsl
```

**2. Rendre le script exécutable :**

```bash
chmod +x setup_wsl.sh
```

**3. Lancer l'installation :**

```bash
./setup_wsl.sh
```

> **Note :** Le script demande votre mot de passe `sudo` au démarrage pour installer les paquets.

---

## ⌨️ Liste des Alias

Voici les raccourcis ajoutés automatiquement à votre `.zshrc` (gérés dans un bloc dédié pour éviter les doublons lors des mises à jour) :

| Catégorie | Alias | Commande | Description |
| :--- | :--- | :--- | :--- |
| **Navigation** | `..` | `cd ..` | Remonter d'un dossier |
| | `...` | `cd ../..` | Remonter de deux dossiers |
| | `ll` | `ls -lah` | Liste détaillée avec tailles et cachés |
| **Général** | `c` | `clear` | Nettoie le terminal |
| | `t` | `tree` | Affiche l'arborescence des fichiers |
| | `maj` | `sudo apt update && upgrade` | Met à jour tout le système |
| | `dbstart` | `sudo service ... start` | Démarre PostgreSQL et MySQL |
| **Git** | `gs` | `git status` | Voir l'état des fichiers |
| | `ga` | `git add` | Ajouter des fichiers à l'index |
| | `gc` | `git commit -m` | Créer un commit |
| | `gp` | `git push` | Envoyer vers le dépôt distant |
| | `gpu` | `git pull` | Récupérer les modifications |
| | `lg` | `lazygit` | Interface Git terminal |
| | `ld` | `lazydocker` | Interface Docker terminal |
| **Dev** | `host` | `php -S localhost:8000` | Serveur PHP local rapide |
