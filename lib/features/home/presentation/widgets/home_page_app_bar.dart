import 'package:flutter/material.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key, required this.context});

  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Icon(Icons.eco, color: Theme.of(context).iconTheme.color, size: 28),
          SizedBox(width: 8),
          Text(
            'Guía Botánica',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Implementar navegación al perfil de usuario
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Información')));
          },
          icon: Icon(Icons.info_outline, size: 28),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(8),
          ),
          tooltip: 'Información',
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Información')));
            },
            icon: Icon(Icons.help_outline, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(8),
            ),
            tooltip: 'Información',
          ),
        ),
      ],
    );
  }
}
