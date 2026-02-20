import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/encyclopedia_bloc.dart';

class EncyPlantGridWidget extends StatelessWidget {
  const EncyPlantGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EncyclopediaBloc, EncyclopediaState>(
      builder: (context, state) {
        if (state is EncyclopediaLoaded) {
          return Text('data: ${state.plants.length} plants');
        }
        if (state is EncyclopediaLoading) {
          return CircularProgressIndicator();
        }
        if (state is EncyclopediaError) {
          return Text('Error: ${state.message}');
        }
        //! Error Widget

        return Container();
      },
    );
  }
}
