# Bounce Dash

Bounce Dash est un jeu mobile arcade vertical construit avec Flutter, Flame et Firebase. Le joueur contrôle un personnage rond qui rebondit automatiquement sur des plateformes et doit grimper toujours plus haut en mode niveaux ou en mode infini.

## Aperçu

Placeholder captures:

- `docs/screenshots/menu.png`
- `docs/screenshots/gameplay.png`
- `docs/screenshots/leaderboard.png`

Vous pouvez remplacer ces chemins par de vraies captures après les premiers runs sur appareil ou simulateur.

## Fonctionnalités

- Gameplay 2D vertical mobile-first avec Flame
- Contrôles à une main par tap gauche / tap droite
- Rebond automatique sur plateformes
- Wrap horizontal du joueur
- Mode niveaux avec 20 niveaux
- Mode infini avec génération procédurale
- Plateformes normales, boost, fragiles, mobiles et dangereuses
- Obstacles simples dangereux
- Score basé sur la hauteur, le rythme et les combos
- Meilleur score infini en local via SharedPreferences
- Progression campagne locale:
  - niveau maximum débloqué
  - meilleur score par niveau
  - statut terminé
- Authentification Firebase anonyme au lancement
- Leaderboard Firestore pour le mode infini
- Saisie d’un pseudo avant envoi du score

## Gameplay

- Le personnage saute automatiquement lorsqu’il touche une plateforme.
- Un tap sur la moitié gauche de l’écran donne une impulsion vers la gauche.
- Un tap sur la moitié droite de l’écran donne une impulsion vers la droite.
- Si le joueur tombe sous l’écran ou touche un obstacle mortel, la partie est perdue.
- Le score augmente avec la hauteur atteinte et les enchaînements de plateformes.

## Modes de jeu

### Mode niveaux

- 20 niveaux courts
- Objectif de hauteur à atteindre
- Difficulté progressive
- Déblocage du niveau suivant après réussite

Progression actuelle:

- Niveaux 1 à 3: plateformes normales majoritaires
- Niveaux 4 à 6: arrivée des plateformes fragiles
- Niveaux 7 à 10: plateformes mobiles
- Niveaux 11 à 15: obstacles et plateformes dangereuses
- Niveaux 16 à 20: mélange complet

### Mode infini

- Génération procédurale continue
- Difficulté qui augmente avec la hauteur
- Sauvegarde locale du meilleur score
- Envoi optionnel du score vers Firebase

## Stack technique

- Flutter
- Dart
- Flame
- flutter_riverpod
- firebase_core
- firebase_auth
- cloud_firestore
- shared_preferences
- go_router

## Installation

### Prérequis

- Flutter 3.38+
- Dart 3.10+
- Xcode pour iOS
- Android Studio / SDK Android pour Android

### Installer les dépendances

```bash
flutter pub get
```

### Lancer l’application

```bash
flutter run
```

## Configuration Firebase

Le projet est préparé pour Firebase, mais aucun secret ni fichier de configuration Firebase n’est versionné dans ce repository.

### Étapes

1. Créer un projet Firebase dans la [console Firebase](https://console.firebase.google.com/).
2. Ajouter une application Android.
3. Ajouter une application iOS.
4. Installer la FlutterFire CLI.
5. Exécuter `flutterfire configure`.
6. Activer `Authentication` avec le provider `Anonymous`.
7. Créer la base Firestore.
8. Ajouter des règles Firestore de développement.
9. Lancer l’application avec `flutter run`.

### Installer FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Configurer Firebase pour le projet

```bash
flutterfire configure
```

### Fichiers Firebase à ne pas committer

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `macos/Runner/GoogleService-Info.plist`

### Règles Firestore de départ

```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /leaderboard/{document} {
      allow read: if true;
      allow create: if request.auth != null
        && request.resource.data.userId is string
        && request.resource.data.displayName is string
        && request.resource.data.displayName.size() > 0
        && request.resource.data.displayName.size() <= 16
        && request.resource.data.score is int
        && request.resource.data.score >= 0
        && request.resource.data.height is int
        && request.resource.data.height >= 0
        && request.resource.data.createdAt is timestamp;
      allow update, delete: if false;
    }
  }
}
```

### Structure Firestore utilisée

Collection: `leaderboard`

Document:

```json
{
  "userId": "firebase-user-id",
  "displayName": "Player",
  "score": 1240,
  "height": 1180,
  "createdAt": "server timestamp"
}
```

## Commandes utiles

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Structure du projet

```txt
lib/
  main.dart
  app/
    app.dart
    providers.dart
    router.dart
    theme.dart
  game/
    bounce_dash_game.dart
    components/
      background.dart
      obstacle.dart
      platform.dart
      player.dart
    systems/
      collision_system.dart
      infinite_generator.dart
      level_generator.dart
      score_system.dart
    models/
      game_mode.dart
      game_session_result.dart
      level_config.dart
      platform_type.dart
  features/
    menu/
      splash_screen.dart
      menu_screen.dart
    gameplay/
      gameplay_screen.dart
      game_over_screen.dart
      level_complete_screen.dart
    leaderboard/
      leaderboard_entry.dart
      leaderboard_screen.dart
      submit_score_screen.dart
    levels/
      level_select_screen.dart
  services/
    auth_service.dart
    leaderboard_service.dart
    local_storage_service.dart
  constants/
    game_constants.dart
```

## Leaderboard

- Le leaderboard affiche les meilleurs scores du mode infini.
- L’utilisateur est authentifié anonymement via Firebase.
- Avant l’envoi, le joueur peut saisir un pseudo simple.
- Si aucun pseudo n’est saisi, la valeur `Player` est utilisée.

## Tests

Les tests couvrent une première base:

- génération des niveaux
- calcul de score
- stockage local

Lancer:

```bash
flutter test
```

## Roadmap

### V1

- Gameplay de base
- Mode niveaux
- Mode infini
- Meilleur score local
- Leaderboard Firebase

### V2

- Skins débloquables
- Pièces
- Daily rewards
- Missions quotidiennes
- Rewarded ads
- Sons et musiques
- Classement hebdomadaire

## Développement

Les prochaines étapes détaillées sont dans [DEVELOPMENT.md](DEVELOPMENT.md).
