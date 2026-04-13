import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_progress_bloc.dart';

class EncyUserProgressCard extends StatelessWidget {
  const EncyUserProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (_, state) {
        final isLoading = state is UserProgressLoading;
        final hasError = state is UserProgressError;
        final loadedState = state is UserProgressLoaded ? state : null;

        final identifiedPlants = loadedState?.identifiedPlants ?? 0;
        final totalPlants = loadedState?.totalPlants ?? 0;
        final progressValue = loadedState?.progressValue ?? 0;
        final progressPercentage = loadedState?.progressPercentage ?? 0;
        final levelNumber = loadedState?.levelNumber ?? 1;
        final levelTitle = loadedState?.levelTitle ?? 'Explorador Inicial';

        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardTitle(),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _userLevel(levelNumber, levelTitle),
                  _plantsObtainedQuantity(identifiedPlants, totalPlants),
                ],
              ),
              const SizedBox(height: 8.0),
              _progressBar(context, progressValue),
              const SizedBox(height: 8.0),
              if (isLoading)
                _helperText('Calculando progreso...')
              else if (hasError)
                _helperText('No se pudo cargar el progreso')
              else
                _completionPercentage(progressPercentage),
            ],
          ),
        );
      },
    );
  }

  Text _plantsObtainedQuantity(int identifiedPlants, int totalPlants) => Text(
    '$identifiedPlants/$totalPlants',
    style: const TextStyle(fontWeight: FontWeight.bold),
  );

  LinearProgressIndicator _progressBar(BuildContext context, double value) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      color: Theme.of(context).primaryColor,
    );
  }

  Text _completionPercentage(int progressPercentage) {
    return Text(
      '$progressPercentage% completado',
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  Text _userLevel(int levelNumber, String levelTitle) {
    return Text(
      'Nivel $levelNumber: $levelTitle',
      style: TextStyle(color: Colors.grey[600], fontSize: 12),
    );
  }

  Text _helperText(String message) {
    return Text(
      message,
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  Text _cardTitle() {
    return const Text(
      'Progreso de Descubrimiento',
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
