import 'package:flutter/material.dart';

import '../../features/exploration/presentation/pages/radar_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/plant_details/presentation/pages/plant_details_page.dart';
import '../../features/qr_scanner/presentation/pages/qr_scanner.page.dart';

class AppRoutes {
  static const home = '/';
  static const plantDetails = '/plant_details';
  static const radarPage = '/radar';
  static const qrScanner = '/qr_scanner';
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _materialRoute(const HomePage());
      case plantDetails:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return _materialRoute(
            PlantDetailsPage(
              plantId: args['plantId'],
              imageUrl: args['imageUrl'],
            ),
          );
        }
        return _materialRoute(
          const PlantDetailsPage(plantId: '0', imageUrl: ''),
        );
      case radarPage:
        return _materialRoute(const RadarPage());
      case qrScanner:
        return _materialRoute(const QRScanner());
      default:
        return _materialRoute(const HomePage()); // Fallback to HomePage
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
