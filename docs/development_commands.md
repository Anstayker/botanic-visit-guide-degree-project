# Comandos de desarrollo

## App normal

```bash
flutter run
```

## Resetear progreso (todas las plantas a `isDiscovered = false`)

```bash
flutter run --dart-define=DEBUG_RESET_PROGRESS=true
```

## Marcar todas las plantas como descubiertas (`isDiscovered = true`)

```bash
flutter run --dart-define=DEBUG_DISCOVER_ALL=true
```

## Seed de plantas a Firestore

```bash
flutter run -t tool/seed_plants_to_firestore.dart
```

## Notas

- Las banderas `DEBUG_RESET_PROGRESS` y `DEBUG_DISCOVER_ALL` son excluyentes.
- El bootstrap de debug solo corre en modo debug.
