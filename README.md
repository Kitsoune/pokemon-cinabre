# Pokémon Cinabre

**Pokémon Cinabre** est un fangame développé sous **PokémonSDK** et **Pokémon Studio**. L'histoire se déroule dans la région d'**Eisenn**, inspirée de la **Allemagne de la Renaissance (XVIe siècle)** et du **Saint-Empire Germanique**.

Ce dépôt contient l'intégralité du code source, des ressources et des données de configuration nécessaires au développement du projet.

## 🔗 Liens Utiles

- **Discord Officiel :** [Discord pas encore fait]()
- **Documentation PSDK :** [https://pokemonworkshop.com/](https://pokemonworkshop.com/)

---

## 🛠️ Installation pour les Développeurs

Si vous rejoignez l'équipe de développement, voici la marche à suivre pour configurer votre environnement de travail.

### Prérequis

- **Pokémon Studio** (Dernière version stable)
- **RPG Maker XP** (Légalement acquis pour la licence des RTP)
- **Tiled** (Pour la gestion du mapping)
- **Git** (Pour la gestion de version)

### Clonage du Projet

```bash
# Cloner le projet Pokémon Cinabre
git clone https://https://github.com/Kitsoune/pokemon-cinabre
cd Pokemon_Cinabre

# Cloner la version spécifique de PSDK utilisée par le projet
git clone https://gitlab.com/pokemonsdk/pokemonsdk.git

```

> [!IMPORTANT]
> Après le premier lancement via Pokémon Studio, ouvrez un terminal à la racine et lancez `psdk --util=restore` via le `cmd.bat` pour régénérer les fichiers `.rxdata` essentiels.

---

## 🏗️ Workflow de Contribution

Pour éviter de corrompre les fichiers de données d'RPG Maker XP, nous utilisons un système de versionnage par fichiers `.yml`.

### Avant de Push (Sauvegarder vos modifs)

1. Fermez RPG Maker XP.
2. Lancez `convert_rxdata_to_yml.bat`.
3. Faites votre `git commit`.

### Après un Pull (Récupérer les modifs des autres)

1. Lancez `convert_yml_to_rxdata.bat`.
2. Ouvrez RPG Maker XP ou Studio.

### Règles de nommage des branches

- `feature/` : Pour les nouveaux systèmes ou scripts.
- `map/` : Pour les modifications de mapping.
- `fix/` : Pour la correction de bugs.
- `story/` : Pour l'intégration d'événements et de scénario.

---

## 📋 Note sur les Ressources

- **Mapping :** Le projet utilise exclusivement **Tiled**. Toute modification faite directement dans l'éditeur de maps de RMXP sera écrasée lors de la prochaine conversion.
- **Textes :** Tous les dialogues sont gérés via les fichiers CSV dans `Data/Text/Dialogs`. Merci de respecter l'indexation pour éviter de briser les liens dans les événements.
- **Scripts :** Les scripts personnalisés doivent être ajoutés dans le dossier `scripts/` en suivant la nomenclature établie dans le projet pour éviter les conflits avec le cœur de PSDK.

---

## ❤️ Crédits

- **Équipe Pokémon Cinabre :** [@Kitsoune](https://github.com/Kitsoune)
- **Moteur :** [PokémonSDK](https://github.com/PokemonWorkshop) par l'équipe Pokémon Workshop.
- **Assets :** [WIP].
