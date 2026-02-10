import 'package:flutter/material.dart';

import '../../features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static const home = '/';

  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _materialRoute(const HomePage());
      default:
        return _materialRoute(const HomePage()); // Fallback to HomePage
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
