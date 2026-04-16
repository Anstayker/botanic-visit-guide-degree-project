import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../encyclopedia/presentation/pages/encyclopedia_page.dart';
import '../widgets/home_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'home_camera_fab',
            backgroundColor: Color.lerp(
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
              Colors.white,
              0.30,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.qrScanner);
            },
            child: const Icon(Icons.camera_alt_rounded),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'home_explore_fab',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.radarPage);
            },
            icon: const Icon(Icons.radar),
            label: const Text('Explorar'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverMainAxisGroup(
            slivers: <Widget>[
              HomePageAppBar(context: context),
              //! Feature Encyclopedia
              const EncyclopediaPage(),
            ],
          ),
        ],
      ),
    );
  }
}
