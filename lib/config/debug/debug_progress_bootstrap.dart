import 'package:flutter/foundation.dart';

import '../../features/plant_progress/domain/usecases/set_all_plants_discovered.dart';

Future<void> runDebugProgressBootstrap({
  required SetAllPlantsDiscovered setAllPlantsDiscovered,
}) async {
  if (!kDebugMode) {
    return;
  }

  const debugResetProgress = bool.fromEnvironment(
    'DEBUG_RESET_PROGRESS',
    defaultValue: false,
  );
  const debugDiscoverAll = bool.fromEnvironment(
    'DEBUG_DISCOVER_ALL',
    defaultValue: false,
  );

  if (!debugResetProgress && !debugDiscoverAll) {
    return;
  }

  if (debugResetProgress && debugDiscoverAll) {
    debugPrint(
      'DEBUG_RESET_PROGRESS and DEBUG_DISCOVER_ALL cannot be true at the same time.',
    );
    return;
  }

  final shouldDiscoverAll = debugDiscoverAll;
  final result = await setAllPlantsDiscovered(
    Params(isDiscovered: shouldDiscoverAll),
  );

  result.fold(
    (failure) => debugPrint('Debug progress action failed: ${failure.message}'),
    (_) => debugPrint(
      shouldDiscoverAll
          ? 'Debug progress action applied: all plants discovered.'
          : 'Debug progress action applied: progress reset (all undiscovered).',
    ),
  );
}
