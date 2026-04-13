import 'package:flutter/material.dart';

import 'config/debug/debug_progress_bootstrap.dart';
import 'config/routes/app_routes.dart';
import 'config/theme/app_themes.dart';
import 'core/data/datasources/plant_local_data_source.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/plant_progress/domain/usecases/set_all_plants_discovered.dart';
import 'injection_container.dart' as dependencies;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencies.init();
  await dependencies.sl<PlantLocalDataSource>().initializeDataSource();
  await runDebugProgressBootstrap(
    setAllPlantsDiscovered: dependencies.sl<SetAllPlantsDiscovered>(),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Botanical App',
      theme: floraTheme(),
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      home: HomePage(),
    );
  }
}
