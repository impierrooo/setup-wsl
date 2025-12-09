# 🐧 WSL Ultimate Setup Script

Ce script Bash (`setup_wsl.sh`) permet d'automatiser l'installation et la configuration complète d'un environnement de développement sous WSL (Ubuntu/Debian).
Il est conçu pour être **idempotent** : vous pouvez l'exécuter plusieurs fois sans risque de créer des doublons ou de casser votre configuration existante.

---

## ⚡ Fonctionnalités

Le script transforme une installation WSL vierge en une station de travail prête à l'emploi avec :

### 🛠️ Outils & Langages
* **Système :** `git`, `curl`, `wget`, `tree`, `nano`, `sshpass`, `zip/unzip`.
* **C / C++ :** `gcc`, `g++`, `make`, `valgrind`, `gdb` (Optimisé pour Epitech).
* **Web :** Node.js (npm), PHP (8.x), Composer.
* **Python :** `python3`, `pip`, `venv`.
* **Bases de données :** Clients PostgreSQL et MySQL.

### DevOps
* **🐳 Docker :** Engine + CLI + Compose Plugin (via le script officiel).
* **💤 Lazygit :** Installation de la dernière version binaire.

### 🎨 Shell & Terminal (Zsh)
* Installation de **Zsh** et **Oh My Zsh**.
* Configuration automatique du thème `robbyrussell`.
* **Plugins essentiels pré-configurés :**
  * `zsh-syntax-highlighting` (Coloration des commandes valides/invalides).
  * `zsh-autosuggestions` (Complétion automatique basée sur l'historique).
  * `zsh-completions` (Tabulation avancée).
  * `docker` (Autocomplétion des commandes Docker).

---

## 🚀 Installation

**1. Télécharger le script (ou créer le fichier) :**

```bash
nano setup_wsl.sh
# Collez le contenu du script et sauvegardez (Ctrl+O, Entrée, Ctrl+X)
```

**2. Rendre le script exécutable :**

```bash
chmod +x setup_wsl.sh
```

**3. Lancer l'installation :**

```bash
./setup_wsl.sh
```

> **Note :** Le script demandera votre mot de passe `sudo` au démarrage pour installer les paquets.

---

## ⚠️ Configuration Post-Installation

### 1. Alias cs (Coding Style)
Le script crée un alias vers un script de coding style situé sur la partition Windows. **Vous devez modifier ce chemin si votre nom d'utilisateur Windows n'est pas `Impierrooo`.**

Éditez le fichier `.zshrc` :

```bash
nano ~/.zshrc
```

Trouvez la ligne :

```bash
alias cs="/mnt/c/Users/Impierrooo/Documents/WORK/..."
```

Remplacez `Impierrooo` par votre véritable nom d'utilisateur Windows.

### 2. Docker
Si vous utilisez Docker, assurez-vous que **Docker Desktop** est lancé sur Windows pour que le démon soit accessible via WSL.

---

## ⌨️ Liste des Alias

Voici les raccourcis ajoutés automatiquement à votre `.zshrc` :

| Catégorie | Alias | Commande | Description |
| :--- | :--- | :--- | :--- |
| **Général** | `c` | `clear` | Nettoie le terminal |
| | `t` | `tree` | Affiche l'arborescence des fichiers |
| | `maj` | `sudo apt update && upgrade` | Met à jour le système |
| **Git** | `gs` | `git status` | Voir l'état des fichiers |
| | `ga` | `git add` | Ajouter des fichiers à l'index |
| | `gc` | `git commit -m` | Créer un commit |
| | `gp` | `git push` | Envoyer vers le dépôt distant |
| | `gpu` | `git pull` | Récupérer les modifications |
| | `lz` | `lazygit` | Interface graphique Git terminal |
| **Dev** | `cs` | *Script Epitech* | Vérification du Coding Style |
| | `host` | `php -S localhost:8000` | Serveur PHP local rapide |

---

## 🔧 Dépannage

**Les plugins ne s'affichent pas ?**
Assurez-vous d'avoir fermé et rouvert votre terminal après l'installation.

**Caractères bizarres ?**
Installez une **Nerd Font** (ex: *FiraCode NF* ou *MesloLGS NF*) sur votre Terminal Windows pour supporter les icônes.

---
*Généré pour synchroniser l'environnement de développement WSL.*
