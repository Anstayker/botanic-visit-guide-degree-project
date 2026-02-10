import 'package:flutter/material.dart';

import '../../features/exploration/presentation/pages/radar_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/plant_details/presentation/pages/plant_details_page.dart';

class AppRoutes {
  static const home = '/';
  static const plantDetails = '/plant_details';
  static const radarPage = '/radar';
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _materialRoute(const HomePage());
      case plantDetails:
        return _materialRoute(const PlantDetailsPage());
      case radarPage:
        return _materialRoute(const RadarPage());
      default:
        return _materialRoute(const HomePage()); // Fallback to HomePage
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
