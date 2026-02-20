import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../encyclopedia/presentation/pages/encyclopedia_page.dart';
import '../widgets/home_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final plantItems = [
      const PlantGridItem(name: 'Aloe', isUnlocked: true),
      const PlantGridItem(name: 'Orquidea', isUnlocked: true),
      const PlantGridItem(name: 'Lavanda', isUnlocked: false),
      const PlantGridItem(name: 'Monstera', isUnlocked: true),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: 'Cactus', isUnlocked: true),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
      const PlantGridItem(name: '??', isUnlocked: false),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.radarPage);
        },
        child: const Icon(Icons.radar),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverMainAxisGroup(
            slivers: <Widget>[
              HomePageAppBar(context: context),
              //! Feature: Noticias
              SliverToBoxAdapter(child: featuredSelection()),

              //! Feature Encyclopedia
              const EncyclopediaPage(),

              //! TMP: PlantGridSliver con items de ejemplo
              PlantGridSliver(
                items: plantItems,
                onItemTap: (item, index) {
                  Navigator.of(context).pushNamed(AppRoutes.plantDetails);
                },
              ),
              TMPEncyclopedia(),
            ],
          ),
        ],
      ),
    );
  }

  Container featuredSelection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Carrusel Placeholder\n(Elementos Cuadrados)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
