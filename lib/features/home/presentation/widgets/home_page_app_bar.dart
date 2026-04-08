import 'package:flutter/material.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key, required this.context});

  final BuildContext context;

  //TODO: Style should be in themedata file

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Guía Botánica',
        style: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () {
              // TODO: Implementar navegación al perfil de usuario
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Información')));
            },
            icon: Icon(
              Icons.info_outline,
              color: Theme.of(context).iconTheme.color,
              size: 28,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Theme.of(context).iconTheme.color,
              padding: const EdgeInsets.all(8),
            ),
            tooltip: 'Información',
          ),
        ),
      ],
    );
  }
}
