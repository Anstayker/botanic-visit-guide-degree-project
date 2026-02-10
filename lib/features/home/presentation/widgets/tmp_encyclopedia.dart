import 'package:flutter/material.dart';

class TMPEncyclopedia extends StatelessWidget {
  const TMPEncyclopedia({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text('Elemento $index'),
              subtitle: Text('Descripción del elemento $index'),
              leading: const Icon(Icons.eco),
            ),
          ),
          childCount: 30,
        ),
      ),
    );
  }
}
