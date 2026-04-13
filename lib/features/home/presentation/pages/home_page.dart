import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../encyclopedia/presentation/pages/encyclopedia_page.dart';
import '../widgets/home_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Image.asset('assets/images/wallpaper1.jpg', fit: BoxFit.fill),
      ),
    );
  }
}
